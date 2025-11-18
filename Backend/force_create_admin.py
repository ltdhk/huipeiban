# -*- coding: utf-8 -*-
"""
强制创建 admin 表
"""
from app import create_app, db
from werkzeug.security import generate_password_hash
import sqlite3

def force_create_admin():
    """强制使用原始 SQL 创建 admin 表"""
    app = create_app('development')

    with app.app_context():
        # Get database path from Flask app
        import os
        from flask import current_app
        db_uri = current_app.config['SQLALCHEMY_DATABASE_URI']
        db_path = db_uri.replace('sqlite:///', '')

        # If relative path, resolve it relative to instance folder
        if not os.path.isabs(db_path):
            db_path = os.path.join(current_app.instance_path, db_path)

        # Create instance folder if it doesn't exist
        os.makedirs(os.path.dirname(db_path), exist_ok=True)
        print(f'[INFO] Database path: {db_path}')

        # 直接用 SQL 创建表
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        try:
            # 创建 admin_users 表
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS admin_users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username VARCHAR(50) NOT NULL UNIQUE,
                    password_hash VARCHAR(255) NOT NULL,
                    real_name VARCHAR(50),
                    email VARCHAR(100),
                    phone VARCHAR(20),
                    role VARCHAR(50) DEFAULT 'admin',
                    status VARCHAR(20) DEFAULT 'active',
                    last_login_at DATETIME,
                    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    is_deleted BOOLEAN DEFAULT 0
                )
            ''')

            # 创建 admin_logs 表
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS admin_logs (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    admin_id BIGINT NOT NULL,
                    admin_username VARCHAR(50),
                    action VARCHAR(100) NOT NULL,
                    module VARCHAR(50),
                    description TEXT,
                    ip_address VARCHAR(50),
                    user_agent VARCHAR(255),
                    request_method VARCHAR(10),
                    request_url VARCHAR(255),
                    request_data TEXT,
                    response_status INTEGER,
                    response_data TEXT,
                    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                )
            ''')

            # 创建索引
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_admin_users_username ON admin_users(username)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_admin_users_status ON admin_users(status)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_admin_logs_admin_id ON admin_logs(admin_id)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_admin_logs_action ON admin_logs(action)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_admin_logs_created_at ON admin_logs(created_at)')

            conn.commit()
            print('[OK] Admin tables created successfully')

            # 插入管理员账号
            password_hash = generate_password_hash('admin123')
            cursor.execute('''
                INSERT INTO admin_users (username, password_hash, real_name, email, phone, role, status)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', ('admin', password_hash, 'System Administrator', 'admin@carelink.com', '13800138000', 'super_admin', 'active'))

            conn.commit()
            print('[SUCCESS] Admin account created!')
            print('=' * 50)
            print('Username: admin')
            print('Password: admin123')
            print('=' * 50)
            print('[WARNING] Please change the default password immediately!')

        except sqlite3.IntegrityError as e:
            print(f'[INFO] Admin account may already exist: {e}')
        except Exception as e:
            print(f'[ERROR] {e}')
        finally:
            conn.close()


if __name__ == '__main__':
    force_create_admin()
