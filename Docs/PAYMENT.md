# CareLink 微信支付集成文档

## 文档信息

| 项目 | 内容 |
|------|------|
| 文档版本 | v1.0 |
| 创建日期 | 2025-11-12 |
| 支付方式 | 微信支付 JSAPI |
| API版本 | V3 |

---

## 一、概述

### 1.1 支付场景

CareLink 平台使用微信支付 JSAPI 支付（小程序支付）完成订单支付。

**支付流程**：
```
用户确认订单 → 后端创建支付订单 → 调起微信支付 → 用户输入密码
→ 支付成功 → 微信回调通知后端 → 更新订单状态 → 通知陪诊师
```

### 1.2 微信支付 V3 API

- **官方文档**：https://pay.weixin.qq.com/wiki/doc/apiv3/index.shtml
- **SDK**：使用官方 Python SDK `wechatpayv3`

---

## 二、准备工作

### 2.1 商户资质

需要在微信商户平台完成以下配置：

1. **注册微信支付商户**
   - 访问：https://pay.weixin.qq.com/
   - 提交营业执照等资料
   - 等待审核通过

2. **获取关键信息**
   | 参数 | 说明 | 示例 |
   |------|------|------|
   | mchid | 商户号 | 1234567890 |
   | appid | 小程序 AppID | wx426040a3db6be21b |
   | serial_no | 证书序列号 | 5E3D... |
   | api_v3_key | API v3 密钥（32位） | 在商户平台设置 |

3. **下载API证书**
   - 商户平台下载 API 证书
   - 包含：`apiclient_cert.pem`、`apiclient_key.pem`

4. **配置支付授权目录**
   - 在小程序管理后台设置支付授权目录
   - 示例：`https://carelink.com/`

5. **配置回调域名**
   - 在商户平台设置支付回调通知 URL
   - 示例：`https://api.carelink.com/v1/webhooks/wechat-pay`

### 2.2 安装 SDK

```bash
pip install wechatpayv3
```

---

## 三、技术实现

### 3.1 初始化支付客户端

```python
# Backend/app/services/payment/wechat_pay.py

from wechatpayv3 import WeChatPay, WeChatPayType
from app.config import Config

class WeChatPayService:
    """微信支付服务"""

    def __init__(self):
        self.wxpay = WeChatPay(
            wechatpay_type=WeChatPayType.MINIPROG,  # 小程序支付
            mchid=Config.WECHAT_PAY_MCHID,  # 商户号
            private_key=self._load_private_key(),  # 商户私钥
            cert_serial_no=Config.WECHAT_PAY_SERIAL_NO,  # 证书序列号
            apiv3_key=Config.WECHAT_PAY_API_V3_KEY,  # API v3密钥
            appid=Config.WECHAT_APPID,  # 小程序AppID
            notify_url=Config.WECHAT_PAY_NOTIFY_URL  # 回调地址
        )

    def _load_private_key(self) -> str:
        """加载商户私钥"""
        with open(Config.WECHAT_PAY_PRIVATE_KEY_PATH, 'r') as f:
            return f.read()
```

### 3.2 创建支付订单

