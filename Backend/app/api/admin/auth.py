# -*- coding: utf-8 -*-
"""
管理端认证相关接口
"""
from flask import request, current_app
from flask_jwt_extended import jwt_required
from werkzeug.security import check_password_hash
from app.api.admin import admin_bp
from app.utils.response import success_response, error_response
from app.utils.jwt_utils import generate_tokens, get_current_user_id
from app.utils.decorators import admin_required
from app.models.admin import AdminUser
from app import db
from datetime import datetime


@admin_bp.route('/auth/login', methods=['POST'])
def admin_login():
    """
    管理员登录

    请求参数:
        username: 用户名
        password: 密码

    Returns:
        管理员信息和 token
    """
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return error_response(400, 'BAD_REQUEST', '用户名和密码不能为空')

    try:
        # 查找管理员
        admin = AdminUser.query.filter_by(username=username, is_deleted=False).first()

        if not admin:
            return error_response(401, 'INVALID_CREDENTIALS', '用户名或密码错误')

        # 验证密码
        if not check_password_hash(admin.password_hash, password):
            return error_response(401, 'INVALID_CREDENTIALS', '用户名或密码错误')

        # 检查账号状态
        if admin.status != 'active':
            return error_response(403, 'ACCOUNT_DISABLED', '账号已被禁用')

        # 更新最后登录时间
        admin.last_login_at = datetime.utcnow()
        db.session.commit()

        # 生成 JWT Token
        tokens = generate_tokens(
            identity=admin.id,
            user_type='admin',
            additional_claims={
                'username': admin.username,
                'role': admin.role
            }
        )

        current_app.logger.info(f'管理员登录: admin_id={admin.id}, username={username}')

        return success_response({
            **tokens,
            'admin': admin.to_dict()
        }, message='登录成功')

    except Exception as e:
        current_app.logger.error(f'管理员登录失败: {e}', exc_info=True)
        return error_response(500, 'INTERNAL_ERROR', '登录失败，请稍后重试')


@admin_bp.route('/auth/refresh-token', methods=['POST'])
@jwt_required(refresh=True)
def admin_refresh_token():
    """
    刷新 Access Token

    需要在请求头中携带 Refresh Token:
        Authorization: Bearer <refresh_token>

    Returns:
        新的 access_token
    """
    current_admin_id = get_current_user_id()

    # 验证管理员是否存在
    admin = AdminUser.query.filter_by(id=current_admin_id, is_deleted=False).first()
    if not admin:
        return error_response(404, 'ADMIN_NOT_FOUND', '管理员不存在')

    if admin.status != 'active':
        return error_response(403, 'ACCOUNT_DISABLED', '账号已被禁用')

    # 生成新的 tokens
    tokens = generate_tokens(
        identity=current_admin_id,
        user_type='admin',
        additional_claims={
            'username': admin.username,
            'role': admin.role
        }
    )

    return success_response({
        **tokens
    }, message='Token 刷新成功')


@admin_bp.route('/auth/current', methods=['GET'])
@admin_required
def get_current_admin():
    """
    获取当前管理员信息

    Returns:
        管理员信息
    """
    current_admin_id = get_current_user_id()

    admin = AdminUser.query.filter_by(id=current_admin_id, is_deleted=False).first()
    if not admin:
        return error_response(404, 'ADMIN_NOT_FOUND', '管理员不存在')

    return success_response({
        'admin': admin.to_dict()
    })


@admin_bp.route('/auth/logout', methods=['POST'])
@admin_required
def admin_logout():
    """
    管理员登出

    Returns:
        操作结果
    """
    current_admin_id = get_current_user_id()
    current_app.logger.info(f'管理员登出: admin_id={current_admin_id}')

    return success_response(message='登出成功')


@admin_bp.route('/auth/change-password', methods=['POST'])
@admin_required
def change_password():
    """
    修改密码

    请求参数:
        old_password: 旧密码
        new_password: 新密码

    Returns:
        操作结果
    """
    current_admin_id = get_current_user_id()
    data = request.get_json()

    old_password = data.get('old_password')
    new_password = data.get('new_password')

    if not old_password or not new_password:
        return error_response(400, 'BAD_REQUEST', '旧密码和新密码不能为空')

    if len(new_password) < 6:
        return error_response(400, 'PASSWORD_TOO_SHORT', '新密码长度不能少于6位')

    try:
        admin = AdminUser.query.get(current_admin_id)
        if not admin:
            return error_response(404, 'ADMIN_NOT_FOUND', '管理员不存在')

        # 验证旧密码
        if not check_password_hash(admin.password_hash, old_password):
            return error_response(401, 'INVALID_PASSWORD', '旧密码错误')

        # 更新密码
        from werkzeug.security import generate_password_hash
        admin.password_hash = generate_password_hash(new_password)
        admin.updated_at = datetime.utcnow()
        db.session.commit()

        current_app.logger.info(f'管理员修改密码: admin_id={current_admin_id}')

        return success_response(message='密码修改成功')

    except Exception as e:
        current_app.logger.error(f'修改密码失败: {e}', exc_info=True)
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', '修改失败，请稍后重试')
