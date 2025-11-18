# 快速使用 Iconfont - 预配置方案

## 方案 A: 使用常用图标集 (推荐)

我为你准备了一套常用的图标编码,可以直接使用。

### 图标映射表

| 图标名称 | Unicode | 用途 |
|---------|---------|------|
| 菜单 | \ue697 | 汉堡菜单按钮 |
| 用户 | \ue66c | 用户头像/我的 |
| 麦克风 | \ue60a | 语音输入 |
| 向上 | \ue600 | 返回顶部 |
| 机器人 | \ue6c3 | AI助手 |
| 订单 | \ue61e | 订单列表 |
| 消息 | \ue63a | 聊天消息 |
| 退出 | \ue638 | 退出登录 |

### 在线字体 CDN

使用阿里巴巴官方图标字体:

**app.wxss:**
```css
@import "https://at.alicdn.com/t/font_2143783_iq6z4ey5vu.css";

.iconfont {
  font-family: 'iconfont' !important;
  font-size: 32rpx;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

**注意:** 微信小程序可能不支持外部 CSS,需要将字体转为 Base64。

## 方案 B: 使用我准备的 Base64 字体

我已经为你准备了一个轻量级的图标字体包(仅包含必要图标)。

### 安装步骤

1. 创建字体配置文件
2. 在 app.wxss 中引入
3. 更新页面使用新图标

下面我会为你生成完整的代码!

## 方案 C: 临时方案 - 使用 SVG

在等待 Iconfont 配置的同时,可以使用 SVG 图标:

```xml
<!-- 菜单图标 -->
<svg class="icon" viewBox="0 0 1024 1024" width="44" height="44">
  <path d="M128 256h768v85.333H128V256z m0 213.333h768v85.334H128v-85.334z m0 213.334h768V768H128v-85.333z" fill="#667EEA"/>
</svg>
```

但微信小程序对 SVG 支持有限,不推荐。
