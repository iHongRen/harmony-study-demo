# 负一屏 (Blur)

实现从主屏向右滑动打开的负一屏展示效果，类似 iOS 的 Today View。

![负一屏效果](./blur.gif)

## 功能说明

- 主屏背景图片展示
- 向右滑动打开负一屏，向左滑动关闭
- 负一屏包含天气、备忘录、健康目标、新闻等卡片
- 滑动过程中主屏产生模糊效果

## 核心技术点

- 使用 `PanGesture` 实现左右滑动手势
- 通过速度判断区分快速滑动和慢速拖拽
- `backdropBlur` 实现背景模糊效果
- 动态计算位移与模糊半径
- 支持手势冲突处理与动画回弹
- 沉浸式全屏布局设置

## 关键实现

### 手势处理

```typescript
PanGesture(this.panOption)
  .onActionStart(() => { /* 记录起始位置 */ })
  .onActionUpdate((event) => { /* 更新偏移量 */ })
  .onActionEnd((event) => {
    // 根据速度判断是滑动还是拖拽
    if (this.isSwipeGesture(distance, duration)) {
      this.handleSwipeGesture(event) // 快速滑动
    } else {
      this.snapToEdge() // 慢速拖拽，吸附到边界
    }
  })
```

### 模糊效果

```typescript
.backdropBlur(this.blurRadius())
.visibility(this.shouldShowBlur() ? Visibility.Visible : Visibility.Hidden)
```

## 文件说明

| 文件 | 说明 |
|------|------|
| BlurDemo.ets | 负一屏主组件 |
