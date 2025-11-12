# -*- coding: utf-8 -*-
"""AI对话历史模型（占位）"""
from app import db

class AIChatHistory(db.Model):
    __tablename__ = 'ai_chat_history'
    id = db.Column(db.BigInteger, primary_key=True)
