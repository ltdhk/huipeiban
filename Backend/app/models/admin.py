# -*- coding: utf-8 -*-
"""
管理员相关模型
"""
from app import db
from datetime import datetime
from sqlalchemy import Index


class AdminUser(db.Model):
    """管理员表"""
    __tablename__ = 'admin_users'

    id = db.Column(db.BigInteger, primary_key=True, autoincrement=True)

    # 基本信息
    username = db.Column(db.String(50), unique=True, nullable=False, comment='用户名')
    password_hash = db.Column(db.String(255), nullable=False, comment='密码哈希')
    real_name = db.Column(db.String(50), comment='真实姓名')
    email = db.Column(db.String(100), comment='邮箱')
    phone = db.Column(db.String(20), comment='手机号')

    # 角色权限
    role = db.Column(db.String(50), default='admin', comment='角色: super_admin/admin/operator')

    # 状态
    status = db.Column(db.String(20), default='active', comment='状态: active/disabled')

    # 时间戳
    last_login_at = db.Column(db.DateTime, comment='最后登录时间')
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 索引
    __table_args__ = (
        Index('idx_admin_users_username', 'username'),
        Index('idx_admin_users_status', 'status'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'username': self.username,
            'real_name': self.real_name,
            'email': self.email,
            'phone': self.phone,
            'role': self.role,
            'status': self.status,
            'last_login_at': self.last_login_at.isoformat() if self.last_login_at else None,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }


class AdminLog(db.Model):
    """管理员操作日志表"""
    __tablename__ = 'admin_logs'

    id = db.Column(db.BigInteger, primary_key=True)

    # 管理员信息
    admin_id = db.Column(db.BigInteger, nullable=False, comment='管理员 ID')
    admin_username = db.Column(db.String(50), comment='管理员用户名')

    # 操作信息
    action = db.Column(db.String(100), nullable=False, comment='操作类型')
    module = db.Column(db.String(50), comment='模块')
    description = db.Column(db.Text, comment='操作描述')

    # 请求信息
    ip_address = db.Column(db.String(50), comment='IP 地址')
    user_agent = db.Column(db.String(255), comment='User Agent')
    request_method = db.Column(db.String(10), comment='请求方法')
    request_url = db.Column(db.String(255), comment='请求 URL')
    request_data = db.Column(db.Text, comment='请求数据')

    # 响应信息
    response_status = db.Column(db.Integer, comment='响应状态码')
    response_data = db.Column(db.Text, comment='响应数据')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')

    # 索引
    __table_args__ = (
        Index('idx_admin_logs_admin_id', 'admin_id'),
        Index('idx_admin_logs_action', 'action'),
        Index('idx_admin_logs_created_at', 'created_at'),
    )

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'admin_id': self.admin_id,
            'admin_username': self.admin_username,
            'action': self.action,
            'module': self.module,
            'description': self.description,
            'ip_address': self.ip_address,
            'request_method': self.request_method,
            'request_url': self.request_url,
            'response_status': self.response_status,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
