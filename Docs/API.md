# CareLink API 接口文档

## 文档信息

| 项目 | 内容 |
|------|------|
| 文档版本 | v1.0 |
| 创建日期 | 2025-11-12 |
| API版本 | v1 |
| 基础URL | https://api.carelink.com/v1 |

---

## 一、API 设计规范

### 1.1 RESTful 设计原则

遵循 REST 架构风格：

- 使用 HTTP 动词表示操作
  - `GET` - 查询资源
  - `POST` - 创建资源
  - `PUT` - 完整更新资源
  - `PATCH` - 部分更新资源
  - `DELETE` - 删除资源

- 资源命名使用名词复数形式
  - ✅ `/api/v1/users`
  - ❌ `/api/v1/getUser`

- 使用 HTTP 状态码表示结果
  - `200 OK` - 请求成功
  - `201 Created` - 创建成功
  - `204 No Content` - 删除成功
  - `400 Bad Request` - 请求参数错误
  - `401 Unauthorized` - 未认证
  - `403 Forbidden` - 无权限
  - `404 Not Found` - 资源不存在
  - `422 Unprocessable Entity` - 验证失败
  - `500 Internal Server Error` - 服务器错误

### 1.2 URL 设计规范

```
基础 URL：https://api.carelink.com/v1

用户端 API: /api/v1/user/*
管理端 API: /api/v1/admin/*
```

**示例**：
```
GET    /api/v1/user/companions          # 获取陪诊师列表
GET    /api/v1/user/companions/:id      # 获取陪诊师详情
POST   /api/v1/user/orders              # 创建订单
GET    /api/v1/user/orders/:id          # 获取订单详情

GET    /api/v1/admin/users              # 管理端：获取用户列表
PATCH  /api/v1/admin/users/:id/status   # 管理端：更新用户状态
```

### 1.3 统一响应格式

#### 成功响应

```json
{
  "success": true,
  "data": {
    "id": 123,
    "name": "张三"
  },
  "message": "操作成功",
  "timestamp": "2025-11-12T12:00:00Z"
}
```

#### 分页响应

```json
{
  "success": true,
  "data": {
    "items": [],
    "pagination": {
      "total": 100,
      "page": 1,
      "page_size": 20,
      "total_pages": 5
    }
  },
  "message": "查询成功",
  "timestamp": "2025-11-12T12:00:00Z"
}
```

#### 错误响应

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "输入验证失败",
    "details": [
      {
        "field": "phone",
        "message": "手机号格式不正确"
      }
    ]
  },
  "timestamp": "2025-11-12T12:00:00Z"
}
```

### 1.4 错误码定义

| 错误码 | HTTP状态码 | 说明 |
|--------|-----------|------|
| SUCCESS | 200 | 成功 |
| CREATED | 201 | 创建成功 |
| BAD_REQUEST | 400 | 请求参数错误 |
| UNAUTHORIZED | 401 | 未认证 |
| FORBIDDEN | 403 | 无权限 |
| NOT_FOUND | 404 | 资源不存在 |
| VALIDATION_ERROR | 422 | 验证失败 |
| INTERNAL_ERROR | 500 | 服务器内部错误 |
| SERVICE_UNAVAILABLE | 503 | 服务不可用 |
| PHONE_ALREADY_EXISTS | 422 | 手机号已存在 |
| INVALID_VERIFICATION_CODE | 422 | 验证码错误 |
| ORDER_NOT_FOUND | 404 | 订单不存在 |
| PAYMENT_FAILED | 422 | 支付失败 |
| INSUFFICIENT_BALANCE | 422 | 余额不足 |

### 1.5 认证机制

使用 JWT (JSON Web Token) 进行认证。

**请求头格式**：
```
Authorization: Bearer <token>
```

**Token 结构**：
```json
{
  "user_id": 123,
  "role": "user",  // user/companion/admin
  "exp": 1699999999
}
```

**Token 过期时间**：
- Access Token: 2 小时
- Refresh Token: 7 天

---

## 二、用户端 API

### 2.1 认证相关

#### 2.1.1 微信登录

```
POST /api/v1/user/auth/wechat-login
```

**请求参数**：
```json
{
  "code": "021yBjll2bINW24J1xnl2k1f2Z0yBjlG"  // 微信登录 code
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 7200,
    "user": {
      "id": 123,
      "phone": "138****1234",
      "nickname": "微信用户",
      "avatar_url": "https://..."
    },
    "is_new_user": true  // 是否新用户
  }
}
```

#### 2.1.2 刷新 Token

```
POST /api/v1/user/auth/refresh-token
```

**请求参数**：
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 7200
  }
}
```

