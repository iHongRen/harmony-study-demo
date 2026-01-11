/**
 * @fileName : CanvasImage.ets
 * @author : @cxy
 * @date : 2026/1/9
 * @description : 文件描述
 */

import { image } from '@kit.ImageKit';
import { fileIo, fileUri, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';


@Component
export struct CanvasImage {
  @State message: string = 'hello world!'
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offCanvas: OffscreenCanvas = new OffscreenCanvas(300, 300)
  private offContext?: OffscreenCanvasRenderingContext2D

  build() {
    Column() {
      Canvas(this.context)
        .height(300)
        .width('100%')
        .onReady(() => {
          this.offContext = this.offCanvas.getContext('2d', this.settings)
          this.offContext.fillStyle = 'rgb(255,0,0)';
          this.offContext.fillRect(0, 0, this.context.width, this.context.height);
          this.offContext.fillStyle = 'rgb(255,255,255)';
          this.offContext.font = '60px sans-serif'
          this.offContext.textAlign = 'start'
          this.offContext.textBaseline = 'top'
          this.offContext.fillText(this.message, 100, 100)
          this.context.transferFromImageBitmap(this.offCanvas.transferToImageBitmap())
        })


      Button('保存图片')
        .onClick(() => {
          this.onSave()
        })
    }
    .alignItems(HorizontalAlign.Center)
  }

  async onSave() {
    if (this.offContext) {
      const pixelMap: image.PixelMap =
        this.offContext.getPixelMap(0, 0, 300, 300)

      const imagePackerApi = image.createImagePacker();
      const buffer = await imagePackerApi.packToData(pixelMap, { format: 'image/png', quality: 100 })
      const filePath = this.getUIContext().getHostContext()?.filesDir + `/${(new Date).getTime()}.png`
      try {
        const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
        fileIo.writeSync(file.fd, buffer)
        fileIo.closeSync(file.fd)

        const config: photoAccessHelper.PhotoCreationConfig[] = []
        config.push({
          fileNameExtension: 'png',
          photoType: photoAccessHelper.PhotoType.IMAGE,
        })

        const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.getUIContext().getHostContext())
        const srcUri = [fileUri.getUriFromPath(filePath)]
        const desUris = await phAccessHelper.showAssetsCreationDialog(srcUri, config)
        this.copyToPhoto(filePath, desUris[0])

      } catch (error) {
        console.error(JSON.stringify(error))
      }
    }
  }

  // 保存到指定路径
  copyToPhoto(srcFilePath: string, destFilePath: string) {
    const srcFile = fileIo.openSync(srcFilePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
    const destFile = fileIo.openSync(destFilePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
    // 读取源文件内容并写入至目的文件
    const stat = fileIo.statSync(srcFilePath)
    const bufSize = stat.size;
    let readSize = 0;
    const buf = new ArrayBuffer(bufSize);
    const readOptions: ReadOptions = {
      offset: readSize,
      length: bufSize
    };
    let readLen = fileIo.readSync(srcFile.fd, buf, readOptions);
    while (readLen > 0) {
      readSize += readLen;
      let writeOptions: WriteOptions = {
        length: readLen
      };
      fileIo.writeSync(destFile.fd, buf, writeOptions);
      readOptions.offset = readSize;
      readLen = fileIo.readSync(srcFile.fd, buf, readOptions);
    }
    // 关闭文件
    fileIo.closeSync(srcFile);
    fileIo.closeSync(destFile);
  }
}


