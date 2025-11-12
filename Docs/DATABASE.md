# CareLink 数据库设计文档

## 文档信息

| 项目 | 内容 |
|------|------|
| 文档版本 | v1.0 |
| 创建日期 | 2025-11-12 |
| 数据库类型 | PostgreSQL 15+ |
| 字符集 | UTF-8 |
| 时区 | Asia/Shanghai |

---

## 一、设计原则

### 1.1 命名规范

- **表名**：小写字母 + 下划线，复数形式（如 `users`, `orders`）
- **字段名**：小写字母 + 下划线（如 `user_id`, `created_at`）
- **索引名**：`idx_表名_字段名`（如 `idx_users_phone`）
- **唯一索引**：`uk_表名_字段名`（如 `uk_users_phone`）
- **外键**：`fk_表名_关联表名`（如 `fk_orders_users`）

### 1.2 字段设计规范

- **主键**：统一使用 `BIGSERIAL` 类型的 `id` 字段
- **时间戳**：
  - `created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP` - 创建时间
  - `updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP` - 更新时间
- **逻辑删除**：`is_deleted BOOLEAN DEFAULT FALSE` - 软删除标记
- **状态字段**：使用 `VARCHAR(20)` 存储状态值，便于扩展
- **金额字段**：使用 `DECIMAL(10, 2)` 存储金额（单位：元）
- **手机号**：`VARCHAR(20)` - 考虑国际号码
- **枚举值**：优先使用 VARCHAR 而非 ENUM 类型，便于扩展

### 1.3 索引设计原则

- 为所有外键字段创建索引
- 为高频查询字段创建索引
- 为常用的组合查询创建复合索引
- 避免过多索引影响写入性能

### 1.4 安全与隐私

- 敏感信息（手机号、身份证号）需加密存储
- 密码使用 bcrypt 或 Argon2 哈希
- 支付相关字段需要额外安全措施

---

## 二、ER 图概览

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│    users     │◄───────┤   patients   │         │  addresses   │
│  (用户表)     │         │  (就诊人表)   │         │  (地址表)     │
└──────┬───────┘         └──────────────┘         └──────┬───────┘
       │                                                  │
       │                                                  │
       │ 1:N                                         1:N  │
       │                                                  │
       ▼                                                  │
┌──────────────┐         ┌──────────────┐                │
│    orders    │◄───────┤   payments   │                │
│   (订单表)    │         │  (支付表)     │                │
└──────┬───────┘         └──────────────┘                │
       │                                                  │
       │ 1:1                                              │
       ▼                                                  │
┌──────────────┐         ┌──────────────┐                │
│ appointments │         │   reviews    │                │
│  (预约表)     │         │  (评价表)     │                │
└──────────────┘         └──────────────┘                │
       │                                                  │
       │                                                  │
       ▼                                                  │
┌──────────────┐         ┌──────────────┐                │
│  companions  │◄───────┤ institutions │◄───────────────┘
│ (陪诊师表)    │    N:1  │ (陪诊机构表)  │
└──────┬───────┘         └──────────────┘
       │
       │ 1:N
       ▼
┌──────────────┐         ┌──────────────┐
│   services   │         │service_specs │
│  (服务表)     │◄───────┤ (服务规格表)  │
└──────────────┘   1:N   └──────────────┘

┌──────────────┐         ┌──────────────┐
│conversations │◄───────┤   messages   │
│  (会话表)     │   1:N   │  (消息表)     │
└──────────────┘         └──────────────┘

┌──────────────┐
│ai_chat_history│
│ (AI对话历史表)│
└──────────────┘

┌──────────────┐         ┌──────────────┐
│ admin_users  │         │ admin_roles  │
│ (管理员表)    │◄───────┤ (角色表)      │
└──────────────┘   N:M   └──────────────┘
```

---

## 三、表结构详细设计

### 3.1 用户相关表

#### 3.1.1 users - 用户表

存储 C 端用户基本信息。

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,

    -- 基本信息
    phone VARCHAR(20) NOT NULL UNIQUE,              -- 手机号（加密存储）
    password_hash VARCHAR(255),                     -- 密码哈希（如支持密码登录）
    nickname VARCHAR(50),                           -- 昵称
    avatar_url VARCHAR(255),                        -- 头像 URL
    gender VARCHAR(10),                             -- 性别: male/female/unknown
    birth_date DATE,                                -- 出生日期

    -- 微信信息
    wechat_openid VARCHAR(100) UNIQUE,              -- 微信 OpenID
    wechat_unionid VARCHAR(100),                    -- 微信 UnionID

    -- 账户信息
    balance DECIMAL(10, 2) DEFAULT 0.00,            -- 账户余额
    points INTEGER DEFAULT 0,                       -- 积分
    member_level VARCHAR(20) DEFAULT 'normal',      -- 会员等级

    -- 统计信息
    total_orders INTEGER DEFAULT 0,                 -- 总订单数
    total_spent DECIMAL(10, 2) DEFAULT 0.00,        -- 总消费金额

    -- 状态
    status VARCHAR(20) DEFAULT 'active',            -- 状态: active/disabled/blocked

    -- 时间戳
    last_login_at TIMESTAMP,                        -- 最后登录时间
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 索引
CREATE INDEX idx_users_phone ON users(phone) WHERE NOT is_deleted;
CREATE INDEX idx_users_wechat_openid ON users(wechat_openid) WHERE NOT is_deleted;
CREATE INDEX idx_users_status ON users(status) WHERE NOT is_deleted;
CREATE INDEX idx_users_created_at ON users(created_at);

-- 注释
COMMENT ON TABLE users IS '用户表';
COMMENT ON COLUMN users.phone IS '手机号（需加密存储）';
COMMENT ON COLUMN users.balance IS '账户余额（单位：元）';
```

#### 3.1.2 patients - 就诊人表

存储用户的就诊人信息。

