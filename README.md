# 🏥 CareLink - 智能陪诊服务平台

> 一个完整的医疗陪诊服务平台，包含小程序端、管理后台和后端 API

## 🚀 快速开始

### 📖 阅读文档

- **[快速启动指南](QUICKSTART.md)** ← 推荐！5分钟快速启动
- **[完整设置指南](SETUP.md)** - 详细配置说明
- **[开发路线图](Docs/ROADMAP.md)** - 功能规划

### ⚡ 一键启动

```bash
# 1. 后端 API
cd Backend
python -m venv venv && venv\Scripts\activate
pip install flask flask-sqlalchemy flask-migrate flask-jwt-extended flask-cors python-dotenv openai requests werkzeug
copy .env.example .env
python -m flask db init && python -m flask db migrate -m "Init" && python -m flask db upgrade
python scripts/init_test_data.py
python run.py

# 2. 小程序
# 用微信开发者工具打开 MiniApp 目录，勾选「不校验合法域名」

# 3. 测试 API
curl http://localhost:5000/health
```

## 📊 项目状态

✅ **已完成** (Week 3-10):
- AI 智能助手 (Week 3, 9)
- 陪诊师/机构管理 (Week 5-6)
- 订单与支付 (Week 7-8)
- 用户中心 (Week 10)
- 消息系统 (Week 10)
- 评价系统 (Week 10)

📅 **规划中** (Week 11-12):
- 测试与优化
- 管理后台

## 🏗️ 技术栈

- **后端**: Flask + SQLAlchemy + JWT
- **小程序**: 微信原生 + TDesign
- **管理后台**: React 19 + Ant Design 5
- **AI**: OpenRouter (Claude 3.5 Sonnet)
- **数据库**: SQLite / PostgreSQL

## 📝 默认账号

```
管理员: admin / admin123
测试用户: 13800138001 / 123456
```

## 📚 更多信息

查看 [QUICKSTART.md](QUICKSTART.md) 开始使用！

---

**Made with ❤️ by CareLink Team**
