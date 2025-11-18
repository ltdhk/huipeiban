# -*- coding: utf-8 -*-
"""
陪诊师和机构相关模型
"""
from app import db
from datetime import datetime
from sqlalchemy import Index


class Institution(db.Model):
    """陪诊机构表"""
    __tablename__ = 'institutions'

    id = db.Column(db.BigInteger, primary_key=True)

    # 基本信息
    name = db.Column(db.String(100), nullable=False, comment='机构名称')
    logo_url = db.Column(db.String(255), comment='LOGO URL')
    phone = db.Column(db.String(20), nullable=False, comment='联系电话')
    email = db.Column(db.String(100), comment='邮箱')

    # 法人信息
    legal_person = db.Column(db.String(50), comment='法人代表')
    legal_person_id_card = db.Column(db.String(100), comment='法人身份证（加密）')

    # 资质信息
    business_license_url = db.Column(db.String(255), comment='营业执照 URL')
    business_license_number = db.Column(db.String(100), comment='营业执照号')
    medical_license_url = db.Column(db.String(255), comment='医疗相关许可证 URL')
    other_certificates = db.Column(db.Text, comment='其他证书（JSON 数组）')

    # 服务信息
    service_area = db.Column(db.Text, comment='服务区域（JSON 数组）')
    service_scope = db.Column(db.Text, comment='服务范围描述')
    introduction = db.Column(db.Text, comment='机构简介')

    # 地址信息
    province = db.Column(db.String(50), comment='省份')
    city = db.Column(db.String(50), comment='城市')
    district = db.Column(db.String(50), comment='区/县')
    detail_address = db.Column(db.String(255), comment='详细地址')
    latitude = db.Column(db.Numeric(10, 7), comment='纬度')
    longitude = db.Column(db.Numeric(10, 7), comment='经度')

    # 评分统计
    rating = db.Column(db.Numeric(3, 2), default=5.00, comment='平均评分')
    review_count = db.Column(db.Integer, default=0, comment='评价数量')

    # 服务统计
    total_orders = db.Column(db.Integer, default=0, comment='总订单数')
    completed_orders = db.Column(db.Integer, default=0, comment='完成订单数')
    companion_count = db.Column(db.Integer, default=0, comment='陪诊师数量')

    # 财务信息
    account_bank = db.Column(db.String(100), comment='开户银行')
    account_number = db.Column(db.String(100), comment='银行账号（加密）')
    account_holder = db.Column(db.String(50), comment='开户人')

    # 状态
    status = db.Column(db.String(20), default='pending', comment='状态: pending/approved/rejected/disabled')
    reject_reason = db.Column(db.Text, comment='拒绝原因')

    # 时间戳
    approved_at = db.Column(db.DateTime, comment='审核通过时间')
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 关系
    companions = db.relationship('Companion', backref='institution', lazy='dynamic')
    orders = db.relationship('Order', backref='institution', lazy='dynamic')

    # 索引
    __table_args__ = (
        Index('idx_institutions_status', 'status'),
        Index('idx_institutions_city', 'city'),
        Index('idx_institutions_rating', 'rating'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'name': self.name,
            'logo_url': self.logo_url,
            'phone': self.phone,
            'email': self.email,
            'service_scope': self.service_scope,
            'introduction': self.introduction,
            'province': self.province,
            'city': self.city,
            'district': self.district,
            'detail_address': self.detail_address,
            'latitude': float(self.latitude) if self.latitude else None,
            'longitude': float(self.longitude) if self.longitude else None,
            'rating': float(self.rating) if self.rating else 5.0,
            'review_count': self.review_count,
            'total_orders': self.total_orders,
            'completed_orders': self.completed_orders,
            'companion_count': self.companion_count,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }


class Companion(db.Model):
    """陪诊师表"""
    __tablename__ = 'companions'

    id = db.Column(db.BigInteger, primary_key=True)

    # 基本信息
    phone = db.Column(db.String(20), unique=True, nullable=False, comment='手机号')
    password_hash = db.Column(db.String(255), nullable=False, comment='密码哈希')
    name = db.Column(db.String(50), nullable=False, comment='姓名')
    avatar_url = db.Column(db.String(255), comment='头像 URL')
    gender = db.Column(db.String(10), comment='性别')
    age = db.Column(db.Integer, comment='年龄')
    id_card = db.Column(db.String(100), nullable=False, comment='身份证号（加密）')

    # 所属机构
    institution_id = db.Column(db.BigInteger, db.ForeignKey('institutions.id'), comment='所属机构 ID')

    # 资质信息
    certificates = db.Column(db.Text, comment='资质证书（JSON 数组）')
    health_certificate_url = db.Column(db.String(255), comment='健康证 URL')
    health_certificate_expire_date = db.Column(db.Date, comment='健康证到期时间')

    # 服务信息
    service_years = db.Column(db.Integer, comment='从业年限')
    specialties = db.Column(db.Text, comment='擅长领域（JSON 数组）')
    service_area = db.Column(db.Text, comment='服务区域（JSON 数组）')
    service_hospitals = db.Column(db.Text, comment='常服务的医院（JSON 数组）')
    introduction = db.Column(db.Text, comment='个人简介')

    # 车辆信息
    has_car = db.Column(db.Boolean, default=False, comment='是否有车')
    car_type = db.Column(db.String(50), comment='车辆类型')
    car_plate = db.Column(db.String(20), comment='车牌号')

    # 评分统计
    rating = db.Column(db.Numeric(3, 2), default=5.00, comment='平均评分')
    review_count = db.Column(db.Integer, default=0, comment='评价数量')

    # 服务统计
    total_orders = db.Column(db.Integer, default=0, comment='总订单数')
    completed_orders = db.Column(db.Integer, default=0, comment='完成订单数')
    cancelled_orders = db.Column(db.Integer, default=0, comment='取消订单数')

    # 财务信息
    total_income = db.Column(db.Numeric(10, 2), default=0.00, comment='总收入')
    available_balance = db.Column(db.Numeric(10, 2), default=0.00, comment='可提现余额')
    bank_name = db.Column(db.String(100), comment='开户银行')
    bank_account = db.Column(db.String(100), comment='银行账号（加密）')
    account_holder = db.Column(db.String(50), comment='开户人')

    # 状态
    status = db.Column(db.String(20), default='pending', comment='状态: pending/approved/rejected/disabled')
    reject_reason = db.Column(db.Text, comment='拒绝原因')
    is_verified = db.Column(db.Boolean, default=False, comment='是否已认证')
    is_online = db.Column(db.Boolean, default=False, comment='是否在线接单')

    # 时间戳
    approved_at = db.Column(db.DateTime, comment='审核通过时间')
    last_login_at = db.Column(db.DateTime, comment='最后登录时间')
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 关系
    services = db.relationship('Service', backref='companion', lazy='dynamic')
    orders = db.relationship('Order', backref='companion', lazy='dynamic')

    # 索引
    __table_args__ = (
        Index('idx_companions_phone', 'phone'),
        Index('idx_companions_institution_id', 'institution_id'),
        Index('idx_companions_status', 'status'),
        Index('idx_companions_rating', 'rating'),
        Index('idx_companions_has_car', 'has_car'),
    )

    def to_dict(self, include_sensitive=False):
        """转换为字典"""
        import json

        data = {
            'id': self.id,
            'name': self.name,
            'avatar_url': self.avatar_url,
            'gender': self.gender,
            'age': self.age,
            'institution_id': self.institution_id,
            'service_years': self.service_years,
            'service_area': json.loads(self.service_area) if self.service_area else [],
            'service_hospitals': json.loads(self.service_hospitals) if self.service_hospitals else [],
            'specialties': json.loads(self.specialties) if self.specialties else [],
            'certificates': json.loads(self.certificates) if self.certificates else [],
            'introduction': self.introduction,
            'has_car': self.has_car,
            'car_type': self.car_type,
            'rating': float(self.rating) if self.rating else 5.0,
            'review_count': self.review_count,
            'total_orders': self.total_orders,
            'completed_orders': self.completed_orders,
            'status': self.status,
            'is_verified': self.is_verified,
            'is_online': self.is_online,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }

        if include_sensitive:
            data['phone'] = self.phone
            data['total_income'] = float(self.total_income) if self.total_income else 0.0
            data['available_balance'] = float(self.available_balance) if self.available_balance else 0.0

        return data


class Service(db.Model):
    """服务产品表"""
    __tablename__ = 'services'

    id = db.Column(db.BigInteger, primary_key=True)
    companion_id = db.Column(db.BigInteger, db.ForeignKey('companions.id'), nullable=False, comment='陪诊师 ID')

    # 服务信息
    title = db.Column(db.String(100), nullable=False, comment='服务标题')
    category = db.Column(db.String(50), comment='服务类别')
    description = db.Column(db.Text, comment='服务描述')
    features = db.Column(db.Text, comment='服务特色（JSON 数组）')

    # 定价
    base_price = db.Column(db.Numeric(10, 2), nullable=False, comment='基础价格')
    additional_hour_price = db.Column(db.Numeric(10, 2), comment='超时加价/小时')

    # 服务区域
    service_cities = db.Column(db.Text, comment='服务城市（JSON 数组）')
    service_hospitals = db.Column(db.Text, comment='服务医院（JSON 数组）')

    # 统计
    sales_count = db.Column(db.Integer, default=0, comment='销量')
    view_count = db.Column(db.Integer, default=0, comment='浏览量')

    # 状态
    is_active = db.Column(db.Boolean, default=True, comment='是否上架')

    # 排序
    sort_order = db.Column(db.Integer, default=0, comment='排序')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_deleted = db.Column(db.Boolean, default=False)

    # 关系
    specs = db.relationship('ServiceSpec', backref='service', lazy='dynamic')

    # 索引
    __table_args__ = (
        Index('idx_services_companion_id', 'companion_id'),
        Index('idx_services_category', 'category'),
        Index('idx_services_is_active', 'is_active'),
    )

    def to_dict(self):
        """转换为字典"""
        import json
        return {
            'id': self.id,
            'companion_id': self.companion_id,
            'title': self.title,
            'category': self.category,
            'description': self.description,
            'features': json.loads(self.features) if self.features else [],
            'base_price': float(self.base_price) if self.base_price else 0.0,
            'additional_hour_price': float(self.additional_hour_price) if self.additional_hour_price else 0.0,
            'sales_count': self.sales_count,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }


class ServiceSpec(db.Model):
    """服务规格表"""
    __tablename__ = 'service_specs'

    id = db.Column(db.BigInteger, primary_key=True)
    service_id = db.Column(db.BigInteger, db.ForeignKey('services.id'), nullable=False, comment='服务 ID')

    # 规格信息
    name = db.Column(db.String(50), nullable=False, comment='规格名称')
    description = db.Column(db.Text, comment='规格描述')
    duration_hours = db.Column(db.Integer, nullable=False, comment='时长（小时）')

    # 定价
    price = db.Column(db.Numeric(10, 2), nullable=False, comment='价格')

    # 包含内容
    features = db.Column(db.Text, comment='包含服务（JSON 数组）')

    # 排序
    sort_order = db.Column(db.Integer, default=0, comment='排序')

    # 状态
    is_active = db.Column(db.Boolean, default=True, comment='是否可用')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_deleted = db.Column(db.Boolean, default=False)

    # 索引
    __table_args__ = (
        Index('idx_service_specs_service_id', 'service_id'),
        Index('idx_service_specs_sort_order', 'service_id', 'sort_order'),
    )

    def to_dict(self):
        """转换为字典"""
        import json
        return {
            'id': self.id,
            'service_id': self.service_id,
            'name': self.name,
            'description': self.description,
            'duration_hours': self.duration_hours,
            'price': float(self.price) if self.price else 0.0,
            'features': json.loads(self.features) if self.features else [],
            'is_active': self.is_active,
            'sort_order': self.sort_order
        }
