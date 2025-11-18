# Flutter App 网络配置指南

## API 地址配置

当前 API 地址配置在: `lib/core/constants/api_constants.dart`

```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

## 不同环境下的配置

### 1. Android Studio 模拟器（推荐用于开发）
```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```
`10.0.2.2` 是 Android 模拟器访问宿主机 localhost 的特殊地址。

**虚拟机环境**: 如果您在虚拟机中运行 Android Studio 模拟器，仍然使用 `10.0.2.2`，模拟器会自动访问虚拟机的 localhost。

### 2. iOS 模拟器
```dart
static const String baseUrl = 'http://localhost:5000';
// 或
static const String baseUrl = 'http://127.0.0.1:5000';
```

### 3. 真机测试（同一局域网）
```dart
static const String baseUrl = 'http://192.168.x.x:5000';
```
将 `192.168.x.x` 替换为您电脑的局域网 IP 地址。

查看电脑 IP：
- Windows: `ipconfig`
- Mac/Linux: `ifconfig` 或 `ip addr`

### 4. Genymotion 模拟器
```dart
static const String baseUrl = 'http://10.0.3.2:5000';
```

## 测试连接

### 方法1: 使用 curl 测试
```bash
# 从电脑测试
curl http://localhost:5000/api/v1/user/auth/login

# 测试登录
curl -X POST http://localhost:5000/api/v1/user/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"13800138000","password":"123456"}'
```

### 方法2: 在浏览器测试
打开浏览器访问: `http://localhost:5000`

## 常见问题排查

### 问题1: Connection Refused

**可能原因**:
1. 后端服务未启动
2. 端口号错误
3. IP 地址错误

**解决方案**:
```bash
# 1. 启动后端服务
cd Backend
python run.py

# 2. 确认服务运行在 0.0.0.0:5000
# 应该看到: Running on all addresses (0.0.0.0)
```

### 问题2: Android 模拟器无法连接 10.0.2.2

**解决方案1: 检查防火墙**
- Windows: 允许 Python 通过防火墙
- Mac: 系统偏好设置 → 安全性与隐私 → 防火墙

**解决方案2: 使用局域网 IP**
1. 查看电脑 IP: `ipconfig` (Windows) 或 `ifconfig` (Mac/Linux)
2. 修改 `api_constants.dart`:
   ```dart
   static const String baseUrl = 'http://192.168.1.100:5000';
   ```
3. 确保后端监听 0.0.0.0:
   ```python
   # Backend/run.py
   app.run(host='0.0.0.0', port=5000, debug=True)
   ```

**解决方案3: 使用 ADB 端口转发**
```bash
adb reverse tcp:5000 tcp:5000
```
然后可以使用 `http://localhost:5000`

### 问题3: iOS 模拟器连接问题

使用 `localhost` 或 `127.0.0.1` 即可：
```dart
static const String baseUrl = 'http://localhost:5000';
```

## 测试账号

创建成功的测试账号：
- **手机号**: 13800138000
- **密码**: 123456
- **用户 ID**: 1763193293952490

## 环境变量配置（可选）

为了更灵活地切换环境，可以使用环境变量：

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  // 根据 Flutter 运行模式自动选择
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  // ... 其他配置
}
```

运行时指定：
```bash
# Android 模拟器
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000

# 真机
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:5000

# iOS 模拟器
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

## 后端配置检查

确保后端正确配置：

```python
# Backend/run.py
if __name__ == '__main__':
    app.run(
        host='0.0.0.0',  # 重要！监听所有接口
        port=5000,
        debug=True
    )
```

## 测试流程

1. **启动后端**:
   ```bash
   cd Backend
   python run.py
   ```

2. **确认后端运行**:
   ```
   应该看到:
   * Running on all addresses (0.0.0.0)
   * Running on http://127.0.0.1:5000
   ```

3. **测试连接**:
   ```bash
   curl http://localhost:5000/api/v1/user/auth/login
   ```

4. **运行 Flutter 应用**:
   ```bash
   cd App
   flutter run
   ```

5. **登录测试**:
   - 手机号: 13800138000
   - 密码: 123456

## 日志调试

### Flutter 端
查看网络请求日志（LoggerInterceptor 已配置）:
```
I/flutter: 🌐 请求开始
I/flutter: URL: http://10.0.2.2:5000/api/v1/user/auth/login
I/flutter: ✅ 响应成功
```

### 后端
Flask 会打印所有请求:
```
127.0.0.1 - - [15/Nov/2025 15:55:06] "POST /api/v1/user/auth/login HTTP/1.1" 200 -
```

## 生产环境配置

生产环境建议使用 HTTPS 和域名：
```dart
static const String baseUrl = 'https://api.carelink.com';
```