#### 2.1.3 绑定手机号

```
POST /api/v1/user/auth/bind-phone
```

**请求头**：
```
Authorization: Bearer <token>
```

**请求参数**：
```json
{
  "phone": "13812341234",
  "code": "123456"  // 验证码
}
```

**响应**：
```json
{
  "success": true,
  "message": "手机号绑定成功"
}
```

---

### 2.2 用户信息

#### 2.2.1 获取当前用户信息

```
GET /api/v1/user/profile
```

**请求头**：
```
Authorization: Bearer <token>
```

**响应**：
```json
{
  "success": true,
  "data": {
    "id": 123,
    "phone": "138****1234",
    "nickname": "张三",
    "avatar_url": "https://...",
    "gender": "male",
    "birth_date": "1990-01-01",
    "balance": 100.50,
    "points": 500,
    "member_level": "normal",
    "total_orders": 10,
    "total_spent": 1500.00,
    "created_at": "2025-01-01T10:00:00Z"
  }
}
```

#### 2.2.2 更新用户信息

```
PATCH /api/v1/user/profile
```

**请求头**：
```
Authorization: Bearer <token>
```

**请求参数**：
```json
{
  "nickname": "李四",
  "avatar_url": "https://...",
  "gender": "female",
  "birth_date": "1995-05-05"
}
```

**响应**：
```json
{
  "success": true,
  "message": "更新成功",
  "data": {
    "id": 123,
    "nickname": "李四",
    ...
  }
}
```

---

### 2.3 就诊人管理

#### 2.3.1 获取就诊人列表

```
GET /api/v1/user/patients
```

**请求头**：
```
Authorization: Bearer <token>
```

**响应**：
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "张三",
      "gender": "male",
      "birth_date": "1990-01-01",
      "phone": "138****1234",
      "id_card": "110101********1234",
      "relationship": "self",
      "medical_history": "无",
      "allergies": "青霉素过敏",
      "is_default": true,
      "created_at": "2025-01-01T10:00:00Z"
    }
  ]
}
```

#### 2.3.2 创建就诊人

```
POST /api/v1/user/patients
```

**请求参数**：
```json
{
  "name": "李四",
  "gender": "female",
  "birth_date": "1995-05-05",
  "phone": "13987654321",
  "id_card": "110101199505051234",
  "relationship": "spouse",
  "medical_history": "高血压",
  "allergies": "无",
  "is_default": false
}
```

**响应**：
```json
{
  "success": true,
  "message": "添加成功",
  "data": {
    "id": 2,
    "name": "李四",
    ...
  }
}
```

#### 2.3.3 更新就诊人

```
PATCH /api/v1/user/patients/:id
```

#### 2.3.4 删除就诊人

```
DELETE /api/v1/user/patients/:id
```

#### 2.3.5 设置默认就诊人

```
POST /api/v1/user/patients/:id/set-default
```

---

### 2.4 地址管理

#### 2.4.1 获取地址列表

```
GET /api/v1/user/addresses
```

**响应**：
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "contact_name": "张三",
      "contact_phone": "13812341234",
      "province": "北京市",
      "city": "北京市",
      "district": "朝阳区",
      "detail_address": "建国路1号",
      "latitude": 39.9042,
      "longitude": 116.4074,
      "address_type": "home",
      "label": "家",
      "is_default": true
    }
  ]
}
```

#### 2.4.2 创建地址

```
POST /api/v1/user/addresses
```

**请求参数**：
```json
{
  "contact_name": "李四",
  "contact_phone": "13987654321",
  "province": "北京市",
  "city": "北京市",
  "district": "海淀区",
  "detail_address": "中关村大街1号",
  "latitude": 39.9893,
  "longitude": 116.3077,
  "address_type": "company",
  "label": "公司",
  "is_default": false
}
```

#### 2.4.3 更新地址

```
PATCH /api/v1/user/addresses/:id
```

#### 2.4.4 删除地址

```
DELETE /api/v1/user/addresses/:id
```

#### 2.4.5 设置默认地址

```
POST /api/v1/user/addresses/:id/set-default
```

---

### 2.5 AI 对话

#### 2.5.1 发送消息给 AI

```
POST /api/v1/user/ai/chat
```

