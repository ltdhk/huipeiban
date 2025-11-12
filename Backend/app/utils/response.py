# -*- coding: utf-8 -*-
"""
统一响应格式
"""
from flask import jsonify
from datetime import datetime


def success_response(data=None, message='操作成功', status_code=200):
    """
    成功响应

    Args:
        data: 响应数据
        message: 提示消息
        status_code: HTTP 状态码

    Returns:
        JSON 响应
    """
    response = {
        'success': True,
        'data': data,
        'message': message,
        'timestamp': datetime.utcnow().isoformat() + 'Z'
    }
    return jsonify(response), status_code


def error_response(status_code, error_code, message, details=None):
    """
    错误响应

    Args:
        status_code: HTTP 状态码
        error_code: 错误码
        message: 错误消息
        details: 错误详情

    Returns:
        JSON 响应
    """
    response = {
        'success': False,
        'error': {
            'code': error_code,
            'message': message
        },
        'timestamp': datetime.utcnow().isoformat() + 'Z'
    }

    if details:
        response['error']['details'] = details

    return jsonify(response), status_code


def paginated_response(items, total, page, page_size, message='查询成功'):
    """
    分页响应

    Args:
        items: 数据列表
        total: 总记录数
        page: 当前页码
        page_size: 每页数量
        message: 提示消息

    Returns:
        JSON 响应
    """
    import math

    data = {
        'items': items,
        'pagination': {
            'total': total,
            'page': page,
            'page_size': page_size,
            'total_pages': math.ceil(total / page_size) if page_size > 0 else 0
        }
    }

    return success_response(data, message)
