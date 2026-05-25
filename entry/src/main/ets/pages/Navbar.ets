/**
 * @fileName : Navbar.ets
 * @author : @cxy
 * @date : 2026/5/25
 * @description : 自定义导航
 */
import { XRouter } from './router/XRouter'

@Component
export struct Navbar {
  @StorageProp('topHeight') topHeight: number = 0
  @Prop title: string = ''
  @Prop hideBack: boolean = false
  @Prop paddingLeft: number = 16
  onBack?: () => void

  build() {
    Row({ space: 10 }) {
      if (!this.hideBack) {
        Button() {
          Image($r('sys.media.ohos_ic_compnent_titlebar_back'))
            .width(20)
        }
        .backgroundColor('#f5f5f5')
        .type(ButtonType.Circle)
        .height(36)
        .width(36)
        .onClick(() => {
          if (this.onBack) {
            this.onBack()
          } else {
            XRouter.pop()
          }
        })
      }
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .height(44)
    }
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .padding({
      left: this.paddingLeft,
      top: this.topHeight
    })
  }
}
