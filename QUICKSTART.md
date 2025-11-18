# 🚀 CareLink 快速启动指南

> 5分钟快速搭建和调试整个项目

## 📝 前置准备

确保已安装：
- ✅ Python 3.9+
- ✅ Node.js 16+
- ✅ 微信开发者工具

---

## 步骤1：后端 API 快速启动

### 1.1 进入后端目录

```bash
cd Backend
```

### 1.2 创建虚拟环境并安装依赖

```bash
# Windows
python -m venv venv
venv\Scripts\activate
pip install flask flask-sqlalchemy flask-migrate flask-jwt-extended flask-cors python-dotenv openai requests werkzeug

# macOS/Linux
python3 -m venv venv
source venv/bin/activate
pip install flask flask-sqlalchemy flask-migrate flask-jwt-extended flask-cors python-dotenv openai requests werkzeug
```

### 1.3 创建环境配置文件

复制 `.env.example` 为 `.env`：

```bash
# Windows
copy .env.example .env

# macOS/Linux
cp .env.example .env
```

或直接创建 `.env` 文件，内容如下：

```env
FLASK_ENV=development
SECRET_KEY=dev-secret-key-for-testing
JWT_SECRET_KEY=jwt-secret-key-for-testing
DATABASE_URL=sqlite:///carelink_dev.db
CORS_ORIGINS=*
LOG_LEVEL=DEBUG

# AI 功能（可选，不影响其他功能测试）
OPENROUTER_API_KEY=your-key-here
```

### 1.4 初始化数据库

```bash
python -m flask db init
python -m flask db migrate -m "Initial migration"
python -m flask db upgrade
```

###1.5 创建测试数据

```bash
python scripts/init_test_data.py
```

成功后会显示：

```
✅ 测试数据初始化完成！

🔐 登录信息:
  管理员:
    用户名: admin
    密码: admin123

  测试用户:
    手机号: 13800138001
    密码: 123456
```

### 1.6 启动后端服务

```bash
python run.py
```

看到以下输出表示成功：

```
 * Running on http://0.0.0.0:5000
 * Debugger is active!
```

### 1.7 测试API

打开新终端，测试健康检查：

```bash
curl http://localhost:5000/health
```

应返回：

```json
{
  "status": "healthy",
  "timestamp": "2025-11-12T...",
  "service": "CareLink API",
  "version": "1.0.0"
}
```

---

## 步骤2：小程序快速启动

### 2.1 打开微信开发者工具

1. 启动微信开发者工具
2. 点击「导入项目」或「+」
3. 选择项目目录：`CareLink/MiniApp`
4. AppID：选择「测试号」或使用你的 AppID

### 2.2 配置本地开发

在微信开发者工具中：

1. 点击右上角「详情」
2. 选择「本地设置」标签
3. 勾选以下选项：
   - ✅ **不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书**
   - ✅ 启用调试
   - ✅ 不校验安全域名

### 2.3 确认 API 配置

打开 `MiniApp/utils/request.js`，确认：

```javascript
const config = {
  baseURL: 'http://localhost:5000/api/v1',  // ← 这里
  timeout: 15000
};
```

### 2.4 编译运行

1. 点击「编译」按钮
2. 查看控制台是否有错误
3. 在模拟器中浏览页面

### 2.5 模拟登录（重要）

由于没有真实的微信登录，需要手动设置 token：

**方法1：在控制台直接设置**

在微信开发者工具的「Console」面板中执行：

```javascript
wx.setStorageSync('access_token', 'test-token-12345')
wx.setStorageSync('userInfo', {
  id: 1,
  nickname: '测试用户',
  phone: '138****8001'
})

// 刷新页面
wx.reLaunch({ url: '/pages/home/index' })
```

**方法2：临时修改登录页面**

编辑 `MiniApp/pages/login/index.js`，在 `onLoad` 中添加：

```javascript
onLoad() {
  // 测试模式：自动登录（使用真实的 JWT token）
  console.log('🧪 测试模式：自动登录');
  const testToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc2MzEzMTU2NCwianRpIjoiNzY3NzllMTQtZTUwMC00MTQ5LWIzOTMtMGYxNGI4ZjcxMWFiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IjE3NjMxMTE2MzczNzI2OTEiLCJuYmYiOjE3NjMxMzE1NjQsImNzcmYiOiI1ODZmNGQ3Ni00NDFlLTRjYjAtODFmNC1lNmRiOTcyNjQyMmMiLCJleHAiOjE3NjMxMzg3NjQsInVzZXJfdHlwZSI6InVzZXIiLCJ0aW1lc3RhbXAiOiIyMDI1LTExLTE0VDE0OjQ2OjA0LjU4NzY1NyIsInBob25lIjoiMTM4MDAxMzgwMDEifQ.N96FwIc_PU4HAJeoNw_uXBxugVtJ3X_Um7S9lffiFC4';

  wx.setStorageSync('access_token', testToken);
  wx.setStorageSync('userInfo', {
    id: 1763111637372691,
    nickname: '测试用户1',
    phone: '13800138001'
  });

  wx.switchTab({
    url: '/pages/home/index'
  });
}
```