```python
from decimal import Decimal
from datetime import datetime, timedelta
import uuid

def create_payment(self, order_id: int, user_openid: str) -> dict:
    """
    创建支付订单

    Args:
        order_id: 订单 ID
        user_openid: 用户微信 OpenID

    Returns:
        dict: 包含预支付信息的字典
    """
    from app.models import Order, Payment

    # 查询订单
    order = Order.query.get(order_id)
    if not order:
        raise ValueError("订单不存在")

    if order.status != 'pending_payment':
        raise ValueError("订单状态不允许支付")

    # 创建支付记录
    payment_no = self._generate_payment_no()
    payment = Payment(
        order_id=order.id,
        payment_no=payment_no,
        payment_method='wechat',
        payment_amount=order.total_price,
        status='pending'
    )
    db.session.add(payment)
    db.session.commit()

    # 调用微信统一下单 API
    try:
        # 金额单位：分
        total_amount = int(order.total_price * 100)

        # 订单描述
        description = f"陪诊服务 - 订单号{order.order_no}"

        # 订单过期时间（30分钟）
        time_expire = (datetime.now() + timedelta(minutes=30)).isoformat()

        # 调用统一下单接口
        code, message = self.wxpay.pay(
            description=description,
            out_trade_no=payment_no,  # 商户订单号
            amount={'total': total_amount, 'currency': 'CNY'},
            payer={'openid': user_openid},
            time_expire=time_expire
        )

        if code == 200:
            result = message
            # 保存预支付信息
            payment.wechat_prepay_id = result.get('prepay_id')
            payment.status = 'processing'
            db.session.commit()

            # 生成小程序支付参数
            payment_params = self._generate_jsapi_params(result['prepay_id'])

            return {
                'payment_no': payment_no,
                'payment_params': payment_params
            }
        else:
            # 支付创建失败
            payment.status = 'failed'
            db.session.commit()
            raise Exception(f"微信支付创建失败: {message}")

    except Exception as e:
        logger.error(f"创建支付订单失败: {e}")
        raise

def _generate_payment_no(self) -> str:
    """生成支付流水号"""
    timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
    random_str = str(uuid.uuid4().hex[:6]).upper()
    return f"PAY{timestamp}{random_str}"

def _generate_jsapi_params(self, prepay_id: str) -> dict:
    """
    生成小程序调起支付所需的参数

    Args:
        prepay_id: 预支付交易会话标识

    Returns:
        dict: 小程序支付参数
    """
    from wechatpayv3 import SignType

    # 使用 SDK 生成签名
    timestamp = str(int(time.time()))
    noncestr = str(uuid.uuid4().hex)

    sign = self.wxpay.sign([
        Config.WECHAT_APPID,
        timestamp,
        noncestr,
        f"prepay_id={prepay_id}"
    ])

    return {
        "timeStamp": timestamp,
        "nonceStr": noncestr,
        "package": f"prepay_id={prepay_id}",
        "signType": "RSA",
        "paySign": sign
    }
```

### 3.3 支付回调处理

```python
from flask import request, jsonify
import json

@app.route('/api/v1/webhooks/wechat-pay', methods=['POST'])
def wechat_pay_callback():
    """
    微信支付回调处理

    微信支付成功后会异步通知此接口
    """
    try:
        # 获取回调数据
        headers = request.headers
        body = request.data.decode('utf-8')

        # 验证签名
        wechat_pay_service = WeChatPayService()
        if not wechat_pay_service.verify_signature(headers, body):
            logger.error("微信支付回调签名验证失败")
            return jsonify({'code': 'FAIL', 'message': '签名验证失败'}), 400

        # 解密回调数据
        result = wechat_pay_service.decrypt_callback(body)

        # 处理支付结果
        wechat_pay_service.handle_payment_notification(result)

        # 返回成功响应给微信
        return jsonify({'code': 'SUCCESS', 'message': '成功'}), 200

    except Exception as e:
        logger.error(f"处理微信支付回调失败: {e}")
        return jsonify({'code': 'FAIL', 'message': str(e)}), 500

def verify_signature(self, headers: dict, body: str) -> bool:
    """
    验证微信支付回调签名

    Args:
        headers: 请求头
        body: 请求体

    Returns:
        bool: 签名是否有效
    """
    timestamp = headers.get('Wechatpay-Timestamp')
    nonce = headers.get('Wechatpay-Nonce')
    signature = headers.get('Wechatpay-Signature')
    serial_no = headers.get('Wechatpay-Serial')

    # 构建验签字符串
    sign_str = f"{timestamp}\n{nonce}\n{body}\n"

    try:
        # 使用 SDK 验证签名
        return self.wxpay.verify_sign({
            'timestamp': timestamp,
            'nonce': nonce,
            'signature': signature,
            'serial_no': serial_no,
            'body': body
        })
    except Exception as e:
        logger.error(f"签名验证异常: {e}")
        return False

def decrypt_callback(self, body: str) -> dict:
    """
    解密微信支付回调数据

    Args:
        body: 加密的回调数据

    Returns:
        dict: 解密后的支付结果
    """
    data = json.loads(body)

    # 提取加密数据
    resource = data['resource']
    ciphertext = resource['ciphertext']
    nonce = resource['nonce']
    associated_data = resource['associated_data']

    # 使用 API v3 密钥解密
    from wechatpayv3.utils import aes_decrypt

    plaintext = aes_decrypt(
        nonce=nonce,
        ciphertext=ciphertext,
        associated_data=associated_data,
        apiv3_key=Config.WECHAT_PAY_API_V3_KEY
    )

    return json.loads(plaintext)

def handle_payment_notification(self, result: dict):
    """
    处理支付通知

    Args:
        result: 解密后的支付结果
    """
    from app.models import Payment, Order

    # 提取关键信息
    out_trade_no = result['out_trade_no']  # 商户订单号（支付流水号）
    transaction_id = result['transaction_id']  # 微信支付订单号
    trade_state = result['trade_state']  # 交易状态

    # 查询支付记录
    payment = Payment.query.filter_by(payment_no=out_trade_no).first()
    if not payment:
        logger.error(f"支付记录不存在: {out_trade_no}")
        return

    # 防止重复处理
    if payment.status == 'success':
        logger.info(f"支付已处理，跳过: {out_trade_no}")
        return

    # 更新支付记录
    payment.wechat_transaction_id = transaction_id
    payment.callback_data = json.dumps(result)

    if trade_state == 'SUCCESS':
        # 支付成功
        payment.status = 'success'
        payment.paid_at = datetime.now()

        # 更新订单状态
        order = payment.order
        order.status = 'pending_accept' if order.order_type == 'companion' else 'pending_service'
        order.paid_at = datetime.now()

        db.session.commit()

        # 发送通知
        self._notify_payment_success(order)

        logger.info(f"支付成功处理完成: {out_trade_no}")

    elif trade_state in ['CLOSED', 'REVOKED', 'PAYERROR']:
        # 支付失败
        payment.status = 'failed'
        db.session.commit()

        logger.warning(f"支付失败: {out_trade_no}, 状态: {trade_state}")

def _notify_payment_success(self, order):
    """支付成功后的通知"""
    # 1. 给用户发送小程序订阅消息
    # 2. 给陪诊师发送接单通知
    # 3. 记录操作日志
    pass
```

