# -*- coding: utf-8 -*-
"""
评价相关API
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity
from app.models.user import User
from app.models.review import Review
from app.models.order import Order
from app.models.companion import Companion, Institution
from app.extensions import db
from app.utils.decorators import login_required
from datetime import datetime

bp = Blueprint('review', __name__, url_prefix='/api/v1/user/reviews')


@bp.route('', methods=['POST'])
@login_required()
def create_review():
    """
    创建评价

    请求体:
    {
        "order_id": 订单ID,
        "rating": 总评分(1-5),
        "content": "评价内容",
        "tags": ["标签1", "标签2"],
        "service_rating": 服务评分,
        "attitude_rating": 态度评分,
        "professional_rating": 专业度评分,
        "images": ["图片URL1", "图片URL2"],
        "is_anonymous": false
    }
    """
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()

        # 验证必填字段
        if not data.get('order_id'):
            return jsonify({
                'success': False,
                'message': '订单ID不能为空'
            }), 400

        if not data.get('rating'):
            return jsonify({
                'success': False,
                'message': '评分不能为空'
            }), 400

        # 验证订单
        order = Order.query.filter_by(
            id=data['order_id'],
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not order:
            return jsonify({
                'success': False,
                'message': '订单不存在'
            }), 404

        # 检查订单状态是否为已完成
        if order.status != 'completed':
            return jsonify({
                'success': False,
                'message': '只能评价已完成的订单'
            }), 400

        # 检查是否已评价
        existing_review = Review.query.filter_by(
            order_id=order.id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if existing_review:
            return jsonify({
                'success': False,
                'message': '该订单已评价'
            }), 400

        # 创建评价
        review = Review(
            user_id=current_user_id,
            order_id=order.id,
            companion_id=order.companion_id,
            institution_id=order.institution_id,
            rating=data['rating'],
            content=data.get('content'),
            tags=data.get('tags', []),
            service_rating=data.get('service_rating'),
            attitude_rating=data.get('attitude_rating'),
            professional_rating=data.get('professional_rating'),
            images=data.get('images', []),
            is_anonymous=data.get('is_anonymous', False)
        )

        db.session.add(review)

        # 更新陪诊师或机构的评分统计
        if order.companion_id:
            companion = Companion.query.get(order.companion_id)
            if companion:
                # 重新计算平均评分
                reviews = Review.query.filter_by(
                    companion_id=companion.id,
                    is_deleted=False
                ).all()

                total_rating = sum([float(r.rating) for r in reviews]) + float(data['rating'])
                companion.rating = round(total_rating / (len(reviews) + 1), 1)
                companion.review_count = len(reviews) + 1

        if order.institution_id:
            institution = Institution.query.get(order.institution_id)
            if institution:
                # 重新计算平均评分
                reviews = Review.query.filter_by(
                    institution_id=institution.id,
                    is_deleted=False
                ).all()

                total_rating = sum([float(r.rating) for r in reviews]) + float(data['rating'])
                institution.rating = round(total_rating / (len(reviews) + 1), 1)
                institution.review_count = len(reviews) + 1

        db.session.commit()

        return jsonify({
            'success': True,
            'data': review.to_dict(include_user=True),
            'message': '评价成功'
        }), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'创建评价失败: {str(e)}'
        }), 500


@bp.route('', methods=['GET'])
@login_required()
def list_reviews():
    """
    获取当前用户的评价列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认10）
    """
    try:
        current_user_id = get_jwt_identity()

        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 10, type=int)

        # 查询评价
        query = Review.query.filter_by(
            user_id=current_user_id,
            is_deleted=False
        ).order_by(Review.created_at.desc())

        # 分页
        pagination = query.paginate(
            page=page,
            per_page=page_size,
            error_out=False
        )

        reviews = []
        for review in pagination.items:
            review_data = review.to_dict(include_user=False)

            # 添加订单信息
            order = Order.query.get(review.order_id)
            if order:
                review_data['order'] = {
                    'id': order.id,
                    'order_no': order.order_no,
                    'service_type': order.service_type
                }

            # 添加陪诊师或机构信息
            if review.companion_id:
                companion = Companion.query.get(review.companion_id)
                if companion:
                    review_data['companion'] = {
                        'id': companion.id,
                        'name': companion.name,
                        'avatar_url': companion.avatar_url
                    }

            if review.institution_id:
                institution = Institution.query.get(review.institution_id)
                if institution:
                    review_data['institution'] = {
                        'id': institution.id,
                        'name': institution.name,
                        'logo_url': institution.logo_url
                    }

            reviews.append(review_data)

        return jsonify({
            'success': True,
            'data': {
                'list': reviews,
                'total': pagination.total,
                'page': page,
                'page_size': page_size,
                'total_pages': pagination.pages
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取评价列表失败: {str(e)}'
        }), 500


@bp.route('/<int:review_id>', methods=['GET'])
@login_required()
def get_review(review_id):
    """
    获取评价详情
    """
    try:
        current_user_id = get_jwt_identity()

        review = Review.query.filter_by(
            id=review_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not review:
            return jsonify({
                'success': False,
                'message': '评价不存在'
            }), 404

        review_data = review.to_dict(include_user=True)

        # 添加订单信息
        order = Order.query.get(review.order_id)
        if order:
            review_data['order'] = {
                'id': order.id,
                'order_no': order.order_no,
                'service_type': order.service_type,
                'service_date': order.service_date.isoformat() if order.service_date else None
            }

        # 添加陪诊师或机构信息
        if review.companion_id:
            companion = Companion.query.get(review.companion_id)
            if companion:
                review_data['companion'] = {
                    'id': companion.id,
                    'name': companion.name,
                    'avatar_url': companion.avatar_url,
                    'rating': float(companion.rating) if companion.rating else 0.0
                }

        if review.institution_id:
            institution = Institution.query.get(review.institution_id)
            if institution:
                review_data['institution'] = {
                    'id': institution.id,
                    'name': institution.name,
                    'logo_url': institution.logo_url,
                    'rating': float(institution.rating) if institution.rating else 0.0
                }

        return jsonify({
            'success': True,
            'data': review_data
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取评价详情失败: {str(e)}'
        }), 500


@bp.route('/<int:review_id>', methods=['DELETE'])
@login_required()
def delete_review(review_id):
    """
    删除评价（软删除）
    """
    try:
        current_user_id = get_jwt_identity()

        review = Review.query.filter_by(
            id=review_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not review:
            return jsonify({
                'success': False,
                'message': '评价不存在'
            }), 404

        # 软删除
        review.is_deleted = True
        review.updated_at = datetime.utcnow()

        # 重新计算陪诊师或机构的评分统计
        if review.companion_id:
            companion = Companion.query.get(review.companion_id)
            if companion:
                # 重新计算平均评分（排除已删除的）
                reviews = Review.query.filter_by(
                    companion_id=companion.id,
                    is_deleted=False
                ).all()

                if reviews:
                    total_rating = sum([float(r.rating) for r in reviews])
                    companion.rating = round(total_rating / len(reviews), 1)
                    companion.review_count = len(reviews)
                else:
                    companion.rating = 0.0
                    companion.review_count = 0

        if review.institution_id:
            institution = Institution.query.get(review.institution_id)
            if institution:
                reviews = Review.query.filter_by(
                    institution_id=institution.id,
                    is_deleted=False
                ).all()

                if reviews:
                    total_rating = sum([float(r.rating) for r in reviews])
                    institution.rating = round(total_rating / len(reviews), 1)
                    institution.review_count = len(reviews)
                else:
                    institution.rating = 0.0
                    institution.review_count = 0

        db.session.commit()

        return jsonify({
            'success': True,
            'message': '删除成功'
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'删除评价失败: {str(e)}'
        }), 500
