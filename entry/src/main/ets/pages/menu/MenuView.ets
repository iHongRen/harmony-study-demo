/**
 * @fileName : MenuView.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 金刚区
 */

export class MenuViewItem {
  name: string = ''
  url: ResourceStr = ''
}

@Component
export struct MenuView {
  @State offsetX: number = 0
  @State menuWidth: number = 0
  @State menus: MenuViewItem[] = []
  private columnCount: number = 5
  private scroller: Scroller = new Scroller()

  onDidBuild(): void {
    const list: MenuViewItem[] = []
    for (let index = 0; index < 8; index++) {
      list.push({
        name: 'name' + index,
        url: $r('app.media.startIcon')
      })
    }
    this.menus = list
  }

  build() {
    Column({ space: 8 }) {
      List({ scroller: this.scroller, space: 5 }) {
        ForEach(this.menus, (item: MenuViewItem) => {
          ListItem() {
            Column({ space: 5 }) {
              Image(item.url)
                .width(36)
                .height(36)
                .objectFit(ImageFit.Contain)

              Text(item.name)
                .fontColor('#666')
                .fontSize(13)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .textAlign(TextAlign.Center)
            }
            .constraintSize({
              minWidth: (this.menuWidth - this.columnCount * (this.columnCount - 1)) / this.columnCount
            })
            .alignItems(HorizontalAlign.Center)
          }
          .onClick(() => {

          })

        }, (item: MenuViewItem) => item.name)
      }
      .height(60)
      .width('100%')
      .listDirection(Axis.Horizontal)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        const count = this.columnCount
        if (this.menus.length > count) {
          const offsetX = this.scroller.currentOffset().xOffset
          const contentWidth = this.menus.length * (this.menuWidth / count)
          let precent = offsetX / (contentWidth - this.menuWidth)
          precent = Math.min(1, precent)
          precent = Math.max(0, precent)
          this.offsetX = (30 - 14 - 2) * precent
        }
      })

      if (this.menus.length > this.columnCount) {
        Row() {
          Row()
            .height(4)
            .borderRadius('50%')
            .width(14)
            .backgroundColor('#ff005eff')
            .offset({ x: this.offsetX })
        }
        .backgroundColor('#DBEDFF')
        .borderRadius('50%')
        .width(30)
        .padding(1)
      }
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.menuWidth = newValue.width as number
    })
    .margin({ top: 20 })
  }
}