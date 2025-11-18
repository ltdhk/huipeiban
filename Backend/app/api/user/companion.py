# -*- coding: utf-8 -*-
"""
陪诊师相关API - 用户端
"""
from flask import Blueprint, request
from sqlalchemy import or_, and_
from app.models.companion import Companion, Service
from app.models.review import Review
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_companion', __name__, url_prefix='/api/v1/user/companions')


@bp.route('', methods=['GET'])
def get_companions():
    """
    获取陪诊师列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    - keyword: 搜索关键词（姓名）
    - gender: 性别筛选
    - has_car: 是否有车（true/false）
    - min_rating: 最低评分
    - city: 城市筛选
    - sort_by: 排序字段（rating/price/orders，默认rating）
    - order: 排序方向（desc/asc，默认desc）

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 100,
            "page": 1,
            "page_size": 20
        }
    }
    """
    try:
        # 获取查询参数
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        keyword = request.args.get('keyword', '').strip()
        gender = request.args.get('gender', '').strip()
        has_car = request.args.get('has_car', '').strip()
        min_rating = request.args.get('min_rating', type=float)
        city = request.args.get('city', '').strip()
        sort_by = request.args.get('sort_by', 'rating').strip()
        order = request.args.get('order', 'desc').strip()

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询
        query = Companion.query.filter_by(
            is_deleted=False,
            status='approved',
            is_verified=True
        )

        # 关键词搜索
        if keyword:
            query = query.filter(Companion.name.like(f'%{keyword}%'))

        # 性别筛选
        if gender and gender in ['male', 'female']:
            query = query.filter(Companion.gender == gender)

        # 是否有车筛选
        if has_car:
            has_car_bool = has_car.lower() == 'true'
            query = query.filter(Companion.has_car == has_car_bool)

        # 最低评分筛选
        if min_rating:
            query = query.filter(Companion.rating >= min_rating)

        # 城市筛选（需要查询服务区域JSON）
        if city:
            query = query.filter(Companion.service_area.like(f'%{city}%'))

        # 排序
        if sort_by == 'rating':
            if order == 'asc':
                query = query.order_by(Companion.rating.asc())
            else:
                query = query.order_by(Companion.rating.desc())
        elif sort_by == 'orders':
            if order == 'asc':
                query = query.order_by(Companion.completed_orders.asc())
            else:
                query = query.order_by(Companion.completed_orders.desc())
        else:
            # 默认按评分降序
            query = query.order_by(Companion.rating.desc())

        # 分页
        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 转换为字典
        companions = [companion.to_dict() for companion in pagination.items]

        return success_response({
            'list': companions,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取陪诊师列表成功')

    except Exception as e:
        return error_response(f'获取陪诊师列表失败: {str(e)}', 500)


@bp.route('/<int:companion_id>', methods=['GET'])
def get_companion_detail(companion_id):
    """
    获取陪诊师详情

    路径参数:
    - companion_id: 陪诊师ID

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            "name": "张医师",
            "avatar_url": "...",
            "rating": 4.8,
            ...
            "services": [...],  // 服务列表
            "institution": {...}  // 所属机构信息
        }
    }
    """
    try:
        # 查询陪诊师
        companion = Companion.query.filter_by(
            id=companion_id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response('陪诊师不存在', 404)

        # 转换为字典
        data = companion.to_dict()

        # 获取服务列表及其规格
        services = Service.query.filter_by(
            companion_id=companion_id,
            is_deleted=False,
            is_active=True
        ).order_by(Service.sort_order).all()

        # 转换服务为字典，包含规格信息
        from app.models.companion import ServiceSpec
        services_data = []
        for service in services:
            service_dict = service.to_dict()
            # 获取服务规格
            specs = ServiceSpec.query.filter_by(
                service_id=service.id,
                is_deleted=False,
                is_active=True
            ).order_by(ServiceSpec.sort_order).all()
            service_dict['specs'] = [spec.to_dict() for spec in specs]
            services_data.append(service_dict)

        data['services'] = services_data

        # 获取所属机构信息
        if companion.institution_id:
            institution = companion.institution
            if institution and not institution.is_deleted:
                data['institution'] = {
                    'id': institution.id,
                    'name': institution.name,
                    'logo_url': institution.logo_url,
                    'rating': float(institution.rating) if institution.rating else 5.0
                }
        else:
            data['institution'] = None

        return success_response(data, '获取陪诊师详情成功')

    except Exception as e:
        return error_response(f'获取陪诊师详情失败: {str(e)}', 500)


@bp.route('/<int:companion_id>/reviews', methods=['GET'])
def get_companion_reviews(companion_id):
    """
    获取陪诊师评价列表

    路径参数:
    - companion_id: 陪诊师ID

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    - rating: 评分筛选（1-5）

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 50,
            "page": 1,
            "page_size": 20,
            "rating_stats": {
                "average": 4.8,
                "5_star": 30,
                "4_star": 15,
                "3_star": 3,
                "2_star": 1,
                "1_star": 1
            }
        }
    }
    """
    try:
        # 检查陪诊师是否存在
        companion = Companion.query.filter_by(
            id=companion_id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response('陪诊师不存在', 404)

        # 获取查询参数
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        rating_filter = request.args.get('rating', type=int)

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询
        query = Review.query.filter_by(
            target_type='companion',
            target_id=companion_id,
            is_deleted=False
        )

        # 评分筛选
        if rating_filter and 1 <= rating_filter <= 5:
            query = query.filter(Review.rating == rating_filter)

        # 按创建时间降序排序
        query = query.order_by(Review.created_at.desc())

        # 分页
        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 转换为字典
        reviews = [review.to_dict() for review in pagination.items]

        # 计算评分统计
        rating_stats = {
            'average': float(companion.rating) if companion.rating else 5.0,
            'total': companion.review_count,
            '5_star': Review.query.filter_by(target_type='companion', target_id=companion_id, rating=5, is_deleted=False).count(),
            '4_star': Review.query.filter_by(target_type='companion', target_id=companion_id, rating=4, is_deleted=False).count(),
            '3_star': Review.query.filter_by(target_type='companion', target_id=companion_id, rating=3, is_deleted=False).count(),
            '2_star': Review.query.filter_by(target_type='companion', target_id=companion_id, rating=2, is_deleted=False).count(),
            '1_star': Review.query.filter_by(target_type='companion', target_id=companion_id, rating=1, is_deleted=False).count(),
        }

        return success_response({
            'list': reviews,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages,
            'rating_stats': rating_stats
        }, '获取评价列表成功')

    except Exception as e:
        return error_response(f'获取评价列表失败: {str(e)}', 500)
