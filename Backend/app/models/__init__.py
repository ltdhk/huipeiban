# -*- coding: utf-8 -*-
"""
数据模型包
"""
from app import db

# 导入所有模型（用于数据库迁移）
from app.models.user import User, Patient, Address
from app.models.companion import Companion, Institution, Service, ServiceSpec
from app.models.order import Order, Payment
from app.models.review import Review
from app.models.message import Conversation, Message
from app.models.ai import AIChatHistory
from app.models.coupon import Coupon, UserCoupon
from app.models.admin import AdminUser, AdminLog

__all__ = [
    'User', 'Patient', 'Address',
    'Companion', 'Institution', 'Service', 'ServiceSpec',
    'Order', 'Payment',
    'Review',
    'Conversation', 'Message',
    'AIChatHistory',
    'Coupon', 'UserCoupon',
    'AdminUser', 'AdminLog'
]
