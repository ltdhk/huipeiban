# -*- coding: utf-8 -*-
"""
装饰器工具
"""
from functools import wraps
from flask import jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity, get_jwt
from app.utils.response import error_response


def login_required(user_type=None):
    """
    登录认证装饰器

    Args:
        user_type: 需要的用户类型，可以是字符串或列表
                  例如: 'user', 'admin', ['user', 'companion']

    Usage:
        @login_required()  # 任何已登录用户
        @login_required('admin')  # 仅管理员
        @login_required(['user', 'companion'])  # 用户或陪诊师
    """
    def decorator(fn):
        @wraps(fn)
        @jwt_required()
        def wrapper(*args, **kwargs):
            # 验证用户类型
            if user_type:
                claims = get_jwt()
                current_user_type = claims.get('user_type', 'user')

                # 检查用户类型是否匹配
                if isinstance(user_type, list):
                    if current_user_type not in user_type:
                        return error_response(403, 'FORBIDDEN', '权限不足')
                else:
                    if current_user_type != user_type:
                        return error_response(403, 'FORBIDDEN', '权限不足')

            return fn(*args, **kwargs)
        return wrapper
    return decorator


def admin_required(fn):
    """
    管理员权限装饰器

    Usage:
        @admin_required
        def some_admin_function():
            pass
    """
    @wraps(fn)
    @jwt_required()
    def wrapper(*args, **kwargs):
        claims = get_jwt()
        user_type = claims.get('user_type', 'user')

        if user_type != 'admin':
            return error_response(403, 'FORBIDDEN', '需要管理员权限')

        return fn(*args, **kwargs)
    return wrapper


def user_required(fn):
    """
    用户权限装饰器（C端用户）

    Usage:
        @user_required
        def some_user_function():
            pass
    """
    @wraps(fn)
    @jwt_required()
    def wrapper(*args, **kwargs):
        claims = get_jwt()
        user_type = claims.get('user_type', 'user')

        if user_type != 'user':
            return error_response(403, 'FORBIDDEN', '需要用户权限')

        return fn(*args, **kwargs)
    return wrapper


def companion_required(fn):
    """
    陪诊师权限装饰器

    Usage:
        @companion_required
        def some_companion_function():
            pass
    """
    @wraps(fn)
    @jwt_required()
    def wrapper(*args, **kwargs):
        claims = get_jwt()
        user_type = claims.get('user_type', 'user')

        if user_type != 'companion':
            return error_response(403, 'FORBIDDEN', '需要陪诊师权限')

        return fn(*args, **kwargs)
    return wrapper
