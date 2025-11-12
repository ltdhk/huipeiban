# -*- coding: utf-8 -*-
"""订单和支付相关模型（占位）"""
from app import db

class Order(db.Model):
    __tablename__ = 'orders'
    id = db.Column(db.BigInteger, primary_key=True)

class Payment(db.Model):
    __tablename__ = 'payments'
    id = db.Column(db.BigInteger, primary_key=True)
