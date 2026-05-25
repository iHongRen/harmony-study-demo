# 图片加载与尺寸适配

通过网络请求加载图片并根据宽高比自动适配显示尺寸。

## 功能说明

- 从网络 URL 加载图片
- 解析图片原始宽高信息
- 根据宽高比自动计算适配后的显示尺寸
- 区分宽图、高图、方图的不同缩放策略

## 核心技术点

- 使用 `http` 模块发起网络请求
- `image.createImageSource` 解析 ArrayBuffer 为图片
- `getImageInfo()` 获取图片原始尺寸
- 根据宽高比自动计算适配尺寸
- 区分宽图、高图、方图的不同缩放策略

## 关键实现

### 网络图片加载

```typescript
const httpClient = http.createHttp()
httpClient.request(url, { method: http.RequestMethod.GET }).then(async res => {
  if (res.responseCode == 200) {
    const source = await image.createImageSource(res.result as ArrayBuffer)
    this.pixel = await source.createPixelMap()
    const info = await this.pixel.getImageInfo()
    this.calcImageSize(info.size.width, info.size.height)
  }
}).finally(() => {
  httpClient.destroy()
})
```

### 尺寸适配计算

```typescript
calcImageSize(width: number, height: number) {
  const ratio = width / height // 宽高比
  if (ratio > 1) {
    // 宽图：限制最大宽度
    this.imageWidth = Math.min(width, this.imageMaxWidth)
    this.imageHeight = this.imageWidth / ratio
  } else {
    // 高图或方图：限制最大高度
    this.imageHeight = Math.min(height, this.imageMaxHeight)
    this.imageWidth = this.imageHeight * ratio
  }
  // 二次校验，确保不超过最大限制
  if (this.imageWidth > this.imageMaxWidth) {
    this.imageWidth = this.imageMaxWidth
    this.imageHeight = this.imageWidth / ratio
  } else if (this.imageHeight > this.imageMaxHeight) {
    this.imageHeight = this.imageMaxHeight
    this.imageWidth = this.imageHeight * ratio
  }
}
```

## 文件说明

| 文件 | 说明 |
|------|------|
| ImageLoad.ets | 图片加载与尺寸适配主组件 |
