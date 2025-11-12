# -*- coding: utf-8 -*-
"""
用户端认证相关接口
"""
from flask import request
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt_identity
from app.api.user import user_bp
from app.utils.response import success_response, error_response
from app.models.user import User
from app import db
from datetime import datetime
import requests


@user_bp.route('/auth/wechat-login', methods=['POST'])
def wechat_login():
    """
    微信登录

    请求参数:
        code: 微信登录 code

    Returns:
        用户信息和 token
    """
    data = request.get_json()
    code = data.get('code')

    if not code:
        return error_response(400, 'BAD_REQUEST', '缺少 code 参数')

    try:
        # 调用微信接口获取 openid 和 session_key
        from flask import current_app
        appid = current_app.config['WECHAT_APPID']
        secret = current_app.config['WECHAT_APP_SECRET']

        url = f'https://api.weixin.qq.com/sns/jscode2session'
        params = {
            'appid': appid,
            'secret': secret,
            'js_code': code,
            'grant_type': 'authorization_code'
        }

        response = requests.get(url, params=params)
        result = response.json()

        if 'errcode' in result and result['errcode'] != 0:
            return error_response(400, 'WECHAT_LOGIN_FAILED', f"微信登录失败: {result.get('errmsg')}")

        openid = result.get('openid')
        # session_key = result.get('session_key')

        # 查找或创建用户
        user = User.query.filter_by(wechat_openid=openid, is_deleted=False).first()

        is_new_user = False
        if not user:
            # 新用户，创建账号
            user = User(
                wechat_openid=openid,
                nickname='微信用户',
                status='active'
            )
            db.session.add(user)
            db.session.commit()
            is_new_user = True
        else:
            # 更新最后登录时间
            user.last_login_at = datetime.utcnow()
            db.session.commit()

        # 生成 JWT Token
        access_token = create_access_token(identity=user.id)
        refresh_token = create_refresh_token(identity=user.id)

        return success_response({
            'access_token': access_token,
            'refresh_token': refresh_token,
            'expires_in': 7200,
            'user': user.to_dict(),
            'is_new_user': is_new_user
        }, message='登录成功')

    except Exception as e:
        current_app.logger.error(f'微信登录失败: {e}')
        return error_response(500, 'INTERNAL_ERROR', '登录失败，请稍后重试')


@user_bp.route('/auth/refresh-token', methods=['POST'])
@jwt_required(refresh=True)
def refresh_token():
    """
    刷新 Access Token

    Returns:
        新的 access_token
    """
    current_user_id = get_jwt_identity()

    # 生成新的 access token
    access_token = create_access_token(identity=current_user_id)

    return success_response({
        'access_token': access_token,
        'expires_in': 7200
    }, message='Token 刷新成功')


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
    current_user_id = get_jwt_identity()
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

        return success_response(message='手机号绑定成功')

    except Exception as e:
        from flask import current_app
        current_app.logger.error(f'绑定手机号失败: {e}')
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', '绑定失败，请稍后重试')
