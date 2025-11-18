# -*- coding: utf-8 -*-
"""
陪诊机构相关API - 用户端
"""
from flask import Blueprint, request
from app.models.companion import Institution, Companion
from app.models.review import Review
from app.utils.response import success_response, error_response

bp = Blueprint('user_institution', __name__, url_prefix='/api/v1/user/institutions')


@bp.route('', methods=['GET'])
def get_institutions():
    """
    获取陪诊机构列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    - keyword: 搜索关键词（机构名称）
    - min_rating: 最低评分
    - city: 城市筛选
    - sort_by: 排序字段（rating/orders，默认rating）
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
        min_rating = request.args.get('min_rating', type=float)
        city = request.args.get('city', '').strip()
        sort_by = request.args.get('sort_by', 'rating').strip()
        order = request.args.get('order', 'desc').strip()

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询
        query = Institution.query.filter_by(
            is_deleted=False,
            status='approved'
        )

        # 关键词搜索
        if keyword:
            query = query.filter(Institution.name.like(f'%{keyword}%'))

        # 最低评分筛选
        if min_rating:
            query = query.filter(Institution.rating >= min_rating)

        # 城市筛选
        if city:
            query = query.filter(Institution.city == city)

        # 排序
        if sort_by == 'rating':
            if order == 'asc':
                query = query.order_by(Institution.rating.asc())
            else:
                query = query.order_by(Institution.rating.desc())
        elif sort_by == 'orders':
            if order == 'asc':
                query = query.order_by(Institution.completed_orders.asc())
            else:
                query = query.order_by(Institution.completed_orders.desc())
        else:
            # 默认按评分降序
            query = query.order_by(Institution.rating.desc())

        # 分页
        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 转换为字典
        institutions = [institution.to_dict() for institution in pagination.items]

        return success_response({
            'list': institutions,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取机构列表成功')

    except Exception as e:
        return error_response(f'获取机构列表失败: {str(e)}', 500)


@bp.route('/<int:institution_id>', methods=['GET'])
def get_institution_detail(institution_id):
    """
    获取陪诊机构详情

    路径参数:
    - institution_id: 机构ID

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            "name": "爱心陪诊中心",
            "logo_url": "...",
            "rating": 4.9,
            ...
            "companions": [...]  // 机构陪诊师列表
        }
    }
    """
    try:
        # 查询机构
        institution = Institution.query.filter_by(
            id=institution_id,
            is_deleted=False
        ).first()

        if not institution:
            return error_response('机构不存在', 404)

        # 转换为字典
        data = institution.to_dict()

        # 获取机构陪诊师列表（只返回前10个，评分最高的）
        companions = Companion.query.filter_by(
            institution_id=institution_id,
            is_deleted=False,
            status='approved',
            is_verified=True
        ).order_by(Companion.rating.desc()).limit(10).all()

        data['companions'] = [companion.to_dict() for companion in companions]

        return success_response(data, '获取机构详情成功')

    except Exception as e:
        return error_response(f'获取机构详情失败: {str(e)}', 500)


@bp.route('/<int:institution_id>/reviews', methods=['GET'])
def get_institution_reviews(institution_id):
    """
    获取机构评价列表

    路径参数:
    - institution_id: 机构ID

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
                "average": 4.9,
                "5_star": 40,
                "4_star": 8,
                ...
            }
        }
    }
    """
    try:
        # 检查机构是否存在
        institution = Institution.query.filter_by(
            id=institution_id,
            is_deleted=False
        ).first()

        if not institution:
            return error_response('机构不存在', 404)

        # 获取查询参数
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        rating_filter = request.args.get('rating', type=int)

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询
        query = Review.query.filter_by(
            target_type='institution',
            target_id=institution_id,
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
            'average': float(institution.rating) if institution.rating else 5.0,
            'total': institution.review_count,
            '5_star': Review.query.filter_by(target_type='institution', target_id=institution_id, rating=5, is_deleted=False).count(),
            '4_star': Review.query.filter_by(target_type='institution', target_id=institution_id, rating=4, is_deleted=False).count(),
            '3_star': Review.query.filter_by(target_type='institution', target_id=institution_id, rating=3, is_deleted=False).count(),
            '2_star': Review.query.filter_by(target_type='institution', target_id=institution_id, rating=2, is_deleted=False).count(),
            '1_star': Review.query.filter_by(target_type='institution', target_id=institution_id, rating=1, is_deleted=False).count(),
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
