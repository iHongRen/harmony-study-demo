# HDS Tab 底部导航栏

基于 UIDesignKit 实现符合 HDS (HarmonyOS Design System) 规范的底部 Tab 导航栏。

## 功能说明

- 底部悬浮式 Tab 导航栏
- 包含首页、免费、问AI、会员、我的五个 Tab
- "问AI" Tab 采用特殊样式（圆形按钮）并支持 Popup 弹窗
- 拦截特定 Tab 的切换行为

## 核心技术点

- 使用 `HdsNavigation` + `HdsTabs` 构建标准底部导航
- `barFloatingStyle` 实现悬浮式底部栏
- `hdsMaterial` 实现底部悬浮页签沉浸光感效果
- 自定义 TabBar 样式（问AI按钮特殊处理）
- `onContentWillChange` 拦截 Tab 切换
- `bindPopup` 实现按钮弹窗

## 关键实现

### HDS Tab 配置

```typescript
HdsTabs({ controller: this.controller }) {
  TabContent() { /* 首页 */ }.tabBar(this.tabItem('首页', 0))
  TabContent() { /* 免费 */ }.tabBar(this.tabItem('免费', 1))
  TabContent() { /* 问AI */ }.tabBar(this.tabItem('问AI', 2))
  TabContent() { /* 会员 */ }.tabBar(this.tabItem('会员', 3))
  TabContent() { /* 我的 */ }.tabBar(this.tabItem('我的', 4))
}
.barFloatingStyle({
  barBottomMargin: 28,
  systemMaterialEffect: {
    materialType: hdsMaterial.MaterialType.ADAPTIVE,
    materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
  }
})
```

### Tab 切换拦截

```typescript
.onContentWillChange((currentIndex, comingIndex) => {
  if (comingIndex == 2) {
    this.showAI = true  // 显示 AI 弹窗
    return false;       // 阻止切换
  }
  return true;          // 允许切换
})
```

### 自定义 TabBar

```typescript
@Builder
tabItem(title: string, index: number) {
  if (title === '问AI') {
    // 特殊样式：圆形按钮 + Popup
    Text(title)
      .backgroundColor(this.showAI ? '#ff17d042' : '#D5F1DB')
      .borderRadius('50%')
      .bindPopup(this.showAI, { builder: this.aiBuilder, placement: Placement.Top })
  } else {
    // 普通样式：根据选中状态变化
    Text(title)
      .fontColor(index === this.currentIndex ? '#4F9860' : '#51473F')
      .fontWeight(index === this.currentIndex ? FontWeight.Medium : FontWeight.Normal)
  }
}
```

## 文件说明

| 文件 | 说明 |
|------|------|
| HdsTab.ets | HDS Tab 底部导航栏主组件 |
