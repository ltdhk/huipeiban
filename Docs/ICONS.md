# 图标使用指南

本项目使用 Unicode emoji 作为图标解决方案,无需额外的图片资源,减小包体积并提升加载速度。

## 当前使用的图标

### 首页 (home.wxml)
| 位置 | Emoji | Unicode | 说明 |
|------|-------|---------|------|
| 菜单按钮 | ☰ | U+2630 | 汉堡菜单图标 |
| 用户按钮 | 👤 | U+1F464 | 用户头像 |
| 语音按钮 | 🎤 | U+1F3A4 | 麦克风 |
| 向上按钮 | ⬆ | U+2B06 | 向上箭头 |

### 侧边抽屉 (drawer)
| 位置 | Emoji | Unicode | 说明 |
|------|-------|---------|------|
| 应用图标 | 🤖 | U+1F916 | 机器人 |
| AI预约 | 🤖 | U+1F916 | 机器人 |
| 订单 | 📋 | U+1F4CB | 剪贴板 |
| 消息 | 💬 | U+1F4AC | 对话气泡 |
| 我的 | 👤 | U+1F464 | 用户头像 |
| 退出登录 | 🚪 | U+1F6AA | 门 |

## 替代图标方案

如果需要更专业的图标,可以考虑以下方案:

### 1. Iconfont (推荐)
阿里巴巴矢量图标库: https://www.iconfont.cn/

**使用步骤:**
1. 注册并登录 iconfont.cn
2. 搜索并选择需要的图标
3. 添加到项目并生成代码
4. 在小程序中引入字体文件

**优点:**
- 免费、矢量、可定制
- 支持彩色图标
- 可调大小和颜色
- 体积小,加载快

**缺点:**
- 需要额外配置
- 需要网络加载或本地引入

### 2. 微信小程序原生图标
微信官方提供的图标组件

**使用示例:**
```xml
<icon type="success" size="23" color="green"/>
```

**可用类型:**
- success, success_no_circle
- info, info_circle
- warn, waiting
- cancel, download, search, clear

**优点:**
- 无需配置,开箱即用
- 体积小

**缺点:**
- 图标种类有限
- 样式固定,不够灵活

### 3. 本地图片图标
将 PNG/SVG 图标放在项目中

**目录结构:**
```
/assets/
  /icons/
    menu.png
    user.png
    ai.png
    order.png
    message.png
    ...
```

**使用示例:**
```xml
<image src="/assets/icons/menu.png" />
```

**优点:**
- 完全自定义
- 不依赖网络
- 支持复杂图形

**缺点:**
- 增加包体积
- 需要准备多套尺寸
- 更改颜色需要重新设计

## 当前方案的优势

使用 Unicode emoji 的优势:
- ✅ 零配置,直接使用
- ✅ 跨平台一致性
- ✅ 无需网络加载
- ✅ 不占用包体积
- ✅ 易于更换和维护
- ✅ 支持系统主题色

## 图标资源推荐

1. **Iconfont** - https://www.iconfont.cn/
2. **Font Awesome** - https://fontawesome.com/
3. **Iconify** - https://iconify.design/
4. **Feather Icons** - https://feathericons.com/
5. **Material Icons** - https://fonts.google.com/icons
6. **Remix Icon** - https://remixicon.com/

## 更换为 Iconfont 的步骤

如果后续想使用 Iconfont,可以按以下步骤操作:

1. 在 iconfont.cn 创建项目并选择图标
2. 下载字体文件到项目
3. 在 app.wxss 中引入字体:

```css
@font-face {
  font-family: 'iconfont';
  src: url('/assets/fonts/iconfont.ttf') format('truetype');
}

.iconfont {
  font-family: 'iconfont' !important;
  font-size: 32rpx;
  font-style: normal;
}
```

4. 在 WXML 中使用:

```xml
<text class="iconfont">&#xe601;</text>
```

## 注意事项

1. emoji 在不同设备上显示可能略有差异
2. 部分旧设备可能不支持某些新 emoji
3. 如需精确控制图标样式,建议使用 iconfont
4. 生产环境建议使用专业图标库以保证一致性
