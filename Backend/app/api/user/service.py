# -*- coding: utf-8 -*-
"""
服务管理API - 陪诊师端
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from app.models.companion import Service, ServiceSpec, Companion
from app.models.user import User
from app.utils.response import success_response, error_response
from app.utils.decorators import login_required
from app.extensions import db
import json


def get_current_user():
    """获取当前登录用户"""
    user_id = get_jwt_identity()
    if isinstance(user_id, str):
        user_id = int(user_id)
    return User.query.get(user_id)

bp = Blueprint('user_service', __name__, url_prefix='/api/v1/user/services')


@bp.route('', methods=['GET'])
@login_required()
def get_services():
    """
    获取当前陪诊师的服务列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    - is_active: 是否上架（true/false/all，默认all）

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 10,
            "page": 1,
            "page_size": 20
        }
    }
    """
    try:
        current_user = get_current_user()

        # 获取当前用户的陪诊师信息
        companion = Companion.query.filter_by(
            user_id=current_user.id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 获取查询参数
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        is_active = request.args.get('is_active', 'all').strip()

        # 限制分页大小
        page_size = min(page_size, 100)

        # 构建查询
        query = Service.query.filter_by(
            companion_id=companion.id,
            is_deleted=False
        )

        # 状态筛选
        if is_active and is_active != 'all':
            is_active_bool = is_active.lower() == 'true'
            query = query.filter_by(is_active=is_active_bool)

        # 排序（按创建时间倒序）
        query = query.order_by(Service.created_at.desc())

        # 分页
        total = query.count()
        services = query.offset((page - 1) * page_size).limit(page_size).all()

        # 转换为字典并加载规格
        service_list = []
        for service in services:
            service_dict = service.to_dict()
            # 加载规格列表
            specs = ServiceSpec.query.filter_by(
                service_id=service.id,
                is_deleted=False
            ).order_by(ServiceSpec.sort_order.asc()).all()
            service_dict['specs'] = [spec.to_dict() for spec in specs]
            # 添加浏览量字段
            service_dict['view_count'] = service.view_count
            service_list.append(service_dict)

        return success_response({
            'list': service_list,
            'total': total,
            'page': page,
            'page_size': page_size
        })

    except Exception as e:
        return error_response(500, 'QUERY_FAILED', f'获取服务列表失败: {str(e)}')


@bp.route('/<int:service_id>', methods=['GET'])
@login_required()
def get_service(service_id):
    """
    获取服务详情

    响应:
    {
        "success": true,
        "data": {服务详情}
    }
    """
    try:
        current_user = get_current_user()

        # 获取当前用户的陪诊师信息
        companion = Companion.query.filter_by(
            user_id=current_user.id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询服务
        service = Service.query.filter_by(
            id=service_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not service:
            return error_response(404, 'SERVICE_NOT_FOUND', '服务不存在')

        # 转换为字典并加载规格
        service_dict = service.to_dict()
        specs = ServiceSpec.query.filter_by(
            service_id=service.id,
            is_deleted=False
        ).order_by(ServiceSpec.sort_order.asc()).all()
        service_dict['specs'] = [spec.to_dict() for spec in specs]
        service_dict['view_count'] = service.view_count

        return success_response(service_dict)

    except Exception as e:
        return error_response(500, 'QUERY_FAILED', f'获取服务详情失败: {str(e)}')


@bp.route('', methods=['POST'])
@login_required()
def create_service():
    """
    创建服务

    请求体:
    {
        "title": "全程陪诊服务",
        "category": "陪诊",
        "description": "提供全程陪同就诊服务",
        "features": ["挂号", "陪同就诊", "取药"],
        "base_price": 200.0,
        "additional_hour_price": 50.0,
        "is_active": true,
        "specs": [
            {
                "name": "基础套餐",
                "description": "4小时服务",
                "duration_hours": 4,
                "price": 200.0,
                "features": ["挂号", "陪同就诊"],
                "sort_order": 0,
                "is_active": true
            }
        ]
    }

    响应:
    {
        "success": true,
        "data": {服务详情}
    }
    """
    try:
        current_user = get_current_user()
        data = request.get_json()

        if not data:
            return error_response(400, 'EMPTY_REQUEST', '请求数据不能为空')

        # 验证必填字段
        if not data.get('title'):
            return error_response(400, 'MISSING_TITLE', '服务标题不能为空')
        if not data.get('base_price'):
            return error_response(400, 'MISSING_PRICE', '基础价格不能为空')
        if not data.get('specs') or len(data['specs']) == 0:
            return error_response(400, 'MISSING_SPECS', '至少需要一个服务规格')

        # 获取当前用户的陪诊师信息
        companion = Companion.query.filter_by(
            user_id=current_user.id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 创建服务
        service = Service(
            companion_id=companion.id,
            title=data['title'],
            category=data.get('category'),
            description=data.get('description'),
            features=json.dumps(data.get('features', []), ensure_ascii=False) if data.get('features') else None,
            base_price=float(data['base_price']),
            additional_hour_price=float(data['additional_hour_price']) if data.get('additional_hour_price') else None,
            is_active=data.get('is_active', True)
        )

        db.session.add(service)
        db.session.flush()  # 获取服务ID

        # 创建服务规格
        for spec_data in data['specs']:
            if not spec_data.get('name') or not spec_data.get('duration_hours') or not spec_data.get('price'):
                continue

            spec = ServiceSpec(
                service_id=service.id,
                name=spec_data['name'],
                description=spec_data.get('description'),
                duration_hours=int(spec_data['duration_hours']),
                price=float(spec_data['price']),
                features=json.dumps(spec_data.get('features', []), ensure_ascii=False) if spec_data.get('features') else None,
                sort_order=spec_data.get('sort_order', 0),
                is_active=spec_data.get('is_active', True)
            )
            db.session.add(spec)

        db.session.commit()

        # 返回创建的服务详情
        service_dict = service.to_dict()
        specs = ServiceSpec.query.filter_by(
            service_id=service.id,
            is_deleted=False
        ).order_by(ServiceSpec.sort_order.asc()).all()
        service_dict['specs'] = [spec.to_dict() for spec in specs]
        service_dict['view_count'] = service.view_count

        return success_response(service_dict, 201)

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'CREATE_FAILED', f'创建服务失败: {str(e)}')


@bp.route('/<int:service_id>', methods=['PUT'])
@login_required()
def update_service(service_id):
    """
    更新服务

    请求体格式同创建服务

    响应:
    {
        "success": true,
        "data": {服务详情}
    }
    """
    try:
        current_user = get_current_user()
        data = request.get_json()

        if not data:
            return error_response(400, 'EMPTY_REQUEST', '请求数据不能为空')

        # 获取当前用户的陪诊师信息
        companion = Companion.query.filter_by(
            user_id=current_user.id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询服务
        service = Service.query.filter_by(
            id=service_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not service:
            return error_response(404, 'SERVICE_NOT_FOUND', '服务不存在')

        # 更新服务基本信息
        if 'title' in data:
            service.title = data['title']
        if 'category' in data:
            service.category = data['category']
        if 'description' in data:
            service.description = data['description']
        if 'features' in data:
            service.features = json.dumps(data['features'], ensure_ascii=False)
        if 'base_price' in data:
            service.base_price = float(data['base_price'])
        if 'additional_hour_price' in data:
            service.additional_hour_price = float(data['additional_hour_price']) if data['additional_hour_price'] else None
        if 'is_active' in data:
            service.is_active = data['is_active']

        # 更新规格
        if 'specs' in data:
            # 删除所有现有规格（软删除）
            existing_specs = ServiceSpec.query.filter_by(
                service_id=service.id,
                is_deleted=False
            ).all()
            for spec in existing_specs:
                spec.is_deleted = True

            # 创建新规格
            for spec_data in data['specs']:
                if not spec_data.get('name') or not spec_data.get('duration_hours') or not spec_data.get('price'):
                    continue

                spec = ServiceSpec(
                    service_id=service.id,
                    name=spec_data['name'],
                    description=spec_data.get('description'),
                    duration_hours=int(spec_data['duration_hours']),
                    price=float(spec_data['price']),
                    features=json.dumps(spec_data.get('features', []), ensure_ascii=False) if spec_data.get('features') else None,
                    sort_order=spec_data.get('sort_order', 0),
                    is_active=spec_data.get('is_active', True)
                )
                db.session.add(spec)

        db.session.commit()

        # 返回更新后的服务详情
        service_dict = service.to_dict()
        specs = ServiceSpec.query.filter_by(
            service_id=service.id,
            is_deleted=False
        ).order_by(ServiceSpec.sort_order.asc()).all()
        service_dict['specs'] = [spec.to_dict() for spec in specs]
        service_dict['view_count'] = service.view_count

        return success_response(service_dict)

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'UPDATE_FAILED', f'更新服务失败: {str(e)}')


@bp.route('/<int:service_id>', methods=['DELETE'])
@login_required()
def delete_service(service_id):
    """
    删除服务（软删除）

    响应:
    {
        "success": true,
        "message": "删除成功"
    }
    """
    try:
        current_user = get_current_user()

        # 获取当前用户的陪诊师信息
        companion = Companion.query.filter_by(
            user_id=current_user.id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询服务
        service = Service.query.filter_by(
            id=service_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not service:
            return error_response(404, 'SERVICE_NOT_FOUND', '服务不存在')

        # 软删除服务
        service.is_deleted = True

        # 软删除所有规格
        specs = ServiceSpec.query.filter_by(
            service_id=service.id,
            is_deleted=False
        ).all()
        for spec in specs:
            spec.is_deleted = True

        db.session.commit()

        return success_response(message='删除成功')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'DELETE_FAILED', f'删除服务失败: {str(e)}')


@bp.route('/<int:service_id>/toggle', methods=['POST'])
@login_required()
def toggle_service(service_id):
    """
    切换服务上下架状态

    响应:
    {
        "success": true,
        "data": {
            "is_active": true
        }
    }
    """
    try:
        current_user = get_current_user()

        # 获取当前用户的陪诊师信息
        companion = Companion.query.filter_by(
            user_id=current_user.id,
            is_deleted=False
        ).first()

        if not companion:
            return error_response(404, 'COMPANION_NOT_FOUND', '陪诊师信息不存在')

        # 查询服务
        service = Service.query.filter_by(
            id=service_id,
            companion_id=companion.id,
            is_deleted=False
        ).first()

        if not service:
            return error_response(404, 'SERVICE_NOT_FOUND', '服务不存在')

        # 切换状态
        service.is_active = not service.is_active
        db.session.commit()

        return success_response({
            'is_active': service.is_active
        })

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'TOGGLE_FAILED', f'切换服务状态失败: {str(e)}')
