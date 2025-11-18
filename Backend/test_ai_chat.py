# -*- coding: utf-8 -*-
"""
测试AI聊天功能
"""
import requests
import json

# 配置
BASE_URL = 'http://localhost:5000'
TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2MzEzMTU2NCwianRpIjoiNzY3NzllMTQtZTUwMC00MTQ5LWIzOTMtMGYxNGI4ZjcxMWFiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IjE3NjMxMTE2MzczNzI2OTEiLCJuYmYiOjE3NjMxMzE1NjQsImNzcmYiOiI1ODZmNGQ3Ni00NDFlLTRjYjAtODFmNC1lNmRiOTcyNjQyMmMiLCJleHAiOjE3NjMxMzg3NjQsInVzZXJfdHlwZSI6InVzZXIiLCJ0aW1lc3RhbXAiOiIyMDI1LTExLTE0VDE0OjQ2OjA0LjU4NzY1NyIsInBob25lIjoiMTM4MDAxMzgwMDEifQ.N96FwIc_PU4HAJeoNw_uXBxugVtJ3X_Um7S9lffiFC4'

headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': f'Bearer {TOKEN}'
}

data = {
    'message': '我要去上海六院看病，帮我推荐陪诊师',
    'session_id': 'test_session_004'
}

try:
    print('发送请求...')
    response = requests.post(
        f'{BASE_URL}/api/v1/user/ai/chat',
        headers=headers,
        json=data,
        timeout=30
    )

    print(f'状态码: {response.status_code}')
    print(f'响应:\n{json.dumps(response.json(), ensure_ascii=False, indent=2)}')

except Exception as e:
    print(f'错误: {str(e)}')
