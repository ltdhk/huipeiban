# -*- coding: utf-8 -*-
"""
简单的数据库创建脚本
"""
import sys
import os

# 设置 UTF-8 编码
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

from app import create_app
from app.extensions import db

def create_database():
    """创建数据库表"""
    print("正在创建数据库...")

    app = create_app('development')

    with app.app_context():
        # 删除所有表
        db.drop_all()
        print("已删除旧表")

        # 创建所有表
        db.create_all()
        print("数据库表创建成功！")

        # 显示创建的表
        from sqlalchemy import inspect
        inspector = inspect(db.engine)
        tables = inspector.get_table_names()
        print(f"\n已创建 {len(tables)} 个表:")
        for table in tables:
            print(f"  - {table}")

if __name__ == '__main__':
    create_database()