---

## 四、退款处理

### 4.1 申请退款

```python
def create_refund(self, order_id: int, refund_amount: Decimal, reason: str) -> dict:
    """
    创建退款

    Args:
        order_id: 订单 ID
        refund_amount: 退款金额
        reason: 退款原因

    Returns:
        dict: 退款结果
    """
    from app.models import Order, Payment

    # 查询订单和支付记录
    order = Order.query.get(order_id)
    payment = Payment.query.filter_by(
        order_id=order_id,
        status='success'
    ).first()

    if not payment:
        raise ValueError("未找到成功的支付记录")

    # 生成退款单号
    refund_no = self._generate_refund_no()

    # 调用微信退款 API
    try:
        total_amount = int(payment.payment_amount * 100)  # 原订单金额（分）
        refund = int(refund_amount * 100)  # 退款金额（分）

        code, message = self.wxpay.refund(
            out_trade_no=payment.payment_no,  # 商户订单号
            out_refund_no=refund_no,  # 商户退款单号
            amount={
                'refund': refund,
                'total': total_amount,
                'currency': 'CNY'
            },
            reason=reason
        )

        if code == 200:
            # 退款申请成功
            order.refund_amount = refund_amount
            order.refund_status = 'processing'
            order.refund_reason = reason
            order.status = 'cancelled'
            db.session.commit()

            return {
                'refund_no': refund_no,
                'status': 'processing'
            }
        else:
            raise Exception(f"退款申请失败: {message}")

    except Exception as e:
        logger.error(f"创建退款失败: {e}")
        raise

def _generate_refund_no(self) -> str:
    """生成退款单号"""
    timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
    random_str = str(uuid.uuid4().hex[:6]).upper()
    return f"REF{timestamp}{random_str}"
```

### 4.2 退款回调处理

