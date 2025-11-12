# -*- coding: utf-8 -*-
"""消息相关模型（占位）"""
from app import db

class Conversation(db.Model):
    __tablename__ = 'conversations'
    id = db.Column(db.BigInteger, primary_key=True)

class Message(db.Model):
    __tablename__ = 'messages'
    id = db.Column(db.BigInteger, primary_key=True)
