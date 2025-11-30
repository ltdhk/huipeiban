# 陪诊师/机构管理功能设计文档

## 概述

实现统一用户认证体系,让陪诊师和陪诊机构通过统一的 User 表进行登录认证,并根据用户类型展示不同的功能模块。

## 架构设计

### 1. 数据库模型改造

#### 1.1 User 表变更
- **新增字段**: `user_type` VARCHAR(20) DEFAULT 'patient'
  - 可选值: 'patient' (普通用户), 'companion' (陪诊师), 'institution' (陪诊机构)
- **用途**: 区分用户类型,用于权限控制和功能展示

#### 1.2 Companion 表变更
- **新增字段**: `user_id` BIGINT NOT NULL UNIQUE, FOREIGN KEY REFERENCES users(id)
- **移除字段**: `phone`, `password_hash` (迁移到 User 表统一管理)
- **关系**: One-to-One with User

#### 1.3 Institution 表变更
- **新增字段**: `user_id` BIGINT NOT NULL UNIQUE, FOREIGN KEY REFERENCES users(id)
- **关系**: One-to-One with User

### 2. 数据库迁移 SQL

```sql
-- 1. 为 User 表添加 user_type 字段
ALTER TABLE users ADD COLUMN user_type VARCHAR(20) DEFAULT 'patient' COMMENT '用户类型: patient/companion/institution';
CREATE INDEX idx_users_user_type ON users(user_type);

-- 2. 为 Companion 表添加 user_id 字段
ALTER TABLE companions ADD COLUMN user_id BIGINT COMMENT '用户ID';
ALTER TABLE companions ADD CONSTRAINT fk_companions_user_id FOREIGN KEY (user_id) REFERENCES users(id);
CREATE UNIQUE INDEX idx_companions_user_id ON companions(user_id);

-- 3. 为 Institution 表添加 user_id 字段
ALTER TABLE institutions ADD COLUMN user_id BIGINT COMMENT '用户ID';
ALTER TABLE institutions ADD CONSTRAINT fk_institutions_user_id FOREIGN KEY (user_id) REFERENCES users(id);
CREATE UNIQUE INDEX idx_institutions_user_id ON institutions(user_id);

-- 4. 数据迁移: 为现有陪诊师创建关联的 User 记录
INSERT INTO users (phone, password_hash, nickname, user_type, created_at, updated_at)
SELECT phone, password_hash, name, 'companion', created_at, updated_at
FROM companions
WHERE user_id IS NULL;

-- 更新 companions 表的 user_id
UPDATE companions c
SET user_id = (SELECT id FROM users u WHERE u.phone = c.phone AND u.user_type = 'companion')
WHERE c.user_id IS NULL;

-- 5. 将字段设为 NOT NULL
ALTER TABLE companions MODIFY COLUMN user_id BIGINT NOT NULL;
ALTER TABLE institutions MODIFY COLUMN user_id BIGINT NOT NULL;

-- 6. 移除 Companion 表的冗余字段
ALTER TABLE companions DROP COLUMN phone;
ALTER TABLE companions DROP COLUMN password_hash;
```

### 3. API 变更

#### 3.1 登录接口 (/api/v1/user/auth/login)

**请求不变**:
```json
{
  "phone": "13800138000",
  "password": "password123"
}
```

**响应增强**:
```json
{
  "success": true,
  "data": {
    "access_token": "...",
    "refresh_token": "...",
    "user": {
      "id": 123,
      "phone": "138****8000",
      "nickname": "张三",
      "user_type": "companion",  // 新增
      "companion_id": 456,        // 当 user_type 为 companion 时返回
      "companion_info": {         // 陪诊师详细信息
        "id": 456,
        "name": "张三",
        "rating": 4.8,
        "status": "approved",
        "is_online": true,
        // ...其他陪诊师信息
      }
    }
  }
}
```

当 user_type 为 'institution' 时:
```json
{
  "user": {
    "id": 123,
    "user_type": "institution",
    "institution_id": 789,
    "institution_info": {
      "id": 789,
      "name": "XX陪诊服务有限公司",
      "rating": 4.9,
      // ...其他机构信息
    }
  }
}
```

#### 3.2 获取当前用户信息 (/api/v1/user/auth/current)

**响应**: 同登录接口,返回包含 user_type 和关联信息的完整用户数据

### 4. Flutter App 改造

#### 4.1 数据模型更新

