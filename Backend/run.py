# -*- coding: utf-8 -*-
"""
应用启动文件
"""
import os
from app import create_app

# 获取环境配置
env = os.getenv('FLASK_ENV', 'development')
app = create_app(env)

if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5001,
        debug=app.config['DEBUG']
    )
