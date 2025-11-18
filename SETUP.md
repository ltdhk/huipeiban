# CareLink 项目设置与调试指南

## 📋 目录

1. [环境要求](#环境要求)
2. [后端 API 设置](#后端-api-设置)
3. [小程序设置](#小程序设置)
4. [管理后台设置](#管理后台设置)
5. [测试数据准备](#测试数据准备)
6. [调试步骤](#调试步骤)
7. [常见问题](#常见问题)

---

## 环境要求

### 必需软件

- **Python**: 3.9+ （后端 API）
- **Node.js**: 16+ （管理后台）
- **微信开发者工具**: 最新稳定版（小程序开发）
- **Git**: 版本管理

### 推荐工具

- **Postman** 或 **Apifox**: API 测试
- **VS Code**: 代码编辑器
- **SQLite Browser**: 查看数据库（可选）

---

## 后端 API 设置

### 1. 创建虚拟环境

```bash
cd Backend

# Windows
python -m venv venv
venv\Scripts\activate

# macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

如果 `requirements.txt` 不存在，安装以下依赖：

```bash
pip install flask flask-sqlalchemy flask-migrate flask-jwt-extended flask-cors python-dotenv openai requests
```

### 3. 配置环境变量

在 `Backend/` 目录下创建 `.env` 文件：

```env
# Flask 配置
FLASK_ENV=development
SECRET_KEY=your-secret-key-change-in-production

# 数据库配置（开发环境使用 SQLite）
DATABASE_URL=sqlite:///carelink_dev.db

# JWT 配置
JWT_SECRET_KEY=your-jwt-secret-key-change-in-production
JWT_ACCESS_TOKEN_EXPIRES=7200
JWT_REFRESH_TOKEN_EXPIRES=604800

# OpenRouter AI 配置（用于 AI 对话功能）
OPENROUTER_API_KEY=your-openrouter-api-key
OPENROUTER_MODEL=anthropic/claude-3.5-sonnet

# 微信小程序配置（可选，用于微信登录）
WECHAT_APPID=your-wechat-appid
WECHAT_APP_SECRET=your-wechat-app-secret

# 微信支付配置（可选，用于支付功能）
WECHAT_PAY_MCHID=your-merchant-id
WECHAT_PAY_SERIAL_NO=your-serial-no
WECHAT_PAY_API_V3_KEY=your-api-v3-key
WECHAT_PAY_NOTIFY_URL=https://your-domain.com/api/v1/user/payments/notify

# CORS 配置
CORS_ORIGINS=*

# 日志级别
LOG_LEVEL=DEBUG
```

### 4. 初始化数据库

```bash
# 初始化数据库迁移
python -m flask db init

# 创建迁移文件
python -m flask db migrate -m "Initial migration"

# 应用迁移
python -m flask db upgrade
```

### 5. 创建测试数据

运行测试数据初始化脚本（后面会创建）：

```bash
python scripts/init_test_data.py
```

### 6. 启动后端服务

```bash
python run.py
```

服务将在 `http://localhost:5000` 启动。

### 7. 验证 API

访问健康检查端点：

```bash
curl http://localhost:5000/health
```

应返回：
```json
{
  "status": "healthy",
  "timestamp": "2025-11-12T..."
}
```

---

## 小程序设置

### 1. 打开微信开发者工具

1. 启动微信开发者工具
2. 选择「导入项目」
3. 项目目录选择：`CareLink/MiniApp`
4. AppID：使用测试号或你的小程序 AppID

### 2. 配置 API 地址

在 `MiniApp/utils/request.js` 中确认配置：

```javascript
const config = {
  baseURL: 'http://localhost:5000/api/v1', // 本地调试
  timeout: 15000
};
```

### 3. 设置本地开发选项

在微信开发者工具中：
1. 点击右上角「详情」
2. 选择「本地设置」
3. 勾选以下选项：
   - ✅ 不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书
   - ✅ 启用调试
   - ✅ 不校验安全域名

### 4. 编译运行

1. 点击「编译」按钮
2. 查看控制台是否有错误
3. 在模拟器中测试页面跳转

### 5. 测试登录流程

由于没有真实的微信 AppID，需要模拟登录：

在 `MiniApp/pages/login/index.js` 中添加测试模式：

```javascript
// 测试模式：直接设置 token
if (process.env.NODE_ENV === 'development') {
  wx.setStorageSync('access_token', 'test-token-12345');
  wx.setStorageSync('userInfo', {
    id: 1,
    nickname: '测试用户',
    phone: '138****8888'
  });

  wx.switchTab({
    url: '/pages/home/index'
  });
}
```

---

## 管理后台设置

### 1. 安装依赖

```bash
cd Admin

# 使用 npm
npm install

# 或使用 yarn
yarn install

# 或使用 pnpm
pnpm install
```

### 2. 配置环境变量

创建 `Admin/.env.development` 文件：

```env
# API 地址
VITE_API_BASE_URL=http://localhost:5000/api/v1

# 应用标题
VITE_APP_TITLE=CareLink 管理后台

# 端口
VITE_PORT=3000
```

### 3. 启动开发服务器

```bash
npm run dev
# 或
yarn dev
# 或
pnpm dev
```

访问 `http://localhost:3000`

### 4. 测试登录

默认管理员账号：
- 用户名：`admin`
- 密码：`admin123`

---

## 测试数据准备

### 创建测试数据脚本

创建 `Backend/scripts/init_test_data.py`：

```python
# -*- coding: utf-8 -*-
"""
初始化测试数据
"""
import sys
import os

# 添加项目根目录到路径
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app
from app.extensions import db
from app.models.user import User, Patient, Address
from app.models.companion import Companion
from app.models.institution import Institution
from app.models.admin import Admin
from werkzeug.security import generate_password_hash
from datetime import datetime, date

app = create_app('development')

with app.app_context():
    # 清空现有数据
    print("清空现有数据...")
    db.drop_all()
    db.create_all()

    # 1. 创建管理员
    print("创建管理员...")
    admin = Admin(
        username='admin',
        email='admin@carelink.com',
        password_hash=generate_password_hash('admin123'),
        role='super_admin',
        status='active'
    )
    db.session.add(admin)

    # 2. 创建测试用户
    print("创建测试用户...")
    user1 = User(
        phone='13800138001',
        password_hash=generate_password_hash('123456'),
        nickname='张三',
        gender='male',
        balance=100.00,
        points=500,
        member_level='vip',
        total_orders=5,
        total_spent=500.00,
        status='active'
    )
    db.session.add(user1)
    db.session.flush()  # 获取 user1.id

    # 3. 创建就诊人
    print("创建就诊人...")
    patient1 = Patient(
        user_id=user1.id,
        name='张三',
        gender='male',
        birth_date=date(1980, 1, 1),
        phone='13800138001',
        relationship='self',
        is_default=True
    )
    patient2 = Patient(
        user_id=user1.id,
        name='李四',
        gender='female',
        birth_date=date(1950, 5, 10),
        phone='13900139000',
        relationship='parent',
        medical_history='高血压'
    )
    db.session.add_all([patient1, patient2])

    # 4. 创建地址
    print("创建地址...")
    address1 = Address(
        user_id=user1.id,
        contact_name='张三',
        contact_phone='13800138001',
        province='北京市',
        city='北京市',
        district='朝阳区',
        detail_address='建国路88号',
        address_type='home',
        is_default=True
    )
    db.session.add(address1)

    # 5. 创建陪诊师
    print("创建陪诊师...")
    companions = [
        Companion(
            name='王护士',
            gender='female',
            age=35,
            phone='13700137001',
            avatar_url='/assets/companion1.jpg',
            city='北京',
            district='朝阳区',
            experience_years=10,
            specialties=['老年护理', '术后康复'],
            introduction='专业护理人员，经验丰富',
            hourly_rate=80.00,
            service_count=100,
            rating=4.9,
            review_count=50,
            status='available',
            has_car=True
        ),
        Companion(
            name='李医生',
            gender='male',
            age=45,
            phone='13700137002',
            avatar_url='/assets/companion2.jpg',
            city='北京',
            district='海淀区',
            experience_years=20,
            specialties=['慢病管理', '健康咨询'],
            introduction='退休医生，耐心细致',
            hourly_rate=120.00,
            service_count=200,
            rating=5.0,
            review_count=100,
            status='available',
            has_car=False
        )
    ]
    db.session.add_all(companions)

    # 6. 创建陪诊机构
    print("创建陪诊机构...")
    institutions = [
        Institution(
            name='北京爱心陪诊中心',
            logo_url='/assets/institution1.jpg',
            city='北京',
            district='朝阳区',
            address='朝阳区建国路99号',
            phone='010-12345678',
            introduction='专业陪诊服务机构，经验丰富',
            service_scope=['医院陪诊', '检查陪同', '拿药取报告'],
            business_hours='08:00-20:00',
            staff_count=50,
            completed_orders=1000,
            rating=4.8,
            review_count=200,
            status='active'
        ),
        Institution(
            name='上海康护陪诊服务',
            logo_url='/assets/institution2.jpg',
            city='上海',
            district='浦东新区',
            address='浦东新区世纪大道88号',
            phone='021-87654321',
            introduction='上海领先的陪诊服务提供商',
            service_scope=['全程陪诊', '翻译服务', '医疗咨询'],
            business_hours='07:00-21:00',
            staff_count=80,
            completed_orders=2000,
            rating=4.9,
            review_count=350,
            status='active'
        )
    ]
    db.session.add_all(institutions)

    # 提交所有数据
    db.session.commit()

    print("✅ 测试数据初始化完成！")
    print(f"管理员账号: admin / admin123")
    print(f"测试用户: 13800138001 / 123456")
```

运行脚本：

```bash
cd Backend
python scripts/init_test_data.py
```

---

## 调试步骤

### 阶段1：后端 API 测试

#### 1.1 启动后端服务

```bash
cd Backend
python run.py
```

确认控制台输出：
```
 * Running on http://0.0.0.0:5000
 * Debugger is active!
```

#### 1.2 测试健康检查

```bash
curl http://localhost:5000/health
```

#### 1.3 测试登录接口

使用 Postman 或 curl：

```bash
curl -X POST http://localhost:5000/api/v1/user/auth/wechat-login \
  -H "Content-Type: application/json" \
  -d '{"code": "test-code-123"}'
```

注意：由于没有真实的微信 AppID，这个接口可能会失败。需要修改代码添加测试模式。

#### 1.4 测试其他接口

使用 Postman 导入以下集合测试所有接口：

- 用户认证
- 陪诊师列表
- 机构列表
- 订单创建
- 消息发送
- 评价创建

---

### 阶段2：小程序功能测试

#### 2.1 启动小程序

1. 确保后端服务正在运行
2. 打开微信开发者工具
3. 编译小程序
4. 检查控制台是否有错误

#### 2.2 测试页面流程

**首页测试：**
1. 打开首页 → 检查陪诊师列表是否加载
2. 点击陪诊师卡片 → 跳转详情页
3. 返回首页 → 检查机构列表

**AI 对话测试：**
1. 进入 AI 聊天页面
2. 输入：「我想找个陪诊师」
3. 检查 AI 回复和推荐卡片

**个人中心测试：**
1. 进入个人中心
2. 点击「就诊人管理」→ 添加就诊人
3. 点击「地址管理」→ 添加地址
4. 检查数据是否正确保存

**消息中心测试：**
1. 进入消息列表
2. 选择会话进入聊天
3. 发送测试消息

**订单流程测试：**
1. 选择陪诊师 → 创建订单
2. 填写订单信息 → 提交
3. 查看订单详情
4. 完成订单 → 创建评价

---

### 阶段3：管理后台测试

#### 3.1 启动管理后台

```bash
cd Admin
npm run dev
```

访问 `http://localhost:3000`

#### 3.2 测试管理功能

1. **登录**: admin / admin123
2. **用户管理**: 查看用户列表、详情
3. **陪诊师管理**: 审核、编辑陪诊师信息
4. **机构管理**: 审核、编辑机构信息
5. **订单管理**: 查看订单列表、状态
6. **评价管理**: 查看评价、隐藏不当评价
7. **数据统计**: 查看仪表盘数据

---

## 常见问题

### 1. 后端启动失败

**问题**: `ModuleNotFoundError: No module named 'flask'`

**解决**:
```bash
pip install -r requirements.txt
```

---

### 2. 数据库连接失败

**问题**: `sqlalchemy.exc.OperationalError`

**解决**:
```bash
# 删除旧数据库
rm carelink_dev.db

# 重新初始化
python -m flask db upgrade
python scripts/init_test_data.py
```

---

### 3. 小程序无法连接后端

**问题**: 请求超时或失败

**解决**:
1. 确认后端服务正在运行
2. 检查 `request.js` 中的 `baseURL`
3. 确认微信开发者工具中「不校验合法域名」已勾选
4. 查看网络面板的请求详情

---

### 4. CORS 错误

**问题**: `Access-Control-Allow-Origin` 错误

**解决**:
在 `Backend/.env` 中设置：
```env
CORS_ORIGINS=*
```

---

### 5. JWT Token 过期

**问题**: 401 Unauthorized

**解决**:
重新登录获取新 token，或延长 token 有效期：
```env
JWT_ACCESS_TOKEN_EXPIRES=86400  # 24小时
```

---

### 6. OpenRouter API 失败

**问题**: AI 对话功能不工作

**解决**:
1. 确认 `.env` 中配置了 `OPENROUTER_API_KEY`
2. 检查 API Key 是否有效
3. 查看后端日志的错误信息
4. 可以暂时注释掉 AI 功能进行其他测试

---

## 🎯 快速启动命令

### 一键启动所有服务

创建启动脚本（Windows PowerShell）:

```powershell
# start_all.ps1

# 启动后端
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd Backend; venv\Scripts\activate; python run.py"

# 等待2秒
Start-Sleep -Seconds 2

# 启动管理后台
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd Admin; npm run dev"

# 打开微信开发者工具（需要配置路径）
# Start-Process "C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat" -ArgumentList "open", "--project", "$PWD\MiniApp"

Write-Host "所有服务已启动！"
Write-Host "后端 API: http://localhost:5000"
Write-Host "管理后台: http://localhost:3000"
Write-Host "请手动打开微信开发者工具导入 MiniApp 目录"
```

运行：
```powershell
.\start_all.ps1
```

---

## 📝 调试检查清单

### 后端 API ✓
- [ ] 虚拟环境已激活
- [ ] 依赖已安装
- [ ] .env 文件已配置
- [ ] 数据库已初始化
- [ ] 测试数据已创建
- [ ] 服务在 5000 端口运行
- [ ] 健康检查接口正常

### 小程序 ✓
- [ ] 微信开发者工具已打开
- [ ] 项目已导入
- [ ] 本地设置已配置（不校验域名）
- [ ] API 地址配置正确
- [ ] 编译无错误
- [ ] 页面可以正常跳转

### 管理后台 ✓
- [ ] Node依赖已安装
- [ ] .env 文件已配置
- [ ] 开发服务器在 3000 端口运行
- [ ] 可以访问登录页面
- [ ] 管理员账号可以登录

---

## 📧 获取帮助

如果遇到其他问题，请检查：

1. **后端日志**: 查看 Backend 目录下的日志输出
2. **小程序控制台**: 微信开发者工具的 Console 面板
3. **浏览器控制台**: 管理后台的浏览器开发者工具
4. **网络请求**: 检查 Network 面板的请求详情

---

**祝调试顺利！** 🚀
