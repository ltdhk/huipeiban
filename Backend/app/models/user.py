# -*- coding: utf-8 -*-
"""
用户相关模型
"""
from app import db
from datetime import datetime
from sqlalchemy import Index, event
import time


class User(db.Model):
    """用户表"""
    __tablename__ = 'users'

    id = db.Column(db.BigInteger, primary_key=True)

    # 基本信息
    phone = db.Column(db.String(20), unique=True, nullable=True, comment='手机号（加密存储）')
    password_hash = db.Column(db.String(255), comment='密码哈希')
    nickname = db.Column(db.String(50), comment='昵称')
    avatar_url = db.Column(db.String(255), comment='头像URL')
    gender = db.Column(db.String(10), comment='性别: male/female/unknown')
    birth_date = db.Column(db.Date, comment='出生日期')

    # 微信信息
    wechat_openid = db.Column(db.String(100), unique=True, comment='微信OpenID')
    wechat_unionid = db.Column(db.String(100), comment='微信UnionID')

    # 用户类型
    user_type = db.Column(db.String(20), default='patient', comment='用户类型: patient/companion/institution')

    # 账户信息
    balance = db.Column(db.Numeric(10, 2), default=0.00, comment='账户余额')
    points = db.Column(db.Integer, default=0, comment='积分')
    member_level = db.Column(db.String(20), default='normal', comment='会员等级')

    # 统计信息
    total_orders = db.Column(db.Integer, default=0, comment='总订单数')
    total_spent = db.Column(db.Numeric(10, 2), default=0.00, comment='总消费金额')

    # 状态
    status = db.Column(db.String(20), default='active', comment='状态: active/disabled/blocked')

    # 时间戳
    last_login_at = db.Column(db.DateTime, comment='最后登录时间')
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 关系
    patients = db.relationship('Patient', backref='user', lazy='dynamic')
    addresses = db.relationship('Address', backref='user', lazy='dynamic')
    orders = db.relationship('Order', backref='user', lazy='dynamic')

    # 索引
    __table_args__ = (
        Index('idx_users_phone', 'phone'),
        Index('idx_users_wechat_openid', 'wechat_openid'),
        Index('idx_users_status', 'status'),
    )

    def to_dict(self, include_sensitive=False):
        """转换为字典"""
        # 处理手机号脱敏
        if self.phone:
            phone = self.phone if include_sensitive else self.phone[:3] + '****' + self.phone[-4:]
        else:
            phone = None

        data = {
            'id': self.id,
            'phone': phone,
            'nickname': self.nickname,
            'avatar_url': self.avatar_url,
            'gender': self.gender,
            'birth_date': self.birth_date.isoformat() if self.birth_date else None,
            'user_type': self.user_type,
            'balance': float(self.balance) if self.balance else 0.0,
            'points': self.points,
            'member_level': self.member_level,
            'total_orders': self.total_orders,
            'total_spent': float(self.total_spent) if self.total_spent else 0.0,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_login_at': self.last_login_at.isoformat() if self.last_login_at else None
        }
        return data


# 自动生成用户 ID（使用毫秒级时间戳 + 微秒）
_last_user_id = 0
@event.listens_for(User, 'before_insert')
def generate_user_id(mapper, connection, target):
    """在插入用户之前自动生成 ID"""
    global _last_user_id
    if target.id is None:
        # 使用微秒级时间戳确保唯一性
        current_id = int(time.time() * 1000000)
        # 如果与上一个 ID 相同，则递增
        if current_id <= _last_user_id:
            current_id = _last_user_id + 1
        _last_user_id = current_id
        target.id = current_id


class Patient(db.Model):
    """就诊人表"""
    __tablename__ = 'patients'

    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, comment='用户ID')

    # 就诊人信息
    name = db.Column(db.String(50), nullable=False, comment='姓名')
    gender = db.Column(db.String(10), nullable=False, comment='性别')
    birth_date = db.Column(db.Date, comment='出生日期')
    phone = db.Column(db.String(20), comment='联系电话')
    id_card = db.Column(db.String(100), comment='身份证号（加密存储）')
    relationship = db.Column(db.String(20), comment='与用户关系: self/parent/spouse/child/other')

    # 医疗信息
    medical_history = db.Column(db.Text, comment='病史摘要')
    allergies = db.Column(db.Text, comment='过敏史')
    special_needs = db.Column(db.Text, comment='特殊需求')

    # 保险信息
    insurance_type = db.Column(db.String(50), comment='医保类型')
    insurance_number = db.Column(db.String(100), comment='医保卡号')

    # 设置
    is_default = db.Column(db.Boolean, default=False, comment='是否默认就诊人')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_deleted = db.Column(db.Boolean, default=False)

    # 索引
    __table_args__ = (
        Index('idx_patients_user_id', 'user_id'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'name': self.name,
            'gender': self.gender,
            'birth_date': self.birth_date.isoformat() if self.birth_date else None,
            'phone': self.phone,
            'id_card': self.id_card,
            'relationship': self.relationship,
            'medical_history': self.medical_history,
            'allergies': self.allergies,
            'special_needs': self.special_needs,
            'insurance_type': self.insurance_type,
            'insurance_number': self.insurance_number,
            'is_default': self.is_default,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }


class Address(db.Model):
    """用户地址表"""
    __tablename__ = 'addresses'

    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, comment='用户ID')

    # 地址信息
    contact_name = db.Column(db.String(50), nullable=False, comment='联系人')
    contact_phone = db.Column(db.String(20), nullable=False, comment='联系电话')
    province = db.Column(db.String(50), nullable=False, comment='省份')
    city = db.Column(db.String(50), nullable=False, comment='城市')
    district = db.Column(db.String(50), nullable=False, comment='区/县')
    detail_address = db.Column(db.String(255), nullable=False, comment='详细地址')

    # 位置信息
    latitude = db.Column(db.Numeric(10, 7), comment='纬度')
    longitude = db.Column(db.Numeric(10, 7), comment='经度')

    # 地址标签
    address_type = db.Column(db.String(20), default='other', comment='地址类型: home/company/hospital/other')
    label = db.Column(db.String(50), comment='自定义标签')

    # 设置
    is_default = db.Column(db.Boolean, default=False, comment='是否默认地址')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_deleted = db.Column(db.Boolean, default=False)

    # 索引
    __table_args__ = (
        Index('idx_addresses_user_id', 'user_id'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'contact_name': self.contact_name,
            'contact_phone': self.contact_phone,
            'province': self.province,
            'city': self.city,
            'district': self.district,
            'detail_address': self.detail_address,
            'latitude': float(self.latitude) if self.latitude else None,
            'longitude': float(self.longitude) if self.longitude else None,
            'address_type': self.address_type,
            'label': self.label,
            'is_default': self.is_default
        }
