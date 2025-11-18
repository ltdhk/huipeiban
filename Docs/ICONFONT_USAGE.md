# Iconfont 使用说明

## 已配置的图标

项目已成功集成 Iconfont 图标库,以下是可用的图标:

| 图标名称 | Class 名称 | Unicode | 使用位置 |
|---------|-----------|---------|---------|
| 菜单 | icon-menu | \e600 | 顶部导航-汉堡菜单 |
| 用户 | icon-user | \e601 | 顶部导航-用户按钮, 侧边栏-我的 |
| 麦克风 | icon-voice | \e602 | 底部输入-语音按钮 |
| 机器人 | icon-robot | \e604 | 抽屉头部, 侧边栏-AI预约 |
| 订单 | icon-order | \e605 | 侧边栏-订单 |
| 消息 | icon-message | \e606 | 侧边栏-消息 |
| 退出 | icon-logout | \e607 | 抽屉底部-退出登录 |

## 使用方法

### 方法1: 使用 Class (推荐)

```xml
<text class="iconfont icon-menu"></text>
<text class="iconfont icon-user"></text>
<text class="iconfont icon-robot"></text>
```

### 方法2: 使用 Unicode

```xml
<text class="iconfont">&#xe600;</text>  <!-- 菜单 -->
<text class="iconfont">&#xe601;</text>  <!-- 用户 -->
<text class="iconfont">&#xe604;</text>  <!-- 机器人 -->
```

### 自定义样式

```css
.my-icon {
  font-size: 48rpx;
  color: #667EEA;
}
```

```xml
<text class="iconfont icon-menu my-icon"></text>
```

## 添加新图标

如果需要添加新图标,按以下步骤操作:

### 1. 访问 Iconfont 官网

访问 https://www.iconfont.cn/ 并登录

### 2. 选择图标

1. 搜索需要的图标
2. 点击"购物车"添加到项目
3. 点击"下载至本地"

### 3. 获取 Base64 字体

两种方法:
- **方法A**: 使用在线工具 https://transfonter.org/ 转换
- **方法B**: 使用 iconfont 项目页面的"Font class"在线链接

### 4. 更新 app.wxss

```css
@font-face {
  font-family: 'iconfont';
  src: url('data:font/truetype;charset=utf-8;base64,【新的Base64代码】') format('truetype');
}

/* 添加新图标类名 */
.icon-new-icon::before { content: '\eXXX'; }
```

### 5. 在页面中使用

```xml
<text class="iconfont icon-new-icon"></text>
```

## 注意事项

1. ⚠️ **Base64 编码必须完整** - 不能有换行或空格
2. ⚠️ **包体积** - 每个图标约增加 1-2KB,注意控制数量
3. ✅ **颜色** - 可以通过 CSS `color` 属性修改颜色
4. ✅ **大小** - 可以通过 CSS `font-size` 调整大小
5. ✅ **兼容性** - 所有微信小程序版本都支持

## 配置文件位置

- **全局样式**: `MiniApp/app.wxss` (第348-369行)
- **页面样式**: `MiniApp/pages/home/home.wxss`
- **使用示例**: `MiniApp/pages/home/home.wxml`

## 图标来源

当前使用的是精简版 Iconfont,仅包含必要图标以减小包体积。

如需完整图标库,请访问:
- Ant Design Icons: https://www.iconfont.cn/collections/detail?cid=9402
- Remix Icon: https://www.iconfont.cn/collections/detail?cid=30186

## 常见问题

**Q: 图标不显示怎么办?**
A: 检查以下几点:
1. app.wxss 中的 @font-face 是否正确引入
2. class 名称是否正确 (icon-xxx)
3. Unicode 编码是否正确

**Q: 如何修改图标颜色?**
A:
```css
.my-custom-icon {
  color: #FF0000;
}
```

**Q: 如何调整图标大小?**
A:
```css
.my-custom-icon {
  font-size: 60rpx;
}
```

**Q: 可以使用彩色图标吗?**
A: 不可以,Iconfont 是单色字体图标。如需彩色图标,请使用 SVG 或 PNG 图片。

## 更新日志

- 2025-11-13: 初始配置,添加7个基础图标
