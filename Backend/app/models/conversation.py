# -*- coding: utf-8 -*-
"""
对话相关数据模型
"""
from datetime import datetime
import time
from sqlalchemy import event
from app.extensions import db


class Conversation(db.Model):
    """对话会话模型"""
    __tablename__ = 'conversations'

    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)
    title = db.Column(db.String(200))  # 对话标题
    status = db.Column(db.String(20), default='active')  # active, archived
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # 关系
    messages = db.relationship('Message', backref='conversation', lazy='dynamic', cascade='all, delete-orphan')
    user = db.relationship('User', backref='conversations')

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'title': self.title,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }


class Message(db.Model):
    """对话消息模型"""
    __tablename__ = 'messages'

    id = db.Column(db.BigInteger, primary_key=True)
    conversation_id = db.Column(db.BigInteger, db.ForeignKey('conversations.id'), nullable=False, index=True)
    role = db.Column(db.String(20), nullable=False)  # user, assistant, system
    content = db.Column(db.Text, nullable=False)
    intent = db.Column(db.String(50))  # 识别的意图类型
    entities = db.Column(db.JSON)  # 提取的实体信息
    metadata = db.Column(db.JSON)  # 其他元数据（如推荐的陪诊师、机构等）
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'conversation_id': self.conversation_id,
            'role': self.role,
            'content': self.content,
            'intent': self.intent,
            'entities': self.entities,
            'metadata': self.metadata,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }


# 自动生成对话 ID（使用微秒级时间戳）
_last_conversation_id = 0

@event.listens_for(Conversation, 'before_insert')
def generate_conversation_id(mapper, connection, target):
    """在插入对话之前自动生成 ID"""
    global _last_conversation_id
    if target.id is None:
        # 使用微秒级时间戳确保唯一性
        current_id = int(time.time() * 1000000)
        # 如果与上一个 ID 相同，则递增
        if current_id <= _last_conversation_id:
            current_id = _last_conversation_id + 1
        _last_conversation_id = current_id
        target.id = current_id


# 自动生成消息 ID（使用微秒级时间戳）
_last_message_id = 0

@event.listens_for(Message, 'before_insert')
def generate_message_id(mapper, connection, target):
    """在插入消息之前自动生成 ID"""
    global _last_message_id
    if target.id is None:
        # 使用微秒级时间戳确保唯一性
        current_id = int(time.time() * 1000000)
        # 如果与上一个 ID 相同，则递增
        if current_id <= _last_message_id:
            current_id = _last_message_id + 1
        _last_message_id = current_id
        target.id = current_id
