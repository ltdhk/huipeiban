# -*- coding: utf-8 -*-
"""
陪诊师和机构相关模型
"""
from app import db
from datetime import datetime

# TODO: 实现 Companion, Institution, Service, ServiceSpec 模型
# 参考 DATABASE.md 文档

class Companion(db.Model):
    """陪诊师表（占位）"""
    __tablename__ = 'companions'
    id = db.Column(db.BigInteger, primary_key=True)
    pass


class Institution(db.Model):
    """陪诊机构表（占位）"""
    __tablename__ = 'institutions'
    id = db.Column(db.BigInteger, primary_key=True)
    pass


class Service(db.Model):
    """服务产品表（占位）"""
    __tablename__ = 'services'
    id = db.Column(db.BigInteger, primary_key=True)
    pass


class ServiceSpec(db.Model):
    """服务规格表（占位）"""
    __tablename__ = 'service_specs'
    id = db.Column(db.BigInteger, primary_key=True)
    pass
