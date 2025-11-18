# -*- coding: utf-8 -*-
"""
评价相关模型
"""
from app.extensions import db
from datetime import datetime
from sqlalchemy import Index


class Review(db.Model):
    """评价表"""
    __tablename__ = 'reviews'

    id = db.Column(db.BigInteger, primary_key=True)

    # 关联信息
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, comment='用户ID')
    order_id = db.Column(db.BigInteger, db.ForeignKey('orders.id'), nullable=False, comment='订单ID')
    companion_id = db.Column(db.BigInteger, db.ForeignKey('companions.id'), comment='陪诊师ID')
    institution_id = db.Column(db.BigInteger, db.ForeignKey('institutions.id'), comment='机构ID')

    # 评价内容
    rating = db.Column(db.Numeric(2, 1), nullable=False, comment='评分（1-5星）')
    content = db.Column(db.Text, comment='评价内容')
    tags = db.Column(db.JSON, comment='评价标签')

    # 详细评分
    service_rating = db.Column(db.Numeric(2, 1), comment='服务评分')
    attitude_rating = db.Column(db.Numeric(2, 1), comment='态度评分')
    professional_rating = db.Column(db.Numeric(2, 1), comment='专业度评分')

    # 图片
    images = db.Column(db.JSON, comment='评价图片URL列表')

    # 状态
    is_anonymous = db.Column(db.Boolean, default=False, comment='是否匿名')
    is_visible = db.Column(db.Boolean, default=True, comment='是否可见')
    status = db.Column(db.String(20), default='published', comment='状态: published/hidden/deleted')

    # 回复
    reply_content = db.Column(db.Text, comment='商家回复内容')
    reply_at = db.Column(db.DateTime, comment='回复时间')

    # 时间戳
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    is_deleted = db.Column(db.Boolean, default=False, comment='是否删除')

    # 索引
    __table_args__ = (
        Index('idx_reviews_user_id', 'user_id'),
        Index('idx_reviews_order_id', 'order_id'),
        Index('idx_reviews_companion_id', 'companion_id'),
        Index('idx_reviews_institution_id', 'institution_id'),
        Index('idx_reviews_rating', 'rating'),
    )

    def to_dict(self, include_user=False):
        """转换为字典"""
        data = {
            'id': self.id,
            'order_id': self.order_id,
            'companion_id': self.companion_id,
            'institution_id': self.institution_id,
            'rating': float(self.rating) if self.rating else 0.0,
            'content': self.content,
            'tags': self.tags or [],
            'service_rating': float(self.service_rating) if self.service_rating else None,
            'attitude_rating': float(self.attitude_rating) if self.attitude_rating else None,
            'professional_rating': float(self.professional_rating) if self.professional_rating else None,
            'images': self.images or [],
            'is_anonymous': self.is_anonymous,
            'reply_content': self.reply_content,
            'reply_at': self.reply_at.isoformat() if self.reply_at else None,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }

        # 添加用户信息
        if include_user and not self.is_anonymous:
            from app.models.user import User
            user = User.query.get(self.user_id)
            if user:
                data['user'] = {
                    'id': user.id,
                    'nickname': user.nickname,
                    'avatar_url': user.avatar_url
                }

        return data
