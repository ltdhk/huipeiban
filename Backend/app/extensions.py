# -*- coding: utf-8 -*-
"""
Flask 扩展实例
"""
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager

# 初始化扩展实例
db = SQLAlchemy()
migrate = Migrate()
jwt = JWTManager()
