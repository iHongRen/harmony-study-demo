# HarmonyOS 学习示例项目

这是一个 HarmonyOS 应用开发学习项目，包含了多个实用的功能示例和最佳实践。每个示例都提供了完整的实现代码和详细的说明文档。


## 功能示例列表

### 1. 倒计时按钮 (CountDown)
实现发送验证码场景的倒计时按钮功能。

**核心技术点：**
- 使用 setInterval 实现倒计时控制器
- 自定义倒计时按钮组件
- 支持自定义倒计时时长

**文档路径：** `entry/src/main/ets/pages/countdown/countdown.md`

### 2. 表情面板 (Emotion)
实现聊天应用中的表情选择面板，支持 emoji 表情和图片表情。

**核心技术点：**
- 使用 Swiper + Grid 实现表情面板
- 懒加载 DataSource 优化性能
- 支持 emoji 和自定义图片表情

**文档路径：** `entry/src/main/ets/pages/emotion/如何实现聊天中的表情面板.md`

### 3. 文本展开收起 (ExpandText)
实现文本内容的展开和收起功能，支持指定行数限制。

**核心技术点：**
- 使用 getMeasureUtils().measureTextSize 计算文本高度
- 动态计算指定行数所需显示的文本内容
- 支持自定义展开/收起按钮样式

**文档路径：** `entry/src/main/ets/pages/expandtext/文本断行展开显示.md`

### 4. 异形 Banner (IrRectangle)
实现左右两边非矩形的异形轮播图效果。

**核心技术点：**
- 使用 maskShape 和 PathShape 实现异形裁剪
- SVG 路径绘制自定义形状
- 单位转换 vp2px

**文档路径：** `entry/src/main/ets/pages/irrectangle/irrectangle.md`

### 5. 位置信息获取 (Location)
获取用户当前位置的国家、城市、区县等地理信息。

**核心技术点：**
- 位置权限申请和管理
- 使用 geoLocationManager 获取位置
- 逆地理编码转换坐标为地址信息

**文档路径：** `entry/src/main/ets/pages/location/Location.md`

### 6. 金刚区菜单 (Menu)
实现带滚动下标的金刚区菜单布局。

**核心技术点：**
- 横向 List 实现金刚区
- 滚动进度计算
- 下标同步滚动效果

**文档路径：** `entry/src/main/ets/pages/menu/menu.md`

### 7. 自定义 Emitter (MyEmitter)
实现支持 Object 类型作为 key 的自定义事件发射器。

**核心技术点：**
- 使用 Map 存储观察者
- 支持泛型回调
- 简化事件监听和取消监听

**文档路径：** `entry/src/main/ets/pages/myemitter/myemitter.md`

### 8. 导航栏渐变 (NavbarGradient)
实现沉浸式导航栏的渐变显示效果。

**核心技术点：**
- 沉浸式布局设置
- 监听滚动偏移量动态调整透明度
- Stack 布局实现层叠效果

**文档路径：** `entry/src/main/ets/pages/navbargradient/navbargradient.md`

### 9. 本地通知 (Notification)
实现本地通知功能，支持自定义提示音和点击唤起应用。

**文档路径：** `entry/src/main/ets/pages/notification/notification.md`

### 10. OSS 文件上传 (OSS)
实现图片上传到阿里云 OSS 的功能。

**核心技术点：**
- 使用 @aliyun/oss SDK
- 封装统一的上传工具类
- 图片选择和沙箱文件处理

**文档路径：** `entry/src/main/ets/pages/oss/ossuploader.md`

### 11. 画中画 (PIP)
实现视频播放的画中画功能。

**文档路径：** `entry/src/main/ets/pages/pip/pip.md`

### 12. 路由管理 (Router)
自定义路由管理工具。

**文档路径：** `entry/src/main/ets/pages/router/xrouter.md`

### 13. 二维码扫描 (Scan)
实现二维码和条形码扫描功能。

**文档路径：** `entry/src/main/ets/pages/scan/scan.md`

### 14. 横竖屏切换 (ScreenRotate)
实现视频播放或图表展示时的横竖屏切换。

**核心技术点：**
- 使用 setPreferredOrientation 控制屏幕方向
- 沉浸式全屏效果
- 横竖屏不同布局适配

**文档路径：** `entry/src/main/ets/pages/screenrotate/screenrotate.md`

### 15. 搜索高亮 (Search)
实现搜索关键词高亮显示功能。

