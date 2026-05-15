/**
 * @fileName : SaveFileToDoc.ets
 * @author : @cxy
 * @date : 2026/5/15
 * @description : 沙箱文件夹压缩后导出到手机存储
 *
 * 流程：
 * 1. 展示沙箱目录，点击文件夹进入，点击「导出」按钮触发
 * 2. zlib.compressFile 将文件夹压缩为沙箱临时 zip
 * 3. DocumentViewPicker.save 让用户选择手机存储保存位置
 * 4. 将 zip 内容写入目标 URI，清理临时 zip
 */

import { fileIo as fs, picker } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'
import { BusinessError, zlib } from '@kit.BasicServicesKit'

interface SandboxItem {
  name: string
  path: string
  isDirectory: boolean
  size: number
}

@Component
export struct SaveFileToDoc {
  @State sandboxItems: SandboxItem[] = []
  @State currentPath: string = ''
  @State isLoading: boolean = false
  @State isExporting: boolean = false
  @State exportingFolder: string = ''
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext
  private rootPath: string = this.context.filesDir

  aboutToAppear(): void {
    this.currentPath = this.rootPath
    this.loadDir(this.currentPath)
  }

  loadDir(dirPath: string): void {
    this.isLoading = true
    this.sandboxItems = []
    try {
      const entries: string[] = fs.listFileSync(dirPath)
      const items: SandboxItem[] = []
      for (const name of entries) {
        const fullPath: string = dirPath + '/' + name
        try {
          const stat: fs.Stat = fs.statSync(fullPath)
          items.push({
            name,
            path: fullPath,
            isDirectory: stat.isDirectory(),
            size: stat.size
          })
        } catch (e) {
          console.warn('stat error: ' + (e as BusinessError).message)
        }
      }
      items.sort((a: SandboxItem, b: SandboxItem): number => {
        if (a.isDirectory && !b.isDirectory) {
          return -1
        }
        if (!a.isDirectory && b.isDirectory) {
          return 1
        }
        return a.name.localeCompare(b.name)
      })
      this.sandboxItems = items
    } catch (e) {
      console.warn('loadDir error: ' + (e as BusinessError).message)
    }
    this.isLoading = false
  }

  goBack(): void {
    if (this.currentPath === this.rootPath) {
      try {
        this.getUIContext().getPromptAction().showToast({ message: '已是沙箱根目录' })
      } catch (e) { /* ignore */
      }
      return
    }
    const parent: string = this.currentPath.substring(0, this.currentPath.lastIndexOf('/'))
    if (parent) {
      this.currentPath = parent
      this.loadDir(parent)
    }
  }

  formatSize(size: number): string {
    if (size < 1024) {
      return `${size} B`
    }
    if (size < 1024 * 1024) {
      return `${(size / 1024).toFixed(1)} KB`
    }
    return `${(size / 1024 / 1024).toFixed(1)} MB`
  }

  safeDelete(path: string): void {
    try {
      fs.unlinkSync(path)
    } catch (e) { /* ignore */
    }
  }

  async onFolderExport(srcFolderPath: string, folderName: string): Promise<void> {
    if (this.isExporting) {
      try {
        this.getUIContext().getPromptAction().showToast({ message: '正在处理中，请稍候...' })
      } catch (e) { /* ignore */
      }
      return
    }

    this.isExporting = true
    this.exportingFolder = folderName
    const tmpZipPath: string = this.rootPath + '/' + folderName + '_export.zip'

    // 压缩
    try {
      await zlib.compressFile(srcFolderPath, tmpZipPath, {
        level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION
      })
    } catch (e) {
      this.safeDelete(tmpZipPath)
      this.isExporting = false
      this.exportingFolder = ''
      try {
        this.getUIContext().getPromptAction().showToast({ message: `压缩失败：${(e as BusinessError).message}` })
      } catch (e2) { /* ignore */
      }
      return
    }

    // Picker 选择保存位置
    const saveOptions: picker.DocumentSaveOptions = new picker.DocumentSaveOptions()
    saveOptions.newFileNames = [folderName + '.zip']
    const docPicker: picker.DocumentViewPicker =
      new picker.DocumentViewPicker(this.getUIContext().getHostContext() as common.UIAbilityContext)

    let destUri: string = ''
    try {
      const uris: string[] = await docPicker.save(saveOptions)
      if (!uris || uris.length === 0) {
        this.safeDelete(tmpZipPath)
        this.isExporting = false
        this.exportingFolder = ''
        return
      }
      destUri = uris[0]
    } catch (e) {
      this.safeDelete(tmpZipPath)
      this.isExporting = false
      this.exportingFolder = ''
      try {
        this.getUIContext().getPromptAction().showToast({ message: `保存失败：${(e as BusinessError).message}` })
      } catch (e2) { /* ignore */
      }
      return
    }

    // 写入目标 URI
    try {
      const srcFile: fs.File = fs.openSync(tmpZipPath, fs.OpenMode.READ_ONLY)
      const destFile: fs.File = fs.openSync(destUri, fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC)
      fs.copyFileSync(srcFile.fd, destFile.fd)
      fs.closeSync(srcFile)
      fs.closeSync(destFile)
    } catch (e) {
      this.safeDelete(tmpZipPath)
      this.isExporting = false
      this.exportingFolder = ''
      try {
        this.getUIContext().getPromptAction().showToast({ message: `写入失败：${(e as BusinessError).message}` })
      } catch (e2) { /* ignore */
      }
      return
    }

    // 清理临时 zip
    this.safeDelete(tmpZipPath)
    this.isExporting = false
    this.exportingFolder = ''
    try {
      this.getUIContext().getPromptAction().showToast({ message: `「${folderName}.zip」已导出` })
    } catch (e) { /* ignore */
    }
  }

