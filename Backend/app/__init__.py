# -*- coding: utf-8 -*-
"""
应用工厂函数
"""
from flask import Flask
from flask_cors import CORS
from config import config
from app.extensions import db, migrate, jwt


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

    # 注册健康检查端点
    register_health_check(app)

    return app


def register_blueprints(app):
    """注册蓝图"""
    from app.api.user import user_bp
    from app.api.user.ai import bp as ai_bp
    from app.api.user.companion import bp as companion_bp
    from app.api.user.institution import bp as institution_bp
    from app.api.user.order import bp as order_bp
    from app.api.user.payment import bp as payment_bp
    from app.api.user.patient import bp as patient_bp
    from app.api.user.address import bp as address_bp
    from app.api.user.message import bp as message_bp
    from app.api.user.review import bp as review_bp
    from app.api.admin import admin_bp

    # 用户端 API
    app.register_blueprint(user_bp, url_prefix='/api/v1/user')
    app.register_blueprint(ai_bp)  # AI 接口（已包含 /api/v1/user/ai 前缀）
    app.register_blueprint(companion_bp)  # 陪诊师接口（已包含 /api/v1/user/companions 前缀）
    app.register_blueprint(institution_bp)  # 机构接口（已包含 /api/v1/user/institutions 前缀）
    app.register_blueprint(order_bp)  # 订单接口（已包含 /api/v1/user/orders 前缀）
    app.register_blueprint(payment_bp)  # 支付接口（已包含 /api/v1/user/payments 前缀）
    app.register_blueprint(patient_bp)  # 就诊人接口（已包含 /api/v1/user/patients 前缀）
    app.register_blueprint(address_bp)  # 地址接口（已包含 /api/v1/user/addresses 前缀）
    app.register_blueprint(message_bp)  # 消息接口（已包含 /api/v1/user/messages 前缀）
    app.register_blueprint(review_bp)  # 评价接口（已包含 /api/v1/user/reviews 前缀）

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
    from app.utils.logger import setup_logging, log_request, log_error

    # 设置日志系统
    setup_logging(app)

    # 配置请求日志（开发环境）
    if app.debug:
        log_request(app)


def register_health_check(app):
    """注册健康检查端点"""
    from flask import jsonify
    from datetime import datetime

    @app.route('/health', methods=['GET'])
    def health_check():
        """健康检查接口"""
        return jsonify({
            'status': 'healthy',
            'timestamp': datetime.utcnow().isoformat(),
            'service': 'CareLink API',
            'version': '1.0.0'
        }), 200

    @app.route('/', methods=['GET'])
    def index():
        """根路径"""
        return jsonify({
            'message': 'Welcome to CareLink API',
            'version': '1.0.0',
            'docs': '/api/docs'
        }), 200

    app.logger.info('CareLink 应用启动')
