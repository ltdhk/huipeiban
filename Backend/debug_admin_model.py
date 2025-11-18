# -*- coding: utf-8 -*-
"""
调试 AdminUser 模型定义
"""
from app import create_app, db
from sqlalchemy.schema import CreateTable

def debug_admin_model():
    """查看 AdminUser 模型的 SQL 定义"""
    app = create_app('development')

    with app.app_context():
        from app.models.admin import AdminUser, AdminLog

        # 显示 CREATE TABLE 语句
        print('=== AdminUser CREATE TABLE SQL ===')
        print(CreateTable(AdminUser.__table__).compile(db.engine))
        print()

        print('=== AdminUser Columns ===')
        for column in AdminUser.__table__.columns:
            print(f'{column.name}: {column.type} (nullable={column.nullable})')
        print()

        print('=== Creating tables ===')
        AdminUser.__table__.create(db.engine, checkfirst=True)
        AdminLog.__table__.create(db.engine, checkfirst=True)
        print('[OK] Tables created')

        # 验证表结构
        import sqlite3
        db_path = app.config['SQLALCHEMY_DATABASE_URI'].replace('sqlite:///', '')
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        print()
        print('=== Actual admin_users table schema ===')
        cursor.execute('SELECT sql FROM sqlite_master WHERE name="admin_users"')
        result = cursor.fetchone()
        if result:
            print(result[0])
        else:
            print('[ERROR] Table not found!')

        conn.close()


if __name__ == '__main__':
    debug_admin_model()
