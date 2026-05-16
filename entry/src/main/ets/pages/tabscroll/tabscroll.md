# Tab 嵌套 Scroll 滑动冲突解决

解决 Tab 左右切换与内嵌 Scroll 横向滑动之间的手势冲突问题。

![Tab嵌套Scroll效果](./tabscroll.gif)

## 功能说明

- 顶部 Tab 支持左右切换
- 中间 Tab 内嵌可缩放、可横向滚动的 Scroll
- 解决 Tab 切换与 Scroll 滚动的手势冲突

## 核心技术点

- `Tabs` 组件实现顶部导航
- `Scroll` 组件实现内容滚动
- `onGestureRecognizerJudgeBegin` 手势冲突处理
- 根据缩放状态和滚动位置判断手势归属
- 支持图片缩放功能

## 关键实现

### 手势冲突处理

```typescript
.onGestureRecognizerJudgeBegin((event, current, others) => {
  if (current.isBuiltIn() && current.getType() === GestureType.PAN_GESTURE) {
    const pan = event as PanGestureEvent;
    
    // 纵向滑动，交给 Scroll 处理
    if (Math.abs(pan.offsetX) <= Math.abs(pan.offsetY)) {
      return GestureJudgeResult.CONTINUE;
    }
    
    // 未放大时，横向滑动交给 Tab 切换
    if (this.currScale <= 1) {
      return GestureJudgeResult.REJECT;
    }
    
    // 已放大时，根据滚动位置判断
    const xOffset = this.scroller.currentOffset().xOffset;
    if (pan.offsetX < 0 && !this.scroller.isAtEnd()) {
      return GestureJudgeResult.CONTINUE; // 左滑且未到最右，Scroll 处理
    }
    if (pan.offsetX > 0 && xOffset > 0) {
      return GestureJudgeResult.CONTINUE; // 右滑且未到最左，Scroll 处理
    }
  }
  return GestureJudgeResult.CONTINUE;
}, true)
```

## 文件说明

| 文件 | 说明 |
|------|------|
| tabscroll.ets | Tab 嵌套 Scroll 主组件 |
