# Supabase PostgreSQL 数据库配置指南

## 1. 获取 Supabase 数据库连接信息

### 步骤：

1. 登录 [Supabase Dashboard](https://app.supabase.com/)
2. 选择你的项目（或创建新项目）
3. 进入 **Settings** -> **Database**
4. 在 **Connection string** 部分，你会看到两种连接模式：

#### 连接模式说明

**Session mode（直连模式）**
- 适用于：长时间运行的应用、少量并发连接
- 端口：`5432`
- 格式：`postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres`

**Transaction mode（连接池模式）** ⭐ **推荐用于开发和生产**
- 适用于：Serverless 函数、大量并发连接、Flask 应用
- 端口：`6543`
- 格式：`postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres`

## 2. 配置数据库连接

### 方式一：使用连接池模式（推荐）

在 `Backend/.env` 文件中配置：

```bash
# 使用连接池模式（推荐）
DATABASE_URL=postgresql://postgres.izkgwfggnuspfpnphmqq:[YOUR_PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true
```

**重要参数**：
- `?pgbouncer=true` - 启用连接池模式
- 端口必须是 `6543`
- 主机名包含 `.pooler.supabase.com`

### 方式二：使用直连模式

```bash
# 直连模式（适用于本地开发）
DATABASE_URL=postgresql://postgres:[YOUR_PASSWORD]@db.izkgwfggnuspfpnphmqq.supabase.co:5432/postgres
```

## 3. 获取正确的连接字符串

### 从 Supabase Dashboard 获取

1. 进入 **Settings** -> **Database**
2. 在 **Connection string** 选择 **URI**
3. 选择 **Transaction mode**（推荐）
4. 点击 **Copy** 复制完整的连接字符串
5. 将密码占位符 `[YOUR-PASSWORD]` 替换为你的实际数据库密码

### 示例：

**原始字符串**（来自 Supabase）：
```
postgresql://postgres.izkgwfggnuspfpnphmqq:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres
```

**替换密码后**：
```
postgresql://postgres.izkgwfggnuspfpnphmqq:Ltd5030229@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres
```

**添加连接池参数**（推荐）：
```
postgresql://postgres.izkgwfggnuspfpnphmqq:Ltd5030229@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true
```

## 4. 数据库密码

如果忘记了数据库密码，可以重置：

1. 进入 **Settings** -> **Database**
2. 向下滚动到 **Database Password**
3. 点击 **Reset Database Password**
4. 输入新密码（例如：`Ltd5030229`）
5. 点击 **Reset Password**

⚠️ **注意**：重置密码后，需要更新所有使用该数据库的应用的连接字符串。

## 5. 更新配置文件

### Backend/.env

```bash
# 数据库配置 (Supabase PostgreSQL - 连接池模式)
DATABASE_URL=postgresql://postgres.izkgwfggnuspfpnphmqq:Ltd5030229@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true
```

### Backend/.env.example

```bash
# 数据库配置 (Supabase PostgreSQL)
# 推荐使用连接池模式（Transaction mode）
DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres?pgbouncer=true

# 或使用直连模式（Session mode）
# DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
```

## 6. 安装依赖

确保已安装 PostgreSQL 驱动：

```bash
cd Backend
pip install psycopg2-binary==2.9.11
```

## 7. 初始化数据库

### 创建表结构

```bash
cd Backend
python -c "from app import create_app, db; app = create_app(); app.app_context().push(); db.create_all(); print('数据库表创建成功！')"
```

### 使用 Flask-Migrate（推荐）

```bash
# 初始化迁移（仅第一次）
flask db init

# 创建迁移
flask db migrate -m "Initial migration"

# 应用迁移
flask db upgrade
```

## 8. 测试连接

创建测试脚本 `Backend/test_db.py`：

```python
# -*- coding: utf-8 -*-
from app import create_app, db

app = create_app()

with app.app_context():
    try:
        # 测试连接
        db.engine.connect()
        print("✓ 数据库连接成功！")

        # 显示连接信息
        print(f"✓ 数据库 URI: {app.config['SQLALCHEMY_DATABASE_URI'][:50]}...")

        # 列出所有表
        from sqlalchemy import inspect
        inspector = inspect(db.engine)
        tables = inspector.get_table_names()
        print(f"✓ 数据库表: {len(tables)} 个")
        for table in tables:
            print(f"  - {table}")

    except Exception as e:
        print(f"✗ 数据库连接失败: {e}")
```

运行测试：

```bash
cd Backend
python test_db.py
```

## 9. 常见问题

### Q1: "connection to server... failed: server closed the connection unexpectedly"

**原因**：
- Supabase 项目暂停（免费版长时间不活动会暂停）
- 使用了错误的连接模式（Session mode 而不是 Transaction mode）
- 数据库密码错误

**解决**：
1. 检查 Supabase 项目是否运行中
2. 使用连接池模式（端口 6543）
3. 验证数据库密码是否正确
4. 在连接字符串末尾添加 `?pgbouncer=true`

### Q2: "too many connections"

**原因**：超过了 Supabase 免费版的连接限制

**解决**：
- 使用连接池模式（Transaction mode）
- 在 Flask 应用中配置连接池：

```python
# config.py
SQLALCHEMY_ENGINE_OPTIONS = {
    'pool_size': 5,
    'pool_recycle': 300,
    'pool_pre_ping': True,
    'max_overflow': 2
}
```

### Q3: "SSL connection required"

**解决**：在连接字符串末尾添加 SSL 参数：

```bash
DATABASE_URL=postgresql://...?sslmode=require
```

### Q4: 如何从 SQLite 迁移到 PostgreSQL？

1. **导出数据**（如果有现有数据）：
```bash
# 使用 SQLite 导出 SQL
sqlite3 carelink_dev.db .dump > data_dump.sql
```

2. **清理 SQL 文件**（SQLite 和 PostgreSQL 语法有差异）

3. **导入到 PostgreSQL**：
```bash
psql postgresql://... < data_cleaned.sql
```

或者使用 Flask-Migrate：
```bash
# 1. 确保 SQLite 数据库是最新的
# 2. 切换到 PostgreSQL
# 3. 运行迁移
flask db upgrade
```

## 10. 连接池配置（推荐）

在 `Backend/config.py` 中添加：

```python
class Config:
    # ... 其他配置 ...

    # SQLAlchemy 连接池配置
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_size': 5,              # 连接池大小
        'pool_recycle': 300,         # 5分钟后回收连接
        'pool_pre_ping': True,       # 使用前测试连接
        'max_overflow': 2,           # 最大溢出连接数
        'pool_timeout': 30,          # 连接超时时间（秒）
        'echo_pool': False           # 是否打印连接池日志
    }
```

## 11. 环境变量参考

完整的 `.env` 文件示例：

```bash
# Flask 配置
FLASK_APP=run.py
FLASK_ENV=development
SECRET_KEY=your-secret-key-change-in-production

# 数据库配置 (Supabase PostgreSQL - 连接池模式)
DATABASE_URL=postgresql://postgres.izkgwfggnuspfpnphmqq:Ltd5030229@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true

# JWT 配置
JWT_SECRET_KEY=your-jwt-secret-key-change-in-production
JWT_ACCESS_TOKEN_EXPIRES=7200
JWT_REFRESH_TOKEN_EXPIRES=604800

# 微信小程序配置
WECHAT_APPID=wx426040a3db6be21b
WECHAT_APP_SECRET=your-wechat-app-secret

# OpenRouter AI 配置
OPENROUTER_API_KEY=sk-or-v1-your-api-key
OPENROUTER_MODEL=google/gemini-2.5-flash-lite

# Supabase 对象存储配置
SUPABASE_URL=https://izkgwfggnuspfpnphmqq.supabase.co
SUPABASE_KEY=your-supabase-anon-key
SUPABASE_BUCKET=carelink-files

# 其他配置
CORS_ORIGINS=http://localhost:3000,https://carelink.com
LOG_LEVEL=INFO
```

## 12. 下一步

配置完成后：

1. ✅ 测试数据库连接
2. ✅ 运行数据库迁移
3. ✅ 创建测试数据
4. ✅ 启动 Flask 应用
5. ✅ 测试 API 接口

如有问题，请查看 Supabase 文档：https://supabase.com/docs/guides/database
