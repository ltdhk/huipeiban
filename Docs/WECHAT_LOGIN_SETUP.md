# 微信小程序登录配置指南

## 1. 获取微信小程序 AppID 和 AppSecret

### 步骤：

1. 登录[微信公众平台](https://mp.weixin.qq.com/)
2. 进入 **开发** -> **开发管理** -> **开发设置**
3. 找到 **开发者ID**：
   - **AppID (小程序ID)**：`wx426040a3db6be21b` (已有)
   - **AppSecret (小程序密钥)**：需要管理员扫码获取

## 2. 配置后端环境变量

在 `Backend/.env` 文件中配置：

```bash
# 微信小程序配置
WECHAT_APPID=wx426040a3db6be21b
WECHAT_APP_SECRET=你的小程序密钥
```

**注意**：`.env` 文件已在 `.gitignore` 中，不会被提交到 Git。

## 3. 配置小程序合法域名

在微信公众平台中配置服务器域名白名单：

1. 进入 **开发** -> **开发管理** -> **开发设置** -> **服务器域名**
2. 配置以下域名：
   - **request合法域名**：`https://你的后端域名`
   - 本地开发可以在微信开发者工具中勾选 **不校验合法域名**

## 4. 微信登录流程

### 前端流程（小程序）：

```javascript
// 1. 调用 wx.login() 获取 code
const { code } = await wx.login();

// 2. 调用 wx.getUserProfile() 获取用户信息
const { userInfo } = await wx.getUserProfile({
  desc: '用于完善会员资料'
});

// 3. 将 code 和 userInfo 发送到后端
const res = await login({
  code,
  userInfo: {
    nickname: userInfo.nickName,
    avatar: userInfo.avatarUrl,
    gender: userInfo.gender // 0=未知, 1=男, 2=女
  }
});

// 4. 保存返回的 token
wx.setStorageSync('access_token', res.data.access_token);
wx.setStorageSync('refresh_token', res.data.refresh_token);
wx.setStorageSync('userInfo', res.data.user);
```

### 后端流程：

```python
# 1. 接收前端传来的 code
code = data.get('code')

# 2. 调用微信接口换取 openid 和 session_key
url = 'https://api.weixin.qq.com/sns/jscode2session'
params = {
    'appid': WECHAT_APPID,
    'secret': WECHAT_APP_SECRET,
    'js_code': code,
    'grant_type': 'authorization_code'
}
response = requests.get(url, params=params)

# 3. 根据 openid 查找或创建用户
user = User.query.filter_by(wechat_openid=openid).first()
if not user:
    # 创建新用户
    user = User(
        wechat_openid=openid,
        nickname=user_info.get('nickname', '微信用户'),
        avatar_url=user_info.get('avatar'),
        gender=gender
    )

# 4. 生成 JWT Token
tokens = generate_tokens(identity=user.id, user_type='user')

# 5. 返回用户信息和 token
return {
    'access_token': tokens['access_token'],
    'refresh_token': tokens['refresh_token'],
    'user': user.to_dict(),
    'is_new_user': is_new_user
}
```

## 5. 本地开发测试

### 方式一：使用真实微信登录

1. 在 `Backend/.env` 中配置真实的 `WECHAT_APP_SECRET`
2. 在微信开发者工具中运行小程序
3. 点击登录按钮，授权获取用户信息
4. 查看网络请求，确认登录成功

### 方式二：使用测试账号（不需要 AppSecret）

如果暂时无法获取 AppSecret，可以继续使用测试脚本：

```bash
cd Backend
python scripts/create_test_user.py
```

然后在微信开发者工具控制台执行输出的命令。

## 6. 常见问题

### Q1: 获取不到 AppSecret？
**A**: 需要小程序管理员在微信公众平台扫码获取，开发者无法直接查看。

### Q2: code2session 接口返回错误？
**A**: 检查以下几点：
- AppID 和 AppSecret 是否正确
- code 是否过期（5分钟有效期）
- code 是否已被使用（一次性的）

### Q3: 本地开发如何跳过域名校验？
**A**: 在微信开发者工具中：**详情** -> **本地设置** -> 勾选 **不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书**

### Q4: 用户拒绝授权怎么办？
**A**: 前端会提示 "需要授权才能登录"，用户需要重新点击登录按钮并同意授权。

## 7. 数据库迁移

由于修改了 User 模型（phone 字段改为可为空），需要重新创建数据库：

```bash
cd Backend
# 删除现有数据库（开发环境）
rm instance/carelink.db

# 重新创建数据库
python scripts/init_test_data.py
```

## 8. API 接口文档

### POST /api/v1/user/auth/wechat-login

**请求体**：
```json
{
  "code": "微信登录code",
  "userInfo": {
    "nickname": "用户昵称",
    "avatar": "头像URL",
    "gender": 1
  }
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "expires_in": 7200,
    "user": {
      "id": 1763049705399,
      "nickname": "用户昵称",
      "avatar_url": "头像URL",
      "gender": "male",
      "phone": null,
      ...
    },
    "is_new_user": true
  },
  "message": "登录成功"
}
```

## 9. 后续优化

- [ ] 实现手机号绑定功能
- [ ] 添加微信手机号快速验证（button open-type="getPhoneNumber"）
- [ ] 实现 Token 自动刷新机制
- [ ] 添加用户登录日志
- [ ] 实现 Token 黑名单机制（用于安全登出）
