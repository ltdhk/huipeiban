# 快速测试指南

## 问题诊断：小程序端只显示"对话成功"但没有AI回复内容

### 已修复的问题

**根本原因**：前端代码期望的数据结构与后端实际返回的不一致。

- **后端返回**：
```json
{
  "success": true,
  "data": {
    "message": "AI回复内容",
    "session_id": "session_123",
    "recommendations": []
  },
  "message": "对话成功"
}
```

- **前端原代码**：直接访问 `res.message`（这是"对话成功"而不是AI回复）
- **前端修复后**：访问 `res.data.message`（这才是AI回复内容）

### 修复内容

已更新 [home.js](MiniApp/pages/home/home.js:156-164)，现在会：
1. 从 `res.data` 中获取实际的AI响应数据
2. 优先尝试 `responseData.message`，然后是 `responseData.content`
3. 添加调试日志 `console.log('AI响应数据:', responseData)`

## 测试步骤

### 方式一：使用测试Token（推荐用于快速测试）

1. **生成测试用户和Token**：
   ```bash
   cd Backend
   python scripts/create_test_user.py
   ```

2. **在微信开发者工具控制台执行**（分三行执行）：
   ```javascript
   wx.setStorageSync('access_token', '你的access_token');
   wx.setStorageSync('refresh_token', '你的refresh_token');
   wx.setStorageSync('userInfo', {'id': 用户ID, 'nickname': '测试用户', 'avatar': '头像URL', 'phone': '13800138000'});
   ```

3. **刷新页面**，进入首页

4. **发送测试消息**：
   - 输入"你好"
   - 点击发送
   - 查看控制台日志中的"AI响应数据"

### 方式二：使用真实微信登录

1. **配置微信AppSecret**（需要管理员权限）：
   - 在 `Backend/.env` 中设置：
     ```
     WECHAT_APPID=wx426040a3db6be21b
     WECHAT_APP_SECRET=你的小程序密钥
     ```

2. **重启后端服务**：
   ```bash
   cd Backend
   python run.py
   ```

3. **在微信开发者工具中**：
   - 进入登录页面
   - 点击"微信登录"
   - 授权获取用户信息
   - 自动跳转到首页

4. **发送测试消息**

## 调试检查清单

### 1. 检查控制台日志

在微信开发者工具控制台中查看：

```
AI响应数据: {
  message: "...",           // AI回复内容
  session_id: "...",        // 会话ID
  recommendations: [],      // 推荐列表
  created_at: "...",       // 创建时间
  intent: "...",           // 意图
  entities: {}             // 实体
}
```

如果看到这个日志，说明数据已正确接收。

### 2. 检查消息列表

在控制台执行：
```javascript
getCurrentPages()[0].data.messages
```

应该看到类似：
```javascript
[
  {
    id: 1731550000000,
    role: 'user',
    content: '你好'
  },
  {
    id: 1731550000001,
    role: 'assistant',
    content: 'AI的回复内容',
    recommendations: []
  }
]
```

### 3. 检查后端响应

在后端日志中查看：
```
INFO in ai_agent: AI对话开始: user_id=xxx, message=你好
INFO in ai_agent: AI响应: message=..., session_id=...
```

### 4. 检查网络请求

在微信开发者工具的"Network"标签中：
- 找到 `/api/v1/user/ai/chat` 请求
- 查看 Response：
  ```json
  {
    "success": true,
    "data": {
      "message": "..."
    }
  }
  ```

## 常见问题排查

### 问题1：显示"回复内容为空"

**原因**：后端返回的数据结构中没有 `message` 或 `content` 字段

**排查**：
1. 查看控制台日志"AI响应数据"
2. 检查后端 AI Agent 是否正确返回

**解决**：
```javascript
// 在控制台查看完整响应
console.log(JSON.stringify(响应数据, null, 2))
```

### 问题2：401 认证错误

**原因**：Token无效或过期

**解决**：
1. 重新运行 `python scripts/create_test_user.py`
2. 重新设置Token到小程序

### 问题3：422 "Subject must be a string"

**原因**：已修复（JWT identity类型问题）

**确认修复**：检查 [jwt_utils.py](Backend/app/utils/jwt_utils.py:33,40) 中是否使用了 `str(identity)`

### 问题4：看不到消息

**原因**：滚动位置不对

**解决**：
```javascript
// 在控制台手动滚动到底部
getCurrentPages()[0].setData({ scrollIntoView: 'bottom' })
```

## 预期效果

正常情况下，你应该看到：

1. **用户消息**：
   - 右侧显示
   - 蓝色气泡
   - 显示"我"标签

2. **AI回复**：
   - 左侧显示
   - 白色气泡
   - 显示"AI助手"标签和头像
   - **完整的回复内容**（而不是"对话成功"）

3. **推荐卡片**（如果有）：
   - 显示在AI消息下方
   - 包含头像、名称、评分、标签等

## 下一步

如果测试成功，你可以：
1. ✅ 删除调试日志（[home.js:158](MiniApp/pages/home/home.js:158)）
2. ✅ 继续实现其他功能（订单、消息等）
3. ✅ 配置真实的微信登录

如果仍有问题，请提供：
1. 微信开发者工具控制台的完整日志
2. Network 标签中的请求和响应内容
3. 后端服务的日志输出
