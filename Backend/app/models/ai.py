# -*- coding: utf-8 -*-
"""
AI对话历史模型
"""
from datetime import datetime
import time
from sqlalchemy import event
from app.extensions import db


class AIChatHistory(db.Model):
    """AI对话历史记录 - 用于存储用户与AI助手的对话"""
    __tablename__ = 'ai_chat_history'

    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.BigInteger, db.ForeignKey('users.id'), nullable=False, index=True)
    session_id = db.Column(db.String(100), nullable=False, index=True)  # 会话ID，用于区分不同对话
    role = db.Column(db.String(20), nullable=False)  # user, assistant, system
    content = db.Column(db.Text, nullable=False)
    intent = db.Column(db.String(50))  # 识别的意图类型: find_companion, find_institution, booking, consultation, etc.
    entities = db.Column(db.JSON)  # 提取的实体信息: {hospital, department, date, time, etc.}
    meta_data = db.Column(db.JSON)  # 其他元数据：推荐的陪诊师、机构列表、对话上下文等
    model_name = db.Column(db.String(100))  # 使用的AI模型名称
    tokens_used = db.Column(db.Integer)  # 消耗的token数量
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

    # 关系
    user = db.relationship('User', backref='ai_chat_history')

    def to_dict(self):
        """转换为字典"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'session_id': self.session_id,
            'role': self.role,
            'content': self.content,
            'intent': self.intent,
            'entities': self.entities,
            'metadata': self.meta_data,
            'model_name': self.model_name,
            'tokens_used': self.tokens_used,
            'created_at': self.created_at.isoformat() if self.created_at else None,
        }


# 自动生成 AI 对话历史 ID（使用微秒级时间戳）
_last_ai_chat_history_id = 0

@event.listens_for(AIChatHistory, 'before_insert')
def generate_ai_chat_history_id(mapper, connection, target):
    """在插入 AI 对话历史之前自动生成 ID"""
    global _last_ai_chat_history_id
    if target.id is None:
        # 使用微秒级时间戳确保唯一性
        current_id = int(time.time() * 1000000)
        # 如果与上一个 ID 相同，则递增
        if current_id <= _last_ai_chat_history_id:
            current_id = _last_ai_chat_history_id + 1
        _last_ai_chat_history_id = current_id
        target.id = current_id
