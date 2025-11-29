# -*- coding: utf-8 -*-
"""
应用配置文件
"""
import os
from datetime import timedelta
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()


class Config:
    """基础配置"""

    # Flask 配置
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-please-change')
    JSON_AS_ASCII = False  # 支持中文 JSON 响应

    # 数据库配置 (Supabase PostgreSQL)
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URL',
        'postgresql://postgres:password@localhost:5432/carelink'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ECHO = False  # 生产环境设为 False

    # 数据库连接池配置 - 解决 Supabase 连接超时问题
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_pre_ping': True,          # 每次连接前检查连接是否有效
        'pool_recycle': 300,            # 5分钟后回收连接
        'pool_size': 10,                # 连接池大小
        'max_overflow': 20,             # 最大溢出连接数
        'pool_timeout': 30,             # 连接超时时间（秒）
        'connect_args': {
            'connect_timeout': 10,      # TCP 连接超时
            'keepalives': 1,            # 启用 TCP keepalive
            'keepalives_idle': 30,      # keepalive 空闲时间
            'keepalives_interval': 10,  # keepalive 间隔
            'keepalives_count': 5,      # keepalive 重试次数
        }
    }

    # JWT 配置
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'jwt-secret-key-please-change')
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(seconds=int(os.getenv('JWT_ACCESS_TOKEN_EXPIRES', 7200)))
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(seconds=int(os.getenv('JWT_REFRESH_TOKEN_EXPIRES', 604800)))
    JWT_TOKEN_LOCATION = ['headers']
    JWT_HEADER_NAME = 'Authorization'
    JWT_HEADER_TYPE = 'Bearer'

    # 微信小程序配置
    WECHAT_APPID = os.getenv('WECHAT_APPID')
    WECHAT_APP_SECRET = os.getenv('WECHAT_APP_SECRET')

    # 微信支付配置
    WECHAT_PAY_MCHID = os.getenv('WECHAT_PAY_MCHID')
    WECHAT_PAY_SERIAL_NO = os.getenv('WECHAT_PAY_SERIAL_NO')
    WECHAT_PAY_API_V3_KEY = os.getenv('WECHAT_PAY_API_V3_KEY')
    WECHAT_PAY_PRIVATE_KEY_PATH = os.getenv('WECHAT_PAY_PRIVATE_KEY_PATH')
    WECHAT_PAY_CERT_PATH = os.getenv('WECHAT_PAY_CERT_PATH')
    WECHAT_PAY_NOTIFY_URL = os.getenv('WECHAT_PAY_NOTIFY_URL')

    # OpenRouter AI 配置
    OPENROUTER_API_KEY = os.getenv('OPENROUTER_API_KEY')
    OPENROUTER_MODEL = os.getenv('OPENROUTER_MODEL', 'anthropic/claude-3.5-sonnet')
    OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1'
    OPENROUTER_SITE_URL = os.getenv('OPENROUTER_SITE_URL')
    OPENROUTER_SITE_TITLE = os.getenv('OPENROUTER_SITE_TITLE', 'CareLink AI Assistant')

    # Supabase 配置
    SUPABASE_URL = os.getenv('SUPABASE_URL')
    SUPABASE_KEY = os.getenv('SUPABASE_KEY')
    SUPABASE_BUCKET = os.getenv('SUPABASE_BUCKET', 'carelink-files')

    # CORS 配置
    CORS_ORIGINS = os.getenv('CORS_ORIGINS', '*').split(',')

    # 日志配置
    LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')

    # 分页配置
    DEFAULT_PAGE_SIZE = 20
    MAX_PAGE_SIZE = 100

    # 文件上传配置
    MAX_CONTENT_LENGTH = 10 * 1024 * 1024  # 10MB
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'pdf'}


class DevelopmentConfig(Config):
    """开发环境配置"""
    DEBUG = True
    SQLALCHEMY_ECHO = True
    # 开发环境也使用 Supabase PostgreSQL


class ProductionConfig(Config):
    """生产环境配置"""
    DEBUG = False
    SQLALCHEMY_ECHO = False


class TestingConfig(Config):
    """测试环境配置"""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:password@localhost:5432/carelink_test'


# 配置字典
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}