```sql
CREATE TABLE patients (
    id BIGSERIAL PRIMARY KEY,

    -- 关联用户
    user_id BIGINT NOT NULL,                        -- 用户 ID

    -- 就诊人信息
    name VARCHAR(50) NOT NULL,                      -- 姓名
    gender VARCHAR(10) NOT NULL,                    -- 性别
    birth_date DATE,                                -- 出生日期
    phone VARCHAR(20),                              -- 联系电话
    id_card VARCHAR(100),                           -- 身份证号（加密存储）
    relationship VARCHAR(20),                       -- 与用户关系: self/parent/spouse/child/other

    -- 医疗信息
    medical_history TEXT,                           -- 病史摘要
    allergies TEXT,                                 -- 过敏史
    special_needs TEXT,                             -- 特殊需求

    -- 保险信息（可选）
    insurance_type VARCHAR(50),                     -- 医保类型
    insurance_number VARCHAR(100),                  -- 医保卡号

    -- 设置
    is_default BOOLEAN DEFAULT FALSE,               -- 是否默认就诊人

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_patients_users FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 索引
CREATE INDEX idx_patients_user_id ON patients(user_id) WHERE NOT is_deleted;
CREATE INDEX idx_patients_is_default ON patients(user_id, is_default) WHERE is_default = TRUE AND NOT is_deleted;

-- 注释
COMMENT ON TABLE patients IS '就诊人表';
COMMENT ON COLUMN patients.id_card IS '身份证号（需加密存储）';
```

#### 3.1.3 addresses - 用户地址表

存储用户常用地址（用于接送服务）。

```sql
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,

    -- 关联用户
    user_id BIGINT NOT NULL,                        -- 用户 ID

    -- 地址信息
    contact_name VARCHAR(50) NOT NULL,              -- 联系人
    contact_phone VARCHAR(20) NOT NULL,             -- 联系电话
    province VARCHAR(50) NOT NULL,                  -- 省份
    city VARCHAR(50) NOT NULL,                      -- 城市
    district VARCHAR(50) NOT NULL,                  -- 区/县
    detail_address VARCHAR(255) NOT NULL,           -- 详细地址

    -- 位置信息
    latitude DECIMAL(10, 7),                        -- 纬度
    longitude DECIMAL(10, 7),                       -- 经度

    -- 地址标签
    address_type VARCHAR(20) DEFAULT 'other',       -- 地址类型: home/company/hospital/other
    label VARCHAR(50),                              -- 自定义标签

    -- 设置
    is_default BOOLEAN DEFAULT FALSE,               -- 是否默认地址

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_addresses_users FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 索引
CREATE INDEX idx_addresses_user_id ON addresses(user_id) WHERE NOT is_deleted;
CREATE INDEX idx_addresses_is_default ON addresses(user_id, is_default) WHERE is_default = TRUE AND NOT is_deleted;
CREATE INDEX idx_addresses_location ON addresses(latitude, longitude) WHERE NOT is_deleted;

-- 注释
COMMENT ON TABLE addresses IS '用户地址表';
COMMENT ON COLUMN addresses.latitude IS '纬度（用于距离计算）';
COMMENT ON COLUMN addresses.longitude IS '经度（用于距离计算）';
```

---

### 3.2 陪诊服务提供方表

#### 3.2.1 companions - 陪诊师表

存储陪诊师信息。

```sql
CREATE TABLE companions (
    id BIGSERIAL PRIMARY KEY,

    -- 基本信息
    phone VARCHAR(20) NOT NULL UNIQUE,              -- 手机号
    password_hash VARCHAR(255) NOT NULL,            -- 密码哈希
    name VARCHAR(50) NOT NULL,                      -- 姓名
    avatar_url VARCHAR(255),                        -- 头像 URL
    gender VARCHAR(10),                             -- 性别
    age INTEGER,                                    -- 年龄
    id_card VARCHAR(100) NOT NULL,                  -- 身份证号（加密）

    -- 所属机构
    institution_id BIGINT,                          -- 所属机构 ID（可为空，表示独立陪诊师）

    -- 资质信息
    certificates TEXT,                              -- 资质证书（JSON 数组：[{type, url, expire_date}]）
    health_certificate_url VARCHAR(255),            -- 健康证 URL
    health_certificate_expire_date DATE,            -- 健康证到期时间

    -- 服务信息
    service_years INTEGER,                          -- 从业年限
    specialties TEXT,                               -- 擅长领域（JSON 数组）
    service_area TEXT,                              -- 服务区域（JSON 数组：[{province, city, districts[]}]）
    service_hospitals TEXT,                         -- 常服务的医院（JSON 数组）
    introduction TEXT,                              -- 个人简介

    -- 车辆信息
    has_car BOOLEAN DEFAULT FALSE,                  -- 是否有车
    car_type VARCHAR(50),                           -- 车辆类型
    car_plate VARCHAR(20),                          -- 车牌号

    -- 评分统计
    rating DECIMAL(3, 2) DEFAULT 5.00,              -- 平均评分
    review_count INTEGER DEFAULT 0,                 -- 评价数量

    -- 服务统计
    total_orders INTEGER DEFAULT 0,                 -- 总订单数
    completed_orders INTEGER DEFAULT 0,             -- 完成订单数
    cancelled_orders INTEGER DEFAULT 0,             -- 取消订单数

    -- 财务信息
    total_income DECIMAL(10, 2) DEFAULT 0.00,       -- 总收入
    available_balance DECIMAL(10, 2) DEFAULT 0.00,  -- 可提现余额
    bank_name VARCHAR(100),                         -- 开户银行
    bank_account VARCHAR(100),                      -- 银行账号（加密）
    account_holder VARCHAR(50),                     -- 开户人

    -- 状态
    status VARCHAR(20) DEFAULT 'pending',           -- 状态: pending/approved/rejected/disabled
    reject_reason TEXT,                             -- 拒绝原因
    is_verified BOOLEAN DEFAULT FALSE,              -- 是否已认证
    is_online BOOLEAN DEFAULT FALSE,                -- 是否在线接单

    -- 时间戳
    approved_at TIMESTAMP,                          -- 审核通过时间
    last_login_at TIMESTAMP,                        -- 最后登录时间
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_companions_institutions FOREIGN KEY (institution_id) REFERENCES institutions(id)
);

-- 索引
CREATE INDEX idx_companions_phone ON companions(phone) WHERE NOT is_deleted;
CREATE INDEX idx_companions_institution_id ON companions(institution_id) WHERE NOT is_deleted;
CREATE INDEX idx_companions_status ON companions(status) WHERE NOT is_deleted;
CREATE INDEX idx_companions_rating ON companions(rating DESC) WHERE status = 'approved' AND NOT is_deleted;
CREATE INDEX idx_companions_has_car ON companions(has_car) WHERE status = 'approved' AND NOT is_deleted;

-- 注释
COMMENT ON TABLE companions IS '陪诊师表';
COMMENT ON COLUMN companions.certificates IS '资质证书（JSON格式）';
COMMENT ON COLUMN companions.service_area IS '服务区域（JSON格式）';
```