```python
@app.route('/api/v1/webhooks/wechat-refund', methods=['POST'])
def wechat_refund_callback():
    """微信退款回调处理"""
    try:
        headers = request.headers
        body = request.data.decode('utf-8')

        # 验证签名
        wechat_pay_service = WeChatPayService()
        if not wechat_pay_service.verify_signature(headers, body):
            return jsonify({'code': 'FAIL', 'message': '签名验证失败'}), 400

        # 解密回调数据
        result = wechat_pay_service.decrypt_callback(body)

        # 处理退款结果
        wechat_pay_service.handle_refund_notification(result)

        return jsonify({'code': 'SUCCESS', 'message': '成功'}), 200

    except Exception as e:
        logger.error(f"处理微信退款回调失败: {e}")
        return jsonify({'code': 'FAIL', 'message': str(e)}), 500

def handle_refund_notification(self, result: dict):
    """处理退款通知"""
    from app.models import Order

    out_refund_no = result['out_refund_no']  # 商户退款单号
    refund_status = result['refund_status']  # 退款状态

    # 查询订单
    order = Order.query.filter_by(refund_no=out_refund_no).first()
    if not order:
        logger.error(f"订单不存在: {out_refund_no}")
        return

    if refund_status == 'SUCCESS':
        # 退款成功
        order.refund_status = 'completed'
        order.refunded_at = datetime.now()
        db.session.commit()

        logger.info(f"退款成功: {out_refund_no}")

    elif refund_status in ['ABNORMAL', 'CLOSED']:
        # 退款失败
        order.refund_status = 'failed'
        db.session.commit()

        logger.warning(f"退款失败: {out_refund_no}, 状态: {refund_status}")
```

---

## 五、查询接口

### 5.1 查询支付结果

```python
def query_payment(self, payment_no: str) -> dict:
    """
    查询支付结果

    Args:
        payment_no: 支付流水号

    Returns:
        dict: 支付结果
    """
    try:
        code, message = self.wxpay.query_order(out_trade_no=payment_no)

        if code == 200:
            result = message
            trade_state = result['trade_state']

            return {
                'payment_no': payment_no,
                'transaction_id': result.get('transaction_id'),
                'trade_state': trade_state,
                'trade_state_desc': result.get('trade_state_desc'),
                'success_time': result.get('success_time')
            }
        else:
            raise Exception(f"查询支付失败: {message}")

    except Exception as e:
        logger.error(f"查询支付失败: {e}")
        raise
```

### 5.2 关闭订单

```python
def close_order(self, payment_no: str) -> bool:
    """
    关闭未支付的订单

    Args:
        payment_no: 支付流水号

    Returns:
        bool: 是否成功
    """
    try:
        code, message = self.wxpay.close_order(out_trade_no=payment_no)

        if code == 204:
            logger.info(f"订单关闭成功: {payment_no}")
            return True
        else:
            logger.error(f"订单关闭失败: {message}")
            return False

    except Exception as e:
        logger.error(f"关闭订单失败: {e}")
        return False
```

---

## 六、配置示例

### 6.1 环境变量配置

```bash
# .env

# 微信小程序
WECHAT_APPID=wx426040a3db6be21b
WECHAT_APP_SECRET=your_app_secret

# 微信支付
WECHAT_PAY_MCHID=1234567890
WECHAT_PAY_SERIAL_NO=5E3D...
WECHAT_PAY_API_V3_KEY=your_32_char_api_v3_key_here_
WECHAT_PAY_PRIVATE_KEY_PATH=/path/to/apiclient_key.pem
WECHAT_PAY_CERT_PATH=/path/to/apiclient_cert.pem
WECHAT_PAY_NOTIFY_URL=https://api.carelink.com/v1/webhooks/wechat-pay
```

### 6.2 Flask 配置

```python
# Backend/app/config.py

import os

class Config:
    # 微信小程序
    WECHAT_APPID = os.getenv('WECHAT_APPID')
    WECHAT_APP_SECRET = os.getenv('WECHAT_APP_SECRET')

    # 微信支付
    WECHAT_PAY_MCHID = os.getenv('WECHAT_PAY_MCHID')
    WECHAT_PAY_SERIAL_NO = os.getenv('WECHAT_PAY_SERIAL_NO')
    WECHAT_PAY_API_V3_KEY = os.getenv('WECHAT_PAY_API_V3_KEY')
    WECHAT_PAY_PRIVATE_KEY_PATH = os.getenv('WECHAT_PAY_PRIVATE_KEY_PATH')
    WECHAT_PAY_CERT_PATH = os.getenv('WECHAT_PAY_CERT_PATH')
    WECHAT_PAY_NOTIFY_URL = os.getenv('WECHAT_PAY_NOTIFY_URL')
```

---

## 七、安全建议

### 7.1 证书管理

