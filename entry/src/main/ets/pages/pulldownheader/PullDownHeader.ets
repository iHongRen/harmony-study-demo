/**
 * @fileName : PullDownHeader.ets
 * @author : @cxy
 * @date : 2026/5/15
 * @description : 下拉放大header
 */
import { window } from "@kit.ArkUI"

@Component
export struct PullDownHeaderDemo {
  @State private headerScale: number = 1
  @State private headerHeight: number = 300
  @State private headerTranslateY: number = 0
  private scroller: Scroller = new ListScroller()
  private readonly MIN_SCALE: number = 1
  private readonly MAX_SCALE: number = 1.5
  private readonly BASE_HEADER_HEIGHT: number = 300
  private readonly MAX_PULL_DISTANCE: number = 100

  aboutToAppear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((win: window.Window) => {
      win.setWindowLayoutFullScreen(true)
    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      List({ scroller: this.scroller }) {
        ListItem() {
          Column()
            .width('100%')
            .height(this.BASE_HEADER_HEIGHT)
        }

        ForEach(Array.from({ length: 30 }, (_: number, i) => i), (index: number) => {
          ListItem() {
            Text(index.toString())
              .padding(10)
          }
        })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .onDidScroll((event) => {
        this.handleScroll()
      })
      .onScrollStop(() => {
        this.resetHeader()
      })
      .backgroundColor('#F5F5F5')

      // Header
      Column() {
        Image($r('app.media.startIcon'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .scale({ y: this.headerScale })
        // .scale({ x: this.headerScale, y: this.headerScale })
      }
      .width('100%')
      .height(this.headerHeight)
      .clip(true)
      .translate({ y: this.headerTranslateY })
    }
    .clip(true)
  }

  private handleScroll(): void {
    const currentOffset = this.scroller.currentOffset().yOffset
    if (currentOffset < 0) {
      const pullDistance = Math.abs(currentOffset)
      const scaleRatio = Math.min(pullDistance / this.MAX_PULL_DISTANCE, 1)
      this.headerScale = this.MIN_SCALE + (this.MAX_SCALE - this.MIN_SCALE) * scaleRatio
      this.headerHeight = this.BASE_HEADER_HEIGHT + pullDistance
      this.headerTranslateY = 0
    } else if (currentOffset > 0) {
      this.headerTranslateY = -currentOffset
      if (this.headerScale > this.MIN_SCALE) {
        this.headerScale = this.MIN_SCALE
        this.headerHeight = this.BASE_HEADER_HEIGHT
      }
    } else {
      this.headerTranslateY = 0
      if (this.headerScale > this.MIN_SCALE) {
        this.headerScale = this.MIN_SCALE
        this.headerHeight = this.BASE_HEADER_HEIGHT
      }
    }
  }

  private resetHeader(): void {
    if (this.headerScale > this.MIN_SCALE) {
      this.getUIContext().animateTo({
        duration: 300,
        curve: Curve.EaseOut
      }, () => {
        this.headerScale = this.MIN_SCALE
        this.headerHeight = this.BASE_HEADER_HEIGHT
      })
    }
  }
}
