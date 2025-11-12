# -*- coding: utf-8 -*-
"""评价相关模型（占位）"""
from app import db

class Review(db.Model):
    __tablename__ = 'reviews'
    id = db.Column(db.BigInteger, primary_key=True)