#### 3.2.2 institutions - 陪诊机构表

存储陪诊机构信息。

```sql
CREATE TABLE institutions (
    id BIGSERIAL PRIMARY KEY,

    -- 基本信息
    name VARCHAR(100) NOT NULL,                     -- 机构名称
    logo_url VARCHAR(255),                          -- LOGO URL
    phone VARCHAR(20) NOT NULL,                     -- 联系电话
    email VARCHAR(100),                             -- 邮箱

    -- 法人信息
    legal_person VARCHAR(50),                       -- 法人代表
    legal_person_id_card VARCHAR(100),              -- 法人身份证（加密）

    -- 资质信息
    business_license_url VARCHAR(255),              -- 营业执照 URL
    business_license_number VARCHAR(100),           -- 营业执照号
    medical_license_url VARCHAR(255),               -- 医疗相关许可证 URL（如需要）
    other_certificates TEXT,                        -- 其他证书（JSON 数组）

    -- 服务信息
    service_area TEXT,                              -- 服务区域（JSON 数组）
    service_scope TEXT,                             -- 服务范围描述
    introduction TEXT,                              -- 机构简介

    -- 地址信息
    province VARCHAR(50),                           -- 省份
    city VARCHAR(50),                               -- 城市
    district VARCHAR(50),                           -- 区/县
    detail_address VARCHAR(255),                    -- 详细地址
    latitude DECIMAL(10, 7),                        -- 纬度
    longitude DECIMAL(10, 7),                       -- 经度

    -- 评分统计
    rating DECIMAL(3, 2) DEFAULT 5.00,              -- 平均评分
    review_count INTEGER DEFAULT 0,                 -- 评价数量

    -- 服务统计
    total_orders INTEGER DEFAULT 0,                 -- 总订单数
    completed_orders INTEGER DEFAULT 0,             -- 完成订单数
    companion_count INTEGER DEFAULT 0,              -- 陪诊师数量

    -- 财务信息（如平台收取会员费）
    account_bank VARCHAR(100),                      -- 开户银行
    account_number VARCHAR(100),                    -- 银行账号（加密）
    account_holder VARCHAR(50),                     -- 开户人

    -- 状态
    status VARCHAR(20) DEFAULT 'pending',           -- 状态: pending/approved/rejected/disabled
    reject_reason TEXT,                             -- 拒绝原因

    -- 时间戳
    approved_at TIMESTAMP,                          -- 审核通过时间
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 索引
CREATE INDEX idx_institutions_status ON institutions(status) WHERE NOT is_deleted;
CREATE INDEX idx_institutions_rating ON institutions(rating DESC) WHERE status = 'approved' AND NOT is_deleted;
CREATE INDEX idx_institutions_location ON institutions(latitude, longitude) WHERE NOT is_deleted;

-- 注释
COMMENT ON TABLE institutions IS '陪诊机构表';
COMMENT ON COLUMN institutions.service_area IS '服务区域（JSON格式）';
```

#### 3.2.3 services - 服务产品表

存储陪诊师提供的服务产品。

```sql
CREATE TABLE services (
    id BIGSERIAL PRIMARY KEY,

    -- 关联陪诊师
    companion_id BIGINT NOT NULL,                   -- 陪诊师 ID

    -- 服务信息
    name VARCHAR(100) NOT NULL,                     -- 服务名称
    description TEXT,                               -- 服务描述
    category VARCHAR(50),                           -- 服务分类: basic/expert/vip/custom

    -- 定价
    base_price DECIMAL(10, 2) NOT NULL,             -- 基础价格

    -- 服务时长
    duration_hours INTEGER NOT NULL,                -- 服务时长（小时）

    -- 是否支持接送
    support_pickup BOOLEAN DEFAULT FALSE,           -- 是否支持接送
    pickup_price DECIMAL(10, 2),                    -- 接送费用（单程）

    -- 状态
    is_active BOOLEAN DEFAULT TRUE,                 -- 是否上架

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_services_companions FOREIGN KEY (companion_id) REFERENCES companions(id)
);

-- 索引
CREATE INDEX idx_services_companion_id ON services(companion_id) WHERE NOT is_deleted;
CREATE INDEX idx_services_category ON services(category) WHERE is_active AND NOT is_deleted;
CREATE INDEX idx_services_is_active ON services(is_active) WHERE NOT is_deleted;

-- 注释
COMMENT ON TABLE services IS '服务产品表';
COMMENT ON COLUMN services.base_price IS '基础价格（单位：元）';
```

#### 3.2.4 service_specs - 服务规格表

存储服务的不同规格（如 2小时、4小时、全天等）。

