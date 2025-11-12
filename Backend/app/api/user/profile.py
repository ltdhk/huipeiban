# -*- coding: utf-8 -*-
"""
用户端个人信息相关接口
"""
from flask import request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.api.user import user_bp
from app.utils.response import success_response, error_response
from app.models.user import User
from app import db
from datetime import datetime


@user_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    """
    获取当前用户信息

    Returns:
        用户信息
    """
    current_user_id = get_jwt_identity()

    user = User.query.get(current_user_id)
    if not user or user.is_deleted:
        return error_response(404, 'USER_NOT_FOUND', '用户不存在')

    return success_response(user.to_dict(), message='获取成功')


@user_bp.route('/profile', methods=['PATCH'])
@jwt_required()
def update_profile():
    """
    更新用户信息

    请求参数:
        nickname: 昵称
        avatar_url: 头像URL
        gender: 性别
        birth_date: 出生日期

    Returns:
        更新后的用户信息
    """
    current_user_id = get_jwt_identity()
    data = request.get_json()

    user = User.query.get(current_user_id)
    if not user or user.is_deleted:
        return error_response(404, 'USER_NOT_FOUND', '用户不存在')

    try:
        # 更新允许的字段
        if 'nickname' in data:
            user.nickname = data['nickname']
        if 'avatar_url' in data:
            user.avatar_url = data['avatar_url']
        if 'gender' in data and data['gender'] in ['male', 'female', 'unknown']:
            user.gender = data['gender']
        if 'birth_date' in data:
            from datetime import datetime
            user.birth_date = datetime.fromisoformat(data['birth_date']).date()

        user.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(user.to_dict(), message='更新成功')

    except Exception as e:
        from flask import current_app
        current_app.logger.error(f'更新用户信息失败: {e}')
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', '更新失败，请稍后重试')