**请求参数**：
```json
{
  "session_id": "uuid-1234-5678",  // 会话 ID，首次可不传，后端生成
  "message": "我需要预约明天上午去协和医院的陪诊服务"
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "session_id": "uuid-1234-5678",
    "message": "好的，我已为您记录以下信息：\n- 时间：明天上午\n- 医院：协和医院\n\n请问您需要什么类型的陪诊服务？",
    "extracted_data": {
      "intent": "book_appointment",
      "slots": {
        "time": "明天上午",
        "hospital": "协和医院"
      },
      "missing_slots": ["service_type", "service_spec"]
    },
    "recommendations": null  // 当信息完整时，返回推荐的陪诊师/机构列表
  }
}
```

#### 2.5.2 获取 AI 推荐结果

当 AI 提取到完整信息后，返回推荐结果：

**响应示例**（信息完整时）：
```json
{
  "success": true,
  "data": {
    "session_id": "uuid-1234-5678",
    "message": "根据您的需求，为您推荐以下陪诊服务：",
    "extracted_data": {
      "intent": "book_appointment",
      "slots": {
        "time": "2025-11-13 09:00",
        "hospital": "北京协和医院",
        "service_type": "基础陪诊",
        "service_spec": "4小时",
        "need_pickup": true
      },
      "is_complete": true
    },
    "recommendations": {
      "companions": [
        {
          "id": 1,
          "name": "王护士",
          "avatar_url": "https://...",
          "rating": 4.9,
          "review_count": 120,
          "service_years": 5,
          "specialties": ["老年陪护", "术后陪护"],
          "has_car": true,
          "price": 199.00,
          "match_score": 0.95  // 匹配度
        }
      ],
      "institutions": [
        {
          "id": 1,
          "name": "康护陪诊中心",
          "logo_url": "https://...",
          "rating": 4.8,
          "review_count": 500,
          "service_scope": "全程陪护、专家陪诊",
          "match_score": 0.88
        }
      ]
    }
  }
}
```

#### 2.5.3 获取对话历史

```
GET /api/v1/user/ai/chat-history?session_id=uuid-1234-5678
```

**响应**：
```json
{
  "success": true,
  "data": {
    "session_id": "uuid-1234-5678",
    "messages": [
      {
        "role": "user",
        "content": "我需要预约明天上午去协和医院的陪诊服务",
        "created_at": "2025-11-12T10:00:00Z"
      },
      {
        "role": "assistant",
        "content": "好的，我已为您记录...",
        "created_at": "2025-11-12T10:00:01Z"
      }
    ]
  }
}
```

---

### 2.6 陪诊师/机构查询

#### 2.6.1 获取陪诊师列表

```
GET /api/v1/user/companions
```

**查询参数**：
```
?page=1
&page_size=20
&rating_min=4.0         // 最低评分
&has_car=true           // 是否有车
&service_area=朝阳区     // 服务区域
&sort=rating            // 排序: rating/price/review_count
```

**响应**：
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "name": "王护士",
        "avatar_url": "https://...",
        "gender": "female",
        "age": 35,
        "service_years": 5,
        "specialties": ["老年陪护", "术后陪护"],
        "rating": 4.9,
        "review_count": 120,
        "has_car": true,
        "institution": {
          "id": 1,
          "name": "康护陪诊中心"
        },
        "services": [
          {
            "id": 1,
            "name": "基础陪诊",
            "base_price": 199.00,
            "duration_hours": 4
          }
        ]
      }
    ],
    "pagination": {
      "total": 50,
      "page": 1,
      "page_size": 20,
      "total_pages": 3
    }
  }
}
```

#### 2.6.2 获取陪诊师详情

```
GET /api/v1/user/companions/:id
```

**响应**：
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "王护士",
    "avatar_url": "https://...",
    "gender": "female",
    "age": 35,
    "service_years": 5,
    "specialties": ["老年陪护", "术后陪护"],
    "service_area": ["北京市朝阳区", "北京市海淀区"],
    "service_hospitals": ["北京协和医院", "301医院"],
    "introduction": "从事陪诊工作5年，具有丰富的老年陪护经验...",
    "rating": 4.9,
    "review_count": 120,
    "total_orders": 500,
    "completed_orders": 480,
    "has_car": true,
    "car_type": "SUV",
    "is_verified": true,
    "institution": {
      "id": 1,
      "name": "康护陪诊中心"
    },
    "services": [
      {
        "id": 1,
        "name": "基础陪诊",
        "description": "包含挂号、候诊、取药等基础服务",
        "base_price": 199.00,
        "duration_hours": 4,
        "support_pickup": true,
        "pickup_price": 50.00,
        "specs": [
          {
            "id": 1,
            "name": "2小时",
            "price": 129.00,
            "duration_hours": 2,
            "features": ["挂号", "候诊"]
          },
          {
            "id": 2,
            "name": "4小时",
            "price": 199.00,
            "duration_hours": 4,
            "features": ["挂号", "候诊", "取药", "缴费"]
          }
        ]
      }
    ],
    "recent_reviews": [
      {
        "id": 1,
        "user_nickname": "张三",
        "user_avatar": "https://...",
        "rating": 5,
        "tags": ["服务态度好", "专业", "准时"],
        "content": "王护士非常专业，服务态度很好...",
        "images": ["https://..."],
        "created_at": "2025-11-10T10:00:00Z"
      }
    ]
  }
}
```