```sql
CREATE TABLE service_specs (
    id BIGSERIAL PRIMARY KEY,

    -- 关联服务
    service_id BIGINT NOT NULL,                     -- 服务 ID

    -- 规格信息
    name VARCHAR(50) NOT NULL,                      -- 规格名称: 2小时/4小时/全天/VIP
    description TEXT,                               -- 规格描述
    duration_hours INTEGER NOT NULL,                -- 时长（小时）

    -- 定价
    price DECIMAL(10, 2) NOT NULL,                  -- 价格

    -- 包含内容
    features TEXT,                                  -- 包含服务（JSON 数组）

    -- 排序
    sort_order INTEGER DEFAULT 0,                   -- 排序

    -- 状态
    is_active BOOLEAN DEFAULT TRUE,                 -- 是否可用

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_service_specs_services FOREIGN KEY (service_id) REFERENCES services(id)
);

-- 索引
CREATE INDEX idx_service_specs_service_id ON service_specs(service_id) WHERE NOT is_deleted;
CREATE INDEX idx_service_specs_sort_order ON service_specs(service_id, sort_order) WHERE is_active AND NOT is_deleted;

-- 注释
COMMENT ON TABLE service_specs IS '服务规格表';
COMMENT ON COLUMN service_specs.features IS '包含服务内容（JSON格式）';
```

---

### 3.3 订单相关表

#### 3.3.1 orders - 订单表

存储所有订单（陪诊师订单和机构订单）。

```sql
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,

    -- 订单编号
    order_no VARCHAR(32) NOT NULL UNIQUE,           -- 订单号（唯一）

    -- 关联信息
    user_id BIGINT NOT NULL,                        -- 用户 ID
    patient_id BIGINT NOT NULL,                     -- 就诊人 ID

    -- 订单类型
    order_type VARCHAR(20) NOT NULL,                -- 订单类型: companion/institution

    -- 服务提供方
    companion_id BIGINT,                            -- 陪诊师 ID（陪诊师订单时必填）
    institution_id BIGINT,                          -- 机构 ID（机构订单时必填）

    -- 服务信息
    service_id BIGINT,                              -- 服务 ID
    service_spec_id BIGINT,                         -- 服务规格 ID

    -- 预约信息
    hospital_name VARCHAR(100) NOT NULL,            -- 医院名称
    hospital_address VARCHAR(255),                  -- 医院地址
    department VARCHAR(100),                        -- 科室
    appointment_date DATE NOT NULL,                 -- 预约日期
    appointment_time TIME NOT NULL,                 -- 预约时间

    -- 接送信息
    need_pickup BOOLEAN DEFAULT FALSE,              -- 是否需要接送
    pickup_type VARCHAR(20),                        -- 接送类型: pickup_only/dropoff_only/both
    pickup_address_id BIGINT,                       -- 接送地址 ID
    pickup_address_detail TEXT,                     -- 接送地址详情（冗余存储）

    -- 费用信息
    service_price DECIMAL(10, 2) NOT NULL,          -- 服务费
    pickup_price DECIMAL(10, 2) DEFAULT 0.00,       -- 接送费
    coupon_discount DECIMAL(10, 2) DEFAULT 0.00,    -- 优惠券抵扣
    total_price DECIMAL(10, 2) NOT NULL,            -- 订单总额

    -- 订单备注
    user_note TEXT,                                 -- 用户备注
    admin_note TEXT,                                -- 管理员备注

    -- 订单状态
    status VARCHAR(20) NOT NULL DEFAULT 'pending',  -- 订单状态
    -- 陪诊师订单状态流转: pending_payment -> pending_accept -> pending_service -> in_service -> completed -> cancelled
    -- 机构订单状态流转: pending_service -> in_service -> completed -> cancelled

    -- 关键时间节点
    paid_at TIMESTAMP,                              -- 支付时间
    accepted_at TIMESTAMP,                          -- 接单时间
    service_started_at TIMESTAMP,                   -- 服务开始时间
    service_completed_at TIMESTAMP,                 -- 服务完成时间
    cancelled_at TIMESTAMP,                         -- 取消时间
    cancel_reason TEXT,                             -- 取消原因
    cancelled_by VARCHAR(20),                       -- 取消方: user/companion/admin

    -- 退款信息
    refund_amount DECIMAL(10, 2),                   -- 退款金额
    refund_status VARCHAR(20),                      -- 退款状态: pending/processing/completed/failed
    refund_reason TEXT,                             -- 退款原因
    refunded_at TIMESTAMP,                          -- 退款时间

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_orders_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_orders_patients FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_orders_companions FOREIGN KEY (companion_id) REFERENCES companions(id),
    CONSTRAINT fk_orders_institutions FOREIGN KEY (institution_id) REFERENCES institutions(id),
    CONSTRAINT fk_orders_addresses FOREIGN KEY (pickup_address_id) REFERENCES addresses(id),

    -- 约束：陪诊师订单必须有 companion_id，机构订单必须有 institution_id
    CONSTRAINT chk_orders_service_provider CHECK (
        (order_type = 'companion' AND companion_id IS NOT NULL) OR
        (order_type = 'institution' AND institution_id IS NOT NULL)
    )
);

-- 索引
CREATE UNIQUE INDEX uk_orders_order_no ON orders(order_no) WHERE NOT is_deleted;
CREATE INDEX idx_orders_user_id ON orders(user_id, created_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_orders_companion_id ON orders(companion_id, created_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_orders_institution_id ON orders(institution_id, created_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_orders_status ON orders(status) WHERE NOT is_deleted;
CREATE INDEX idx_orders_appointment_date ON orders(appointment_date) WHERE NOT is_deleted;
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- 注释
COMMENT ON TABLE orders IS '订单表';
COMMENT ON COLUMN orders.order_no IS '订单编号（格式：CL + 时间戳 + 随机数）';
COMMENT ON COLUMN orders.status IS '订单状态：pending_payment/pending_accept/pending_service/in_service/completed/cancelled';
```

