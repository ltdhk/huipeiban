# -*- coding: utf-8 -*-
"""
对话和消息相关数据模型
"""
from datetime import datetime
import time
from sqlalchemy import event
from app.extensions import db


class Conversation(db.Model):
    """对话会话模型 - 用于用户之间的一对一聊天"""
    __tablename__ = 'conversations'

    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)
    companion_id = db.Column(db.BigInteger, db.ForeignKey('companions.id'), index=True)
    institution_id = db.Column(db.BigInteger, db.ForeignKey('institutions.id'), index=True)
    title = db.Column(db.String(200))  # 对话标题
    last_message = db.Column(db.Text)  # 最后一条消息内容
    unread_count = db.Column(db.Integer, default=0)  # 未读消息数
    status = db.Column(db.String(20), default='active')  # active, archived
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # 关系
    messages = db.relationship('Message', backref='conversation', lazy='dynamic', cascade='all, delete-orphan')
    user = db.relationship('User', foreign_keys=[user_id], backref='conversations')
    companion = db.relationship('Companion', foreign_keys=[companion_id], backref='conversations')
    institution = db.relationship('Institution', foreign_keys=[institution_id], backref='conversations')

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'companion_id': self.companion_id,
            'institution_id': self.institution_id,
            'title': self.title,
            'last_message': self.last_message,
            'unread_count': self.unread_count,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }


class Message(db.Model):
    """消息模型 - 用于用户之间的一对一聊天消息"""
    __tablename__ = 'messages'

    id = db.Column(db.BigInteger, primary_key=True)
    conversation_id = db.Column(db.BigInteger, db.ForeignKey('conversations.id'), nullable=False, index=True)
    sender_id = db.Column(db.BigInteger, nullable=False, index=True)  # 发送者ID
    sender_type = db.Column(db.String(20), nullable=False)  # user, companion, institution, system
    receiver_id = db.Column(db.BigInteger, nullable=False)  # 接收者ID
    receiver_type = db.Column(db.String(20), nullable=False)  # user, companion, institution
    content_type = db.Column(db.String(20), default='text')  # text, image, voice, system
    content = db.Column(db.Text, nullable=False)
    is_read = db.Column(db.Boolean, default=False, index=True)
    is_deleted = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'conversation_id': self.conversation_id,
            'sender_id': self.sender_id,
            'sender_type': self.sender_type,
            'receiver_id': self.receiver_id,
            'receiver_type': self.receiver_type,
            'content_type': self.content_type,
            'content': self.content,
            'is_read': self.is_read,
            'is_deleted': self.is_deleted,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }


# 自动生成对话 ID（使用微秒级时间戳）
_last_conversation_msg_id = 0

@event.listens_for(Conversation, 'before_insert')
def generate_conversation_msg_id(mapper, connection, target):
    """在插入对话之前自动生成 ID"""
    global _last_conversation_msg_id
    if target.id is None:
        # 使用微秒级时间戳确保唯一性
        current_id = int(time.time() * 1000000)
        # 如果与上一个 ID 相同，则递增
        if current_id <= _last_conversation_msg_id:
            current_id = _last_conversation_msg_id + 1
        _last_conversation_msg_id = current_id
        target.id = current_id


# 自动生成消息 ID（使用微秒级时间戳）
_last_message_msg_id = 0

@event.listens_for(Message, 'before_insert')
def generate_message_msg_id(mapper, connection, target):
    """在插入消息之前自动生成 ID"""
    global _last_message_msg_id
    if target.id is None:
        # 使用微秒级时间戳确保唯一性
        current_id = int(time.time() * 1000000)
        # 如果与上一个 ID 相同，则递增
        if current_id <= _last_message_msg_id:
            current_id = _last_message_msg_id + 1
        _last_message_msg_id = current_id
        target.id = current_id
