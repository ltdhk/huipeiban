# -*- coding: utf-8 -*-
"""
订单和支付相关模型
"""
from app import db
from datetime import datetime
from sqlalchemy import Index


class Order(db.Model):
    """订单表"""
    __tablename__ = 'orders'

    id = db.Column(db.BigInteger, primary_key=True)

    # 订单编号
    order_no = db.Column(db.String(32), unique=True, nullable=False, comment='订单号')

    # 关联信息
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, comment='用户 ID')
    patient_id = db.Column(db.BigInteger, db.ForeignKey('patients.id'), nullable=False, comment='就诊人 ID')

    # 订单类型
    order_type = db.Column(db.String(20), nullable=False, comment='订单类型: companion/institution')

    # 服务提供方
    companion_id = db.Column(db.BigInteger, db.ForeignKey('companions.id'), comment='陪诊师 ID')
    institution_id = db.Column(db.BigInteger, db.ForeignKey('institutions.id'), comment='机构 ID')

    # 服务信息
    service_id = db.Column(db.BigInteger, comment='服务 ID')
    service_spec_id = db.Column(db.BigInteger, comment='服务规格 ID')

    # 预约信息
    hospital_name = db.Column(db.String(100), nullable=False, comment='医院名称')
    hospital_address = db.Column(db.String(255), comment='医院地址')
    department = db.Column(db.String(100), comment='科室')
    appointment_date = db.Column(db.Date, nullable=False, comment='预约日期')
    appointment_time = db.Column(db.Time, nullable=False, comment='预约时间')

    # 接送信息
    need_pickup = db.Column(db.Boolean, default=False, comment='是否需要接送')
    pickup_type = db.Column(db.String(20), comment='接送类型: pickup_only/dropoff_only/both')
    pickup_address_id = db.Column(db.BigInteger, db.ForeignKey('addresses.id'), comment='接送地址 ID')
    pickup_address_detail = db.Column(db.Text, comment='接送地址详情')

    # 费用信息
    service_price = db.Column(db.Numeric(10, 2), nullable=False, comment='服务费')
    pickup_price = db.Column(db.Numeric(10, 2), default=0.00, comment='接送费')
    coupon_discount = db.Column(db.Numeric(10, 2), default=0.00, comment='优惠券抵扣')
    total_price = db.Column(db.Numeric(10, 2), nullable=False, comment='订单总额')

    # 订单备注
    user_note = db.Column(db.Text, comment='用户备注')
    admin_note = db.Column(db.Text, comment='管理员备注')

    # 订单状态
    status = db.Column(db.String(20), nullable=False, default='pending_payment',
                       comment='订单状态: pending_payment/pending_accept/pending_service/in_service/completed/cancelled')

    # 关键时间节点
    paid_at = db.Column(db.DateTime, comment='支付时间')
    accepted_at = db.Column(db.DateTime, comment='接单时间')
    service_started_at = db.Column(db.DateTime, comment='服务开始时间')
    service_completed_at = db.Column(db.DateTime, comment='服务完成时间')
    cancelled_at = db.Column(db.DateTime, comment='取消时间')
    cancel_reason = db.Column(db.Text, comment='取消原因')
    cancelled_by = db.Column(db.String(20), comment='取消方: user/companion/admin')

    # 退款信息
    refund_amount = db.Column(db.Numeric(10, 2), comment='退款金额')
    refund_status = db.Column(db.String(20), comment='退款状态: pending/processing/completed/failed')
    refund_reason = db.Column(db.Text, comment='退款原因')
    refunded_at = db.Column(db.DateTime, comment='退款时间')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 关系
    payments = db.relationship('Payment', backref='order', lazy='dynamic')

    # 索引
    __table_args__ = (
        Index('idx_orders_order_no', 'order_no'),
        Index('idx_orders_user_id', 'user_id'),
        Index('idx_orders_companion_id', 'companion_id'),
        Index('idx_orders_institution_id', 'institution_id'),
        Index('idx_orders_status', 'status'),
        Index('idx_orders_appointment_date', 'appointment_date'),
        Index('idx_orders_created_at', 'created_at'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'order_no': self.order_no,
            'user_id': self.user_id,
            'patient_id': self.patient_id,
            'order_type': self.order_type,
            'companion_id': self.companion_id,
            'institution_id': self.institution_id,
            'hospital_name': self.hospital_name,
            'hospital_address': self.hospital_address,
            'department': self.department,
            'appointment_date': self.appointment_date.isoformat() if self.appointment_date else None,
            'appointment_time': self.appointment_time.isoformat() if self.appointment_time else None,
            'need_pickup': self.need_pickup,
            'pickup_type': self.pickup_type,
            'service_price': float(self.service_price) if self.service_price else 0.0,
            'pickup_price': float(self.pickup_price) if self.pickup_price else 0.0,
            'coupon_discount': float(self.coupon_discount) if self.coupon_discount else 0.0,
            'total_price': float(self.total_price) if self.total_price else 0.0,
            'user_note': self.user_note,
            'status': self.status,
            'paid_at': self.paid_at.isoformat() if self.paid_at else None,
            'accepted_at': self.accepted_at.isoformat() if self.accepted_at else None,
            'service_started_at': self.service_started_at.isoformat() if self.service_started_at else None,
            'service_completed_at': self.service_completed_at.isoformat() if self.service_completed_at else None,
            'cancelled_at': self.cancelled_at.isoformat() if self.cancelled_at else None,
            'cancel_reason': self.cancel_reason,
            'cancelled_by': self.cancelled_by,
            'refund_amount': float(self.refund_amount) if self.refund_amount else 0.0,
            'refund_status': self.refund_status,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }


class Payment(db.Model):
    """支付表"""
    __tablename__ = 'payments'

    id = db.Column(db.BigInteger, primary_key=True)

    # 支付编号
    payment_no = db.Column(db.String(32), unique=True, nullable=False, comment='支付单号')

    # 关联订单
    order_id = db.Column(db.BigInteger, db.ForeignKey('orders.id'), nullable=False, comment='订单 ID')
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, comment='用户 ID')

    # 支付信息
    payment_method = db.Column(db.String(20), nullable=False, comment='支付方式: wechat/alipay/balance')
    payment_amount = db.Column(db.Numeric(10, 2), nullable=False, comment='支付金额')

    # 第三方支付信息
    third_party_trade_no = db.Column(db.String(64), comment='第三方交易号')
    third_party_response = db.Column(db.Text, comment='第三方响应（JSON）')

    # 支付状态
    status = db.Column(db.String(20), nullable=False, default='pending',
                       comment='支付状态: pending/processing/success/failed/refunding/refunded')

    # 时间戳
    paid_at = db.Column(db.DateTime, comment='支付成功时间')
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 索引
    __table_args__ = (
        Index('idx_payments_payment_no', 'payment_no'),
        Index('idx_payments_order_id', 'order_id'),
        Index('idx_payments_user_id', 'user_id'),
        Index('idx_payments_status', 'status'),
        Index('idx_payments_third_party_trade_no', 'third_party_trade_no'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'payment_no': self.payment_no,
            'order_id': self.order_id,
            'user_id': self.user_id,
            'payment_method': self.payment_method,
            'payment_amount': float(self.payment_amount) if self.payment_amount else 0.0,
            'status': self.status,
            'paid_at': self.paid_at.isoformat() if self.paid_at else None,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