#### 3.3.2 payments - 支付记录表

存储订单支付记录。

```sql
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,

    -- 关联订单
    order_id BIGINT NOT NULL,                       -- 订单 ID

    -- 支付信息
    payment_no VARCHAR(32) NOT NULL UNIQUE,         -- 支付流水号
    payment_method VARCHAR(20) NOT NULL,            -- 支付方式: wechat/alipay/balance
    payment_amount DECIMAL(10, 2) NOT NULL,         -- 支付金额

    -- 微信支付信息
    wechat_prepay_id VARCHAR(64),                   -- 微信预支付交易会话标识
    wechat_transaction_id VARCHAR(64),              -- 微信支付订单号

    -- 支付状态
    status VARCHAR(20) NOT NULL DEFAULT 'pending',  -- 状态: pending/processing/success/failed

    -- 回调信息
    callback_data TEXT,                             -- 支付回调数据（JSON）

    -- 时间戳
    paid_at TIMESTAMP,                              -- 支付成功时间
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- 外键
    CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 索引
CREATE UNIQUE INDEX uk_payments_payment_no ON payments(payment_no);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_wechat_transaction_id ON payments(wechat_transaction_id) WHERE wechat_transaction_id IS NOT NULL;
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_created_at ON payments(created_at DESC);

-- 注释
COMMENT ON TABLE payments IS '支付记录表';
COMMENT ON COLUMN payments.wechat_prepay_id IS '微信预支付交易会话标识';
```

---

### 3.4 评价相关表

#### 3.4.1 reviews - 评价表

存储用户对陪诊师/机构的评价。

```sql
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,

    -- 关联信息
    order_id BIGINT NOT NULL UNIQUE,                -- 订单 ID（一个订单只能评价一次）
    user_id BIGINT NOT NULL,                        -- 用户 ID

    -- 评价对象
    review_type VARCHAR(20) NOT NULL,               -- 评价类型: companion/institution
    companion_id BIGINT,                            -- 陪诊师 ID
    institution_id BIGINT,                          -- 机构 ID

    -- 评价内容
    rating INTEGER NOT NULL,                        -- 评分（1-5星）
    tags TEXT,                                      -- 评价标签（JSON 数组：["服务态度好", "专业", "准时"]）
    content TEXT,                                   -- 评价内容
    images TEXT,                                    -- 评价图片（JSON 数组）

    -- 回复
    reply_content TEXT,                             -- 陪诊师/机构回复内容
    replied_at TIMESTAMP,                           -- 回复时间

    -- 状态
    status VARCHAR(20) DEFAULT 'published',         -- 状态: published/hidden/deleted
    hide_reason TEXT,                               -- 隐藏原因

    -- 点赞数（可选）
    likes_count INTEGER DEFAULT 0,                  -- 点赞数

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_reviews_orders FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_reviews_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_reviews_companions FOREIGN KEY (companion_id) REFERENCES companions(id),
    CONSTRAINT fk_reviews_institutions FOREIGN KEY (institution_id) REFERENCES institutions(id),

    -- 约束：评价对象必须是陪诊师或机构之一
    CONSTRAINT chk_reviews_target CHECK (
        (review_type = 'companion' AND companion_id IS NOT NULL) OR
        (review_type = 'institution' AND institution_id IS NOT NULL)
    ),

    -- 约束：评分范围 1-5
    CONSTRAINT chk_reviews_rating CHECK (rating >= 1 AND rating <= 5)
);

-- 索引
CREATE UNIQUE INDEX uk_reviews_order_id ON reviews(order_id) WHERE NOT is_deleted;
CREATE INDEX idx_reviews_companion_id ON reviews(companion_id, created_at DESC) WHERE status = 'published' AND NOT is_deleted;
CREATE INDEX idx_reviews_institution_id ON reviews(institution_id, created_at DESC) WHERE status = 'published' AND NOT is_deleted;
CREATE INDEX idx_reviews_rating ON reviews(rating) WHERE status = 'published' AND NOT is_deleted;
CREATE INDEX idx_reviews_created_at ON reviews(created_at DESC);

-- 注释
COMMENT ON TABLE reviews IS '评价表';
COMMENT ON COLUMN reviews.tags IS '评价标签（JSON数组）';
COMMENT ON COLUMN reviews.rating IS '评分（1-5星）';
```

---

### 3.5 消息相关表

#### 3.5.1 conversations - 会话表

存储用户与陪诊师/机构/客服的会话。

```sql
CREATE TABLE conversations (
    id BIGSERIAL PRIMARY KEY,

    -- 会话参与方
    user_id BIGINT NOT NULL,                        -- 用户 ID

    -- 对话对象
    conversation_type VARCHAR(20) NOT NULL,         -- 会话类型: companion/institution/customer_service
    companion_id BIGINT,                            -- 陪诊师 ID
    institution_id BIGINT,                          -- 机构 ID
    admin_id BIGINT,                                -- 客服 ID

    -- 关联订单（可选）
    order_id BIGINT,                                -- 关联订单 ID

    -- 最后消息
    last_message_id BIGINT,                         -- 最后一条消息 ID
    last_message_content TEXT,                      -- 最后一条消息内容（冗余）
    last_message_at TIMESTAMP,                      -- 最后消息时间

    -- 未读数
    user_unread_count INTEGER DEFAULT 0,            -- 用户未读数
    target_unread_count INTEGER DEFAULT 0,          -- 对方未读数

    -- 状态
    is_active BOOLEAN DEFAULT TRUE,                 -- 是否活跃

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_conversations_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_conversations_companions FOREIGN KEY (companion_id) REFERENCES companions(id),
    CONSTRAINT fk_conversations_institutions FOREIGN KEY (institution_id) REFERENCES institutions(id),
    CONSTRAINT fk_conversations_orders FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 索引
CREATE INDEX idx_conversations_user_id ON conversations(user_id, last_message_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_conversations_companion_id ON conversations(companion_id, last_message_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_conversations_institution_id ON conversations(institution_id, last_message_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_conversations_order_id ON conversations(order_id) WHERE NOT is_deleted;

-- 注释
COMMENT ON TABLE conversations IS '会话表';
COMMENT ON COLUMN conversations.conversation_type IS '会话类型：companion/institution/customer_service';
```

