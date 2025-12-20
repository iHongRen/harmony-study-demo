/**
 * @fileName : Irrectangele.ets
 * @author : @cxy
 * @date : 2025/12/20
 * @description : 异形banner
 */

import { PathShape } from "@kit.ArkUI"

@Component
export struct Irrectange {
  @State commands: string = ''
  @State irHeight: number = 0
  @State banners: string[] = [
    'https://picsum.photos/300/150?random=1',
    'https://picsum.photos/300/150?random=2',
    'https://picsum.photos/300/150?random=3',
    'https://picsum.photos/300/150?random=4',
    'https://picsum.photos/300/150?random=5'
  ]

  build() {
    Row({ space: 3 }) {
      Swiper() {
        ForEach(this.banners, (item: string) => {
          Image(item)
            .width('100%')
        }, (item: string) => item)
      }
      .interval(5000)
      .loop(true)
      .indicator(
        new DotIndicator()
          .itemWidth(6)
          .itemHeight(6)
          .selectedItemWidth(12)
          .selectedItemHeight(6)
          .color('#eee')
          .selectedColor('#fff')
      )
      .layoutWeight(1)
      .borderRadius(8)
      .maskShape(new PathShape().commands(this.commands).fill(Color.White))
      .onAreaChange((oldValue: Area, newValue: Area) => {
        const ctx = this.getUIContext()
        this.irHeight = newValue.height as number
        const width = ctx.vp2px(newValue.width as number)
        const height = ctx.vp2px(this.irHeight)
        this.updateCommands(width, height)
      })

      Stack() {
        Image($r('app.media.irrect_right'))
          .width('100%')
          .height('100%')
          .resizable({
            slice: {
              top: 30,
              bottom: 30,
              left: 40,
              right: 40
            }
          })
      }
      .width(105)
      .height(this.irHeight)
    }
    .width('100%')
    .padding({ left: 12, right: 12 })
    .margin({ top: 20 })
  }

  updateCommands(width: number, height: number) {
    const ctx = this.getUIContext()
    const radius = ctx.vp2px(12)
    this.commands =
      `M0,0 L${width - ctx.vp2px(20)},0 A${radius},${radius} 0 0,1 ${width -
      ctx.vp2px(8)},${radius} L${width},${height -
        radius} L${width},${height} L0,${height} Z`
  }
}