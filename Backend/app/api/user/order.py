# -*- coding: utf-8 -*-
"""
订单相关API - 用户端
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime, date, time as time_obj
import uuid

from app.models.order import Order, Payment
from app.models.user import Patient
from app.models.companion import Companion, Institution
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_order', __name__, url_prefix='/api/v1/user/orders')


@bp.route('', methods=['POST'])
@login_required()
def create_order():
    """
    创建订单

    请求体:
    {
        "patient_id": 1,
        "order_type": "companion",  // companion 或 institution
        "companion_id": 1,  // order_type=companion 时必填
        "institution_id": 1,  // order_type=institution 时必填
        "service_id": 1,
        "hospital_name": "北京协和医院",
        "hospital_address": "...",
        "department": "心内科",
        "appointment_date": "2025-11-15",
        "appointment_time": "09:00",
        "need_pickup": true,
        "pickup_type": "both",  // pickup_only/dropoff_only/both
        "pickup_address_id": 1,
        "service_price": 200.00,
        "pickup_price": 50.00,
        "coupon_id": 1,  // 可选
        "user_note": "需要轮椅"
    }

    响应:
    {
        "success": true,
        "data": {
            "order_id": 1,
            "order_no": "ORD20251112123456",
            ...
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # JWT 返回的 user_id 可能是字符串，需要转换为整数
        if isinstance(current_user_id, str):
            current_user_id = int(current_user_id)

        data = request.get_json()

        # 验证必填字段
        required_fields = ['patient_id', 'order_type', 'hospital_name',
                          'appointment_date', 'appointment_time', 'service_price']
        for field in required_fields:
            if field not in data:
                return error_response(400, 'MISSING_FIELD', f'缺少必填字段: {field}')

        # 验证订单类型
        order_type = data['order_type']
        if order_type not in ['companion', 'institution']:
            return error_response(400, 'INVALID_ORDER_TYPE', '订单类型错误')

        # 验证服务提供方
        if order_type == 'companion':
            if 'companion_id' not in data:
                return error_response(400, 'MISSING_COMPANION_ID', '缺少陪诊师ID')
            companion = Companion.query.get(data['companion_id'])
            if not companion or companion.is_deleted:
                return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师不存在')
        else:
            if 'institution_id' not in data:
                return error_response(400, 'MISSING_INSTITUTION_ID', '缺少机构ID')
            institution = Institution.query.get(data['institution_id'])
            if not institution or institution.is_deleted:
                return error_response(404, 'INSTITUTION_NOT_FOUND', '机构不存在')

        # 验证就诊人
        patient = Patient.query.filter_by(
            id=data['patient_id'],
            user_id=current_user_id,
            is_deleted=False
        ).first()
        if not patient:
            return error_response(404, 'PATIENT_NOT_FOUND', '就诊人不存在')

        # 生成订单号
        order_no = f"ORD{datetime.now().strftime('%Y%m%d%H%M%S')}{uuid.uuid4().hex[:6].upper()}"

        # 计算总价
        service_price = float(data['service_price'])
        pickup_price = float(data.get('pickup_price', 0))
        coupon_discount = 0.0  # TODO: 处理优惠券逻辑
        total_price = service_price + pickup_price - coupon_discount

        # 创建订单
        order = Order(
            order_no=order_no,
            user_id=current_user_id,
            patient_id=data['patient_id'],
            order_type=order_type,
            companion_id=data.get('companion_id'),
            institution_id=data.get('institution_id'),
            service_id=data.get('service_id'),
            service_spec_id=data.get('service_spec_id'),
            hospital_name=data['hospital_name'],
            hospital_address=data.get('hospital_address'),
            department=data.get('department'),
            appointment_date=datetime.strptime(data['appointment_date'], '%Y-%m-%d').date(),
            appointment_time=datetime.strptime(data['appointment_time'], '%H:%M').time(),
            need_pickup=data.get('need_pickup', False),
            pickup_type=data.get('pickup_type'),
            pickup_address_id=data.get('pickup_address_id'),
            service_price=service_price,
            pickup_price=pickup_price,
            coupon_discount=coupon_discount,
            total_price=total_price,
            user_note=data.get('user_note'),
            status='pending_payment'
        )

        db.session.add(order)
        db.session.commit()

        return success_response({
            'order_id': order.id,
            'order_no': order.order_no,
            'total_price': float(total_price),
            'status': order.status
        }, '订单创建成功')

    except ValueError as e:
        return error_response(400, 'INVALID_DATE_FORMAT', f'日期时间格式错误: {str(e)}')
    except Exception as e:
        db.session.rollback()
        return error_response(500, 'CREATE_FAILED', f'创建订单失败: {str(e)}')


@bp.route('', methods=['GET'])
@login_required()
def get_orders():
    """
    获取订单列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    - status: 订单状态筛选
    - order_type: 订单类型筛选（companion/institution）

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
        current_user_id = get_jwt_identity()
        # JWT 返回的 user_id 可能是字符串，需要转换为整数
        if isinstance(current_user_id, str):
            current_user_id = int(current_user_id)

        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        status = request.args.get('status', '').strip()
        order_type = request.args.get('order_type', '').strip()

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询
        query = Order.query.filter_by(
            user_id=current_user_id,
            is_deleted=False
        )

        # 状态筛选（支持逗号分隔的多个状态）
        if status:
            if ',' in status:
                # 多个状态，使用 IN 查询
                status_list = [s.strip() for s in status.split(',')]
                query = query.filter(Order.status.in_(status_list))
            else:
                # 单个状态
                query = query.filter(Order.status == status)

        # 类型筛选
        if order_type:
            query = query.filter(Order.order_type == order_type)

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
                    order_dict['patient'] = {
                        'id': patient.id,
                        'name': patient.name,
                        'phone': patient.phone
                    }

            # 添加陪诊师/机构信息
            if order.companion_id:
                companion = Companion.query.get(order.companion_id)
                if companion:
                    # 从关联的 User 获取头像和电话
                    user = companion.user
                    order_dict['companion'] = {
                        'id': companion.id,
                        'user_id': companion.user_id,  # 用于即时通讯
                        'name': companion.name,
                        'avatar_url': user.avatar_url if user else None,
                        'phone': user.phone if user else None,
                        'rating': float(companion.rating) if companion.rating else 5.0,
                        'service_years': companion.service_years
                    }
            elif order.institution_id:
                institution = Institution.query.get(order.institution_id)
                if institution:
                    order_dict['institution'] = {
                        'id': institution.id,
                        'user_id': institution.user_id,  # 用于即时通讯
                        'name': institution.name,
                        'logo_url': institution.logo_url,
                        'phone': institution.phone
                    }

            orders.append(order_dict)

        # 调试日志
        print(f"DEBUG: 准备返回 {len(orders)} 个订单, total={pagination.total}")

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
        "data": {
            "id": 1,
            "order_no": "...",
            ...
            "patient": {...},
            "companion": {...} 或 "institution": {...},
            "payment": {...}
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # JWT 返回的 user_id 可能是字符串，需要转换为整数
        if isinstance(current_user_id, str):
            current_user_id = int(current_user_id)

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            user_id=current_user_id,
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

        # 添加陪诊师/机构信息
        if order.companion_id:
            companion = Companion.query.get(order.companion_id)
            if companion:
                order_dict['companion'] = companion.to_dict()
        elif order.institution_id:
            institution = Institution.query.get(order.institution_id)
            if institution:
                order_dict['institution'] = institution.to_dict()

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


@bp.route('/<int:order_id>/cancel', methods=['POST'])
@login_required()
def cancel_order(order_id):
    """
    取消订单

    路径参数:
    - order_id: 订单ID

    请求体:
    {
        "cancel_reason": "行程有变"
    }

    响应:
    {
        "success": true,
        "data": {
            "order_id": 1,
            "status": "cancelled",
            "refund_amount": 200.00
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # JWT 返回的 user_id 可能是字符串，需要转换为整数
        if isinstance(current_user_id, str):
            current_user_id = int(current_user_id)

        data = request.get_json() or {}

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not order:
            return error_response(404, 'ORDER_NOT_FOUND', '订单不存在')

        # 检查订单状态是否可以取消
        cancellable_statuses = ['pending_payment', 'pending_accept', 'pending_service']
        if order.status not in cancellable_statuses:
            return error_response(400, 'INVALID_STATUS', f'当前订单状态({order.status})不能取消')

        # 计算退款金额
        refund_amount = 0.0
        if order.status == 'pending_payment':
            # 未支付订单，无需退款
            refund_amount = 0.0
        else:
            # 已支付订单，需要退款
            # TODO: 根据取消时间和政策计算退款金额
            refund_amount = float(order.total_price)

        # 更新订单状态
        order.status = 'cancelled'
        order.cancelled_at = datetime.utcnow()
        order.cancel_reason = data.get('cancel_reason', '用户取消')
        order.cancelled_by = 'user'
        order.refund_amount = refund_amount
        order.refund_status = 'pending' if refund_amount > 0 else None

        db.session.commit()

        # TODO: 如果需要退款，调用退款接口

        return success_response({
            'order_id': order.id,
            'status': order.status,
            'refund_amount': float(refund_amount)
        }, '订单已取消')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'CANCEL_FAILED', f'取消订单失败: {str(e)}')
