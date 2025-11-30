# -*- coding: utf-8 -*-
"""
用户端认证相关接口
"""
from flask import request, current_app
from flask_jwt_extended import jwt_required
from werkzeug.security import check_password_hash
from app.api.user import user_bp
from app.utils.response import success_response, error_response
from app.utils.jwt_utils import generate_tokens, get_current_user_id
from app.models.user import User
from app.models.companion import Companion, Institution
from app.extensions import db
from datetime import datetime
import requests


def _get_role_data(user):
    """
    根据用户类型获取关联的角色数据

    Args:
        user: User 对象

    Returns:
        dict: 包含角色相关信息的字典,如果用户不是陪诊师或机构则返回 None
    """
    if user.user_type == 'companion':
        # 查找陪诊师信息
        companion = Companion.query.filter_by(user_id=user.id, is_deleted=False).first()
        if companion:
            return {
                'companion_id': companion.id,
                'companion_info': companion.to_dict(include_sensitive=True)
            }
    elif user.user_type == 'institution':
        # 查找机构信息
        institution = Institution.query.filter_by(user_id=user.id, is_deleted=False).first()
        if institution:
            return {
                'institution_id': institution.id,
                'institution_info': institution.to_dict()
            }
    return None


@user_bp.route('/auth/login', methods=['POST'])
def phone_login():
    """
    手机号密码登录（测试用）

    请求参数:
        phone: 手机号
        password: 密码

    Returns:
        用户信息和 token
    """
    data = request.get_json()
    phone = data.get('phone')
    password = data.get('password')

    if not phone or not password:
        return error_response(400, 'BAD_REQUEST', '手机号和密码不能为空')

    try:
        # 查找用户
        user = User.query.filter_by(phone=phone, is_deleted=False).first()

        if not user:
            return error_response(404, 'USER_NOT_FOUND', '用户不存在')

        # 验证密码
        if not user.password_hash or not check_password_hash(user.password_hash, password):
            return error_response(401, 'INVALID_PASSWORD', '密码错误')

        # 更新最后登录时间
        user.last_login_at = datetime.utcnow()
        db.session.commit()

        # 生成 token，传递用户类型
        tokens = generate_tokens(user.id, user_type=user.user_type or 'user')

        # 根据用户类型获取关联信息
        user_data = user.to_dict()
        role_data = _get_role_data(user)
        if role_data:
            user_data.update(role_data)

        return success_response({
            **tokens,
            'user': user_data
        }, message='登录成功')

    except Exception as e:
        current_app.logger.error(f'登录失败: {e}', exc_info=True)
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', '登录失败，请稍后重试')


@user_bp.route('/auth/wechat-login', methods=['POST'])
def wechat_login():
    """
    微信登录

    请求参数:
        code: 微信登录 code
        userInfo: 用户信息（可选）
            - nickname: 昵称
            - avatar: 头像
            - gender: 性别 (1=男, 2=女, 0=未知)

    Returns:
        用户信息和 token
    """
    data = request.get_json()
    code = data.get('code')
    user_info = data.get('userInfo', {})

    if not code:
        return error_response(400, 'BAD_REQUEST', '缺少 code 参数')

    try:
        # 调用微信接口获取 openid 和 session_key
        appid = current_app.config.get('WECHAT_APPID')
        secret = current_app.config.get('WECHAT_APP_SECRET')

        if not appid or not secret:
            current_app.logger.warning('微信 AppID 或 Secret 未配置')
            return error_response(500, 'CONFIG_ERROR', '微信登录配置错误')

        url = 'https://api.weixin.qq.com/sns/jscode2session'
        params = {
            'appid': appid,
            'secret': secret,
            'js_code': code,
            'grant_type': 'authorization_code'
        }

        response = requests.get(url, params=params, timeout=10)
        result = response.json()

        if 'errcode' in result and result['errcode'] != 0:
            current_app.logger.error(f"微信登录失败: {result}")
            return error_response(400, 'WECHAT_LOGIN_FAILED', f"微信登录失败: {result.get('errmsg', '未知错误')}")

        openid = result.get('openid')
        unionid = result.get('unionid')  # 如果配置了开放平台

        if not openid:
            return error_response(400, 'INVALID_CODE', '无效的登录 code')

        # 查找或创建用户
        user = User.query.filter_by(wechat_openid=openid, is_deleted=False).first()

        is_new_user = False
        if not user:
            # 新用户，创建账号
            # 处理性别映射：微信 1=男, 2=女, 0=未知
            gender_map = {1: 'male', 2: 'female', 0: 'unknown'}
            gender = gender_map.get(user_info.get('gender', 0), 'unknown')

            user = User(
                wechat_openid=openid,
                wechat_unionid=unionid,
                nickname=user_info.get('nickname', '微信用户'),
                avatar_url=user_info.get('avatar'),
                gender=gender,
                status='active'
            )
            db.session.add(user)
            db.session.commit()
            is_new_user = True
            current_app.logger.info(f'新用户注册: user_id={user.id}, openid={openid}')
        else:
            # 更新用户信息和最后登录时间
            if user_info.get('nickname'):
                user.nickname = user_info.get('nickname')
            if user_info.get('avatar'):
                user.avatar_url = user_info.get('avatar')
            if user_info.get('gender') is not None:
                gender_map = {1: 'male', 2: 'female', 0: 'unknown'}
                user.gender = gender_map.get(user_info.get('gender', 0), 'unknown')

            user.last_login_at = datetime.utcnow()
            db.session.commit()
            current_app.logger.info(f'用户登录: user_id={user.id}')

        # 生成 JWT Token
        tokens = generate_tokens(
            identity=user.id,
            user_type='user',
            additional_claims={'openid': openid}
        )

        return success_response({
            **tokens,
            'user': user.to_dict(),
            'is_new_user': is_new_user
        }, message='登录成功')

    except requests.exceptions.RequestException as e:
        current_app.logger.error(f'微信接口调用失败: {e}')
        return error_response(500, 'WECHAT_API_ERROR', '微信服务暂时不可用，请稍后重试')
    except Exception as e:
        current_app.logger.error(f'微信登录失败: {e}', exc_info=True)
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', '登录失败，请稍后重试')


