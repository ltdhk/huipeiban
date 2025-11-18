# -*- coding: utf-8 -*-
"""
AI助手相关API - 用户端
"""
from flask import Blueprint, request, jsonify
from flask_jwt_extended import get_jwt_identity
from app.utils.decorators import login_required
from app.services.ai_agent import ai_agent
from app.utils.response import success_response, error_response

bp = Blueprint('user_ai', __name__, url_prefix='/api/v1/user/ai')


@bp.route('/chat', methods=['POST'])
@login_required()
def chat():
    """
    AI对话接口

    请求体:
    {
        "message": "我想找陪诊师",
        "session_id": "session_123" # 可选，如果是新对话可以不传
    }

    响应:
    {
        "success": true,
        "data": {
            "session_id": "session_123",
            "message": "AI响应内容",
            "intent": "find_companion",
            "entities": {...},
            "recommendations": [...],
            "created_at": "2025-11-12T10:00:00"
        }
    }
    """
    try:
        data = request.get_json()
        message = data.get('message', '').strip()
        session_id = data.get('session_id')

        # 验证必填参数
        if not message:
            return error_response(400, 'INVALID_INPUT', '消息内容不能为空')

        # 获取当前用户ID（JWT identity 是字符串，需要转换为整数）
        current_user_id = int(get_jwt_identity())

        # 调用AI Agent
        result = ai_agent.chat(
            user_id=current_user_id,
            message=message,
            session_id=session_id
        )

        if result.get('success'):
            return success_response(result, '对话成功')
        else:
            return error_response(500, 'CHAT_ERROR', result.get('error', '对话失败'))

    except Exception as e:
        return error_response(500, 'CHAT_ERROR', f'AI对话失败: {str(e)}')


@bp.route('/history', methods=['GET'])
@login_required()
def get_history():
    """
    获取AI对话历史

    查询参数:
    - session_id: 会话ID（必填）
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）

    响应:
    {
        "success": true,
        "data": {
            "list": [...],
            "total": 100,
            "page": 1,
            "page_size": 20,
            "has_more": true
        }
    }
    """
    try:
        session_id = request.args.get('session_id')
        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)

        # 验证必填参数
        if not session_id:
            return error_response(400, 'INVALID_INPUT', '会话ID不能为空')

        # 获取当前用户ID（JWT identity 是字符串，需要转换为整数）
        current_user_id = int(get_jwt_identity())

        # 获取历史记录
        result = ai_agent.get_chat_history(
            user_id=current_user_id,
            session_id=session_id,
            page=page,
            page_size=page_size
        )

        if result.get('success'):
            return success_response(result, '获取历史记录成功')
        else:
            return error_response(500, 'QUERY_ERROR', result.get('error', '获取历史记录失败'))

    except Exception as e:
        return error_response(500, 'QUERY_ERROR', f'获取历史记录失败: {str(e)}')


@bp.route('/sessions', methods=['GET'])
@login_required()
def get_sessions():
    """
    获取用户的所有AI对话会话列表

    查询参数:
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）

    响应:
    {
        "success": true,
        "data": {
            "list": [
                {
                    "session_id": "session_123",
                    "last_message": "最后一条消息",
                    "created_at": "2025-11-12T10:00:00",
                    "updated_at": "2025-11-12T10:30:00"
                }
            ],
            "total": 10,
            "page": 1,
            "page_size": 20
        }
    }
    """
    try:
        from app.models.ai import AIChatHistory
        from sqlalchemy import func

        page = request.args.get('page', 1, type=int)
        page_size = request.args.get('page_size', 20, type=int)

        # 获取当前用户ID（JWT identity 是字符串，需要转换为整数）
        current_user_id = int(get_jwt_identity())

        # 查询用户的所有会话（按session_id分组）
        subquery = AIChatHistory.query.filter_by(
            user_id=current_user_id
        ).with_entities(
            AIChatHistory.session_id,
            func.max(AIChatHistory.created_at).label('last_time'),
            func.count(AIChatHistory.id).label('message_count')
        ).group_by(
            AIChatHistory.session_id
        ).subquery()

        # 获取每个会话的最后一条消息
        sessions_query = AIChatHistory.query.join(
            subquery,
            (AIChatHistory.session_id == subquery.c.session_id) &
            (AIChatHistory.created_at == subquery.c.last_time)
        ).order_by(AIChatHistory.created_at.desc())

        # 分页
        pagination = sessions_query.paginate(page=page, per_page=page_size, error_out=False)

        sessions = []
        for msg in pagination.items:
            # 获取该会话的第一条消息（作为会话标题）
            first_msg = AIChatHistory.query.filter_by(
                user_id=current_user_id,
                session_id=msg.session_id
            ).order_by(AIChatHistory.created_at.asc()).first()

            sessions.append({
                'session_id': msg.session_id,
                'first_message': first_msg.content[:50] if first_msg else '',  # 前50个字符作为标题
                'last_message': msg.content[:50],
                'created_at': first_msg.created_at.isoformat() if first_msg else None,
                'updated_at': msg.created_at.isoformat()
            })

        return success_response({
            'list': sessions,
            'total': pagination.total,
            'page': page,
            'page_size': page_size
        }, '获取会话列表成功')

    except Exception as e:
        return error_response(500, 'QUERY_ERROR', f'获取会话列表失败: {str(e)}')
