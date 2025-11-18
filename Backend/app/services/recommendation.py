# -*- coding: utf-8 -*-
"""
推荐服务 - 智能匹配陪诊师和机构
"""
from typing import List, Dict, Optional
from flask import current_app
from sqlalchemy import and_, or_

from app.models.companion import Companion, Institution
from app.extensions import db


class RecommendationService:
    """推荐服务类"""

    def __init__(self):
        """初始化推荐服务"""
        pass

    def recommend_companions(
        self,
        city: Optional[str] = None,
        hospital: Optional[str] = None,
        department: Optional[str] = None,
        has_car: Optional[bool] = None,
        min_rating: float = 4.0,
        limit: int = 10
    ) -> List[Dict]:
        """
        推荐陪诊师

        Args:
            city: 城市
            hospital: 医院
            department: 科室
            has_car: 是否需要有车
            min_rating: 最低评分
            limit: 返回数量

        Returns:
            推荐的陪诊师列表
        """
        try:
            # 构建基础查询（不包含城市和医院筛选）
            base_query = Companion.query.filter(
                Companion.is_deleted == False,
                Companion.status == 'approved',
                Companion.is_verified == True,
                Companion.rating >= min_rating
            )

            # 是否有车筛选（这个条件始终保留）
            if has_car is not None:
                base_query = base_query.filter(Companion.has_car == has_car)

            # 两级降级策略（只匹配城市相关）
            companions = []

            # 第一级：同时匹配城市和医院
            if city and hospital:
                query = base_query.filter(
                    Companion.service_area.like(f'%{city}%'),
                    Companion.service_hospitals.like(f'%{hospital}%')
                ).order_by(
                    (Companion.rating * 0.6 + (Companion.completed_orders / 100.0) * 0.4).desc(),
                    Companion.rating.desc(),
                    Companion.completed_orders.desc()
                )

                # 打印 SQL 查询语句
                sql_query = str(query.limit(limit).statement.compile(
                    compile_kwargs={"literal_binds": True}
                ))
                current_app.logger.info('执行SQL查询（城市+医院）:')
                current_app.logger.info(sql_query)

                companions = query.limit(limit).all()

                if companions:
                    current_app.logger.info(f'找到 {len(companions)} 个同时服务 {city} 和 {hospital} 的陪诊师')
                else:
                    # 第二级：只匹配城市，忽略医院
                    current_app.logger.info(f'未找到同时服务 {city} 和 {hospital} 的陪诊师，尝试只匹配城市')
                    query = base_query.filter(
                        Companion.service_area.like(f'%{city}%')
                    ).order_by(
                        (Companion.rating * 0.6 + (Companion.completed_orders / 100.0) * 0.4).desc(),
                        Companion.rating.desc(),
                        Companion.completed_orders.desc()
                    )

                    # 打印 SQL 查询语句
                    sql_query = str(query.limit(limit).statement.compile(
                        compile_kwargs={"literal_binds": True}
                    ))
                    current_app.logger.info('执行SQL查询（仅城市）:')
                    current_app.logger.info(sql_query)

                    companions = query.limit(limit).all()

                    if companions:
                        current_app.logger.info(f'找到 {len(companions)} 个服务 {city} 的陪诊师')
                    else:
                        current_app.logger.info(f'未找到服务 {city} 的陪诊师，暂无合适陪诊师')

            # 只有城市条件
            elif city:
                query = base_query.filter(
                    Companion.service_area.like(f'%{city}%')
                ).order_by(
                    (Companion.rating * 0.6 + (Companion.completed_orders / 100.0) * 0.4).desc(),
                    Companion.rating.desc(),
                    Companion.completed_orders.desc()
                )

                # 打印 SQL 查询语句
                sql_query = str(query.limit(limit).statement.compile(
                    compile_kwargs={"literal_binds": True}
                ))
                current_app.logger.info('执行SQL查询（仅城市）:')
                current_app.logger.info(sql_query)

                companions = query.limit(limit).all()

                if companions:
                    current_app.logger.info(f'找到 {len(companions)} 个服务 {city} 的陪诊师')
                else:
                    current_app.logger.info(f'未找到服务 {city} 的陪诊师，暂无合适陪诊师')

            # 只有医院条件（需要城市信息才能查询）
            elif hospital:
                current_app.logger.info(f'只有医院条件 {hospital}，但缺少城市信息，无法查询')
                # 不返回任何结果，需要用户提供城市信息

            # 没有任何条件
            else:
                current_app.logger.info('缺少城市和医院条件，无法查询陪诊师')

            # 转换为字典并计算推荐理由
            results = []
            for companion in companions:
                data = companion.to_dict()
                data['recommendation_reason'] = self._generate_companion_reason(
                    companion, city, hospital, has_car
                )
                data['match_score'] = self._calculate_companion_score(
                    companion, city, hospital, has_car
                )
                results.append(data)

            # 按匹配分数重新排序
            results.sort(key=lambda x: x['match_score'], reverse=True)

            return results

        except Exception as e:
            current_app.logger.error(f'推荐陪诊师失败: {str(e)}')
            return []

    def recommend_institutions(
        self,
        city: Optional[str] = None,
        min_rating: float = 4.0,
        limit: int = 10
    ) -> List[Dict]:
        """
        推荐陪诊机构

        Args:
            city: 城市
            min_rating: 最低评分
            limit: 返回数量

        Returns:
            推荐的机构列表
        """
        try:
            # 构建查询
            query = Institution.query.filter(
                Institution.is_deleted == False,
                Institution.status == 'approved',
                Institution.rating >= min_rating
            )

            # 城市筛选
            if city:
                query = query.filter(Institution.city == city)

            # 综合排序：评分权重50%，订单数权重30%，陪诊师数量权重20%
            query = query.order_by(
                (
                    Institution.rating * 0.5 +
                    (Institution.completed_orders / 100.0) * 0.3 +
                    (Institution.companion_count / 10.0) * 0.2
                ).desc(),
                Institution.rating.desc(),
                Institution.completed_orders.desc()
            )

            # 限制数量
            institutions = query.limit(limit).all()

            # 转换为字典并计算推荐理由
            results = []
            for institution in institutions:
                data = institution.to_dict()
                data['recommendation_reason'] = self._generate_institution_reason(
                    institution, city
                )
                data['match_score'] = self._calculate_institution_score(
                    institution, city
                )
                results.append(data)

            # 按匹配分数重新排序
            results.sort(key=lambda x: x['match_score'], reverse=True)

            return results

        except Exception as e:
            current_app.logger.error(f'推荐机构失败: {str(e)}')
            return []

    def _generate_companion_reason(
        self,
        companion: Companion,
        city: Optional[str],
        hospital: Optional[str],
        has_car: Optional[bool]
    ) -> str:
        """生成陪诊师推荐理由"""
        reasons = []

        # 评分高
        if companion.rating >= 4.8:
            reasons.append(f'高评分 {float(companion.rating):.1f}')

        # 经验丰富
        if companion.completed_orders >= 50:
            reasons.append(f'完成{companion.completed_orders}单')

        # 有车
        if has_car and companion.has_car:
            reasons.append('提供接送服务')

        # 本地陪诊师
        if city and companion.service_area and city in companion.service_area:
            reasons.append(f'{city}本地陪诊师')

        # 熟悉医院
        if hospital and companion.service_hospitals and hospital in companion.service_hospitals:
            reasons.append(f'熟悉{hospital}')

        # 从业年限
        if companion.service_years and companion.service_years >= 3:
            reasons.append(f'{companion.service_years}年经验')

        return ' • '.join(reasons) if reasons else '优质陪诊师'

    def _generate_institution_reason(
        self,
        institution: Institution,
        city: Optional[str]
    ) -> str:
        """生成机构推荐理由"""
        reasons = []

        # 评分高
        if institution.rating >= 4.8:
            reasons.append(f'高评分 {float(institution.rating):.1f}')

        # 服务量大
        if institution.completed_orders >= 100:
            reasons.append(f'服务{institution.completed_orders}+人次')

        # 陪诊师多
        if institution.companion_count >= 10:
            reasons.append(f'{institution.companion_count}名专业陪诊师')

        # 本地机构
        if city and institution.city == city:
            reasons.append(f'{city}本地机构')

        return ' • '.join(reasons) if reasons else '专业陪诊机构'

    def _calculate_companion_score(
        self,
        companion: Companion,
        city: Optional[str],
        hospital: Optional[str],
        has_car: Optional[bool]
    ) -> float:
        """计算陪诊师匹配分数（0-100）"""
        score = 0.0

        # 基础分：评分（40分）
        score += (float(companion.rating) / 5.0) * 40

        # 经验分：订单数（20分）
        order_score = min(companion.completed_orders / 100.0, 1.0) * 20
        score += order_score

        # 匹配分（40分）
        match_score = 0

        # 城市匹配（10分）
        if city and companion.service_area and city in companion.service_area:
            match_score += 10

        # 医院匹配（15分）
        if hospital and companion.service_hospitals and hospital in companion.service_hospitals:
            match_score += 15

        # 有车匹配（10分）
        if has_car and companion.has_car:
            match_score += 10
        elif not has_car:
            match_score += 5  # 不需要车也给一半分

        # 在线状态（5分）
        if companion.is_online:
            match_score += 5

        score += match_score

        return round(score, 2)

    def _calculate_institution_score(
        self,
        institution: Institution,
        city: Optional[str]
    ) -> float:
        """计算机构匹配分数（0-100）"""
        score = 0.0

        # 基础分：评分（50分）
        score += (float(institution.rating) / 5.0) * 50

        # 规模分：陪诊师数量（20分）
        companion_score = min(institution.companion_count / 20.0, 1.0) * 20
        score += companion_score

        # 经验分：订单数（20分）
        order_score = min(institution.completed_orders / 200.0, 1.0) * 20
        score += order_score

        # 城市匹配（10分）
        if city and institution.city == city:
            score += 10

        return round(score, 2)


# 创建全局实例
recommendation_service = RecommendationService()