#### 3.5.2 messages - 消息表

存储会话中的具体消息。

```sql
CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,

    -- 关联会话
    conversation_id BIGINT NOT NULL,                -- 会话 ID

    -- 发送方
    sender_type VARCHAR(20) NOT NULL,               -- 发送方类型: user/companion/institution/admin
    sender_id BIGINT NOT NULL,                      -- 发送方 ID

    -- 消息内容
    message_type VARCHAR(20) NOT NULL,              -- 消息类型: text/image/location/voice/system
    content TEXT NOT NULL,                          -- 消息内容
    extra_data TEXT,                                -- 额外数据（JSON：如图片 URL、位置坐标等）

    -- 状态
    is_read BOOLEAN DEFAULT FALSE,                  -- 是否已读
    read_at TIMESTAMP,                              -- 阅读时间

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,

    -- 外键
    CONSTRAINT fk_messages_conversations FOREIGN KEY (conversation_id) REFERENCES conversations(id)
);

-- 索引
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id, created_at DESC) WHERE NOT is_deleted;
CREATE INDEX idx_messages_is_read ON messages(conversation_id, is_read) WHERE NOT is_read AND NOT is_deleted;
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

-- 注释
COMMENT ON TABLE messages IS '消息表';
COMMENT ON COLUMN messages.message_type IS '消息类型：text/image/location/voice/system';
COMMENT ON COLUMN messages.extra_data IS '额外数据（JSON格式）';
```

---

### 3.6 AI 相关表

#### 3.6.1 ai_chat_history - AI 对话历史表

存储用户与 AI Agent 的对话历史。

```sql
CREATE TABLE ai_chat_history (
    id BIGSERIAL PRIMARY KEY,

    -- 关联用户
    user_id BIGINT NOT NULL,                        -- 用户 ID

    -- 会话 ID（用于区分不同的对话会话）
    session_id VARCHAR(64) NOT NULL,                -- 会话 ID（UUID）

    -- 消息角色
    role VARCHAR(20) NOT NULL,                      -- 角色: user/assistant/system

    -- 消息内容
    content TEXT NOT NULL,                          -- 消息内容

    -- AI 模型信息
    model VARCHAR(50),                              -- 使用的模型（如 gpt-4, claude-3）

    -- 提取的结构化信息（如果是 AI 回复）
    extracted_data TEXT,                            -- 提取的结构化数据（JSON）
    -- 示例：{"intent": "book_appointment", "slots": {"time": "明天上午", "hospital": "协和医院"}}

    -- Token 消耗（可选，用于统计成本）
    prompt_tokens INTEGER,                          -- 输入 Token 数
    completion_tokens INTEGER,                      -- 输出 Token 数
    total_tokens INTEGER,                           -- 总 Token 数

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- 外键
    CONSTRAINT fk_ai_chat_history_users FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 索引
CREATE INDEX idx_ai_chat_history_user_id ON ai_chat_history(user_id, created_at DESC);
CREATE INDEX idx_ai_chat_history_session_id ON ai_chat_history(session_id, created_at ASC);
CREATE INDEX idx_ai_chat_history_created_at ON ai_chat_history(created_at DESC);

-- 注释
COMMENT ON TABLE ai_chat_history IS 'AI对话历史表';
COMMENT ON COLUMN ai_chat_history.session_id IS '会话ID（用于区分不同对话会话）';
COMMENT ON COLUMN ai_chat_history.extracted_data IS '提取的结构化数据（JSON格式）';
```

---

### 3.7 优惠券相关表

#### 3.7.1 coupons - 优惠券表

存储优惠券模板。

```sql
CREATE TABLE coupons (
    id BIGSERIAL PRIMARY KEY,

    -- 优惠券信息
    name VARCHAR(100) NOT NULL,                     -- 优惠券名称
    description TEXT,                               -- 优惠券描述
    coupon_type VARCHAR(20) NOT NULL,               -- 类型: discount/full_reduction

    -- 优惠金额
    discount_amount DECIMAL(10, 2),                 -- 优惠金额（直接抵扣）
    discount_rate DECIMAL(5, 2),                    -- 折扣率（如 0.9 表示 9折）

    -- 使用条件
    min_amount DECIMAL(10, 2),                      -- 最低消费金额
    max_discount DECIMAL(10, 2),                    -- 最高优惠金额（针对折扣券）

    -- 适用范围
    applicable_scope VARCHAR(20) DEFAULT 'all',     -- 适用范围: all/companion/institution

    -- 发放数量
    total_count INTEGER,                            -- 总发放数量（NULL 表示不限）
    received_count INTEGER DEFAULT 0,               -- 已领取数量

    -- 有效期
    start_date TIMESTAMP NOT NULL,                  -- 开始日期
    end_date TIMESTAMP NOT NULL,                    -- 结束日期
    valid_days INTEGER,                             -- 领取后有效天数（NULL 表示使用 end_date）

    -- 状态
    status VARCHAR(20) DEFAULT 'active',            -- 状态: active/inactive/expired

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 索引
CREATE INDEX idx_coupons_status ON coupons(status) WHERE NOT is_deleted;
CREATE INDEX idx_coupons_date_range ON coupons(start_date, end_date) WHERE status = 'active' AND NOT is_deleted;

-- 注释
COMMENT ON TABLE coupons IS '优惠券模板表';
COMMENT ON COLUMN coupons.coupon_type IS '优惠券类型：discount（直接抵扣）/full_reduction（满减）';
```

