/**
 * @fileName : ScreenRotate.ets
 * @author : @cxy
 * @date : 2025/12/20
 * @description : 实现横竖屏切换
 */
import { window } from "@kit.ArkUI";

@Component
export struct ScreenRotate {
  @State isFullScreen: boolean = false

  aboutToAppear(): void {
    // 开启沉浸式
    window.getLastWindow(this.getUIContext().getHostContext()).then(win => {
      win.setWindowLayoutFullScreen(true)
    });
  }

  build() {
    Stack() {
      Stack() {
        Image('https://picsum.photos/800/450?random=1')
          .width('100%')
          .aspectRatio(16 / 9)
          .constraintSize({
            maxWidth: '100%',
            maxHeight: '100%'
          })

        if (this.isFullScreen) {
          Row({ space: 10 }) {
            Slider({
              value: 100,
            })
              .selectedColor('#ff0099ff')
              .layoutWeight(1)

            Image($r('app.media.fullout'))
              .width(24)
              .height(24)
              .onClick(() => {
                this.onFullChange()
              })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .padding({
            left: 44, right: 44, bottom: 20
          })
        } else {
          Text('全屏切换')
            .borderWidth(1)
            .borderRadius('50%')
            .borderColor('#fff')
            .fontColor('#fff')
            .fontSize(14)
            .padding({
              left: 10,
              right: 10,
              top: 5,
              bottom: 5
            })
            .onClick(() => {
              this.onFullChange()
            })
            .offset({
              y: 50
            })
        }
      }
      .alignContent(Alignment.Bottom)
    }
    .backgroundColor('#000')
    .width('100%')
    .height('100%')
  }

  onFullChange() {
    window.getLastWindow(this.getUIContext().getHostContext()).then(win => {
      this.isFullScreen = !this.isFullScreen;
      win.setPreferredOrientation(this.isFullScreen ? window.Orientation.AUTO_ROTATION_LANDSCAPE :
        window.Orientation.PORTRAIT)
    });
  }
}