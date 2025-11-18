# -*- coding: utf-8 -*-
"""
消息/会话管理API - 用户端
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime
from sqlalchemy import or_, and_

from app.models.message import Conversation, Message
from app.models.companion import Companion
from app.models.user import User
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_message', __name__, url_prefix='/api/v1/user/messages')


@bp.route('/conversations', methods=['GET'])
@login_required()
def get_conversations():
    """
    获取会话列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）

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
        current_user_id = get_jwt_identity()
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        page_size = min(page_size, 100)

        # 查询用户的会话列表
        query = Conversation.query.filter_by(
            user_id=current_user_id,
            status='active'
        ).order_by(Conversation.updated_at.desc())

        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 转换为字典并添加对方信息
        conversations = []
        for conv in pagination.items:
            conv_dict = conv.to_dict()

            # 添加对方信息（陪诊师或机构）
            if conv.companion_id:
                companion = Companion.query.get(conv.companion_id)
                if companion:
                    conv_dict['other_party'] = {
                        'id': companion.id,
                        'type': 'companion',
                        'name': companion.name,
                        'avatar_url': companion.avatar_url
                    }
            # TODO: 添加机构信息处理

            conversations.append(conv_dict)

        return success_response({
            'list': conversations,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取会话列表成功')

    except Exception as e:
        return error_response(f'获取会话列表失败: {str(e)}', 500)


@bp.route('/conversations/<int:conversation_id>', methods=['GET'])
@login_required()
def get_conversation_messages(conversation_id):
    """
    获取会话消息列表

    路径参数:
    - conversation_id: 会话ID

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认50）

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 100,
            "page": 1,
            "page_size": 50
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # 验证会话权限
        conversation = Conversation.query.filter_by(
            id=conversation_id,
            user_id=current_user_id
        ).first()

        if not conversation:
            return error_response('会话不存在', 404)

        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 50, type=int)
        page_size = min(page_size, 100)

        # 查询消息列表
        query = Message.query.filter_by(
            conversation_id=conversation_id,
            is_deleted=False
        ).order_by(Message.created_at.desc())

        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 标记消息为已读
        Message.query.filter_by(
            conversation_id=conversation_id,
            receiver_id=current_user_id,
            is_read=False
        ).update({'is_read': True})

        # 更新会话未读数
        conversation.unread_count = 0
        db.session.commit()

        return success_response({
            'list': [msg.to_dict() for msg in reversed(pagination.items)],  # 反转，最早的在前
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取消息列表成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'获取消息列表失败: {str(e)}', 500)


@bp.route('/conversations/<int:conversation_id>/messages', methods=['POST'])
@login_required()
def send_message(conversation_id):
    """
    发送消息

    路径参数:
    - conversation_id: 会话ID

    请求体:
    {
        "content": "消息内容",
        "content_type": "text"
    }

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            "content": "消息内容",
            ...
        },
        "message": "发送成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # 验证会话权限
        conversation = Conversation.query.filter_by(
            id=conversation_id,
            user_id=current_user_id
        ).first()

        if not conversation:
            return error_response('会话不存在', 404)

        data = request.get_json()

        if 'content' not in data:
            return error_response('缺少必填字段: content', 400)

        # 确定接收者
        receiver_id = conversation.companion_id or conversation.institution_id
        receiver_type = 'companion' if conversation.companion_id else 'institution'

        # 创建消息
        message = Message(
            conversation_id=conversation_id,
            sender_id=current_user_id,
            sender_type='user',
            receiver_id=receiver_id,
            receiver_type=receiver_type,
            content_type=data.get('content_type', 'text'),
            content=data['content']
        )

        db.session.add(message)

        # 更新会话信息
        conversation.last_message = data['content']
        conversation.updated_at = datetime.utcnow()

        db.session.commit()

        return success_response(message.to_dict(), '发送成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'发送失败: {str(e)}', 500)


@bp.route('/conversations', methods=['POST'])
@login_required()
def create_conversation():
    """
    创建会话

    请求体:
    {
        "companion_id": 1,  // 或 institution_id
        "title": "会话标题"
    }

    响应:
    {
        "success": true,
        "data": {
            "id": 1,
            ...
        },
        "message": "创建成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        data = request.get_json()

        # 验证参数
        companion_id = data.get('companion_id')
        institution_id = data.get('institution_id')

        if not companion_id and not institution_id:
            return error_response('必须指定 companion_id 或 institution_id', 400)

        # 检查是否已存在会话
        existing = Conversation.query.filter_by(
            user_id=current_user_id,
            companion_id=companion_id,
            institution_id=institution_id,
            status='active'
        ).first()

        if existing:
            return success_response(existing.to_dict(), '会话已存在')

        # 创建新会话
        conversation = Conversation(
            user_id=current_user_id,
            companion_id=companion_id,
            institution_id=institution_id,
            title=data.get('title', '新会话')
        )

        db.session.add(conversation)
        db.session.commit()

        return success_response(conversation.to_dict(), '创建成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'创建失败: {str(e)}', 500)


@bp.route('/conversations/<int:conversation_id>', methods=['DELETE'])
@login_required()
def delete_conversation(conversation_id):
    """
    删除会话（归档）

    路径参数:
    - conversation_id: 会话ID

    响应:
    {
        "success": true,
        "message": "删除成功"
    }
    """
    try:
        current_user_id = get_jwt_identity()
        conversation = Conversation.query.filter_by(
            id=conversation_id,
            user_id=current_user_id
        ).first()

        if not conversation:
            return error_response('会话不存在', 404)

        # 归档会话
        conversation.status = 'archived'
        conversation.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(None, '删除成功')

    except Exception as e:
        db.session.rollback()
        return error_response(f'删除失败: {str(e)}', 500)


@bp.route('/unread-count', methods=['GET'])
@login_required()
def get_unread_count():
    """
    获取未读消息总数

    响应:
    {
        "success": true,
        "data": {
            "count": 5
        }
    }
    """
    try:
        current_user_id = get_jwt_identity()
        # 统计未读消息数
        total_unread = db.session.query(
            db.func.sum(Conversation.unread_count)
        ).filter_by(
            user_id=current_user_id,
            status='active'
        ).scalar() or 0

        return success_response({
            'count': int(total_unread)
        }, '获取成功')

    except Exception as e:
        return error_response(f'获取失败: {str(e)}', 500)