#### 3.7.2 user_coupons - 用户优惠券表

存储用户领取的优惠券。

```sql
CREATE TABLE user_coupons (
    id BIGSERIAL PRIMARY KEY,

    -- 关联信息
    user_id BIGINT NOT NULL,                        -- 用户 ID
    coupon_id BIGINT NOT NULL,                      -- 优惠券模板 ID

    -- 优惠券信息（冗余存储，防止模板修改）
    name VARCHAR(100) NOT NULL,
    discount_amount DECIMAL(10, 2),
    discount_rate DECIMAL(5, 2),
    min_amount DECIMAL(10, 2),

    -- 有效期
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,

    -- 使用状态
    status VARCHAR(20) DEFAULT 'unused',            -- 状态: unused/used/expired
    used_order_id BIGINT,                           -- 使用的订单 ID
    used_at TIMESTAMP,                              -- 使用时间

    -- 时间戳
    received_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- 外键
    CONSTRAINT fk_user_coupons_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_user_coupons_coupons FOREIGN KEY (coupon_id) REFERENCES coupons(id),
    CONSTRAINT fk_user_coupons_orders FOREIGN KEY (used_order_id) REFERENCES orders(id)
);

-- 索引
CREATE INDEX idx_user_coupons_user_id ON user_coupons(user_id, status);
CREATE INDEX idx_user_coupons_status ON user_coupons(status, end_date);
CREATE INDEX idx_user_coupons_used_order_id ON user_coupons(used_order_id) WHERE used_order_id IS NOT NULL;

-- 注释
COMMENT ON TABLE user_coupons IS '用户优惠券表';
COMMENT ON COLUMN user_coupons.status IS '状态：unused/used/expired';
```

---

### 3.8 管理后台相关表

#### 3.8.1 admin_users - 管理员表

存储平台管理员账号。

```sql
CREATE TABLE admin_users (
    id BIGSERIAL PRIMARY KEY,

    -- 账号信息
    username VARCHAR(50) NOT NULL UNIQUE,           -- 用户名
    password_hash VARCHAR(255) NOT NULL,            -- 密码哈希

    -- 个人信息
    name VARCHAR(50) NOT NULL,                      -- 姓名
    email VARCHAR(100),                             -- 邮箱
    phone VARCHAR(20),                              -- 手机号
    avatar_url VARCHAR(255),                        -- 头像

    -- 角色
    role VARCHAR(20) NOT NULL,                      -- 角色: admin/customer_service/finance

    -- 状态
    status VARCHAR(20) DEFAULT 'active',            -- 状态: active/disabled

    -- 时间戳
    last_login_at TIMESTAMP,                        -- 最后登录时间
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 索引
CREATE UNIQUE INDEX uk_admin_users_username ON admin_users(username) WHERE NOT is_deleted;
CREATE INDEX idx_admin_users_role ON admin_users(role) WHERE NOT is_deleted;

-- 注释
COMMENT ON TABLE admin_users IS '管理员表';
COMMENT ON COLUMN admin_users.role IS '角色：admin（超级管理员）/customer_service（客服）/finance（财务）';
```

#### 3.8.2 admin_logs - 管理员操作日志表

记录管理员的关键操作。

```sql
CREATE TABLE admin_logs (
    id BIGSERIAL PRIMARY KEY,

    -- 操作人
    admin_id BIGINT NOT NULL,                       -- 管理员 ID
    admin_name VARCHAR(50) NOT NULL,                -- 管理员姓名（冗余）

    -- 操作信息
    module VARCHAR(50) NOT NULL,                    -- 操作模块: user/order/companion/institution/system
    action VARCHAR(50) NOT NULL,                    -- 操作动作: create/update/delete/approve/reject
    description TEXT,                               -- 操作描述

    -- 操作对象
    target_type VARCHAR(50),                        -- 对象类型
    target_id BIGINT,                               -- 对象 ID

    -- 操作数据
    old_data TEXT,                                  -- 修改前数据（JSON）
    new_data TEXT,                                  -- 修改后数据（JSON）

    -- 请求信息
    ip_address VARCHAR(50),                         -- IP 地址
    user_agent TEXT,                                -- User Agent

    -- 时间戳
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 索引
CREATE INDEX idx_admin_logs_admin_id ON admin_logs(admin_id, created_at DESC);
CREATE INDEX idx_admin_logs_module ON admin_logs(module, created_at DESC);
CREATE INDEX idx_admin_logs_created_at ON admin_logs(created_at DESC);

-- 注释
COMMENT ON TABLE admin_logs IS '管理员操作日志表';
COMMENT ON COLUMN admin_logs.module IS '操作模块：user/order/companion/institution/system';
```

---

## 四、数据初始化

### 4.1 基础数据 SQL

```sql
-- 插入测试管理员账号（密码: admin123，需使用 bcrypt 哈希）
INSERT INTO admin_users (username, password_hash, name, role) VALUES
('admin', '$2b$12$...', '超级管理员', 'admin'),
('service', '$2b$12$...', '客服人员', 'customer_service'),
('finance', '$2b$12$...', '财务人员', 'finance');

-- 插入初始优惠券模板
INSERT INTO coupons (name, description, coupon_type, discount_amount, min_amount, start_date, end_date, total_count, status) VALUES
('新用户专享券', '新用户首单立减20元', 'discount', 20.00, 100.00, NOW(), NOW() + INTERVAL '90 days', 1000, 'active'),
('满200减30', '订单满200元减30元', 'full_reduction', 30.00, 200.00, NOW(), NOW() + INTERVAL '30 days', 500, 'active');
```

---

## 五、数据库维护

### 5.1 定期维护任务

