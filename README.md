# CareLink 医疗陪诊服务平台

基于 AI Native 理念打造的智能陪诊预约服务平台。

## 项目简介

CareLink 通过 AI 对话助手帮助用户快速匹配合适的陪诊服务，连接有陪诊需求的用户、专业陪诊师和陪诊机构。

### 核心特色

- 🤖 **AI Native 交互**：基于 LangChain 构建的智能对话系统
- 🎯 **智能匹配推荐**：多维度因素智能推荐陪诊服务
- 💳 **双轨服务模式**：支持陪诊师直约（在线支付）和机构预约（线下服务）
- 📱 **全流程数字化**：从需求采集到服务完成的完整闭环

## 技术栈

### 后端
- **框架**：Flask 3.x
- **数据库**：Supabase PostgreSQL
- **AI**：LangChain + OpenRouter
- **支付**：微信支付 V3

### 前端
- **小程序**：微信小程序 + TDesign
- **管理后台**：React 18 + Ant Design 5

## 项目结构

```
CareLink/
├── Backend/           # Flask 后端
├── MiniApp/           # 微信小程序
├── Admin/             # React 管理后台
├── Docs/              # 项目文档
├── Script/            # 脚本工具
└── CLAUDE.md          # 开发指南
```

## 快速开始

### 后端开发

```bash
cd Backend

# 创建虚拟环境
python -m venv venv

# 激活虚拟环境 (Windows)
venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt

# 复制环境变量配置
copy .env.example .env
# 编辑 .env 文件，填写配置信息

# 初始化数据库
flask db init
flask db migrate -m "初始迁移"
flask db upgrade

# 启动开发服务器
python run.py
```

### 小程序开发

1. 使用微信开发者工具打开 `MiniApp/` 目录
2. 配置 AppID
3. 开始开发

### 管理后台开发

```bash
cd Admin

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

## 文档

详细文档请查看 [Docs/](./Docs/) 目录：

- [PRD.md](./Docs/PRD.md) - 产品需求文档
- [DATABASE.md](./Docs/DATABASE.md) - 数据库设计
- [API.md](./Docs/API.md) - API 接口文档
- [AI_AGENT.md](./Docs/AI_AGENT.md) - AI Agent 设计
- [PAYMENT.md](./Docs/PAYMENT.md) - 微信支付集成
- [ROADMAP.md](./Docs/ROADMAP.md) - 开发路线图

## 开发规范

请遵循 [CLAUDE.md](./CLAUDE.md) 中的开发规范：

- 代码注释和日志使用简体中文
- 遵循 RESTful API 设计规范
- 使用约定式提交(Conventional Commits)格式

## 许可证

待定

## 联系方式

如有问题，请联系项目负责人。
