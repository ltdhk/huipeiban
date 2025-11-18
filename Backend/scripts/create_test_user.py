# -*- coding: utf-8 -*-
"""
创建测试用户并生成 token
"""
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models.user import User
from flask_jwt_extended import create_access_token, create_refresh_token
from datetime import timedelta

def create_test_user():
    """创建测试用户"""
    app = create_app()

    with app.app_context():
        # 检查测试用户是否已存在
        test_user = User.query.filter_by(wechat_openid='test_openid_001').first()

        if test_user:
            print("测试用户已存在")
        else:
            # 创建测试用户（使用简单的时间戳作为 ID）
            import time
            test_user = User(
                id=int(time.time() * 1000),  # 使用毫秒级时间戳作为 ID
                wechat_openid='test_openid_001',
                nickname='测试用户',
                avatar_url='https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132',
                gender='male',
                phone='13800138000'
            )
            db.session.add(test_user)
            db.session.commit()
            print(f"创建测试用户成功，ID: {test_user.id}")

        # 生成 token（identity 必须是字符串类型）
        access_token = create_access_token(
            identity=str(test_user.id),
            expires_delta=timedelta(days=30)
        )
        refresh_token = create_refresh_token(
            identity=str(test_user.id),
            expires_delta=timedelta(days=90)
        )

        print("\n" + "="*80)
        print("测试用户信息:")
        print("="*80)
        print(f"用户 ID: {test_user.id}")
        print(f"昵称: {test_user.nickname}")
        print(f"手机号: {test_user.phone}")
        print(f"OpenID: {test_user.wechat_openid}")
        print("\n" + "="*80)
        print("Token 信息 (有效期30天):")
        print("="*80)
        print(f"Access Token:\n{access_token}")
        print(f"\nRefresh Token:\n{refresh_token}")
        print("\n" + "="*80)
        print("\n使用说明:")
        print("1. 在微信开发者工具的控制台中执行以下代码:")
        print(f"\nwx.setStorageSync('access_token', '{access_token}');")
        print(f"wx.setStorageSync('refresh_token', '{refresh_token}');")
        print(f"wx.setStorageSync('userInfo', {{'id': {test_user.id}, 'nickname': '{test_user.nickname}', 'avatar': '{test_user.avatar_url}', 'phone': '{test_user.phone}'}});")
        print("\n2. 刷新页面即可使用")
        print("="*80)

if __name__ == '__main__':
    create_test_user()