**User 模型** (`lib/data/models/user.dart`):
```dart
@freezed
class User with _$User {
  const factory User({
    required int id,
    String? phone,
    String? nickname,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? gender,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'user_type') @Default('patient') String userType,  // 新增
    @JsonKey(name: 'companion_id') int? companionId,                  // 新增
    @JsonKey(name: 'institution_id') int? institutionId,              // 新增
    @JsonKey(name: 'companion_info') Map<String, dynamic>? companionInfo,    // 新增
    @JsonKey(name: 'institution_info') Map<String, dynamic>? institutionInfo,// 新增
    double? balance,
    int? points,
    @JsonKey(name: 'member_level') String? memberLevel,
    @JsonKey(name: 'total_orders') int? totalOrders,
    @JsonKey(name: 'total_spent') double? totalSpent,
    String? status,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**AuthResponse 模型更新**:
```dart
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
```

#### 4.2 UI 改造

**侧边栏** (`lib/presentation/widgets/main_drawer.dart`):
```dart
class MainDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Drawer(
      child: ListView(
        children: [
          // 用户信息头部
          _buildUserHeader(user),

          // 通用菜单
          ListTile(
            leading: Icon(Icons.home),
            title: Text('首页'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('我的订单'),
            onTap: () => context.go('/orders'),
          ),

          // 陪诊师/机构专属菜单
          if (user?.userType == 'companion' || user?.userType == 'institution')
            Divider(),
          if (user?.userType == 'companion' || user?.userType == 'institution')
            ListTile(
              leading: Icon(Icons.business_center),
              title: Text('陪诊管理'),
              onTap: () => context.go('/companion-management'),
            ),

          // 其他通用菜单
          ListTile(
            leading: Icon(Icons.person),
            title: Text('个人中心'),
            onTap: () => context.go('/profile'),
          ),
        ],
      ),
    );
  }
}
```

**路由配置** (`lib/app/router.dart`):
```dart
final router = GoRouter(
  routes: [
    // ... 现有路由

    // 陪诊管理路由
    GoRoute(
      path: '/companion-management',
      builder: (context, state) => CompanionManagementPage(),
      routes: [
        GoRoute(
          path: 'services',
          builder: (context, state) => ServiceManagementPage(),
        ),
        GoRoute(
          path: 'schedule',
          builder: (context, state) => ScheduleManagementPage(),
        ),
        GoRoute(
          path: 'orders',
          builder: (context, state) => CompanionOrdersPage(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final user = // 从状态管理获取当前用户

    // 非陪诊师/机构用户无法访问陪诊管理页面
    if (state.location.startsWith('/companion-management')) {
      if (user?.userType != 'companion' && user?.userType != 'institution') {
        return '/';  // 重定向到首页
      }
    }
    return null;
  },
);
```

### 5. 陪诊管理页面结构

#### 5.1 陪诊管理主页面 (`CompanionManagementPage`)

```
┌─────────────────────────────────────┐
│   陪诊管理                            │
├─────────────────────────────────────┤
│                                     │
│  ┌────────┐  ┌────────┐  ┌────────┐│
│  │ 服务   │  │ 时间   │  │ 订单   ││
│  │ 管理   │  │ 管理   │  │ 管理   ││
│  │  12    │  │   5    │  │   23   ││
│  └────────┘  └────────┘  └────────┘│
│                                     │
│  统计概览:                           │
│  ┌─────────────────────────────┐   │
│  │ 今日订单: 5                  │   │
│  │ 本月收入: ¥ 3,500           │   │
│  │ 评分: ⭐️ 4.8                │   │
│  └─────────────────────────────┘   │
│                                     │
│  最近订单:                           │
│  ┌─────────────────────────────┐   │
│  │ 张先生 | 协和医院 | 待确认     │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 李女士 | 人民医院 | 进行中     │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

#### 5.2 服务管理页面 (`ServiceManagementPage`)

**功能**:
- 服务列表展示
- 新增服务
- 编辑服务(价格、描述、服务范围等)
- 上架/下架服务
- 删除服务

**API 端点**:
- GET `/api/v1/user/companions/services` - 获取服务列表
- POST `/api/v1/user/companions/services` - 创建服务
- PUT `/api/v1/user/companions/services/:id` - 更新服务
- DELETE `/api/v1/user/companions/services/:id` - 删除服务

#### 5.3 时间管理页面 (`ScheduleManagementPage`)

**功能**:
- 日历视图展示可用时间段
- 设置可接单时间
- 批量设置重复时间段(如每周固定时间)
- 临时设置不可用时间(请假)

**数据模型** (需新建表):
```sql
CREATE TABLE companion_schedules (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  companion_id BIGINT NOT NULL,
  date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_companion_date (companion_id, date)
);
```

#### 5.4 订单管理页面 (`CompanionOrdersPage`)

**功能**:
- 订单列表(按状态分类: 待确认、进行中、已完成、已取消)
- 接单/拒单操作
- 开始服务/完成服务
- 查看订单详情
- 订单地图导航

**状态流转**:
```
待确认 -> 已确认 -> 进行中 -> 已完成
   ↓
  已拒绝/已取消
```

### 6. 权限控制

#### 6.1 API 级别
- 所有 `/api/v1/user/companions/*` 接口需验证 `user.user_type == 'companion'`
- 使用装饰器 `@require_companion` 进行权限校验

```python
from functools import wraps
from flask_jwt_extended import get_current_user

def require_companion(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        user = get_current_user()
        if user.user_type != 'companion':
            return error_response(403, 'FORBIDDEN', '权限不足')
        return f(*args, **kwargs)
    return decorated_function
```

#### 6.2 前端级别
- 路由守卫: 检查 `user.userType`
- UI元素条件渲染: `if (user?.userType == 'companion')`

### 7. 实施步骤

1. ✅ **数据库模型改造** - 完成
2. ✅ **Backend API 更新** - 完成
3. **数据库迁移脚本** - 待执行
4. **Flutter 数据模型更新** - 待实现
5. **侧边栏条件展示** - 待实现
6. **陪诊管理主页面** - 待实现
7. **服务管理功能** - 待实现
8. **时间管理功能** - 待实现
9. **订单管理功能** - 待实现

### 8. 注意事项

1. **数据一致性**: 确保 User、Companion、Institution 三表数据一致性
2. **向后兼容**: 现有普通用户(user_type='patient')不受影响
3. **权限隔离**: 陪诊师只能管理自己的服务和订单
4. **状态同步**: User 表和 Companion 表的状态需要同步(如禁用用户时同时禁用陪诊师)
5. **事务处理**: 创建陪诊师时需同时创建 User 和 Companion 记录,使用数据库事务保证原子性

### 9. 测试计划

1. **单元测试**: 模型方法、API 端点
2. **集成测试**: 登录流程、权限控制
3. **UI 测试**: 侧边栏显示逻辑、页面权限
4. **数据迁移测试**: 在测试环境验证迁移脚本

---

文档版本: 1.0
创建日期: 2025-11-30
最后更新: 2025-11-30
