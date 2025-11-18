# -*- coding: utf-8 -*-
"""
添加测试订单数据
"""
import sys
import os
from datetime import datetime, timedelta, date

# 添加项目根目录到路径
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from app import create_app
from app.extensions import db
from app.models.user import User, Patient, Address
from app.models.companion import Companion, Service, ServiceSpec
from app.models.order import Order, Payment

def add_test_orders():
    """添加测试订单数据"""
    app = create_app('development')

    with app.app_context():
        print("📦 添加测试订单...")

        # 获取测试用户
        user = User.query.filter_by(phone='13800138001').first()
        if not user:
            print("❌ 测试用户不存在，请先运行 init_test_data.py")
            return

        print(f"✓ 找到测试用户: {user.nickname} (ID: {user.id})")

        # 获取就诊人
        patient = Patient.query.filter_by(user_id=user.id, is_default=True).first()
        if not patient:
            print("❌ 未找到就诊人")
            return

        print(f"✓ 找到就诊人: {patient.name} (ID: {patient.id})")

        # 获取陪诊师
        companion = Companion.query.filter_by(name='王护士').first()
        if not companion:
            print("❌ 未找到陪诊师")
            return

        print(f"✓ 找到陪诊师: {companion.name} (ID: {companion.id})")

        # 获取服务和规格
        service = Service.query.filter_by(companion_id=companion.id).first()
        if not service:
            print("❌ 未找到服务")
            return

        spec = ServiceSpec.query.filter_by(service_id=service.id).first()
        if not spec:
            print("❌ 未找到服务规格")
            return

        print(f"✓ 找到服务: {service.title} - {spec.name} (价格: ¥{spec.price})")

        # 创建测试订单
        orders = []

        # 订单 1: 待支付
        order1 = Order(
            order_no=f'ORD{datetime.now().strftime("%Y%m%d%H%M%S")}001',
            user_id=user.id,
            patient_id=patient.id,
            companion_id=companion.id,
            order_type='companion',
            service_id=service.id,
            service_spec_id=spec.id,
            hospital_name='北京协和医院',
            department='心内科',
            appointment_date=date.today() + timedelta(days=3),
            appointment_time='09:00',
            service_price=spec.price,
            total_price=spec.price,
            status='pending_payment',
            user_note='需要陪诊师协助挂号和问诊',
        )
        orders.append(order1)

        # 订单 2: 待接单
        order2 = Order(
            order_no=f'ORD{datetime.now().strftime("%Y%m%d%H%M%S")}002',
            user_id=user.id,
            patient_id=patient.id,
            companion_id=companion.id,
            order_type='companion',
            service_id=service.id,
            service_spec_id=spec.id,
            hospital_name='北京301医院',
            department='骨科',
            appointment_date=date.today() + timedelta(days=5),
            appointment_time='14:00',
            service_price=spec.price,
            total_price=spec.price,
            status='pending_accept',
            paid_at=datetime.utcnow(),
            user_note='需要推轮椅',
        )
        orders.append(order2)

        # 订单 3: 已接单
        order3 = Order(
            order_no=f'ORD{datetime.now().strftime("%Y%m%d%H%M%S")}003',
            user_id=user.id,
            patient_id=patient.id,
            companion_id=companion.id,
            order_type='companion',
            service_id=service.id,
            service_spec_id=spec.id,
            hospital_name='北京天坛医院',
            department='神经内科',
            appointment_date=date.today() + timedelta(days=7),
            appointment_time='10:30',
            service_price=spec.price,
            total_price=spec.price,
            status='accepted',
            paid_at=datetime.utcnow(),
            accepted_at=datetime.utcnow(),
        )
        orders.append(order3)

        # 订单 4: 服务中
        order4 = Order(
            order_no=f'ORD{datetime.now().strftime("%Y%m%d%H%M%S")}004',
            user_id=user.id,
            patient_id=patient.id,
            companion_id=companion.id,
            order_type='companion',
            service_id=service.id,
            service_spec_id=spec.id,
            hospital_name='北京协和医院',
            department='内分泌科',
            appointment_date=date.today(),
            appointment_time='08:30',
            service_price=spec.price,
            total_price=spec.price,
            status='in_progress',
            paid_at=datetime.utcnow(),
            accepted_at=datetime.utcnow(),
            service_started_at=datetime.utcnow(),
        )
        orders.append(order4)

        # 订单 5: 已完成
        order5 = Order(
            order_no=f'ORD{datetime.now().strftime("%Y%m%d%H%M%S")}005',
            user_id=user.id,
            patient_id=patient.id,
            companion_id=companion.id,
            order_type='companion',
            service_id=service.id,
            service_spec_id=spec.id,
            hospital_name='北京301医院',
            department='眼科',
            appointment_date=date.today() - timedelta(days=2),
            appointment_time='15:00',
            service_price=spec.price,
            total_price=spec.price,
            status='completed',
            paid_at=datetime.utcnow() - timedelta(days=3),
            accepted_at=datetime.utcnow() - timedelta(days=3),
            service_started_at=datetime.utcnow() - timedelta(days=2),
            service_completed_at=datetime.utcnow() - timedelta(days=2),
        )
        orders.append(order5)

        # 订单 6: 已完成（需要评价）
        order6 = Order(
            order_no=f'ORD{datetime.now().strftime("%Y%m%d%H%M%S")}006',
            user_id=user.id,
            patient_id=patient.id,
            companion_id=companion.id,
            order_type='companion',
            service_id=service.id,
            service_spec_id=spec.id,
            hospital_name='北京天坛医院',
            department='康复科',
            appointment_date=date.today() - timedelta(days=5),
            appointment_time='11:00',
            service_price=spec.price,
            total_price=spec.price,
            status='completed',
            paid_at=datetime.utcnow() - timedelta(days=6),
            accepted_at=datetime.utcnow() - timedelta(days=6),
            service_started_at=datetime.utcnow() - timedelta(days=5),
            service_completed_at=datetime.utcnow() - timedelta(days=5),
        )
        orders.append(order6)

        # 添加到数据库
        db.session.add_all(orders)
        db.session.commit()

        print(f"\n✅ 成功添加 {len(orders)} 个测试订单！")
        print("\n订单列表:")
        for i, order in enumerate(orders, 1):
            print(f"  {i}. {order.order_no} - {order.hospital_name} - {order.status}")

        print("\n🔐 测试登录信息:")
        print("  手机号: 13800138001")
        print("  密码: 123456")

if __name__ == '__main__':
    add_test_orders()
