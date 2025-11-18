# -*- coding: utf-8 -*-
"""
直接测试搜索陪诊师功能
"""
from app import create_app
from app.services.recommendation import recommendation_service

app = create_app()

with app.app_context():
    print('='*60)
    print('测试1: 搜索上海的陪诊师')
    print('='*60)
    results1 = recommendation_service.recommend_companions(
        city='上海',
        limit=10
    )
    print(f'找到 {len(results1)} 个陪诊师')
    for c in results1:
        print(f'  - {c["name"]} (评分: {c["rating"]}, 匹配分: {c["match_score"]})')
    print()

    print('='*60)
    print('测试2: 搜索服务上海六院的陪诊师')
    print('='*60)
    results2 = recommendation_service.recommend_companions(
        city='上海',
        hospital='上海六院',
        limit=10
    )
    print(f'找到 {len(results2)} 个陪诊师')
    for c in results2:
        print(f'  - {c["name"]} (评分: {c["rating"]}, 服务医院: {c.get("service_hospitals", "无")})')
        print(f'    匹配分: {c["match_score"]}, 推荐理由: {c["recommendation_reason"]}')
    print()

    print('='*60)
    print('测试3: 搜索所有服务医院包含"六院"的陪诊师')
    print('='*60)
    results3 = recommendation_service.recommend_companions(
        hospital='六院',
        limit=10
    )
    print(f'找到 {len(results3)} 个陪诊师')
    for c in results3:
        print(f'  - {c["name"]} (服务医院: {c.get("service_hospitals", "无")})')