#### 2.6.3 获取陪诊机构列表

```
GET /api/v1/user/institutions
```

**响应格式类似陪诊师列表**

#### 2.6.4 获取陪诊机构详情

```
GET /api/v1/user/institutions/:id
```

---

### 2.7 订单管理

#### 2.7.1 创建陪诊师订单

```
POST /api/v1/user/orders
```

**请求参数**：
```json
{
  "order_type": "companion",
  "companion_id": 1,
  "service_id": 1,
  "service_spec_id": 2,
  "patient_id": 1,
  "hospital_name": "北京协和医院",
  "hospital_address": "北京市东城区...",
  "department": "骨科",
  "appointment_date": "2025-11-13",
  "appointment_time": "09:00",
  "need_pickup": true,
  "pickup_type": "both",  // pickup_only/dropoff_only/both
  "pickup_address_id": 1,
  "user_note": "需要轮椅",
  "coupon_id": null  // 优惠券 ID（可选）
}
```

**响应**：
```json
{
  "success": true,
  "message": "订单创建成功",
  "data": {
    "id": 1001,
    "order_no": "CL202511121234567890",
    "order_type": "companion",
    "status": "pending_payment",
    "service_price": 199.00,
    "pickup_price": 100.00,
    "coupon_discount": 0.00,
    "total_price": 299.00,
    "created_at": "2025-11-12T12:00:00Z"
  }
}
```

#### 2.7.2 创建陪诊机构订单

```
POST /api/v1/user/orders
```

**请求参数**：
```json
{
  "order_type": "institution",
  "institution_id": 1,
  "patient_id": 1,
  "hospital_name": "北京协和医院",
  "appointment_date": "2025-11-13",
  "appointment_time": "09:00",
  "user_note": "需要有经验的陪诊师，患者行动不便"
}
```

**响应**：
```json
{
  "success": true,
  "message": "预约提交成功，机构将在24小时内联系您",
  "data": {
    "id": 1002,
    "order_no": "CL202511121234567891",
    "order_type": "institution",
    "status": "pending_service",  // 机构订单直接进入待服务状态
    "total_price": 0.00,  // 机构订单无需线上支付
    "created_at": "2025-11-12T12:00:00Z"
  }
}
```

#### 2.7.3 获取订单列表

```
GET /api/v1/user/orders
```

**查询参数**：
```
?page=1
&page_size=20
&status=pending_payment  // 订单状态筛选（可选）
&order_type=companion    // 订单类型筛选（可选）
```

