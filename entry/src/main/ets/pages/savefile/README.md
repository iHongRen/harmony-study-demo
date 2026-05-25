# 沙箱文件夹压缩导出

实现沙箱目录浏览、文件夹压缩并导出到手机存储的完整流程。

![](./savefile.gif)


## 功能说明

- 浏览沙箱目录结构，支持进入子目录和返回上级
- 显示文件和文件夹信息（名称、类型、大小）
- 点击文件夹的「导出」按钮触发压缩导出
- 使用 zlib 将文件夹压缩为 zip 格式
- 通过 DocumentViewPicker 选择手机存储保存位置
- 导出完成后自动清理临时文件

## 核心技术点

- 沙箱目录浏览与导航
- `zlib.compressFile` 压缩文件夹为 zip
- `DocumentViewPicker` 选择保存路径
- 文件读写与临时文件清理
- 异步操作状态管理（加载中、导出中）

## 关键实现

### 目录浏览

```typescript
loadDir(dirPath: string): void {
  const entries: string[] = fs.listFileSync(dirPath)
  const items: SandboxItem[] = []
  for (const name of entries) {
    const stat: fs.Stat = fs.statSync(fullPath)
    items.push({
      name,
      path: fullPath,
      isDirectory: stat.isDirectory(),
      size: stat.size
    })
  }
  // 文件夹排在前面
  items.sort((a, b) => {
    if (a.isDirectory && !b.isDirectory) return -1
    if (!a.isDirectory && b.isDirectory) return 1
    return a.name.localeCompare(b.name)
  })
  this.sandboxItems = items
}
```

### 压缩导出

```typescript
async onFolderExport(srcFolderPath: string, folderName: string): Promise<void> {
  const tmpZipPath: string = this.rootPath + '/' + folderName + '_export.zip'
  
  // 1. 压缩文件夹
  await zlib.compressFile(srcFolderPath, tmpZipPath, {
    level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION
  })
  
  // 2. 选择保存位置
  const saveOptions: picker.DocumentSaveOptions = new picker.DocumentSaveOptions()
  saveOptions.newFileNames = [folderName + '.zip']
  const docPicker: picker.DocumentViewPicker = new picker.DocumentViewPicker(context)
  const uris: string[] = await docPicker.save(saveOptions)
  
  // 3. 写入目标文件
  const srcFile: fs.File = fs.openSync(tmpZipPath, fs.OpenMode.READ_ONLY)
  const destFile: fs.File = fs.openSync(destUri, fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC)
  fs.copyFileSync(srcFile.fd, destFile.fd)
  
  // 4. 清理临时文件
  this.safeDelete(tmpZipPath)
}
```

## 文件说明

| 文件 | 说明 |
|------|------|
| SaveFileToDoc.ets | 沙箱文件夹压缩导出主组件 |
