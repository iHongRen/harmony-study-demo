/**
 * @fileName : OssDemo.ets
 * @author : @cxy
 * @date : 2025/12/20
 * @description : oss文件上传demo
 */
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo } from "@kit.CoreFileKit";
import { OSSToken, OSSUploadConfig, OSSUploader } from "./OssUploader";

@Component
export struct OssDemo {
  @State imgUrl: string = ''
  private imagePath: string = ''

  build() {
    Column({ space: 30 }) {
      if (this.imgUrl) {
        Image(this.imgUrl)
          .width(200)

        Button('上传图片')
          .onClick(() => {
            this.copyToSandBox(this.imgUrl)
          })
      } else {
        Button('选择图片')
          .onClick(() => {
            this.onPickerImage()
          })
      }

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  onPickerImage() {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    photoSelectOptions.maxSelectNumber = 1;

    const photoPicker = new photoAccessHelper.PhotoViewPicker();
    photoPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      const uri = photoSelectResult.photoUris[0]
      this.imgUrl = uri
    }).catch((err: BusinessError) => {
    });
  }

  async copyToSandBox(uri: string) {
    const context = this.getUIContext().getHostContext()
    if (!context) {
      return
    }

    const ext = uri.split('.').pop() || 'png'

    const tempDir = context.tempDir + '/'
    const cacheFilePath = tempDir + 'test.' + ext;
    const srcFile = fileIo.openSync(uri);
    const dstFile = fileIo.openSync(cacheFilePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    await fileIo.copyFile(srcFile.fd, dstFile.fd);
    await fileIo.close(srcFile)
    await fileIo.close(dstFile)

    this.upload(cacheFilePath)
  }

  async upload(filePath: string) {
    const name = filePath.split('/').pop() || ''

    // 通常从接口获取
    const token: OSSToken = {
      AccessKeyId: 'your AccessKeySecret',
      AccessKeySecret: 'your AccessKeySecret',
      Expiration: '2025-12-21T13:30:15Z',
      SecurityToken: 'your SecurityToken',
    };

    const config: OSSUploadConfig = {
      bucket: 'your-bucket',
      endpoint: 'oss-cn-hangzhou.aliyuncs.com',
      objectKey: 'your-dir/' + name,
      filePath: filePath,
    };

    // 静态调用
    const result = await OSSUploader.quickUpload(token, config);
    if (result.success) {
      console.log('上传成功，文件URL：', result.url);
      this.getUIContext().getPromptAction().openToast({
        message: '上传成功',
        duration: 3000,
      })
    } else {
      console.error('上传失败：', result.message);
    }
  }
}