**响应**：
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1001,
        "order_no": "CL202511121234567890",
        "order_type": "companion",
        "status": "pending_payment",
        "companion": {
          "id": 1,
          "name": "王护士",
          "avatar_url": "https://..."
        },
        "patient": {
          "id": 1,
          "name": "张三"
        },
        "hospital_name": "北京协和医院",
        "appointment_date": "2025-11-13",
        "appointment_time": "09:00",
        "total_price": 299.00,
        "created_at": "2025-11-12T12:00:00Z"
      }
    ],
    "pagination": {
      "total": 10,
      "page": 1,
      "page_size": 20,
      "total_pages": 1
    }
  }
}
```

#### 2.7.4 获取订单详情

```
GET /api/v1/user/orders/:id
```

**响应**：
```json
{
  "success": true,
  "data": {
    "id": 1001,
    "order_no": "CL202511121234567890",
    "order_type": "companion",
    "status": "pending_service",
    "companion": {
      "id": 1,
      "name": "王护士",
      "avatar_url": "https://...",
      "phone": "138****1234"
    },
    "patient": {
      "id": 1,
      "name": "张三",
      "phone": "138****5678",
      "gender": "male",
      "age": 60
    },
    "service": {
      "name": "基础陪诊",
      "spec_name": "4小时"
    },
    "hospital_name": "北京协和医院",
    "hospital_address": "北京市东城区...",
    "department": "骨科",
    "appointment_date": "2025-11-13",
    "appointment_time": "09:00",
    "need_pickup": true,
    "pickup_type": "both",
    "pickup_address": {
      "contact_name": "张三",
      "contact_phone": "13812341234",
      "detail_address": "北京市朝阳区建国路1号"
    },
    "service_price": 199.00,
    "pickup_price": 100.00,
    "coupon_discount": 0.00,
    "total_price": 299.00,
    "user_note": "需要轮椅",
    "admin_note": null,
    "created_at": "2025-11-12T12:00:00Z",
    "paid_at": "2025-11-12T12:05:00Z",
    "accepted_at": "2025-11-12T12:10:00Z",
    "service_started_at": null,
    "service_completed_at": null
  }
}
```

#### 2.7.5 取消订单

```
POST /api/v1/user/orders/:id/cancel
```

**请求参数**：
```json
{
  "cancel_reason": "临时有事，无法按时就诊"
}
```

**响应**：
```json
{
  "success": true,
  "message": "订单已取消",
  "data": {
    "refund_amount": 269.10,  // 退款金额（扣除手续费）
    "refund_status": "processing"
  }
}
```

---

### 2.8 支付相关

#### 2.8.1 创建支付

```
POST /api/v1/user/payments/create
```

**请求参数**：
```json
{
  "order_id": 1001,
  "payment_method": "wechat"  // 目前仅支持微信支付
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "payment_no": "PAY202511121234567890",
    "payment_params": {
      // 微信小程序支付参数
      "timeStamp": "1699999999",
      "nonceStr": "abc123",
      "package": "prepay_id=wx12345678901234567890",
      "signType": "RSA",
      "paySign": "..."
    }
  }
}
```

#### 2.8.2 查询支付结果

```
GET /api/v1/user/payments/:payment_no
```

**响应**：
```json
{
  "success": true,
  "data": {
    "payment_no": "PAY202511121234567890",
    "status": "success",  // pending/processing/success/failed
    "payment_amount": 299.00,
    "paid_at": "2025-11-12T12:05:00Z"
  }
}
```

---

### 2.9 评价相关

#### 2.9.1 创建评价

```
POST /api/v1/user/reviews
```

**请求参数**：
```json
{
  "order_id": 1001,
  "rating": 5,
  "tags": ["服务态度好", "专业", "准时"],
  "content": "王护士非常专业，服务态度很好，全程陪同非常贴心。",
  "images": ["https://...", "https://..."]
}
```

**响应**：
```json
{
  "success": true,
  "message": "评价成功",
  "data": {
    "id": 1,
    "rating": 5,
    "created_at": "2025-11-13T15:00:00Z"
  }
}
```

#### 2.9.2 获取陪诊师/机构的评价列表

```
GET /api/v1/user/companions/:id/reviews
```

或

```
GET /api/v1/user/institutions/:id/reviews
```

**查询参数**：
```
?page=1
&page_size=20
&rating=5  // 筛选评分（可选）
```

**响应**：
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "user": {
          "nickname": "张三",
          "avatar_url": "https://..."
        },
        "rating": 5,
        "tags": ["服务态度好", "专业"],
        "content": "非常满意...",
        "images": ["https://..."],
        "reply_content": "感谢您的认可！",
        "replied_at": "2025-11-13T16:00:00Z",
        "created_at": "2025-11-13T15:00:00Z"
      }
    ],
    "pagination": {
      "total": 120,
      "page": 1,
      "page_size": 20,
      "total_pages": 6
    },
    "rating_summary": {
      "average": 4.9,
      "total_count": 120,
      "distribution": {
        "5": 100,
        "4": 15,
        "3": 3,
        "2": 1,
        "1": 1
      }
    }
  }
}
```

---

### 2.10 消息相关

#### 2.10.1 获取会话列表

```
GET /api/v1/user/conversations
```

