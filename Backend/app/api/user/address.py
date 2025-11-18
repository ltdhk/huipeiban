# -*- coding: utf-8 -*-
"""
地址管理API - 用户端
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime

from app.models.user import Address
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_address', __name__, url_prefix='/api/v1/user/addresses')


@bp.route('', methods=['GET'])
@login_required()
def get_addresses():
    """
    获取地址列表

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 3
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        addresses = Address.query.filter_by(
            user_id=current_user_id,
            is_deleted=False
        ).order_by(Address.is_default.desc(), Address.created_at.desc()).all()

        return success_response({
            'list': [addr.to_dict() for addr in addresses],
            'total': len(addresses)
        }, '获取地址列表成功')

    except Exception as e:
        return error_response(f'获取地址列表失败: {str(e)}', 500)


@bp.route('/<int:address_id>', methods=['GET'])
@login_required()
def get_address(address_id):
    """
    获取地址详情

    路径参数:
    - address_id: 地址ID

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            "contact_name": "张三",
            ...
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        address = Address.query.filter_by(
            id=address_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not address:
            return error_response('地址不存在', 404)

        return success_response(address.to_dict(), '获取地址详情成功')

    except Exception as e:
        return error_response(f'获取地址详情失败: {str(e)}', 500)


@bp.route('', methods=['POST'])
@login_required()
def create_address():
    """
    创建地址

    请求体:
    {
        "contact_name": "张三",
        "contact_phone": "13800138000",
        "province": "北京市",
        "city": "北京市",
        "district": "朝阳区",
        "detail_address": "xxx小区xxx号楼xxx室",
        "latitude": 39.9042,
        "longitude": 116.4074,
        "address_type": "home",
        "label": "家",
        "is_default": true
    }

    响应:
    {
        "success": true,
        "data": {...},
        "message": "添加成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()

        # 验证必填字段
        required_fields = ['contact_name', 'contact_phone', 'province', 'city', 'district', 'detail_address']
        for field in required_fields:
            if field not in data:
                return error_response(f'缺少必填字段: {field}', 400)

        # 验证地址类型
        address_type = data.get('address_type', 'other')
        if address_type not in ['home', 'company', 'hospital', 'other']:
            return error_response('地址类型错误', 400)

        # 如果设置为默认地址，取消其他默认
        if data.get('is_default'):
            Address.query.filter_by(
                user_id=current_user_id,
                is_default=True,
                is_deleted=False
            ).update({'is_default': False})

        # 创建地址
        address = Address(
            user_id=current_user_id,
            contact_name=data['contact_name'],
            contact_phone=data['contact_phone'],
            province=data['province'],
            city=data['city'],
            district=data['district'],
            detail_address=data['detail_address'],
            latitude=data.get('latitude'),
            longitude=data.get('longitude'),
            address_type=address_type,
            label=data.get('label'),
            is_default=data.get('is_default', False)
        )

        db.session.add(address)
        db.session.commit()

        return success_response(address.to_dict(), '添加成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'添加失败: {str(e)}', 500)


@bp.route('/<int:address_id>', methods=['PUT'])
@login_required()
def update_address(address_id):
    """
    更新地址

    路径参数:
    - address_id: 地址ID

    请求体:
    {
        "contact_name": "李四",
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
        address = Address.query.filter_by(
            id=address_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not address:
            return error_response('地址不存在', 404)

        data = request.get_json()

        # 如果设置为默认地址，取消其他默认
        if data.get('is_default') and not address.is_default:
            Address.query.filter_by(
                user_id=current_user_id,
                is_default=True,
                is_deleted=False
            ).update({'is_default': False})

        # 更新字段
        if 'contact_name' in data:
            address.contact_name = data['contact_name']
        if 'contact_phone' in data:
            address.contact_phone = data['contact_phone']
        if 'province' in data:
            address.province = data['province']
        if 'city' in data:
            address.city = data['city']
        if 'district' in data:
            address.district = data['district']
        if 'detail_address' in data:
            address.detail_address = data['detail_address']
        if 'latitude' in data:
            address.latitude = data['latitude']
        if 'longitude' in data:
            address.longitude = data['longitude']
        if 'address_type' in data:
            if data['address_type'] not in ['home', 'company', 'hospital', 'other']:
                return error_response('地址类型错误', 400)
            address.address_type = data['address_type']
        if 'label' in data:
            address.label = data['label']
        if 'is_default' in data:
            address.is_default = data['is_default']

        address.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(address.to_dict(), '更新成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'更新失败: {str(e)}', 500)


@bp.route('/<int:address_id>', methods=['DELETE'])
@login_required()
def delete_address(address_id):
    """
    删除地址

    路径参数:
    - address_id: 地址ID

    响应:
    {
        "success": true,
        "message": "删除成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        address = Address.query.filter_by(
            id=address_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not address:
            return error_response('地址不存在', 404)

        # 软删除
        address.is_deleted = True
        address.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(None, '删除成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'删除失败: {str(e)}', 500)


@bp.route('/<int:address_id>/set-default', methods=['POST'])
@login_required()
def set_default_address(address_id):
    """
    设置默认地址

    路径参数:
    - address_id: 地址ID

    响应:
    {
        "success": true,
        "message": "设置成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        address = Address.query.filter_by(
            id=address_id,
            user_id=current_user_id,
            is_deleted=False
        ).first()

        if not address:
            return error_response('地址不存在', 404)

        # 取消其他默认
        Address.query.filter_by(
            user_id=current_user_id,
            is_default=True,
            is_deleted=False
        ).update({'is_default': False})

        # 设置为默认
        address.is_default = True
        address.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(address.to_dict(), '设置成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'设置失败: {str(e)}', 500)
