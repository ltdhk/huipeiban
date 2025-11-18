# -*- coding: utf-8 -*-
"""
初始化管理员账号
"""
from app import create_app, db
from werkzeug.security import generate_password_hash

def init_admin():
    """创建初始管理员账号"""
    app = create_app('development')

    with app.app_context():
        # 先创建所有表
        db.create_all()
        print('[OK] Database tables created')

        # 导入模型
        from app.models.admin import AdminUser

        # 检查是否已存在管理员
        try:
            existing_admin = AdminUser.query.filter_by(username='admin').first()

            if existing_admin:
                print('Admin account already exists')
                print(f'Username: {existing_admin.username}')
                print(f'Status: {existing_admin.status}')
                return
        except Exception as e:
            print(f'Error querying admin: {e}')
            # Continue to create

        # 创建新管理员
        admin = AdminUser(
            username='admin',
            password_hash=generate_password_hash('admin123'),  # 默认密码
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
    init_admin()