**响应**：
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "conversation_type": "companion",
      "companion": {
        "id": 1,
        "name": "王护士",
        "avatar_url": "https://..."
      },
      "last_message": {
        "content": "好的，明天见！",
        "created_at": "2025-11-12T18:00:00Z"
      },
      "unread_count": 2,
      "order": {
        "id": 1001,
        "order_no": "CL202511121234567890"
      }
    }
  ]
}
```

#### 2.10.2 获取会话消息

```
GET /api/v1/user/conversations/:id/messages
```

**查询参数**：
```
?page=1
&page_size=50
```

**响应**：
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "sender_type": "user",
        "message_type": "text",
        "content": "您好，我想确认一下明天的时间",
        "is_read": true,
        "created_at": "2025-11-12T17:50:00Z"
      },
      {
        "id": 2,
        "sender_type": "companion",
        "message_type": "text",
        "content": "您好，明天上午9点在医院门口见",
        "is_read": true,
        "created_at": "2025-11-12T17:55:00Z"
      }
    ],
    "pagination": {
      "total": 10,
      "page": 1,
      "page_size": 50,
      "total_pages": 1
    }
  }
}
```

#### 2.10.3 发送消息

```
POST /api/v1/user/conversations/:id/messages
```

**请求参数**：
```json
{
  "message_type": "text",
  "content": "好的，明天见！"
}
```

或（图片消息）：
```json
{
  "message_type": "image",
  "content": "https://...",  // 图片 URL
  "extra_data": {
    "width": 1024,
    "height": 768
  }
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "id": 3,
    "message_type": "text",
    "content": "好的，明天见！",
    "created_at": "2025-11-12T18:00:00Z"
  }
}
```

---

### 2.11 优惠券相关

#### 2.11.1 获取可领取的优惠券

```
GET /api/v1/user/coupons/available
```

**响应**：
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "新用户专享券",
      "description": "新用户首单立减20元",
      "coupon_type": "discount",
      "discount_amount": 20.00,
      "min_amount": 100.00,
      "end_date": "2026-02-12T23:59:59Z",
      "can_receive": true  // 是否可领取
    }
  ]
}
```

#### 2.11.2 领取优惠券

```
POST /api/v1/user/coupons/:id/receive
```

**响应**：
```json
{
  "success": true,
  "message": "领取成功",
  "data": {
    "user_coupon_id": 1,
    "end_date": "2026-02-12T23:59:59Z"
  }
}
```

#### 2.11.3 获取我的优惠券

```
GET /api/v1/user/my-coupons
```

**查询参数**：
```
?status=unused  // unused/used/expired
```

**响应**：
```json
{
  "success": true,
  "data": {
    "unused": [
      {
        "id": 1,
        "name": "新用户专享券",
        "discount_amount": 20.00,
        "min_amount": 100.00,
        "end_date": "2026-02-12T23:59:59Z",
        "status": "unused"
      }
    ],
    "used": [],
    "expired": []
  }
}
```

---

## 三、管理端 API

### 3.1 认证相关

#### 3.1.1 管理员登录

```
POST /api/v1/admin/auth/login
```

**请求参数**：
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 7200,
    "admin": {
      "id": 1,
      "username": "admin",
      "name": "超级管理员",
      "role": "admin",
      "avatar_url": "https://..."
    }
  }
}
```

---

### 3.2 用户管理

#### 3.2.1 获取用户列表

```
GET /api/v1/admin/users
```

**查询参数**：
```
?page=1
&page_size=20
&keyword=张三              // 搜索关键词（昵称/手机号）
&status=active            // 状态筛选
&start_date=2025-01-01    // 注册开始日期
&end_date=2025-12-31      // 注册结束日期
```