@user_bp.route('/auth/refresh-token', methods=['POST'])
@jwt_required(refresh=True)
def refresh_token():
    """
    刷新 Access Token

    需要在请求头中携带 Refresh Token:
        Authorization: Bearer <refresh_token>

    Returns:
        新的 access_token
    """
    current_user_id = get_current_user_id()

    # 验证用户是否存在
    user = User.query.filter_by(id=current_user_id, is_deleted=False).first()
    if not user:
        return error_response(404, 'USER_NOT_FOUND', '用户不存在')

    if user.status != 'active':
        return error_response(403, 'USER_DISABLED', '用户已被禁用')

    # 生成新的 tokens，保留用户类型
    tokens = generate_tokens(
        identity=current_user_id,
        user_type=user.user_type or 'user'
    )

    return success_response({
        **tokens
    }, message='Token 刷新成功')


@user_bp.route('/auth/current', methods=['GET'])
@jwt_required()
def get_current_user():
    """
    获取当前用户信息

    Returns:
        用户信息
    """
    current_user_id = get_current_user_id()

    user = User.query.filter_by(id=current_user_id, is_deleted=False).first()
    if not user:
        return error_response(404, 'USER_NOT_FOUND', '用户不存在')

    # 根据用户类型获取关联信息
    user_data = user.to_dict()
    role_data = _get_role_data(user)
    if role_data:
        user_data.update(role_data)

    return success_response({
        'user': user_data
    })


@user_bp.route('/auth/bind-phone', methods=['POST'])
@jwt_required()
def bind_phone():
    """
    绑定手机号

    请求参数:
        phone: 手机号
        code: 验证码

    Returns:
        操作结果
    """
    current_user_id = get_current_user_id()
    data = request.get_json()

    phone = data.get('phone')
    code = data.get('code')

    if not phone or not code:
        return error_response(400, 'BAD_REQUEST', '手机号和验证码不能为空')

    # TODO: 验证验证码
    # 这里简化处理，实际需要接入短信服务

    try:
        # 检查手机号是否已被使用
        existing_user = User.query.filter_by(phone=phone, is_deleted=False).first()
        if existing_user and existing_user.id != current_user_id:
            return error_response(422, 'PHONE_ALREADY_EXISTS', '该手机号已被使用')

        # 更新用户手机号
        user = User.query.get(current_user_id)
        if not user:
            return error_response(404, 'USER_NOT_FOUND', '用户不存在')

        user.phone = phone
        user.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response({
            'user': user.to_dict()
        }, message='手机号绑定成功')

    except Exception as e:
        current_app.logger.error(f'绑定手机号失败: {e}', exc_info=True)
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', '绑定失败，请稍后重试')


@user_bp.route('/auth/logout', methods=['POST'])
@jwt_required()
def logout():
    """
    用户登出

    注意: JWT 是无状态的，真正的登出需要在客户端删除 token
          或者实现 token 黑名单机制

    Returns:
        操作结果
    """
    # 这里可以记录登出日志
    current_user_id = get_current_user_id()
    current_app.logger.info(f'用户登出: user_id={current_user_id}')

    # TODO: 如果需要，可以将 token 加入黑名单

    return success_response(message='登出成功')
