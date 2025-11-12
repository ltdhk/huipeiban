# -*- coding: utf-8 -*-
"""优惠券相关模型（占位）"""
from app import db

class Coupon(db.Model):
    __tablename__ = 'coupons'
    id = db.Column(db.BigInteger, primary_key=True)

class UserCoupon(db.Model):
    __tablename__ = 'user_coupons'
    id = db.Column(db.BigInteger, primary_key=True)