**响应**：
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 123,
        "phone": "138****1234",
        "nickname": "张三",
        "avatar_url": "https://...",
        "gender": "male",
        "member_level": "normal",
        "total_orders": 10,
        "total_spent": 1500.00,
        "balance": 100.50,
        "status": "active",
        "created_at": "2025-01-01T10:00:00Z",
        "last_login_at": "2025-11-12T08:00:00Z"
      }
    ],
    "pagination": {
      "total": 1000,
      "page": 1,
      "page_size": 20,
      "total_pages": 50
    }
  }
}
```

#### 3.2.2 获取用户详情

```
GET /api/v1/admin/users/:id
```

**响应**（包含完整信息）：
```json
{
  "success": true,
  "data": {
    "id": 123,
    "phone": "13812341234",  // 管理端可见完整手机号
    "nickname": "张三",
    "avatar_url": "https://...",
    "gender": "male",
    "birth_date": "1990-01-01",
    "wechat_openid": "oABC123...",
    "balance": 100.50,
    "points": 500,
    "member_level": "normal",
    "total_orders": 10,
    "total_spent": 1500.00,
    "status": "active",
    "created_at": "2025-01-01T10:00:00Z",
    "last_login_at": "2025-11-12T08:00:00Z",
    "patients": [
      {
        "id": 1,
        "name": "张三",
        "relationship": "self"
      }
    ],
    "recent_orders": [
      {
        "id": 1001,
        "order_no": "CL202511121234567890",
        "status": "completed",
        "total_price": 299.00,
        "created_at": "2025-11-12T12:00:00Z"
      }
    ]
  }
}
```

#### 3.2.3 更新用户状态

```
PATCH /api/v1/admin/users/:id/status
```

**请求参数**：
```json
{
  "status": "disabled",  // active/disabled/blocked
  "reason": "违规行为"
}
```

**响应**：
```json
{
  "success": true,
  "message": "用户状态已更新"
}
```

---

### 3.3 订单管理

#### 3.3.1 获取订单列表

```
GET /api/v1/admin/orders
```

**查询参数**：
```
?page=1
&page_size=20
&keyword=CL202511121234567890  // 订单号/用户手机号
&order_type=companion          // companion/institution
&status=pending_service
&start_date=2025-11-01
&end_date=2025-11-30
&companion_id=1                // 筛选陪诊师
&institution_id=1              // 筛选机构
```

**响应**：类似用户端订单列表，但包含更详细的信息

#### 3.3.2 获取订单详情

```
GET /api/v1/admin/orders/:id
```

#### 3.3.3 订单备注

```
POST /api/v1/admin/orders/:id/note
```

**请求参数**：
```json
{
  "admin_note": "用户投诉已处理"
}
```

#### 3.3.4 强制取消订单

```
POST /api/v1/admin/orders/:id/force-cancel
```

**请求参数**：
```json
{
  "cancel_reason": "陪诊师无法提供服务",
  "refund_amount": 299.00  // 退款金额
}
```

---

### 3.4 陪诊师管理

#### 3.4.1 获取陪诊师列表

```
GET /api/v1/admin/companions
```

**查询参数**：
```
?page=1
&page_size=20
&keyword=王护士
&status=approved  // pending/approved/rejected/disabled
&institution_id=1
&has_car=true
```

#### 3.4.2 获取陪诊师详情

```
GET /api/v1/admin/companions/:id
```

**响应**（包含完整信息，含身份证号、银行卡等）

#### 3.4.3 审核陪诊师

```
POST /api/v1/admin/companions/:id/review
```

**请求参数**：
```json
{
  "action": "approve",  // approve/reject
  "reject_reason": "资质证书不清晰"  // action为reject时必填
}
```

**响应**：
```json
{
  "success": true,
  "message": "审核成功"
}
```

#### 3.4.4 更新陪诊师状态

```
PATCH /api/v1/admin/companions/:id/status
```

**请求参数**：
```json
{
  "status": "disabled",  // approved/disabled
  "reason": "多次投诉"
}
```

---

### 3.5 陪诊机构管理

#### 3.5.1 获取机构列表

```
GET /api/v1/admin/institutions
```

#### 3.5.2 获取机构详情

```
GET /api/v1/admin/institutions/:id
```

#### 3.5.3 审核机构

```
POST /api/v1/admin/institutions/:id/review
```

#### 3.5.4 更新机构状态

```
PATCH /api/v1/admin/institutions/:id/status
```

---

### 3.6 评价管理

#### 3.6.1 获取评价列表

```
GET /api/v1/admin/reviews
```

**查询参数**：
```
?page=1
&page_size=20
&review_type=companion  // companion/institution
&target_id=1
&rating=5
&status=published  // published/hidden/deleted
```

#### 3.6.2 隐藏/删除评价

```
PATCH /api/v1/admin/reviews/:id/status
```

**请求参数**：
```json
{
  "status": "hidden",  // published/hidden/deleted
  "hide_reason": "包含敏感信息"
}
```

---

### 3.7 财务管理

#### 3.7.1 获取收入统计

```
GET /api/v1/admin/finance/income-summary
```

**查询参数**：
```
?start_date=2025-11-01
&end_date=2025-11-30
```

**响应**：
```json
{
  "success": true,
  "data": {
    "total_income": 50000.00,
    "platform_commission": 5000.00,  // 平台佣金
    "companion_income": 45000.00,    // 陪诊师收入
    "total_orders": 200,
    "completed_orders": 180,
    "refund_amount": 1000.00,
    "daily_trend": [
      {
        "date": "2025-11-01",
        "income": 1500.00,
        "orders": 10
      }
    ]
  }
}
```

#### 3.7.2 获取待结算列表

```
GET /api/v1/admin/finance/pending-settlements
```

**响应**：
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "companion_id": 1,
        "companion_name": "王护士",
        "pending_amount": 5000.00,  // 待结算金额
        "completed_orders_count": 30,
        "earliest_order_date": "2025-10-01"
      }
    ]
  }
}
```

