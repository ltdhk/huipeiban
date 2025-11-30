# -*- coding: utf-8 -*-
"""
陪诊师订单管理API
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime

from app.models.order import Order, Payment
from app.models.user import User, Patient
from app.models.companion import Companion
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('companion_order', __name__, url_prefix='/api/v1/companion/orders')


def get_current_companion():
    """获取当前登录用户的陪诊师信息"""
    user_id = get_jwt_identity()
    if isinstance(user_id, str):
        user_id = int(user_id)

    companion = Companion.query.filter_by(
        user_id=user_id,
        is_deleted=False
    ).first()

    return companion


@bp.route('', methods=['GET'])
@login_required()
def get_orders():
    """
    获取陪诊师的订单列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    - status: 订单状态筛选（支持逗号分隔多个状态）

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 50,
            "page": 1,
            "page_size": 20
        }
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        status = request.args.get('status', '').strip()

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询 - 查询该陪诊师的订单
        query = Order.query.filter_by(
            companion_id=companion.id,
            is_deleted=False
        )

        # 状态筛选（支持逗号分隔的多个状态）
        if status:
            if ',' in status:
                status_list = [s.strip() for s in status.split(',')]
                query = query.filter(Order.status.in_(status_list))
            else:
                query = query.filter(Order.status == status)

        # 按创建时间降序排序
        query = query.order_by(Order.created_at.desc())

        # 分页
        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 转换为字典并添加关联信息
        orders = []
        for order in pagination.items:
            order_dict = order.to_dict()

            # 添加就诊人信息
            if order.patient_id:
                patient = Patient.query.get(order.patient_id)
                if patient:
                    # 从出生日期计算年龄
                    age = None
                    if patient.birth_date:
                        today = datetime.utcnow().date()
                        age = today.year - patient.birth_date.year
                        # 如果今年生日还没过，年龄减1
                        if (today.month, today.day) < (patient.birth_date.month, patient.birth_date.day):
                            age -= 1

                    order_dict['patient'] = {
                        'id': patient.id,
                        'name': patient.name,
                        'phone': patient.phone,
                        'gender': patient.gender,
                        'age': age
                    }

            # 添加用户信息（下单用户）
            if order.user_id:
                user = User.query.get(order.user_id)
                if user:
                    order_dict['user'] = {
                        'id': user.id,
                        'nickname': user.nickname,
                        'phone': user.phone,
                        'avatar_url': user.avatar_url
                    }

            orders.append(order_dict)

        return success_response({
            'list': orders,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取订单列表成功')

    except Exception as e:
        return error_response(500, 'QUERY_FAILED', f'获取订单列表失败: {str(e)}')


@bp.route('/<int:order_id>', methods=['GET'])
@login_required()
def get_order_detail(order_id):
    """
    获取订单详情

    路径参数:
    - order_id: 订单ID

    响应:
    {
        "success": true,
        "data": {...}
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not order:
            return error_response(404, 'ORDER_NOT_FOUND', '订单不存在')

        # 转换为字典
        order_dict = order.to_dict()

        # 添加就诊人信息
        if order.patient_id:
            patient = Patient.query.get(order.patient_id)
            if patient:
                order_dict['patient'] = patient.to_dict()

        # 添加用户信息
        if order.user_id:
            user = User.query.get(order.user_id)
            if user:
                order_dict['user'] = {
                    'id': user.id,
                    'nickname': user.nickname,
                    'phone': user.phone,
                    'avatar_url': user.avatar_url
                }

        # 添加支付信息
        payment = Payment.query.filter_by(
            order_id=order_id,
            is_deleted=False
        ).order_by(Payment.created_at.desc()).first()
        if payment:
            order_dict['payment'] = payment.to_dict()

        return success_response(order_dict, '获取订单详情成功')

    except Exception as e:
        return error_response(500, 'QUERY_FAILED', f'获取订单详情失败: {str(e)}')


@bp.route('/<int:order_id>/accept', methods=['POST'])
@login_required()
def accept_order(order_id):
    """
    接受订单

    路径参数:
    - order_id: 订单ID

    响应:
    {
        "success": true,
        "data": {
            "order_id": 1,
            "status": "pending_service"
        }
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not order:
            return error_response(404, 'ORDER_NOT_FOUND', '订单不存在')

        # 检查订单状态是否可以接单
        if order.status != 'pending_accept':
            return error_response(400, 'INVALID_STATUS', f'当前订单状态({order.status})不能接单')

        # 更新订单状态
        order.status = 'pending_service'
        order.accepted_at = datetime.utcnow()

        db.session.commit()

        return success_response({
            'order_id': order.id,
            'status': order.status
        }, '接单成功')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'ACCEPT_FAILED', f'接单失败: {str(e)}')


@bp.route('/<int:order_id>/reject', methods=['POST'])
@login_required()
def reject_order(order_id):
    """
    拒绝订单

    路径参数:
    - order_id: 订单ID

    请求体:
    {
        "reject_reason": "时间冲突"
    }

    响应:
    {
        "success": true,
        "data": {
            "order_id": 1,
            "status": "cancelled"
        }
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        data = request.get_json() or {}

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not order:
            return error_response(404, 'ORDER_NOT_FOUND', '订单不存在')

        # 检查订单状态是否可以拒绝
        if order.status != 'pending_accept':
            return error_response(400, 'INVALID_STATUS', f'当前订单状态({order.status})不能拒绝')

        # 更新订单状态
        order.status = 'cancelled'
        order.cancelled_at = datetime.utcnow()
        order.cancel_reason = data.get('reject_reason', '陪诊师拒绝接单')
        order.cancelled_by = 'companion'

        db.session.commit()

        return success_response({
            'order_id': order.id,
            'status': order.status
        }, '已拒绝订单')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'REJECT_FAILED', f'拒绝订单失败: {str(e)}')


@bp.route('/<int:order_id>/start', methods=['POST'])
@login_required()
def start_service(order_id):
    """
    开始服务

    路径参数:
    - order_id: 订单ID

    响应:
    {
        "success": true,
        "data": {
            "order_id": 1,
            "status": "in_service"
        }
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not order:
            return error_response(404, 'ORDER_NOT_FOUND', '订单不存在')

        # 检查订单状态是否可以开始服务
        if order.status != 'pending_service':
            return error_response(400, 'INVALID_STATUS', f'当前订单状态({order.status})不能开始服务')

        # 更新订单状态
        order.status = 'in_service'
        order.service_started_at = datetime.utcnow()

        db.session.commit()

        return success_response({
            'order_id': order.id,
            'status': order.status
        }, '服务已开始')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'START_FAILED', f'开始服务失败: {str(e)}')


@bp.route('/<int:order_id>/complete', methods=['POST'])
@login_required()
def complete_service(order_id):
    """
    完成服务

    路径参数:
    - order_id: 订单ID

    请求体:
    {
        "service_note": "服务备注"
    }

    响应:
    {
        "success": true,
        "data": {
            "order_id": 1,
            "status": "completed"
        }
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        data = request.get_json() or {}

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not order:
            return error_response(404, 'ORDER_NOT_FOUND', '订单不存在')

        # 检查订单状态是否可以完成服务
        if order.status != 'in_service':
            return error_response(400, 'INVALID_STATUS', f'当前订单状态({order.status})不能完成服务')

        # 更新订单状态
        order.status = 'completed'
        order.completed_at = datetime.utcnow()
        if data.get('service_note'):
            order.companion_note = data['service_note']

        # 更新陪诊师统计数据
        companion.completed_orders = (companion.completed_orders or 0) + 1
        companion.total_orders = (companion.total_orders or 0) + 1

        db.session.commit()

        return success_response({
            'order_id': order.id,
            'status': order.status
        }, '服务已完成')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'COMPLETE_FAILED', f'完成服务失败: {str(e)}')


@bp.route('/stats', methods=['GET'])
@login_required()
def get_order_stats():
    """
    获取订单统计

    响应:
    {
        "success": true,
        "data": {
            "pending_accept": 5,
            "pending_service": 3,
            "in_service": 2,
            "completed": 100,
            "cancelled": 10,
            "total": 120
        }
    }
    """
    try:
        companion = get_current_companion()
        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 统计各状态订单数量
        base_query = Order.query.filter_by(
            companion_id=companion.id,
            is_deleted=False
        )

        stats = {
            'pending_accept': base_query.filter_by(status='pending_accept').count(),
            'pending_service': base_query.filter_by(status='pending_service').count(),
            'in_service': base_query.filter_by(status='in_service').count(),
            'completed': base_query.filter_by(status='completed').count(),
            'cancelled': base_query.filter_by(status='cancelled').count(),
            'total': base_query.count()
        }

        return success_response(stats, '获取订单统计成功')

    except Exception as e:
        return error_response(500, 'QUERY_FAILED', f'获取订单统计失败: {str(e)}')