  build() {
    Column() {

      // ── 标题栏 ──────────────────────────────────────────
      Row() {
        Text('沙箱文件夹压缩导出')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .layoutWeight(1)
        if (this.isExporting) {
          LoadingProgress().width(24).height(24)
        }
      }
      .width('100%')
      .padding({
        top: 16,
        bottom: 12,
        left: 16,
        right: 16
      })
      .backgroundColor(Color.White)

      // ── 路径导航 ─────────────────────────────────────────
      Row() {
        Button('← 返回')
          .fontSize(12)
          .height(30)
          .fontColor(Color.White)
          .visibility(this.currentPath != this.rootPath ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            this.goBack()
          })
        Text(this.currentPath.replace(this.rootPath, '[沙箱]'))
          .fontSize(11)
          .fontColor(Color.Gray)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
          .margin({ left: 8 })
      }
      .width('100%')
      .padding({
        top: 8,
        bottom: 8,
        left: 12,
        right: 12
      })
      .backgroundColor('#f5f5f5')

      // ── 文件列表 ─────────────────────────────────────────
      if (this.isLoading) {
        LoadingProgress().width(40).height(40).margin({ top: 40 })
      } else if (this.sandboxItems.length === 0) {
        Column() {
          Text('📂').fontSize(48).margin({ bottom: 8 })
          Text('该目录为空').fontSize(14).fontColor(Color.Gray)
        }
        .width('100%')
        .margin({ top: 60 })
        .alignItems(HorizontalAlign.Center)
      } else {
        List() {
          ForEach(this.sandboxItems, (item: SandboxItem) => {
            ListItem() {
              Row() {
                Text(item.isDirectory ? '📁' : '📄')
                  .fontSize(24)
                  .margin({ right: 12 })

                Column() {
                  Text(item.name)
                    .fontSize(14)
                    .fontColor(Color.Black)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(item.isDirectory ? '文件夹' : this.formatSize(item.size))
                    .fontSize(11)
                    .fontColor(Color.Gray)
                    .margin({ top: 2 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                if (item.isDirectory) {
                  Button('导出')
                    .fontSize(12)
                    .height(30)
                    .padding({
                      left: 10,
                      right: 10,
                      top: 0,
                      bottom: 0
                    })
                    .backgroundColor(this.exportingFolder === item.name ? Color.Gray : '#1677ff')
                    .fontColor(Color.White)
                    .margin({ right: 8 })
                    .enabled(this.exportingFolder !== item.name)
                    .onClick(() => {
                      this.onFolderExport(item.path, item.name)
                    })

                  Text('›')
                    .fontSize(20)
                    .fontColor(Color.Gray)
                    .onClick(() => {
                      this.currentPath = item.path
                      this.loadDir(item.path)
                    })
                }
              }
              .width('100%')
              .padding({
                top: 10,
                bottom: 10,
                left: 16,
                right: 16
              })
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item.isDirectory) {
                  this.currentPath = item.path
                  this.loadDir(item.path)
                }
              })
            }
          })
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0.5, color: '#eeeeee' })
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}
