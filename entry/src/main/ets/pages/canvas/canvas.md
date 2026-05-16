# Canvas 绘图与保存图片

使用 Canvas 进行离屏绘图并将绘制结果保存到系统相册。

## 功能说明

- 使用 OffscreenCanvas 进行离屏渲染
- 绘制红色背景和白色文字
- 将 Canvas 内容保存为 PNG 图片
- 通过系统相册选择器保存到相册

## 核心技术点

- 使用 `OffscreenCanvas` 实现离屏渲染
- `CanvasRenderingContext2D` 绘制图形和文字
- 使用 `image.ImagePacker` 将 PixelMap 打包为 PNG 格式
- 通过 `photoAccessHelper` 调用系统相册保存对话框
- 文件读写操作将图片复制到相册路径

## 关键实现

### 离屏绘图

```typescript
this.offContext = this.offCanvas.getContext('2d', this.settings)
this.offContext.fillStyle = 'rgb(255,0,0)'
this.offContext.fillRect(0, 0, this.context.width, this.context.height)
this.offContext.fillStyle = 'rgb(255,255,255)'
this.offContext.font = '60px sans-serif'
this.offContext.fillText(this.message, 100, 100)
this.context.transferFromImageBitmap(this.offCanvas.transferToImageBitmap())
```

### 保存图片

```typescript
const pixelMap: image.PixelMap = this.offContext.getPixelMap(0, 0, 300, 300)
const imagePackerApi = image.createImagePacker()
const buffer = await imagePackerApi.packToData(pixelMap, { format: 'image/png', quality: 100 })

// 保存到临时文件
const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
fileIo.writeSync(file.fd, buffer)

// 调用系统相册保存
const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context)
const desUris = await phAccessHelper.showAssetsCreationDialog(srcUri, config)
```

## 文件说明

| 文件 | 说明 |
|------|------|
| CanvasImage.ets | Canvas 绘图与保存图片主组件 |
