# -*- coding: utf-8 -*-
"""管理员相关模型（占位）"""
from app import db

class AdminUser(db.Model):
    __tablename__ = 'admin_users'
    id = db.Column(db.BigInteger, primary_key=True)

class AdminLog(db.Model):
    __tablename__ = 'admin_logs'
    id = db.Column(db.BigInteger, primary_key=True)
