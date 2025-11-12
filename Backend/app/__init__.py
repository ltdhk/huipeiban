# -*- coding: utf-8 -*-
"""
应用工厂函数
"""
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from config import config

# 初始化扩展
db = SQLAlchemy()
migrate = Migrate()
jwt = JWTManager()


def create_app(config_name='default'):
    """
    应用工厂函数

    Args:
        config_name: 配置名称 (development/production/testing)

    Returns:
        Flask app 实例
    """
    app = Flask(__name__)

    # 加载配置
    app.config.from_object(config[config_name])

    # 初始化扩展
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    CORS(app, origins=app.config['CORS_ORIGINS'])

    # 注册蓝图
    register_blueprints(app)

    # 注册错误处理器
    register_error_handlers(app)

    # 配置日志
    configure_logging(app)

    return app


def register_blueprints(app):
    """注册蓝图"""
    from app.api.user import user_bp
    from app.api.admin import admin_bp

    # 用户端 API
    app.register_blueprint(user_bp, url_prefix='/api/v1/user')

    # 管理端 API
    app.register_blueprint(admin_bp, url_prefix='/api/v1/admin')


def register_error_handlers(app):
    """注册错误处理器"""
    from app.utils.response import error_response

    @app.errorhandler(400)
    def bad_request(e):
        return error_response(400, 'BAD_REQUEST', str(e))

    @app.errorhandler(401)
    def unauthorized(e):
        return error_response(401, 'UNAUTHORIZED', '未授权，请先登录')

    @app.errorhandler(403)
    def forbidden(e):
        return error_response(403, 'FORBIDDEN', '无权限访问')

    @app.errorhandler(404)
    def not_found(e):
        return error_response(404, 'NOT_FOUND', '资源不存在')

    @app.errorhandler(500)
    def internal_error(e):
        app.logger.error(f'服务器内部错误: {e}')
        return error_response(500, 'INTERNAL_ERROR', '服务器内部错误')


def configure_logging(app):
    """配置日志"""
    import logging
    from logging.handlers import RotatingFileHandler
    import os

    if not app.debug and not app.testing:
        # 创建日志目录
        if not os.path.exists('logs'):
            os.mkdir('logs')

        # 文件日志处理器
        file_handler = RotatingFileHandler(
            'logs/carelink.log',
            maxBytes=10240000,  # 10MB
            backupCount=10,
            encoding='utf-8'
        )
        file_handler.setFormatter(logging.Formatter(
            '[%(asctime)s] %(levelname)s in %(module)s: %(message)s'
        ))
        file_handler.setLevel(logging.INFO)
        app.logger.addHandler(file_handler)

    app.logger.setLevel(logging.INFO)
    app.logger.info('CareLink 应用启动')