---

## 步骤3：测试主要功能

### 3.1 测试首页

- ✅ 查看陪诊师列表
- ✅ 查看陪诊机构列表
- ✅ 点击卡片进入详情页

### 3.2 测试 AI 对话

1. 进入「AI 助手」页面
2. 输入：「我想找个陪诊师」
3. 查看 AI 回复

⚠️ **注意**：如果没有配置 OpenRouter API Key，AI 功能会报错，这不影响其他功能测试。

### 3.3 测试个人中心

1. 进入「个人中心」
2. 点击「就诊人管理」→ 添加就诊人
3. 点击「地址管理」→ 添加地址
4. 检查数据保存情况

### 3.4 测试订单流程

1. 选择一个陪诊师
2. 点击「立即预约」
3. 填写订单信息
4. 提交订单
5. 查看订单列表

### 3.5 测试消息功能

1. 进入「消息中心」
2. 选择一个会话
3. 发送测试消息

### 3.6 测试评价功能

1. 在订单列表中选择已完成的订单
2. 点击「评价」
3. 填写评价内容
4. 提交评价

---

## 步骤4：使用 Postman 测试 API

### 4.1 导入 API 集合

创建一个 Postman Collection，添加以下请求：

#### 健康检查

```
GET http://localhost:5000/health
```

#### 获取陪诊师列表

```
GET http://localhost:5000/api/v1/user/companions?page=1&page_size=10
```

#### 获取用户信息（需要 token）

```
GET http://localhost:5000/api/v1/user/profile
Headers:
  Authorization: Bearer {{access_token}}
```

#### 创建就诊人

```
POST http://localhost:5000/api/v1/user/patients
Headers:
  Authorization: Bearer {{access_token}}
  Content-Type: application/json

Body:
{
  "name": "测试患者",
  "gender": "male",
  "phone": "13800138888",
  "relationship": "self"
}
```

### 4.2 获取测试 Token

如果需要真实的 token，可以通过后端生成：

```python
# 在 Backend 目录下创建 generate_token.py
from app import create_app
from flask_jwt_extended import create_access_token

app = create_app('development')

with app.app_context():
    token = create_access_token(identity=1)
    print(f"Test Token: {token}")
```

运行：

```bash
python generate_token.py
```

---

## 🐛 常见问题快速解决

### 问题1：后端启动失败 - ModuleNotFoundError

**解决**：检查虚拟环境是否激活

```bash
# 看到 (venv) 前缀表示已激活
(venv) C:\...\Backend>

# 如果没有，重新激活
venv\Scripts\activate  # Windows
source venv/bin/activate  # macOS/Linux
```

### 问题2：数据库错误

**解决**：删除数据库文件重新初始化

```bash
# 删除数据库
rm carelink_dev.db

# 重新初始化
python -m flask db upgrade
python scripts/init_test_data.py
```

### 问题3：小程序无法连接后端

**解决**：

1. 确认后端服务正在运行（访问 http://localhost:5000/health）
2. 确认微信开发者工具中「不校验合法域名」已勾选
3. 查看控制台的网络请求错误详情

### 问题4：AI 对话功能报错

**解决**：

AI 功能需要 OpenRouter API Key，如果暂时不测试 AI，可以：

1. 注释掉 AI 相关页面的跳转
2. 或者在 `.env` 中添加有效的 API Key

### 问题5：端口被占用

**解决**：

```bash
# Windows - 查找占用 5000 端口的进程
netstat -ano | findstr :5000

# 杀死进程
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:5000 | xargs kill -9
```

---

## 📊 验证清单

启动完成后，检查以下项：

### 后端 API ✓
- [ ] `http://localhost:5000/health` 返回正常
- [ ] `http://localhost:5000` 返回欢迎信息
- [ ] 可以看到控制台日志输出
- [ ] 数据库文件 `carelink_dev.db` 存在

### 小程序 ✓
- [ ] 微信开发者工具中项目正常打开
- [ ] 编译无错误
- [ ] 首页能正常显示
- [ ] 可以点击跳转到详情页
- [ ] 控制台无严重错误

### 数据库 ✓
- [ ] 有测试用户数据
- [ ] 有陪诊师数据
- [ ] 有机构数据

---

## 🎯 下一步

现在你可以：

1. **浏览功能**：在小程序中测试各个页面和功能
2. **测试 API**：使用 Postman 测试各个接口
3. **查看数据库**：使用 SQLite Browser 查看数据
4. **阅读代码**：了解项目架构和实现细节
5. **开发新功能**：基于现有代码扩展功能

---

## 📚 更多文档

- [完整设置指南](SETUP.md) - 详细的配置说明
- [API 文档](Docs/API.md) - 完整的 API 接口文档
- [开发指南](CLAUDE.md) - 开发规范和最佳实践
- [路线图](Docs/ROADMAP.md) - 项目功能规划

---

**享受编码！** 🎉

如有问题，请检查控制台日志或查看完整的 [SETUP.md](SETUP.md) 文档。
