/**
 * @fileName : TranscoderDemo.ets
 * @author : @cxy
 * @date : 2025/12/21
 * @description : 视频转码demo
 */
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo } from "@kit.CoreFileKit";
import { Transcoder } from "./Transcoder";

@Component
export struct TranscoderDemo {
  @State message: string = ''
  @State isTransing: boolean = false
  @State progress: number = 0

  build() {
    Column({ space: 30 }) {
      if (this.message) {
        Text(this.message)
          .fontSize(14)
      }

      Button(this.isTransing ? `正在转换：${this.progress}%` : '视频转码')
        .enabled(!this.isTransing)
        .onClick(() => {
          this.onPickerVideo()
        })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  onPickerVideo() {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    photoSelectOptions.maxSelectNumber = 1;

    const photoPicker = new photoAccessHelper.PhotoViewPicker();
    photoPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      const uri = photoSelectResult.photoUris[0]
      this.copyToSandBox(uri)
    }).catch((err: BusinessError) => {
    });
  }

  async copyToSandBox(uri: string) {
    const context = this.getUIContext().getHostContext()
    if (!context) {
      return
    }
    const tempDir = context.filesDir + '/'
    const cacheFilePath = tempDir + 'test.mp4';
    const srcFile = fileIo.openSync(uri);
    const dstFile = fileIo.openSync(cacheFilePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    fileIo.copyFileSync(srcFile.fd, dstFile.fd);

    const srcInfo = await fileIo.stat(srcFile.fd)

    const transPath = tempDir + 'trans.mp4'
    const path = await this.onTransCoder(cacheFilePath, transPath)
    if (!path) {
      console.error('转换失败')
      return
    }

    const trans = await fileIo.stat(path)

    const transInfo: Record<string, Object> = {
      '原大小': this.getSizeStr(srcInfo.size),
      '转码后大小': this.getSizeStr(trans.size),
      'dstPath': transPath
    }
    this.message = JSON.stringify(transInfo, null, 4)

    fileIo.close(srcFile)
    fileIo.close(dstFile)
  }

  async onTransCoder(srcPath: string, dstPath: string): Promise<string> {
    this.isTransing = true
    this.progress = 0
    return new Promise((resolve) => {
      const transcoder = new Transcoder(this.getUIContext().getHostContext())
      transcoder.startTranscoderingProcess(srcPath, dstPath)
      transcoder.processCallback = (completed: boolean, progress: number, error?: BusinessError) => {
        this.progress = progress
        if (completed) {
          this.isTransing = false
          resolve(dstPath)
        } else if (error) {
          this.isTransing = false
          resolve('')
        }
      }
    })
  }

  getSizeStr(size: number): string {
    if (size === 0) {
      return '0KB'
    } else if (size > 1024 * 1024 * 1024) {
      return Number(size / 1024.0 / 1024.0 / 1024.0).toFixed(1) + 'G'
    } else if (size > 1024 * 1024) {
      return Number(size / 1024.0 / 1024.0).toFixed(1) + 'M'
    } else {
      return Number(size / 1024.0).toFixed(1) + 'KB'
    }
  }
}