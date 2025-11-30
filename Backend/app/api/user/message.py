# -*- coding: utf-8 -*-
"""
消息/会话管理API - 用户端

简化设计：
- 会话只需要指定对方用户ID（target_user_id）
- 所有用户ID都统一使用 users 表
"""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity
from datetime import datetime
from sqlalchemy import or_, and_

from app.models.message import Conversation, Message
from app.models.user import User
from app.utils.decorators import login_required
from app.utils.response import success_response, error_response
from app.extensions import db

bp = Blueprint('user_message', __name__, url_prefix='/api/v1/user/messages')


def _get_user_info(user_id):
    """获取用户基本信息"""
    user = User.query.get(user_id)
    if not user:
        return None
    return {
        'id': user.id,
        'nickname': user.nickname,
        'avatar_url': user.avatar_url,
        'user_type': user.user_type
    }


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
        current_user_id = int(get_jwt_identity())
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)
        page_size = min(page_size, 100)

        # 查询用户参与的所有会话
        query = Conversation.get_user_conversations(current_user_id)
        pagination = query.paginate(page=page, per_page=page_size, error_out=False)

        # 转换为字典并添加对方信息
        conversations = []
        for conv in pagination.items:
            conv_dict = conv.to_dict(current_user_id)
            # 添加对方用户信息
            other_user_id = conv.get_other_user_id(current_user_id)
            other_user = _get_user_info(other_user_id)
            if other_user:
                conv_dict['other_party'] = other_user
            conversations.append(conv_dict)

        return success_response({
            'list': conversations,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取会话列表成功')

    except Exception as e:
        return error_response(500, 'INTERNAL_ERROR', f'获取会话列表失败: {str(e)}')


@bp.route('/conversations/<conversation_id>', methods=['GET'])
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
    # 将字符串转换为整数（支持大整数ID）
    try:
        conversation_id = int(conversation_id)
    except ValueError:
        return error_response(400, 'BAD_REQUEST', '无效的会话ID')

    try:
        current_user_id = int(get_jwt_identity())

        # 验证会话权限（用户必须是会话参与者）
        conversation = Conversation.query.get(conversation_id)
        if not conversation or not conversation.is_participant(current_user_id):
            return error_response(404, 'NOT_FOUND', '会话不存在')

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

        # 清除当前用户的未读数
        conversation.clear_unread(current_user_id)
        db.session.commit()

        messages_list = [msg.to_dict() for msg in reversed(pagination.items)]

        return success_response({
            'list': messages_list,
            'total': pagination.total,
            'page': page,
            'page_size': page_size,
            'total_pages': pagination.pages
        }, '获取消息列表成功')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', f'获取消息列表失败: {str(e)}')


@bp.route('/conversations/<conversation_id>/messages', methods=['POST'])
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
    # 将字符串转换为整数（支持大整数ID）
    try:
        conversation_id = int(conversation_id)
    except ValueError:
        return error_response(400, 'BAD_REQUEST', '无效的会话ID')

    try:
        current_user_id = int(get_jwt_identity())

        # 验证会话权限
        conversation = Conversation.query.get(conversation_id)
        if not conversation or not conversation.is_participant(current_user_id):
            return error_response(404, 'NOT_FOUND', '会话不存在')

        data = request.get_json()

        if 'content' not in data:
            return error_response(400, 'BAD_REQUEST', '缺少必填字段: content')

        # 确定接收者（对方用户）
        receiver_id = conversation.get_other_user_id(current_user_id)

        # 创建消息
        message = Message(
            conversation_id=conversation_id,
            sender_id=current_user_id,
            receiver_id=receiver_id,
            content_type=data.get('content_type', 'text'),
            content=data['content']
        )

        db.session.add(message)

        # 更新会话信息
        now = datetime.utcnow()
        conversation.last_message = data['content'] if data.get('content_type', 'text') == 'text' else f"[{data.get('content_type')}]"
        conversation.last_message_at = now
        conversation.updated_at = now
        # 增加接收者的未读数
        conversation.increment_unread(receiver_id)

        db.session.commit()

        return success_response(message.to_dict(), '发送成功')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', f'发送失败: {str(e)}')


@bp.route('/conversations', methods=['POST'])
@login_required()
def create_conversation():
    """
    创建会话

    请求体:
    {
        "target_user_id": 123  // 对方用户ID
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
        current_user_id = int(get_jwt_identity())
        data = request.get_json()

        # 验证参数
        target_user_id = data.get('target_user_id')
        if not target_user_id:
            return error_response(400, 'BAD_REQUEST', '必须指定 target_user_id')

        target_user_id = int(target_user_id)

        # 不能与自己创建会话
        if target_user_id == current_user_id:
            return error_response(400, 'BAD_REQUEST', '不能与自己创建会话')

        # 验证目标用户存在
        target_user = User.query.get(target_user_id)
        if not target_user:
            return error_response(404, 'NOT_FOUND', '目标用户不存在')

        # 检查是否已存在会话（不区分顺序）
        existing = Conversation.find_by_users(current_user_id, target_user_id)
        if existing:
            conv_dict = existing.to_dict(current_user_id)
            # 添加对方信息
            other_user = _get_user_info(target_user_id)
            if other_user:
                conv_dict['other_party'] = other_user
            return success_response(conv_dict, '会话已存在')

        # 创建新会话
        conversation = Conversation(
            user1_id=current_user_id,
            user2_id=target_user_id
        )

        db.session.add(conversation)
        db.session.commit()

        conv_dict = conversation.to_dict(current_user_id)
        # 添加对方信息
        other_user = _get_user_info(target_user_id)
        if other_user:
            conv_dict['other_party'] = other_user

        return success_response(conv_dict, '创建成功')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', f'创建失败: {str(e)}')


@bp.route('/conversations/<conversation_id>', methods=['DELETE'])
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
    # 将字符串转换为整数（支持大整数ID）
    try:
        conversation_id = int(conversation_id)
    except ValueError:
        return error_response(400, 'BAD_REQUEST', '无效的会话ID')

    try:
        current_user_id = int(get_jwt_identity())

        conversation = Conversation.query.get(conversation_id)
        if not conversation or not conversation.is_participant(current_user_id):
            return error_response(404, 'NOT_FOUND', '会话不存在')

        # 归档会话
        conversation.status = 'archived'
        conversation.updated_at = datetime.utcnow()
        db.session.commit()

        return success_response(None, '删除成功')

    except Exception as e:
        db.session.rollback()
        return error_response(500, 'INTERNAL_ERROR', f'删除失败: {str(e)}')


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
        current_user_id = int(get_jwt_identity())

        # 统计用户在所有会话中的未读数
        # 需要分别查询 user1_unread 和 user2_unread
        total_unread = 0

        # 作为 user1 的会话
        unread_as_user1 = db.session.query(
            db.func.coalesce(db.func.sum(Conversation.user1_unread), 0)
        ).filter(
            Conversation.user1_id == current_user_id,
            Conversation.status == 'active'
        ).scalar() or 0

        # 作为 user2 的会话
        unread_as_user2 = db.session.query(
            db.func.coalesce(db.func.sum(Conversation.user2_unread), 0)
        ).filter(
            Conversation.user2_id == current_user_id,
            Conversation.status == 'active'
        ).scalar() or 0

        total_unread = int(unread_as_user1) + int(unread_as_user2)

        return success_response({
            'count': total_unread
        }, '获取成功')

    except Exception as e:
        return error_response(500, 'INTERNAL_ERROR', f'获取失败: {str(e)}')
