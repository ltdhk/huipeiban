# -*- coding: utf-8 -*-
"""
生成测试用的 JWT Token
"""
import sys
import os

# 添加项目根目录到路径
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app
from flask_jwt_extended import create_access_token, create_refresh_token

def generate_tokens(user_id=1):
    """生成测试 token"""
    app = create_app('development')

    with app.app_context():
        # 生成 access token
        access_token = create_access_token(identity=user_id)

        # 生成 refresh token
        refresh_token = create_refresh_token(identity=user_id)

        print("=" * 80)
        print("🔑 JWT Token 已生成")
        print("=" * 80)
        print(f"\n用户 ID: {user_id}\n")
        print("Access Token (用于 API 请求):")
        print("-" * 80)
        print(access_token)
        print("\n")
        print("Refresh Token (用于刷新 token):")
        print("-" * 80)
        print(refresh_token)
        print("\n")
        print("=" * 80)
        print("📝 使用方法:")
        print("=" * 80)
        print("\n1. 在 Postman 中设置 Header:")
        print("   Authorization: Bearer <access_token>")
        print("\n2. 在微信开发者工具 Console 中执行:")
        print(f"   wx.setStorageSync('access_token', '{access_token}')")
        print(f"   wx.setStorageSync('refresh_token', '{refresh_token}')")
        print("\n3. curl 命令示例:")
        print(f"   curl -H \"Authorization: Bearer {access_token}\" \\")
        print("        http://localhost:5000/api/v1/user/profile")
        print("\n" + "=" * 80)

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='生成测试用的 JWT Token')
    parser.add_argument('--user-id', type=int, default=1, help='用户 ID（默认：1）')

    args = parser.parse_args()

    generate_tokens(args.user_id)