#### 清理过期数据
```sql
-- 清理过期的 AI 对话历史（保留最近 90 天）
DELETE FROM ai_chat_history
WHERE created_at < NOW() - INTERVAL '90 days';

-- 清理过期的优惠券
UPDATE user_coupons
SET status = 'expired'
WHERE status = 'unused' AND end_date < NOW();
```

#### 更新统计数据
```sql
-- 更新陪诊师统计信息
UPDATE companions c
SET
    total_orders = (SELECT COUNT(*) FROM orders WHERE companion_id = c.id AND NOT is_deleted),
    completed_orders = (SELECT COUNT(*) FROM orders WHERE companion_id = c.id AND status = 'completed' AND NOT is_deleted),
    cancelled_orders = (SELECT COUNT(*) FROM orders WHERE companion_id = c.id AND status = 'cancelled' AND NOT is_deleted),
    rating = (SELECT COALESCE(AVG(rating), 5.00) FROM reviews WHERE companion_id = c.id AND status = 'published' AND NOT is_deleted),
    review_count = (SELECT COUNT(*) FROM reviews WHERE companion_id = c.id AND status = 'published' AND NOT is_deleted);

-- 更新陪诊机构统计信息
UPDATE institutions i
SET
    total_orders = (SELECT COUNT(*) FROM orders WHERE institution_id = i.id AND NOT is_deleted),
    completed_orders = (SELECT COUNT(*) FROM orders WHERE institution_id = i.id AND status = 'completed' AND NOT is_deleted),
    rating = (SELECT COALESCE(AVG(rating), 5.00) FROM reviews WHERE institution_id = i.id AND status = 'published' AND NOT is_deleted),
    review_count = (SELECT COUNT(*) FROM reviews WHERE institution_id = i.id AND status = 'published' AND NOT is_deleted),
    companion_count = (SELECT COUNT(*) FROM companions WHERE institution_id = i.id AND status = 'approved' AND NOT is_deleted);
```

### 5.2 备份策略

- **全量备份**：每天凌晨 2:00 进行全量备份
- **增量备份**：每 6 小时进行一次 WAL 归档
- **备份保留**：保留最近 30 天的备份文件

```bash
# PostgreSQL 备份命令示例
pg_dump -U postgres -d carelink -F c -b -v -f "/backup/carelink_$(date +%Y%m%d).backup"
```

### 5.3 性能监控

定期检查慢查询：

```sql
-- 查看慢查询（假设已启用 pg_stat_statements 扩展）
SELECT query, calls, total_time, mean_time, max_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 20;
```

### 5.4 索引优化

定期分析表统计信息：

```sql
-- 分析所有表
ANALYZE;

-- 重建索引（如发现索引膨胀）
REINDEX DATABASE carelink;
```

---

## 六、数据安全

### 6.1 敏感字段加密

以下字段需要在应用层加密后存储：

- `users.phone` - 手机号
- `patients.id_card` - 身份证号
- `companions.id_card` - 陪诊师身份证号
- `companions.bank_account` - 银行账号
- `institutions.legal_person_id_card` - 法人身份证号
- `institutions.account_number` - 机构账号

**推荐加密方案**：
- 使用 AES-256 对称加密
- 密钥存储在环境变量或密钥管理服务（如 AWS KMS）

### 6.2 数据脱敏

在管理后台展示敏感信息时需脱敏：

```sql
-- 脱敏查询示例（手机号）
SELECT
    id,
    CONCAT(LEFT(phone, 3), '****', RIGHT(phone, 4)) AS phone_masked,
    nickname
FROM users;

-- 脱敏查询示例（身份证号）
SELECT
    id,
    CONCAT(LEFT(id_card, 6), '********', RIGHT(id_card, 4)) AS id_card_masked
FROM patients;
```

---

## 七、附录

### 7.1 数据字典汇总表

| 表名 | 中文名 | 记录数预估（首年） |
|------|-------|------------------|
| users | 用户表 | 10,000 |
| patients | 就诊人表 | 15,000 |
| addresses | 地址表 | 20,000 |
| companions | 陪诊师表 | 500 |
| institutions | 陪诊机构表 | 50 |
| services | 服务产品表 | 1,000 |
| service_specs | 服务规格表 | 3,000 |
| orders | 订单表 | 50,000 |
| payments | 支付记录表 | 45,000 |
| reviews | 评价表 | 30,000 |
| conversations | 会话表 | 20,000 |
| messages | 消息表 | 200,000 |
| ai_chat_history | AI对话历史表 | 100,000 |
| coupons | 优惠券模板表 | 100 |
| user_coupons | 用户优惠券表 | 50,000 |
| admin_users | 管理员表 | 20 |
| admin_logs | 管理员日志表 | 10,000 |

### 7.2 常用查询示例

#### 查询用户的所有订单
```sql
SELECT
    o.*,
    c.name AS companion_name,
    i.name AS institution_name,
    p.name AS patient_name
FROM orders o
LEFT JOIN companions c ON o.companion_id = c.id
LEFT JOIN institutions i ON o.institution_id = i.id
JOIN patients p ON o.patient_id = p.id
WHERE o.user_id = :user_id
  AND NOT o.is_deleted
ORDER BY o.created_at DESC;
```

#### 查询陪诊师的评价列表
```sql
SELECT
    r.*,
    u.nickname AS user_nickname,
    u.avatar_url AS user_avatar
FROM reviews r
JOIN users u ON r.user_id = u.id
WHERE r.companion_id = :companion_id
  AND r.status = 'published'
  AND NOT r.is_deleted
ORDER BY r.created_at DESC;
```

#### 查询可用的优惠券
```sql
SELECT c.*
FROM coupons c
WHERE c.status = 'active'
  AND c.start_date <= NOW()
  AND c.end_date >= NOW()
  AND (c.total_count IS NULL OR c.received_count < c.total_count)
  AND NOT c.is_deleted;
```

---

**文档结束**
