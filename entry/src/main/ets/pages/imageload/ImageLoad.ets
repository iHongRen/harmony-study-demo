/**
 * @fileName : ImageLoad.ets
 * @author : @cxy
 * @date : 2026/1/10
 * @description : 图片加载
 */

import { http } from '@kit.NetworkKit'
import { image } from '@kit.ImageKit'

@Component
export struct ImageLoadDemo {
  @State imageWidth: number = 0
  @State imageHeight: number = 0
  @State pixel: image.PixelMap | undefined = undefined
  private imageMaxWidth: number = 300
  private imageMaxHeight: number = 200

  aboutToAppear(): void {
    const url = 'https://picsum.photos/800/600?random=1'
    const httpClient = http.createHttp()
    httpClient.request(url, { method: http.RequestMethod.GET }).then(async res => {
      if (res.responseCode == 200) {
        const source = await image.createImageSource(res.result as ArrayBuffer)
        this.pixel = await source.createPixelMap()
        const info = await this.pixel.getImageInfo()
        const width = info.size.width
        const height = info.size.height
        this.calcImageSize(width, height)
      }
    })
      .finally(() => {
        httpClient.destroy()
      })

  }

  calcImageSize(width: number, height: number) {
    if (width > 0 && height > 0) {
      const ratio = width / height //宽高比
      if (ratio > 1) {
        //宽图
        this.imageWidth = Math.min(width, this.imageMaxWidth)
        this.imageHeight = this.imageWidth / ratio
      } else {
        //高图或方图
        this.imageHeight = Math.min(height, this.imageMaxHeight)
        this.imageWidth = this.imageHeight * ratio
      }
      if (this.imageWidth > this.imageMaxWidth) {
        this.imageWidth = this.imageMaxWidth
        this.imageHeight = this.imageWidth / ratio
      } else if (this.imageHeight > this.imageMaxHeight) {
        this.imageHeight = this.imageMaxHeight
        this.imageWidth = this.imageHeight * ratio
      }
    }
  }

  build() {
    Column() {
      Image(this.pixel)
        .width(this.imageWidth)
        .height(this.imageHeight)
        .backgroundColor("#eee")
    }
  }
}
