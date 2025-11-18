# -*- coding: utf-8 -*-
"""
管理端 API 蓝图
"""
from flask import Blueprint

admin_bp = Blueprint('admin', __name__)

# 导入路由
from app.api.admin import auth
