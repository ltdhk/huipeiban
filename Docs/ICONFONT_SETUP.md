# Iconfont 配置指南

## 需要的图标列表

在 https://www.iconfont.cn/ 搜索并添加以下图标到你的项目:

### 首页图标
1. **菜单图标** - 搜索 "menu" 或 "hamburger"
2. **用户图标** - 搜索 "user" 或 "profile"
3. **麦克风图标** - 搜索 "microphone" 或 "voice"
4. **向上箭头** - 搜索 "arrow-up" 或 "upload"

### 侧边栏图标
5. **AI机器人** - 搜索 "robot" 或 "ai"
6. **订单图标** - 搜索 "order" 或 "list"
7. **消息图标** - 搜索 "message" 或 "chat"
8. **我的图标** - 搜索 "user" 或 "profile"
9. **退出图标** - 搜索 "logout" 或 "exit"

## 配置步骤

### 1. 注册并登录 Iconfont

访问 https://www.iconfont.cn/,注册并登录账号。

### 2. 创建项目

1. 点击顶部导航的"资源管理" -> "我的项目"
2. 点击"新建项目"
3. 填写项目名称,如 "会照护小程序"
4. 设置 FontClass/Symbol 前缀,建议使用 `icon-`

### 3. 选择图标

1. 在首页搜索需要的图标
2. 鼠标悬停在图标上,点击"购物车"图标
3. 将所有需要的图标加入购物车
4. 点击右上角购物车,点击"添加至项目"
5. 选择你创建的项目

### 4. 下载字体文件

1. 进入"我的项目"
2. 点击"下载至本地"
3. 解压下载的 ZIP 文件

### 5. 文件说明

下载的文件包含:
- `iconfont.ttf` - 字体文件(主要使用)
- `iconfont.woff` - Web字体文件
- `iconfont.woff2` - 优化的Web字体
- `iconfont.css` - 样式文件(参考用)
- `iconfont.json` - 图标信息
- `demo_index.html` - 示例页面

## 安装到小程序

### 步骤 1: 复制字体文件

将 `iconfont.ttf` 复制到项目中:

```
MiniApp/
  assets/
    fonts/
      iconfont.ttf  ← 复制到这里
```

### 步骤 2: Base64 转换(重要!)

**微信小程序不支持直接引入本地字体文件,需要转换为 Base64。**

方法1 - 在线转换:
1. 访问 https://transfonter.org/
2. 上传 `iconfont.ttf`
3. 勾选 "Base64 encode"
4. 点击 Convert
5. 下载并获取 Base64 代码

方法2 - 使用 Iconfont 平台:
1. 在项目页面选择 "Font class"
2. 点击"查看在线链接"
3. 复制 CSS 代码(已包含 Base64)

### 步骤 3: 在 app.wxss 中引入字体

```css
/* app.wxss - 全局样式 */

@font-face {
  font-family: 'iconfont';
  src: url('data:font/truetype;charset=utf-8;base64,【这里粘贴Base64代码】') format('truetype');
}

.iconfont {
  font-family: 'iconfont' !important;
  font-size: 32rpx;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

### 步骤 4: 查看图标代码

在下载的文件中打开 `demo_index.html`,可以看到每个图标对应的 Unicode 码,例如:
- &#xe601; (菜单)
- &#xe602; (用户)
- &#xe603; (麦克风)

### 步骤 5: 在页面中使用

**WXML:**
```xml
<!-- 使用 Unicode -->
<text class="iconfont">&#xe601;</text>

<!-- 或使用 class (需要额外配置) -->
<text class="iconfont icon-menu"></text>
```

**WXSS:**
如果要使用 class 方式,需要在 app.wxss 中添加:
```css
.icon-menu::before { content: '\e601'; }
.icon-user::before { content: '\e602'; }
.icon-voice::before { content: '\e603'; }
/* ... 其他图标 */
```

## 推荐图标项目

如果你不想自己选择,可以使用这些优质的图标集:

1. **Ant Design Icons** - https://www.iconfont.cn/collections/detail?cid=9402
2. **Element UI Icons** - https://www.iconfont.cn/collections/detail?cid=11803
3. **Remix Icon** - https://www.iconfont.cn/collections/detail?cid=30186

## 注意事项

1. ⚠️ **必须使用 Base64** - 小程序不支持本地字体文件路径
2. ⚠️ **大小限制** - Base64 后的字体文件会增大约 1.3 倍,注意包体积
3. ⚠️ **图标数量** - 只添加需要的图标,避免字体文件过大
4. ✅ **颜色** - Iconfont 是单色图标,可以通过 `color` 属性修改颜色
5. ✅ **大小** - 可以通过 `font-size` 调整大小

## 完成后的使用示例

```xml
<!-- home.wxml -->
<view class="top-bar">
  <view class="menu-btn" bindtap="toggleDrawer">
    <text class="iconfont">&#xe601;</text>
  </view>
  <text class="app-title">会照护</text>
  <view class="user-btn" bindtap="goToProfile">
    <text class="iconfont">&#xe602;</text>
  </view>
</view>
```

```css
/* home.wxss */
.menu-btn .iconfont,
.user-btn .iconfont {
  font-size: 44rpx;
  color: #667EEA;
}
```

## 下一步

完成上述步骤后,告诉我:
1. 你选择的图标 Unicode 代码
2. 或者直接提供 Base64 编码后的字体文件内容

我会帮你更新所有页面的代码!
