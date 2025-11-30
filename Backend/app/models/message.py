# -*- coding: utf-8 -*-
"""
对话和消息相关数据模型

简化设计：
- 会话只记录两个用户ID（user1_id, user2_id），统一使用 users 表
- 消息的 sender_id 和 receiver_id 也统一使用 users 表的 ID
- 不再区分角色类型（companion_id, institution_id 等）
"""
from datetime import datetime
import time
from sqlalchemy import event, or_, and_
from app.extensions import db


class Conversation(db.Model):
    """
    对话会话模型 - 用于用户之间的一对一聊天

    简化设计：只记录两个用户ID，不区分角色类型
    user1_id 和 user2_id 都指向 users 表
    """
    __tablename__ = 'conversations'

    id = db.Column(db.BigInteger, primary_key=True)
    # 参与者1（通常是发起会话的用户）
    user1_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)
    # 参与者2（通常是被联系的用户）
    user2_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)
    last_message = db.Column(db.Text)  # 最后一条消息内容
    last_message_at = db.Column(db.DateTime)  # 最后消息时间
    # 分别记录两个用户的未读数
    user1_unread = db.Column(db.Integer, default=0)
    user2_unread = db.Column(db.Integer, default=0)
    status = db.Column(db.String(20), default='active')  # active, archived
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # 关系
    messages = db.relationship('Message', backref='conversation', lazy='dynamic', cascade='all, delete-orphan')
    user1 = db.relationship('User', foreign_keys=[user1_id], backref='conversations_as_user1')
    user2 = db.relationship('User', foreign_keys=[user2_id], backref='conversations_as_user2')

    @staticmethod
    def find_by_users(user_id_1, user_id_2):
        """
        查找两个用户之间的会话（不区分顺序）
        """
        return Conversation.query.filter(
            or_(
                and_(Conversation.user1_id == user_id_1, Conversation.user2_id == user_id_2),
                and_(Conversation.user1_id == user_id_2, Conversation.user2_id == user_id_1)
            ),
            Conversation.status == 'active'
        ).first()

    @staticmethod
    def get_user_conversations(user_id):
        """
        获取用户的所有会话
        """
        return Conversation.query.filter(
            or_(Conversation.user1_id == user_id, Conversation.user2_id == user_id),
            Conversation.status == 'active'
        ).order_by(Conversation.updated_at.desc())

    def get_other_user_id(self, current_user_id):
        """获取对方用户ID"""
        return self.user2_id if self.user1_id == current_user_id else self.user1_id

    def is_participant(self, user_id):
        """检查用户是否是会话参与者"""
        return self.user1_id == user_id or self.user2_id == user_id

    def get_unread_count(self, user_id):
        """获取指定用户的未读数"""
        if self.user1_id == user_id:
            return self.user1_unread or 0
        elif self.user2_id == user_id:
            return self.user2_unread or 0
        return 0

    def increment_unread(self, receiver_id):
        """增加接收者的未读数"""
        if self.user1_id == receiver_id:
            self.user1_unread = (self.user1_unread or 0) + 1
        elif self.user2_id == receiver_id:
            self.user2_unread = (self.user2_unread or 0) + 1

    def clear_unread(self, user_id):
        """清除指定用户的未读数"""
        if self.user1_id == user_id:
            self.user1_unread = 0
        elif self.user2_id == user_id:
            self.user2_unread = 0

    def to_dict(self, current_user_id=None):
        """转换为字典"""
        result = {
            'id': self.id,
            'user1_id': self.user1_id,
            'user2_id': self.user2_id,
            'last_message': self.last_message,
            'last_message_at': self.last_message_at.isoformat() if self.last_message_at else None,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }
        # 如果提供了当前用户ID，添加未读数和对方ID
        if current_user_id:
            result['unread_count'] = self.get_unread_count(current_user_id)
            result['other_user_id'] = self.get_other_user_id(current_user_id)
        return result


class Message(db.Model):
    """
    消息模型 - 用于用户之间的一对一聊天消息

    简化设计：sender_id 和 receiver_id 都统一使用 users 表的 ID
    """
    __tablename__ = 'messages'

    id = db.Column(db.BigInteger, primary_key=True)
    conversation_id = db.Column(db.BigInteger, db.ForeignKey('conversations.id'), nullable=False, index=True)
    sender_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)  # 发送者用户ID
    receiver_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)  # 接收者用户ID
    content_type = db.Column(db.String(20), default='text')  # text, image, voice, file, system
    content = db.Column(db.Text, nullable=False)
    is_read = db.Column(db.Boolean, default=False, index=True)
    is_deleted = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

    # 关系
    sender = db.relationship('User', foreign_keys=[sender_id], backref='sent_messages')
    receiver = db.relationship('User', foreign_keys=[receiver_id], backref='received_messages')

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'conversation_id': self.conversation_id,
            'sender_id': self.sender_id,
            'receiver_id': self.receiver_id,
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
