# -*- coding: utf-8 -*-
"""
添加测试数据脚本（不清空现有数据）
"""
import sys
import os
import time

# 添加项目根目录到路径
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app
from app.extensions import db
from app.models.user import User, Patient, Address
from app.models.companion import Companion, Institution
from app.models.admin import AdminUser
from werkzeug.security import generate_password_hash
from datetime import datetime, date

def add_test_data():
    """添加测试数据（不清空现有数据）"""
    app = create_app('development')

    with app.app_context():
        print("📊 开始添加测试数据...\n")

        # 1. 检查并创建管理员
        print("👤 检查管理员...")
        admin = AdminUser.query.filter_by(username='admin').first()
        if not admin:
            admin = AdminUser(
                username='admin',
                email='admin@carelink.com',
                password_hash=generate_password_hash('admin123'),
                role='super_admin',
                status='active'
            )
            db.session.add(admin)
            print("  ✓ 创建管理员: admin")
        else:
            print("  ⊙ 管理员已存在")

        # 2. 创建测试用户（避免手机号冲突）
        print("\n👥 创建测试用户...")
        users = []
        for i in range(1, 4):
            phone = f'1380013800{i}'
            existing_user = User.query.filter_by(phone=phone).first()
            if existing_user:
                print(f"  ⊙ 用户 {phone} 已存在，跳过")
                users.append(existing_user)
                continue

            # 添加延迟确保 ID 唯一
            time.sleep(0.001)

            user = User(
                phone=phone,
                password_hash=generate_password_hash('123456'),
                nickname=f'测试用户{i}',
                gender='male' if i % 2 == 1 else 'female',
                balance=100.00 * i,
                points=500 * i,
                member_level='vip' if i == 1 else 'normal',
                total_orders=i * 2,
                total_spent=200.00 * i,
                status='active'
            )
            users.append(user)
            db.session.add(user)
            print(f"  ✓ 创建用户: {phone}")

        db.session.flush()  # 获取用户 ID

        # 3. 创建就诊人
        if len(users) > 0:
            print("\n🏥 创建就诊人...")
            patients_data = [
                {
                    'user': users[0],
                    'name': '张三',
                    'gender': 'male',
                    'birth_date': date(1980, 1, 1),
                    'phone': '13800138001',
                    'relationship': 'self',
                    'is_default': True
                },
                {
                    'user': users[0],
                    'name': '李父',
                    'gender': 'male',
                    'birth_date': date(1950, 5, 10),
                    'phone': '13900139000',
                    'relationship': 'parent',
                    'medical_history': '高血压、糖尿病',
                    'allergies': '青霉素过敏'
                }
            ]

            if len(users) > 1:
                patients_data.append({
                    'user': users[1],
                    'name': '王五',
                    'gender': 'female',
                    'birth_date': date(1990, 8, 15),
                    'phone': '13800138002',
                    'relationship': 'self',
                    'is_default': True
                })

            for patient_data in patients_data:
                user = patient_data.pop('user')
                # 检查是否已存在
                existing = Patient.query.filter_by(
                    user_id=user.id,
                    name=patient_data['name']
                ).first()
                if existing:
                    print(f"  ⊙ 就诊人 {patient_data['name']} 已存在，跳过")
                    continue

                patient = Patient(user_id=user.id, **patient_data)
                db.session.add(patient)
                print(f"  ✓ 创建就诊人: {patient_data['name']}")

        # 4. 创建地址
        if len(users) > 0:
            print("\n📍 创建地址...")
            addresses_data = [
                {
                    'user': users[0],
                    'contact_name': '张三',
                    'contact_phone': '13800138001',
                    'province': '北京市',
                    'city': '北京市',
                    'district': '朝阳区',
                    'detail_address': '建国路88号SOHO现代城',
                    'address_type': 'home',
                    'label': '家',
                    'is_default': True
                },
                {
                    'user': users[0],
                    'contact_name': '张三',
                    'contact_phone': '13800138001',
                    'province': '北京市',
                    'city': '北京市',
                    'district': '海淀区',
                    'detail_address': '中关村大街1号',
                    'address_type': 'company',
                    'label': '公司'
                }
            ]

            if len(users) > 1:
                addresses_data.append({
                    'user': users[1],
                    'contact_name': '王五',
                    'contact_phone': '13800138002',
                    'province': '上海市',
                    'city': '上海市',
                    'district': '浦东新区',
                    'detail_address': '陆家嘴环路1000号',
                    'address_type': 'home',
                    'is_default': True
                })

            for addr_data in addresses_data:
                user = addr_data.pop('user')
                # 检查是否已存在
                existing = Address.query.filter_by(
                    user_id=user.id,
                    detail_address=addr_data['detail_address']
                ).first()
                if existing:
                    print(f"  ⊙ 地址已存在，跳过")
                    continue

                address = Address(user_id=user.id, **addr_data)
                db.session.add(address)
                print(f"  ✓ 创建地址: {addr_data['detail_address']}")

        # 5. 创建陪诊师
        print("\n🩺 创建陪诊师...")
        companions_data = [
            {
                'phone': '13700137001',
                'name': '王护士',
                'gender': 'female',
                'age': 35,
                'id_card': '110101198901011234',
                'password_hash': generate_password_hash('123456'),
                'service_years': 10,
                'specialties': '老年护理,术后康复,慢病管理',
                'introduction': '从事护理工作10年，有丰富的老年护理经验，耐心细致，深受患者信赖。',
                'service_area': '北京',
                'rating': 4.9,
                'review_count': 75,
                'total_orders': 150,
                'completed_orders': 148,
                'status': 'approved',
                'has_car': True,
                'is_verified': True
            },
            {
                'phone': '13700137002',
                'name': '李医生',
                'gender': 'male',
                'age': 45,
                'id_card': '110101197901011234',
                'password_hash': generate_password_hash('123456'),
                'service_years': 20,
                'specialties': '慢病管理,健康咨询,医疗翻译',
                'introduction': '退休主治医师，20年临床经验，擅长慢病管理和健康指导。',
                'service_area': '北京',
                'rating': 5.0,
                'review_count': 140,
                'total_orders': 280,
                'completed_orders': 278,
                'status': 'approved',
                'has_car': False,
                'is_verified': True
            },
            {
                'phone': '13700137003',
                'name': '赵护工',
                'gender': 'male',
                'age': 40,
                'id_card': '110101198401011234',
                'password_hash': generate_password_hash('123456'),
                'service_years': 8,
                'specialties': '术后护理,康复陪护,生活照料',
                'introduction': '专业护工，有多年医院陪护经验，细心负责。',
                'service_area': '北京',
                'rating': 4.8,
                'review_count': 100,
                'total_orders': 200,
                'completed_orders': 196,
                'status': 'approved',
                'has_car': True,
                'is_verified': True
            },
            {
                'phone': '13700137004',
                'name': '孙助理',
                'gender': 'female',
                'age': 28,
                'id_card': '110101199601011234',
                'password_hash': generate_password_hash('123456'),
                'service_years': 5,
                'specialties': '就医陪同,检查陪护,取药代办',
                'introduction': '年轻有活力，熟悉各大医院流程，服务周到。',
                'service_area': '北京',
                'rating': 4.7,
                'review_count': 60,
                'total_orders': 120,
                'completed_orders': 118,
                'status': 'approved',
                'has_car': False,
                'is_verified': True
            },
            {
                'phone': '13700137005',
                'name': '陈护士',
                'gender': 'female',
                'age': 32,
                'id_card': '310101199201011234',
                'password_hash': generate_password_hash('123456'),
                'service_years': 8,
                'specialties': '老年护理,康复指导,健康管理',
                'introduction': '上海市优秀护理人员，专业细心，服务态度好。',
                'service_area': '上海',
                'rating': 4.9,
                'review_count': 88,
                'total_orders': 160,
                'completed_orders': 158,
                'status': 'approved',
                'has_car': True,
                'is_verified': True
            }
        ]

        for comp_data in companions_data:
            # 检查是否已存在
            existing = Companion.query.filter_by(phone=comp_data['phone']).first()
            if existing:
                print(f"  ⊙ 陪诊师 {comp_data['name']} 已存在，跳过")
                continue

            companion = Companion(**comp_data)
            db.session.add(companion)
            print(f"  ✓ 创建陪诊师: {comp_data['name']}")

        # 6. 创建陪诊机构
        print("\n🏢 创建陪诊机构...")
        institutions_data = [
            {
                'name': '北京爱心陪诊中心',
                'phone': '010-12345678',
                'legal_person': '张经理',
                'legal_person_id_card': '110101197001011234',
                'province': '北京市',
                'city': '北京市',
                'district': '朝阳区',
                'detail_address': '朝阳区建国路99号',
                'introduction': '北京市领先的专业陪诊服务机构，成立于2018年，拥有经验丰富的医护团队。',
                'service_scope': '医院陪诊,检查陪同,拿药取报告,康复护理',
                'companion_count': 50,
                'completed_orders': 1000,
                'rating': 4.8,
                'review_count': 200,
                'status': 'approved'
            },
            {
                'name': '上海康护陪诊服务',
                'phone': '021-87654321',
                'legal_person': '李总',
                'legal_person_id_card': '310101196801011234',
                'province': '上海市',
                'city': '上海市',
                'district': '浦东新区',
                'detail_address': '浦东新区世纪大道88号',
                'introduction': '上海领先的陪诊服务提供商，提供全方位的医疗陪护服务。',
                'service_scope': '全程陪诊,翻译服务,医疗咨询,健康管理',
                'companion_count': 80,
                'completed_orders': 2000,
                'rating': 4.9,
                'review_count': 350,
                'status': 'approved'
            },
            {
                'name': '广州健康陪护中心',
                'phone': '020-11112222',
                'legal_person': '王主任',
                'legal_person_id_card': '440101196901011234',
                'province': '广东省',
                'city': '广州市',
                'district': '天河区',
                'detail_address': '天河区天河路123号',
                'introduction': '华南地区专业陪诊服务机构，温馨贴心的服务。',
                'service_scope': '陪诊陪护,术后护理,康复指导',
                'companion_count': 40,
                'completed_orders': 800,
                'rating': 4.7,
                'review_count': 150,
                'status': 'approved'
            }
        ]

        for inst_data in institutions_data:
            # 检查是否已存在
            existing = Institution.query.filter_by(phone=inst_data['phone']).first()
            if existing:
                print(f"  ⊙ 机构 {inst_data['name']} 已存在，跳过")
                continue

            institution = Institution(**inst_data)
            db.session.add(institution)
            print(f"  ✓ 创建机构: {inst_data['name']}")

        # 提交所有数据
        print("\n💾 提交数据到数据库...")
        db.session.commit()

        # 统计数据
        print("\n✅ 测试数据添加完成！\n")
        print("=" * 50)
        print("📊 数据统计:")
        print(f"  - 管理员: {AdminUser.query.count()} 个")
        print(f"  - 用户: {User.query.count()} 个")
        print(f"  - 就诊人: {Patient.query.count()} 个")
        print(f"  - 地址: {Address.query.count()} 个")
        print(f"  - 陪诊师: {Companion.query.count()} 个")
        print(f"  - 陪诊机构: {Institution.query.count()} 个")
        print("=" * 50)
        print("\n🔐 登录信息:")
        print("  管理员:")
        print("    用户名: admin")
        print("    密码: admin123")
        print("\n  测试用户:")
        print("    手机号: 13800138001 / 13800138002 / 13800138003")
        print("    密码: 123456")
        print("\n  陪诊师:")
        print("    手机号: 13700137001 / 13700137002 / 13700137003 等")
        print("    密码: 123456")
        print("=" * 50)

if __name__ == '__main__':
    add_test_data()
