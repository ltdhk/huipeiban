# -*- coding: utf-8 -*-
"""
支付相关API - 用户端
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime
import uuid

from app.models.order import Order, Payment
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_payment', __name__, url_prefix='/api/v1/user/payments')


@bp.route('/create', methods=['POST'])
@login_required()
def create_payment():
    """
    创建支付

    请求体:
    {
        "order_id": 1,
        "payment_method": "wechat"  // wechat/alipay/balance
    }

    响应:
    {
        "success": true,
        "data": {
            "payment_id": 1,
            "payment_no": "PAY20251112123456",
            "payment_params": {  // 微信支付参数
                "appId": "...",
                "timeStamp": "...",
                "nonceStr": "...",
                "package": "...",
                "signType": "...",
                "paySign": "..."
            }
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()

        # 验证必填字段
        if 'order_id' not in data:
            return error_response('缺少订单ID', 400)
        if 'payment_method' not in data:
            return error_response('缺少支付方式', 400)

        order_id = data['order_id']
        payment_method = data['payment_method']

        # 验证支付方式
        if payment_method not in ['wechat', 'alipay', 'balance']:
            return error_response('不支持的支付方式', 400)

        # 查询订单
        order = Order.query.filter_by(
            id=order_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not order:
            return error_response('订单不存在', 404)

        # 检查订单状态
        if order.status != 'pending_payment':
            return error_response('订单状态不正确', 400)

        # 检查是否已有待支付的支付记录
        existing_payment = Payment.query.filter_by(
            order_id=order_id,
            status='pending',
            is_deleted=False
        ).first()

        if existing_payment:
            # 返回现有支付记录
            payment = existing_payment
        else:
            # 生成支付单号
            payment_no = f"PAY{datetime.now().strftime('%Y%m%d%H%M%S')}{uuid.uuid4().hex[:6].upper()}"

            # 创建支付记录
            payment = Payment(
                payment_no=payment_no,
                order_id=order_id,
                user_id=current_user_id,
                payment_method=payment_method,
                payment_amount=order.total_price,
                status='pending'
            )

            db.session.add(payment)
            db.session.commit()

        # 调用第三方支付接口
        payment_params = {}

        if payment_method == 'wechat':
            # TODO: 集成微信支付SDK
            # 这里返回模拟数据，实际需要调用微信统一下单接口
            payment_params = {
                'appId': 'wx426040a3db6be21b',  # 从配置读取
                'timeStamp': str(int(datetime.now().timestamp())),
                'nonceStr': uuid.uuid4().hex,
                'package': f'prepay_id=wx{payment.payment_no}',  # 实际应该是微信返回的prepay_id
                'signType': 'MD5',
                'paySign': 'mock_sign_value'  # 实际需要根据微信规则签名
            }

            # 更新支付记录（保存第三方响应）
            payment.status = 'processing'
            payment.third_party_response = str(payment_params)
            db.session.commit()

        elif payment_method == 'alipay':
            # TODO: 集成支付宝SDK
            payment_params = {
                'orderInfo': 'mock_alipay_params'
            }

        elif payment_method == 'balance':
            # TODO: 余额支付逻辑
            # 检查用户余额是否足够
            # 扣除余额
            # 直接标记支付成功
            payment.status = 'success'
            payment.paid_at = datetime.utcnow()

            # 更新订单状态
            order.status = 'pending_accept'
            order.paid_at = datetime.utcnow()

            db.session.commit()

            return success_response({
                'payment_id': payment.id,
                'payment_no': payment.payment_no,
                'status': 'success',
                'message': '支付成功'
            }, '支付成功')

        return success_response({
            'payment_id': payment.id,
            'payment_no': payment.payment_no,
            'payment_method': payment_method,
            'payment_amount': float(payment.payment_amount),
            'payment_params': payment_params
        }, '支付单创建成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'创建支付失败: {str(e)}', 500)


@bp.route('/<int:payment_id>', methods=['GET'])
@login_required()
def get_payment_status(payment_id):
    """
    查询支付状态

    路径参数:
    - payment_id: 支付ID

    响应:
    {
        "success": true,
        "data": {
            "payment_id": 1,
            "payment_no": "...",
            "status": "success",
            "paid_at": "..."
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # 查询支付记录
        payment = Payment.query.filter_by(
            id=payment_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not payment:
            return error_response('支付记录不存在', 404)

        # TODO: 如果支付状态为processing，调用微信/支付宝接口查询实际支付状态

        return success_response(payment.to_dict(), '获取支付状态成功')

    except Exception as e:
        return error_response(f'查询支付状态失败: {str(e)}', 500)


@bp.route('/<int:payment_id>/notify', methods=['POST'])
def payment_notify(payment_id):
    """
    支付成功通知（前端模拟调用，实际应该由微信/支付宝回调）

    这个接口仅用于开发测试，生产环境应该使用 webhook

    请求体:
    {
        "status": "success"
    }
    """
    try:
        data = request.get_json()

        # 查询支付记录
        payment = Payment.query.filter_by(
            id=payment_id,
            is_deleted=False
        ).first()

        if not payment:
            return error_response('支付记录不存在', 404)

        # 更新支付状态
        if data.get('status') == 'success':
            payment.status = 'success'
            payment.paid_at = datetime.utcnow()

            # 更新订单状态
            order = Order.query.get(payment.order_id)
            if order:
                order.status = 'pending_accept'
                order.paid_at = datetime.utcnow()

            db.session.commit()

            return success_response({
                'payment_id': payment.id,
                'order_id': payment.order_id,
                'status': 'success'
            }, '支付成功')
        else:
            payment.status = 'failed'
            db.session.commit()

            return success_response({
                'payment_id': payment.id,
                'status': 'failed'
            }, '支付失败')

    except Exception as e:
        db.session.rollback()
        return error_response(f'处理支付通知失败: {str(e)}', 500)
