# -*- coding: utf-8 -*-
"""
就诊人管理API - 用户端
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime

from app.models.user import Patient
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_patient', __name__, url_prefix='/api/v1/user/patients')


@bp.route('', methods=['GET'])
@login_required()
def get_patients():
    """
    获取就诊人列表

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 5
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        patients = Patient.query.filter_by(
            user_id=current_user_id,
            is_deleted=False
        ).order_by(Patient.is_default.desc(), Patient.created_at.desc()).all()

        return success_response({
            'list': [p.to_dict() for p in patients],
            'total': len(patients)
        }, '获取就诊人列表成功')

    except Exception as e:
        return error_response(f'获取就诊人列表失败: {str(e)}', 500)


@bp.route('/<int:patient_id>', methods=['GET'])
@login_required()
def get_patient(patient_id):
    """
    获取就诊人详情

    路径参数:
    - patient_id: 就诊人ID

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            "name": "张三",
            ...
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        patient = Patient.query.filter_by(
            id=patient_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not patient:
            return error_response('就诊人不存在', 404)

        return success_response(patient.to_dict(), '获取就诊人详情成功')

    except Exception as e:
        return error_response(f'获取就诊人详情失败: {str(e)}', 500)


@bp.route('', methods=['POST'])
@login_required()
def create_patient():
    """
    创建就诊人

    请求体:
    {
        "name": "张三",
        "gender": "male",
        "birth_date": "1990-01-01",
        "phone": "13800138000",
        "id_card": "110101199001011234",
        "relationship": "self",
        "medical_history": "高血压",
        "allergies": "青霉素过敏",
        "special_needs": "需要轮椅",
        "insurance_type": "城镇职工医保",
        "insurance_number": "12345678",
        "is_default": true
    }

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            "name": "张三",
            ...
        },
        "message": "添加成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()

        # 验证必填字段
        if 'name' not in data:
            return error_response('缺少必填字段: name', 400)
        if 'gender' not in data:
            return error_response('缺少必填字段: gender', 400)

        # 验证性别
        if data['gender'] not in ['male', 'female']:
            return error_response('性别值错误，应为 male/female', 400)

        # 如果设置为默认就诊人，取消其他默认
        if data.get('is_default'):
            Patient.query.filter_by(
                user_id=current_user_id,
                is_default=True,
                is_deleted=False
            ).update({'is_default': False})

        # 处理出生日期
        birth_date = None
        if 'birth_date' in data and data['birth_date']:
            try:
                birth_date = datetime.strptime(data['birth_date'], '%Y-%m-%d').date()
            except ValueError:
                return error_response('出生日期格式错误，应为 YYYY-MM-DD', 400)

        # 创建就诊人
        patient = Patient(
            user_id=current_user_id,
            name=data['name'],
            gender=data['gender'],
            birth_date=birth_date,
            phone=data.get('phone'),
            id_card=data.get('id_card'),
            relationship=data.get('relationship', 'self'),
            medical_history=data.get('medical_history'),
            allergies=data.get('allergies'),
            special_needs=data.get('special_needs'),
            insurance_type=data.get('insurance_type'),
            insurance_number=data.get('insurance_number'),
            is_default=data.get('is_default', False)
        )

        db.session.add(patient)
        db.session.commit()

        return success_response(patient.to_dict(), '添加成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'添加失败: {str(e)}', 500)


@bp.route('/<int:patient_id>', methods=['PUT'])
@login_required()
def update_patient(patient_id):
    """
    更新就诊人

    路径参数:
    - patient_id: 就诊人ID

    请求体:
    {
        "name": "张三",
        "gender": "male",
        ...
    }

    响应:
    {
        "success": true,
        "data": {...},
        "message": "更新成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        patient = Patient.query.filter_by(
            id=patient_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not patient:
            return error_response('就诊人不存在', 404)

        data = request.get_json()

        # 如果设置为默认就诊人，取消其他默认
        if data.get('is_default') and not patient.is_default:
            Patient.query.filter_by(
                user_id=current_user_id,
                is_default=True,
                is_deleted=False
            ).update({'is_default': False})

        # 更新字段
        if 'name' in data:
            patient.name = data['name']
        if 'gender' in data:
            if data['gender'] not in ['male', 'female']:
                return error_response('性别值错误', 400)
            patient.gender = data['gender']
        if 'birth_date' in data and data['birth_date']:
            try:
                patient.birth_date = datetime.strptime(data['birth_date'], '%Y-%m-%d').date()
            except ValueError:
                return error_response('出生日期格式错误', 400)
        if 'phone' in data:
            patient.phone = data['phone']
        if 'id_card' in data:
            patient.id_card = data['id_card']
        if 'relationship' in data:
            patient.relationship = data['relationship']
        if 'medical_history' in data:
            patient.medical_history = data['medical_history']
        if 'allergies' in data:
            patient.allergies = data['allergies']
        if 'special_needs' in data:
            patient.special_needs = data['special_needs']
        if 'insurance_type' in data:
            patient.insurance_type = data['insurance_type']
        if 'insurance_number' in data:
            patient.insurance_number = data['insurance_number']
        if 'is_default' in data:
            patient.is_default = data['is_default']

        patient.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(patient.to_dict(), '更新成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'更新失败: {str(e)}', 500)


@bp.route('/<int:patient_id>', methods=['DELETE'])
@login_required()
def delete_patient(patient_id):
    """
    删除就诊人

    路径参数:
    - patient_id: 就诊人ID

    响应:
    {
        "success": true,
        "message": "删除成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        patient = Patient.query.filter_by(
            id=patient_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not patient:
            return error_response('就诊人不存在', 404)

        # 软删除
        patient.is_deleted = True
        patient.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(None, '删除成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'删除失败: {str(e)}', 500)


@bp.route('/<int:patient_id>/set-default', methods=['POST'])
@login_required()
def set_default_patient(patient_id):
    """
    设置默认就诊人

    路径参数:
    - patient_id: 就诊人ID

    响应:
    {
        "success": true,
        "message": "设置成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        patient = Patient.query.filter_by(
            id=patient_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not patient:
            return error_response('就诊人不存在', 404)

        # 取消其他默认
        Patient.query.filter_by(
            user_id=current_user_id,
            is_default=True,
            is_deleted=False
        ).update({'is_default': False})

        # 设置为默认
        patient.is_default = True
        patient.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(patient.to_dict(), '设置成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'设置失败: {str(e)}', 500)
