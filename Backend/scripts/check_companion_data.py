# -*- coding: utf-8 -*-
"""
检查和初始化陪诊师数据
"""
import sys
import os

# 添加项目根目录到 Python 路径
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models.user import User
from app.models.companion import Companion

def check_and_init_companion():
    """检查并初始化陪诊师数据"""
    app = create_app()

    with app.app_context():
        # 查看所有用户
        users = User.query.all()
        print(f'\n=== 数据库中的用户 ({len(users)}) ===')
        for user in users:
            print(f'ID: {user.id}, 手机号: {user.phone}, 类型: {user.user_type}')

        # 查看所有陪诊师
        companions = Companion.query.filter_by(is_deleted=False).all()
        print(f'\n=== 数据库中的陪诊师 ({len(companions)}) ===')
        for companion in companions:
            print(f'ID: {companion.id}, 用户ID: {companion.user_id}, 姓名: {companion.name}, 状态: {companion.status}')

        # 检查所有用户的陪诊师记录
        print('\n=== 检查所有用户的陪诊师记录 ===')
        for user in users:
            companion = Companion.query.filter_by(user_id=user.id, is_deleted=False).first()
            if companion:
                print(f'✓ 用户 {user.id} ({user.phone}, 类型:{user.user_type}) 有陪诊师记录 (ID: {companion.id}, 状态: {companion.status})')
            else:
                print(f'✗ 用户 {user.id} ({user.phone}, 类型:{user.user_type}) 没有陪诊师记录')

if __name__ == '__main__':
    check_and_init_companion()