**核心技术点：**
- 自定义搜索框组件
- 关键词拆分和节点生成
- 使用 Text + Span 实现高亮效果

**文档路径：** `entry/src/main/ets/pages/search/search.md`

### 16. 文本选择菜单 (SelectableText)
实现聊天消息的长按选择和复制功能。

**核心技术点：**
- 使用 @cxy/selecteablemenu 三方库
- 自定义选择菜单项
- 支持文本选择和全选

**文档路径：** `entry/src/main/ets/pages/selectabletext/selectable.md`

### 17. Swiper 动画 (SwiperAnimation)
实现中间放大、两边缩小的轮播图效果。

**核心技术点：**
- 使用 customContentTransition 自定义切换动画
- 动态计算缩放比例和透明度
- 平滑的过渡效果

**文档路径：** `entry/src/main/ets/pages/swiperanimation/swiperanimation.md`

### 18. 表格布局 (Table)
实现支持上下左右滚动的表格布局。

**核心技术点：**
- 左右分栏布局
- 使用 List + Scroll 实现双向滚动
- 表头吸顶效果
- 左右滚动同步

**文档路径：** `entry/src/main/ets/pages/table/table.md`

### 19. 视频转码 (Transcoder)
实现 HDR 视频转 SDR 视频的功能。

**核心技术点：**
- 使用 AVTranscoder 实现视频转码
- 封装转码工具类
- 转码进度监听
- 文件大小对比

**文档路径：** `entry/src/main/ets/pages/transcoder/transcoder.md`

### 20. Web 字体调整 (WebFont)
实现 Web 资讯页面的字体大小动态调整。

**核心技术点：**
- 使用 SegmentButton 实现字号选择
- 通过 textZoomRatio 调整 Web 字体
- 半模态弹窗交互

**文档路径：** `entry/src/main/ets/pages/webfont/webfont.md`

### 21. 日期时间处理 (Dayjs)
日期时间处理相关功能示例。

**文档路径：** `entry/src/main/ets/pages/dayjs/dayjs.md`

## 项目结构

```
harmony-study-demo/
├── AppScope/                    # 应用全局配置
│   ├── app.json5               # 应用配置文件
│   └── resources/              # 全局资源文件
├── entry/                      # 主模块
│   ├── src/
│   │   └── main/
│   │       ├── ets/
│   │       │   └── pages/      # 页面目录
│   │       │       ├── Index.ets              # 主入口页面
│   │       │       ├── countdown/             # 倒计时示例
│   │       │       ├── emotion/               # 表情面板示例
│   │       │       ├── expandtext/            # 文本展开示例
│   │       │       ├── irrectangle/           # 异形Banner示例
│   │       │       ├── location/              # 位置信息示例
│   │       │       ├── menu/                  # 金刚区示例
│   │       │       ├── myemitter/             # 自定义Emitter示例
│   │       │       ├── navbargradient/        # 导航栏渐变示例
│   │       │       ├── notification/          # 通知示例
│   │       │       ├── oss/                   # OSS上传示例
│   │       │       ├── pip/                   # 画中画示例
│   │       │       ├── router/                # 路由示例
│   │       │       ├── scan/                  # 扫描示例
│   │       │       ├── screenrotate/          # 横竖屏切换示例
│   │       │       ├── search/                # 搜索高亮示例
│   │       │       ├── selectabletext/        # 文本选择示例
│   │       │       ├── swiperanimation/       # Swiper动画示例
│   │       │       ├── table/                 # 表格布局示例
│   │       │       ├── transcoder/            # 视频转码示例
│   │       │       └── webfont/               # Web字体示例
│   │       └── resources/      # 模块资源文件
│   └── oh-package.json5        # 模块依赖配置
├── oh_modules/                 # 依赖模块
├── build-profile.json5         # 构建配置
└── oh-package.json5            # 项目依赖配置
```

## 使用说明

1. 克隆项目到本地
2. 使用 DevEco Studio 打开项目
3. 等待依赖安装完成
4. 在 `entry/src/main/ets/pages/Index.ets` 中取消注释想要查看的示例组件
5. 运行项目到模拟器或真机


## 注意事项

1. 部分功能需要真机测试，模拟器可能不支持（如位置信息、扫描等）
2. OSS 上传功能需要配置自己的阿里云账号信息
3. 视频转码功能需要设备支持 AVTranscoder 能力
4. 使用前请确保已申请相应的权限（位置、相机、存储等）