- API 证书文件存放在安全目录，设置 600 权限
- 不要将证书提交到代码仓库
- 定期更新证书（微信支付证书有效期 5 年）

### 7.2 密钥管理

- API v3 密钥长度必须为 32 位
- 使用环境变量或密钥管理服务（如 AWS Secrets Manager）
- 定期轮换密钥

### 7.3 回调验证

- 务必验证回调签名
- 防止重复通知导致的重复处理
- 记录所有回调数据以备查

### 7.4 金额处理

- 后端计算订单金额，不信任前端传入的金额
- 金额使用 `Decimal` 类型避免精度问题
- 支付时金额单位转换为"分"

---

## 八、测试

### 8.1 沙箱环境

微信支付提供沙箱环境用于测试：

```python
# 切换到沙箱环境
wxpay = WeChatPay(
    wechatpay_type=WeChatPayType.MINIPROG,
    mchid='1900000109',  # 沙箱商户号
    # ... 其他配置
    sandbox=True  # 开启沙箱模式
)
```

### 8.2 测试用例

```python
import pytest
from app.services.payment.wechat_pay import WeChatPayService

def test_create_payment():
    """测试创建支付"""
    service = WeChatPayService()

    order_id = 1
    user_openid = 'oABC123...'

    result = service.create_payment(order_id, user_openid)

    assert 'payment_no' in result
    assert 'payment_params' in result
    assert 'timeStamp' in result['payment_params']

def test_refund():
    """测试退款"""
    service = WeChatPayService()

    order_id = 1
    refund_amount = Decimal('100.00')
    reason = "用户取消订单"

    result = service.create_refund(order_id, refund_amount, reason)

    assert result['status'] == 'processing'
```

---

## 九、常见问题

### 9.1 签名验证失败

**原因**：
- 证书序列号不正确
- 时间戳偏差过大
- 请求体被修改

**解决**：
- 检查证书序列号是否正确
- 确保服务器时间同步
- 确保请求体未被修改（注意字符编码）

### 9.2 回调通知未收到

**原因**：
- 回调 URL 配置错误
- 服务器防火墙拦截
- 回调处理超时（微信要求 5 秒内响应）

**解决**：
- 检查回调 URL 是否可访问（使用 HTTPS）
- 确保服务器允许微信 IP 访问
- 优化回调处理逻辑，快速返回响应

### 9.3 退款失败

**原因**：
- 余额不足
- 订单未支付成功
- 退款金额超过订单金额

**解决**：
- 确保商户账户余额充足
- 检查订单支付状态
- 验证退款金额计算逻辑

---

## 十、监控与日志

### 10.1 支付成功率监控

```python
from prometheus_client import Counter

payment_success_count = Counter(
    'carelink_payment_success_total',
    'Total successful payments'
)

payment_failed_count = Counter(
    'carelink_payment_failed_total',
    'Total failed payments',
    ['reason']
)
```

### 10.2 日志记录

```python
import logging

logger = logging.getLogger('wechat_pay')

# 记录关键操作
logger.info(f"创建支付订单: order_id={order_id}, amount={amount}")
logger.info(f"支付成功: payment_no={payment_no}, transaction_id={transaction_id}")
logger.warning(f"支付失败: payment_no={payment_no}, reason={reason}")

# 记录所有回调数据
logger.info(f"微信支付回调: {json.dumps(result)}")
```

---

## 十一、附录

### 11.1 微信支付状态码

| 状态码 | 说明 |
|--------|------|
| SUCCESS | 支付成功 |
| REFUND | 转入退款 |
| NOTPAY | 未支付 |
| CLOSED | 已关闭 |
| REVOKED | 已撤销（付款码支付） |
| USERPAYING | 用户支付中 |
| PAYERROR | 支付失败 |

### 11.2 退款状态码

| 状态码 | 说明 |
|--------|------|
| SUCCESS | 退款成功 |
| CLOSED | 退款关闭 |
| PROCESSING | 退款处理中 |
| ABNORMAL | 退款异常 |

### 11.3 参考文档

- [微信支付官方文档](https://pay.weixin.qq.com/wiki/doc/apiv3/index.shtml)
- [JSAPI 支付文档](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_1.shtml)
- [退款文档](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_5_9.shtml)
- [Python SDK GitHub](https://github.com/wechatpay-apiv3/wechatpay-python)

---

**文档结束**