#### 3.7.3 处理提现申请

```
POST /api/v1/admin/finance/withdrawals/:id/process
```

**请求参数**：
```json
{
  "action": "approve",  // approve/reject
  "reject_reason": "银行卡信息有误"
}
```

---

### 3.8 数据统计

#### 3.8.1 获取仪表盘数据

```
GET /api/v1/admin/dashboard
```

**响应**：
```json
{
  "success": true,
  "data": {
    "overview": {
      "total_users": 10000,
      "new_users_today": 50,
      "total_companions": 500,
      "total_institutions": 50,
      "total_orders": 50000,
      "orders_today": 100,
      "total_revenue": 1000000.00,
      "revenue_today": 5000.00
    },
    "order_status_distribution": {
      "pending_payment": 10,
      "pending_accept": 5,
      "pending_service": 20,
      "in_service": 15,
      "completed": 45000,
      "cancelled": 2000
    },
    "recent_orders": [],
    "top_companions": [],
    "user_growth_trend": []
  }
}
```

---

### 3.9 系统设置

#### 3.9.1 获取系统配置

```
GET /api/v1/admin/settings
```

**响应**：
```json
{
  "success": true,
  "data": {
    "platform": {
      "name": "CareLink",
      "logo_url": "https://...",
      "customer_service_phone": "400-123-4567"
    },
    "order": {
      "auto_cancel_minutes": 30,  // 未支付订单自动取消时间
      "accept_timeout_minutes": 60,  // 接单超时时间
      "refund_fee_rate": 0.1  // 退款手续费比例
    },
    "commission": {
      "companion_rate": 0.15,  // 陪诊师订单佣金比例
      "settlement_cycle_days": 7  // 结算周期（天）
    },
    "ai": {
      "model": "gpt-4",
      "temperature": 0.7
    }
  }
}
```

#### 3.9.2 更新系统配置

```
PUT /api/v1/admin/settings
```

**请求参数**：
```json
{
  "platform": {
    "customer_service_phone": "400-999-8888"
  },
  "order": {
    "auto_cancel_minutes": 60
  }
}
```

---

## 四、Webhook 回调

### 4.1 微信支付回调

```
POST /api/v1/webhooks/wechat-pay
```

**说明**：微信支付成功后的异步通知

**请求头**：
```
Wechatpay-Signature: ...
Wechatpay-Timestamp: ...
Wechatpay-Nonce: ...
Wechatpay-Serial: ...
```

**请求体**（加密后的数据）

**响应**（返回给微信）：
```json
{
  "code": "SUCCESS",
  "message": "成功"
}
```

---

## 五、附录

### 5.1 分页参数统一说明

所有列表接口都支持分页参数：

| 参数 | 类型 | 默认值 | 说明 |
|------|------|-------|------|
| page | integer | 1 | 页码 |
| page_size | integer | 20 | 每页数量（最大100） |

### 5.2 时间格式说明

- 所有时间字段使用 ISO 8601 格式：`2025-11-12T12:00:00Z`
- 时区：UTC+8 (Asia/Shanghai)

### 5.3 文件上传说明

文件上传使用独立的上传接口：

```
POST /api/v1/upload
```

**请求**：
```
Content-Type: multipart/form-data

file: (binary)
type: image  // image/video/document
```

**响应**：
```json
{
  "success": true,
  "data": {
    "url": "https://cdn.carelink.com/uploads/2025/11/12/abc123.jpg",
    "filename": "abc123.jpg",
    "size": 102400,
    "mime_type": "image/jpeg"
  }
}
```

### 5.4 限流说明

- 用户端 API：每个用户每分钟最多 60 次请求
- 管理端 API：每个管理员每分钟最多 120 次请求

超过限流后返回：
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "请求过于频繁，请稍后再试"
  }
}
```

### 5.5 API 版本管理

- 当前版本：v1
- 向后不兼容的修改会发布新版本（v2, v3...）
- 旧版本会保留至少 6 个月的支持期

---

**文档结束**
