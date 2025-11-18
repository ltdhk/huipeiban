# -*- coding: utf-8 -*-
"""
重新创建 admin_users 表
"""
from app import create_app, db
from werkzeug.security import generate_password_hash
import sqlite3

def recreate_admin_table():
    """删除并重新创建 admin_users 表"""
    app = create_app('development')

    with app.app_context():
        # 获取数据库文件路径
        db_path = app.config['SQLALCHEMY_DATABASE_URI'].replace('sqlite:///', '')

        # 直接使用 sqlite3 删除表
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        try:
            # 删除旧表
            cursor.execute('DROP TABLE IF EXISTS admin_users')
            cursor.execute('DROP TABLE IF EXISTS admin_logs')
            conn.commit()
            print('[OK] Dropped old admin tables')
        except Exception as e:
            print(f'[WARN] Error dropping tables: {e}')
        finally:
            conn.close()

        # 导入模型
        from app.models.admin import AdminUser, AdminLog

        # 使用 SQLAlchemy 创建新表
        AdminUser.__table__.create(db.engine, checkfirst=True)
        AdminLog.__table__.create(db.engine, checkfirst=True)
        print('[OK] Created new admin tables')

        # 创建管理员账号
        admin = AdminUser(
            username='admin',
            password_hash=generate_password_hash('admin123'),
            real_name='System Administrator',
            email='admin@carelink.com',
            phone='13800138000',
            role='super_admin',
            status='active'
        )

        db.session.add(admin)
        db.session.commit()

        print('[SUCCESS] Admin account created!')
        print('=' * 50)
        print('Username: admin')
        print('Password: admin123')
        print('=' * 50)
        print('[WARNING] Please change the default password immediately!')


if __name__ == '__main__':
    recreate_admin_table()
