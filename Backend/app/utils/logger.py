# -*- coding: utf-8 -*-
"""
日志工具模块
"""
import logging
import os
from logging.handlers import RotatingFileHandler
from datetime import datetime


def setup_logging(app):
    """
    配置应用日志系统

    Args:
        app: Flask 应用实例
    """
    # 创建 logs 目录
    log_dir = 'logs'
    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    # 设置日志级别
    log_level = app.config.get('LOG_LEVEL', 'INFO')
    app.logger.setLevel(getattr(logging, log_level))

    # 日志格式
    formatter = logging.Formatter(
        '[%(asctime)s] %(levelname)s in %(module)s: %(message)s'
    )

    # 文件处理器（所有日志）
    file_handler = RotatingFileHandler(
        os.path.join(log_dir, 'carelink.log'),
        maxBytes=10 * 1024 * 1024,  # 10MB
        backupCount=10
    )
    file_handler.setFormatter(formatter)
    file_handler.setLevel(logging.INFO)
    app.logger.addHandler(file_handler)

    # 错误日志处理器
    error_handler = RotatingFileHandler(
        os.path.join(log_dir, 'error.log'),
        maxBytes=10 * 1024 * 1024,  # 10MB
        backupCount=10
    )
    error_handler.setFormatter(formatter)
    error_handler.setLevel(logging.ERROR)
    app.logger.addHandler(error_handler)

    # 控制台处理器（开发环境）
    if app.config['DEBUG']:
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        console_handler.setLevel(logging.DEBUG)
        app.logger.addHandler(console_handler)

    app.logger.info('日志系统初始化完成')


def log_request(app):
    """
    配置请求日志

    Args:
        app: Flask 应用实例
    """

    @app.before_request
    def before_request_logging():
        """请求前记录日志"""
        from flask import request
        app.logger.info(
            f'请求开始: {request.method} {request.path} '
            f'来自 {request.remote_addr}'
        )

    @app.after_request
    def after_request_logging(response):
        """请求后记录日志"""
        from flask import request
        app.logger.info(
            f'请求完成: {request.method} {request.path} '
            f'状态码 {response.status_code}'
        )
        return response


def log_error(app):
    """
    配置错误日志

    Args:
        app: Flask 应用实例
    """

    @app.errorhandler(Exception)
    def handle_exception(e):
        """全局异常处理"""
        app.logger.error(f'未捕获的异常: {str(e)}', exc_info=True)

        # 返回错误响应
        from flask import jsonify
        return jsonify({
            'success': False,
            'message': '服务器内部错误',
            'timestamp': datetime.utcnow().isoformat() + 'Z'
        }), 500
