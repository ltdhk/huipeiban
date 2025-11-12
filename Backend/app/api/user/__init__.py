# -*- coding: utf-8 -*-
"""
用户端 API 蓝图
"""
from flask import Blueprint

user_bp = Blueprint('user', __name__)

# 导入路由
from app.api.user import auth, profile
