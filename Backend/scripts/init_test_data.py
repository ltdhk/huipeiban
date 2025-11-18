# -*- coding: utf-8 -*-
"""
初始化测试数据脚本
"""
import sys
import os
import json

# 添加项目根目录到路径
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app
from app.extensions import db
from app.models.user import User, Patient, Address
from app.models.companion import Companion, Institution, Service, ServiceSpec
from app.models.admin import AdminUser
from werkzeug.security import generate_password_hash
from datetime import datetime, date

def init_test_data():
    """初始化测试数据"""
    app = create_app('development')

    with app.app_context():
        # 清空现有数据
        print("🗑️  清空现有数据...")
        db.drop_all()
        db.create_all()

        # 1. 创建管理员
        print("👤 创建管理员...")
        admin = AdminUser(
            username='admin',
            email='admin@carelink.com',
            password_hash=generate_password_hash('admin123'),
            role='super_admin',
            status='active'
        )
        db.session.add(admin)

        # 2. 创建测试用户
        print("👥 创建测试用户...")
        users = []
        for i in range(1, 4):
            user = User(
                phone=f'1380013800{i}',
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

        db.session.flush()  # 获取用户 ID

        # 3. 创建就诊人
        print("🏥 创建就诊人...")
        patients = [
            Patient(
                user_id=users[0].id,
                name='张三',
                gender='male',
                birth_date=date(1980, 1, 1),
                phone='13800138001',
                relationship='self',
                is_default=True
            ),
            Patient(
                user_id=users[0].id,
                name='李父',
                gender='male',
                birth_date=date(1950, 5, 10),
                phone='13900139000',
                relationship='parent',
                medical_history='高血压、糖尿病',
                allergies='青霉素过敏'
            ),
            Patient(
                user_id=users[1].id,
                name='王五',
                gender='female',
                birth_date=date(1990, 8, 15),
                phone='13800138002',
                relationship='self',
                is_default=True
            )
        ]
        db.session.add_all(patients)

        # 4. 创建地址
        print("📍 创建地址...")
        addresses = [
            Address(
                user_id=users[0].id,
                contact_name='张三',
                contact_phone='13800138001',
                province='北京市',
                city='北京市',
                district='朝阳区',
                detail_address='建国路88号SOHO现代城',
                address_type='home',
                label='家',
                is_default=True
            ),
            Address(
                user_id=users[0].id,
                contact_name='张三',
                contact_phone='13800138001',
                province='北京市',
                city='北京市',
                district='海淀区',
                detail_address='中关村大街1号',
                address_type='company',
                label='公司'
            ),
            Address(
                user_id=users[1].id,
                contact_name='王五',
                contact_phone='13800138002',
                province='上海市',
                city='上海市',
                district='浦东新区',
                detail_address='陆家嘴环路1000号',
                address_type='home',
                is_default=True
            )
        ]
        db.session.add_all(addresses)

        # 5. 创建陪诊师
        print("🩺 创建陪诊师...")

        companions = [
            Companion(
                name='王护士',
                gender='female',
                age=35,
                phone='13700137001',
                password_hash=generate_password_hash('123456'),
                id_card='110101198801011234',
                avatar_url='/assets/companion1.jpg',
                service_years=10,
                service_area=json.dumps(['北京'], ensure_ascii=False),
                service_hospitals=json.dumps(['北京协和医院', '北京301医院', '北京天坛医院'], ensure_ascii=False),
                specialties=json.dumps(['老年护理', '术后康复', '慢病管理'], ensure_ascii=False),
                introduction='从事护理工作10年，有丰富的老年护理经验，耐心细致，深受患者信赖。',
                completed_orders=150,
                rating=4.9,
                review_count=75,
                status='approved',
                is_verified=True,
                is_online=True,
                has_car=True,
                certificates=json.dumps(['护士执业证', '高级护理师证'], ensure_ascii=False)
            ),
            Companion(
                name='李医生',
                gender='male',
                age=45,
                phone='13700137002',
                password_hash=generate_password_hash('123456'),
                id_card='110101197801011235',
                avatar_url='/assets/companion2.jpg',
                service_years=20,
                service_area=json.dumps(['北京', '上海'], ensure_ascii=False),
                service_hospitals=json.dumps(['北京协和医院', '上海第六人民医院', '上海中山医院', '上海瑞金医院'], ensure_ascii=False),
                specialties=json.dumps(['慢病管理', '健康咨询', '医疗翻译'], ensure_ascii=False),
                introduction='退休主治医师，20年临床经验，擅长慢病管理和健康指导。',
                completed_orders=280,
                rating=5.0,
                review_count=140,
                status='approved',
                is_verified=True,
                is_online=True,
                has_car=False,
                certificates=json.dumps(['医师执业证', '主治医师职称'], ensure_ascii=False)
            ),
            Companion(
                name='赵护工',
                gender='male',
                age=40,
                phone='13700137003',
                password_hash=generate_password_hash('123456'),
                id_card='110101198301011236',
                avatar_url='/assets/companion3.jpg',
                service_years=8,
                service_area=json.dumps(['上海'], ensure_ascii=False),
                service_hospitals=json.dumps(['上海第六人民医院', '上海华山医院', '上海交通大学附属医院'], ensure_ascii=False),
                specialties=json.dumps(['术后护理', '康复陪护', '生活照料'], ensure_ascii=False),
                introduction='专业护工，有多年医院陪护经验，细心负责。',
                completed_orders=200,
                rating=4.8,
                review_count=100,
                status='approved',
                is_verified=True,
                is_online=True,
                has_car=True
            ),
            Companion(
                name='孙助理',
                gender='female',
                age=28,
                phone='13700137004',
                password_hash=generate_password_hash('123456'),
                id_card='110101199501011237',
                avatar_url='/assets/companion4.jpg',
                service_years=5,
                service_area=json.dumps(['上海'], ensure_ascii=False),
                service_hospitals=json.dumps(['上海第六人民医院', '上海第九人民医院', '上海仁济医院'], ensure_ascii=False),
                specialties=json.dumps(['就医陪同', '检查陪护', '取药代办'], ensure_ascii=False),
                introduction='年轻有活力，熟悉各大医院流程，服务周到。',
                completed_orders=120,
                rating=4.7,
                review_count=60,
                status='approved',
                is_verified=True,
                is_online=True,
                has_car=False
            )
        ]
        db.session.add_all(companions)
        db.session.flush()  # 获取陪诊师 ID

        # 6. 创建服务包和服务规格
        print("📦 创建服务包...")
        services_and_specs = []

        for companion in companions:
            # 为每个陪诊师创建一个全程陪诊服务包
            service = Service(
                companion_id=companion.id,
                title='全程陪诊服务',
                category='陪诊',
                description='提供专业的陪诊服务，包括挂号、就诊陪同、检查陪护、取药等一站式服务',
                features=json.dumps(['挂号预约', '就诊陪同', '检查陪护', '取药服务', '报告解读'], ensure_ascii=False),
                base_price=200.00,
                additional_hour_price=50.00,
                sales_count=companion.completed_orders,
                is_active=True,
                sort_order=1
            )
            services_and_specs.append(service)
            db.session.add(service)

        db.session.flush()  # 获取服务 ID

        # 为每个服务创建规格
        print("📋 创建服务规格...")
        for service in services_and_specs:
            specs = [
                ServiceSpec(
                    service_id=service.id,
                    name='2小时服务',
                    description='适合简单门诊',
                    duration_hours=2,
                    price=200.00,
                    features=json.dumps(['挂号', '就诊陪同'], ensure_ascii=False),
                    sort_order=1,
                    is_active=True
                ),
                ServiceSpec(
                    service_id=service.id,
                    name='4小时服务',
                    description='适合检查较多的门诊',
                    duration_hours=4,
                    price=350.00,
                    features=json.dumps(['挂号', '就诊陪同', '检查陪护', '取药'], ensure_ascii=False),
                    sort_order=2,
                    is_active=True
                ),
                ServiceSpec(
                    service_id=service.id,
                    name='全天服务',
                    description='8小时全程陪护',
                    duration_hours=8,
                    price=600.00,
                    features=json.dumps(['挂号', '就诊陪同', '检查陪护', '取药', '报告解读', '全程陪伴'], ensure_ascii=False),
                    sort_order=3,
                    is_active=True
                ),
                ServiceSpec(
                    service_id=service.id,
                    name='VIP定制服务',
                    description='高端定制化服务',
                    duration_hours=12,
                    price=1200.00,
                    features=json.dumps(['专属陪诊师', '全程陪同', '专车接送', '快速通道', '报告解读', '健康咨询'], ensure_ascii=False),
                    sort_order=4,
                    is_active=True
                )
            ]
            db.session.add_all(specs)

        # 7. 创建陪诊机构
        print("🏢 创建陪诊机构...")
        institutions = [
            Institution(
                name='北京爱心陪诊中心',
                logo_url='/assets/institution1.jpg',
                city='北京',
                district='朝阳区',
                detail_address='朝阳区建国路99号',
                phone='010-12345678',
                introduction='北京市领先的专业陪诊服务机构，成立于2018年，拥有经验丰富的医护团队。',
                service_scope='医院陪诊、检查陪同、拿药取报告、康复护理',
                completed_orders=1000,
                rating=4.8,
                review_count=200,
                status='approved',
                companion_count=50
            ),
            Institution(
                name='上海康护陪诊服务',
                logo_url='/assets/institution2.jpg',
                city='上海',
                district='浦东新区',
                detail_address='浦东新区世纪大道88号',
                phone='021-87654321',
                introduction='上海领先的陪诊服务提供商，提供全方位的医疗陪护服务。',
                service_scope='全程陪诊、翻译服务、医疗咨询、健康管理',
                completed_orders=2000,
                rating=4.9,
                review_count=350,
                status='approved',
                companion_count=80
            ),
            Institution(
                name='广州健康陪护中心',
                logo_url='/assets/institution3.jpg',
                city='广州',
                district='天河区',
                detail_address='天河区天河路123号',
                phone='020-11112222',
                introduction='华南地区专业陪诊服务机构，温馨贴心的服务。',
                service_scope='陪诊陪护、术后护理、康复指导',
                completed_orders=800,
                rating=4.7,
                review_count=150,
                status='approved',
                companion_count=40
            )
        ]
        db.session.add_all(institutions)

        # 提交所有数据
        print("💾 提交数据到数据库...")
        db.session.commit()

        # 统计数据
        service_count = len(services_and_specs)
        spec_count = service_count * 4  # 每个服务4个规格

        print("\n✅ 测试数据初始化完成！\n")
        print("=" * 50)
        print("📊 数据统计:")
        print(f"  - 管理员: 1 个")
        print(f"  - 用户: {len(users)} 个")
        print(f"  - 就诊人: {len(patients)} 个")
        print(f"  - 地址: {len(addresses)} 个")
        print(f"  - 陪诊师: {len(companions)} 个")
        print(f"  - 服务包: {service_count} 个")
        print(f"  - 服务规格: {spec_count} 个")
        print(f"  - 陪诊机构: {len(institutions)} 个")
        print("=" * 50)
        print("\n🔐 登录信息:")
        print("  管理员:")
        print("    用户名: admin")
        print("    密码: admin123")
        print("\n  测试用户:")
        print("    手机号: 13800138001")
        print("    密码: 123456")
        print("\n  陪诊师:")
        print("    手机号: 13700137001-13700137004")
        print("    密码: 123456")
        print("=" * 50)

if __name__ == '__main__':
    init_test_data()
