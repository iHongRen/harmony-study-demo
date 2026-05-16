# 下拉放大 Header

实现列表下拉时 Header 图片放大回弹效果，常见于资讯类 App 的顶部 Banner。

![下拉放大Header效果](./pulldownheader.gif)

## 功能说明

- 列表下拉时顶部图片逐渐放大
- 松手后图片平滑回弹到原始大小
- 列表上滚时 Header 跟随上移

## 核心技术点

- 监听 List `onDidScroll` 实现下拉距离计算
- 动态 `scale` 和 `height` 实现放大效果
- `onScrollStop` 回弹动画恢复
- `Stack` 布局实现 Header 悬浮覆盖
- 沉浸式全屏布局设置

## 关键实现

### 滚动处理

```typescript
.onDidScroll((event) => {
  this.handleScroll()
})
.onScrollStop(() => {
  this.resetHeader()
})

private handleScroll(): void {
  const currentOffset = this.scroller.currentOffset().yOffset
  if (currentOffset < 0) {
    // 下拉状态
    const pullDistance = Math.abs(currentOffset)
    const scaleRatio = Math.min(pullDistance / this.MAX_PULL_DISTANCE, 1)
    this.headerScale = this.MIN_SCALE + (this.MAX_SCALE - this.MIN_SCALE) * scaleRatio
    this.headerHeight = this.BASE_HEADER_HEIGHT + pullDistance
  } else if (currentOffset > 0) {
    // 上滚状态
    this.headerTranslateY = -currentOffset
  }
}
```

### 回弹动画

```typescript
private resetHeader(): void {
  if (this.headerScale > this.MIN_SCALE) {
    this.getUIContext().animateTo({
      duration: 300,
      curve: Curve.EaseOut
    }, () => {
      this.headerScale = this.MIN_SCALE
      this.headerHeight = this.BASE_HEADER_HEIGHT
    })
  }
}
```

### Header 布局

```typescript
Stack({ alignContent: Alignment.Top }) {
  List({ scroller: this.scroller }) { /* 列表内容 */ }
  
  // Header 覆盖在列表上方
  Column() {
    Image($r('app.media.startIcon'))
      .scale({ y: this.headerScale })
  }
  .height(this.headerHeight)
  .clip(true)
  .translate({ y: this.headerTranslateY })
}
```

## 文件说明

| 文件 | 说明 |
|------|------|
| PullDownHeader.ets | 下拉放大 Header 主组件 |
