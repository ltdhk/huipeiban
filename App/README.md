# CareLink Flutter App

CareLink (会照护) - 智能陪诊服务平台 Flutter 客户端

## 项目概述

这是 CareLink 项目的 Flutter 移动端应用，采用 AI Native 交互模式，通过侧边栏导航提供智能陪诊服务。

## 技术栈

- **Flutter**: 3.35.4
- **Dart**: 3.9.2
- **状态管理**: Riverpod 2.x
- **网络请求**: Dio + Retrofit
- **路由导航**: go_router
- **本地存储**: flutter_secure_storage + SharedPreferences + Hive
- **UI 组件**: Material Design 3

## 项目结构

```
lib/
├── app/                    # 应用配置
│   ├── theme.dart         # 主题配置 ✅
│   ├── routes.dart        # 路由配置 (待实现)
│   └── app.dart          # 应用入口 (待实现)
├── core/                   # 核心功能
│   ├── constants/         # 常量定义 ✅
│   ├── network/           # 网络层 ✅
│   ├── services/          # 核心服务 ✅
│   └── utils/             # 工具类
├── data/                  # 数据层
│   ├── models/           # 数据模型
│   ├── repositories/     # 仓库层
│   └── providers/        # API 提供者
└── presentation/         # 展示层
    ├── layouts/          # 布局组件
    ├── pages/            # 页面
    ├── widgets/          # 可复用组件
    └── controllers/      # 状态管理
```

## 已完成功能

### Phase 1: 项目搭建 ✅

- [x] 创建 Flutter 项目结构
- [x] 配置依赖项 (Riverpod, Dio, go_router 等)
- [x] 应用主题配置 (紫蓝色 #667EEA)
- [x] API 常量定义
- [x] Dio 网络客户端
- [x] 请求拦截器 (认证/日志/错误处理)
- [x] 本地存储服务
- [x] API 响应格式定义

## 核心特性

### 1. AI Native 交互
- 主界面即 AI 聊天
- 通过对话完成服务发现
- 智能推荐陪诊师/机构

### 2. 侧边栏导航
- AI 智能助手
- 我的订单
- 消息
- 个人中心
- 设置

### 3. 后端集成
- 基础 URL: `http://localhost:5000/api/v1`
- JWT 认证
- 自动 Token 刷新
- 完善的错误处理

## 开发指南

### 安装依赖
```bash
cd App
flutter pub get
```

### 代码生成
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 运行应用
```bash
flutter run
```

## 主题颜色

- **Primary**: #667EEA
- **Gradient**: #667EEA → #764BA2
- **Success**: #43E97B
- **Warning**: #FFA940
- **Error**: #FF4D4F
- **Info**: #4FACFE

## 下一步

1. 创建数据模型 (User, Order, Message 等)
2. 实现认证功能 (登录、Token 管理)
3. 开发侧边栏布局
4. 实现 AI 聊天界面
5. 完成订单流程

## 注意事项

- 确保后端服务运行在 localhost:5000
- Token 使用安全存储
- 所有请求经过拦截器
- 支持自动错误处理和日志记录
