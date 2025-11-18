# -*- coding: utf-8 -*-
"""
JWT Token 工具
"""
from datetime import datetime, timedelta
from flask import current_app
from flask_jwt_extended import create_access_token, create_refresh_token, get_jwt_identity, get_jwt


def generate_tokens(identity, user_type='user', additional_claims=None):
    """
    生成 Access Token 和 Refresh Token

    Args:
        identity: 用户ID
        user_type: 用户类型 (user/companion/admin)
        additional_claims: 额外的声明信息

    Returns:
        dict: 包含 access_token 和 refresh_token
    """
    claims = {
        'user_type': user_type,
        'timestamp': datetime.utcnow().isoformat()
    }

    if additional_claims:
        claims.update(additional_claims)

    # 生成 Access Token (2小时过期)
    # 注意：identity 必须是字符串类型
    access_token = create_access_token(
        identity=str(identity),
        additional_claims=claims,
        expires_delta=timedelta(hours=2)
    )

    # 生成 Refresh Token (7天过期)
    refresh_token = create_refresh_token(
        identity=str(identity),
        additional_claims=claims,
        expires_delta=timedelta(days=7)
    )

    return {
        'access_token': access_token,
        'refresh_token': refresh_token,
        'expires_in': 7200  # 2小时，单位秒
    }


def get_current_user_id():
    """
    获取当前用户ID

    Returns:
        int: 用户ID
    """
    # JWT identity 是字符串，需要转换为整数
    return int(get_jwt_identity())


def get_current_user_type():
    """
    获取当前用户类型

    Returns:
        str: 用户类型 (user/companion/admin)
    """
    claims = get_jwt()
    return claims.get('user_type', 'user')


def verify_user_type(required_type):
    """
    验证用户类型

    Args:
        required_type: 需要的用户类型

    Returns:
        bool: 是否匹配
    """
    current_type = get_current_user_type()
    if isinstance(required_type, list):
        return current_type in required_type
    return current_type == required_type
