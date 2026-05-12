/**
 * @fileName : TabScroll.ets
 * @author : @cxy
 * @date : 2026/5/12
 * @description : tab和内嵌Scroll左右滑动冲突解决。
 */

@Component
export struct TabScroll {
  @State currentIndex: number = 0;
  @State selectedIndex: number = 0;
  @State fontColor: string = '#182431';
  @State selectedFontColor: string = '#007DFF';
  controller?: TabsController = new TabsController();
  @State currScale: number = 1;
  private scroller: Scroller = new Scroller();

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(
          this.selectedIndex === index
            ? this.selectedFontColor
            : this.fontColor
        )
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })

      Divider()
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.selectedIndex === index ? 1 : 0)
    }
    .width('100%')
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor(Color.Green)
        }
        .tabBar(this.tabBuilder(0, 'green'))

        TabContent() {
          this.scrollBuilder()
        }
        .tabBar(this.tabBuilder(1, 'image'))

        TabContent() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor(Color.Brown)
        }
        .tabBar(this.tabBuilder(2, 'brown'))
      }
      .width('100%')
      .height('100%')
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        this.selectedIndex = targetIndex;
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  scrollBuilder() {
    Scroll(this.scroller) {
      Image($r('app.media.startIcon'))
        .width('100%')
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.FREE)
    .minZoomScale(1)
    .maxZoomScale(2)
    .enableBouncesZoom(true)
    .onDidZoom((scale: number) => {
      this.currScale = scale;
    })
    .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
      others: Array<GestureRecognizer>): GestureJudgeResult => {
      if (!current) {
        return GestureJudgeResult.CONTINUE;
      }

      if (current.isBuiltIn() && current.getType() === GestureControl.GestureType.PAN_GESTURE) {
        const pan = event as PanGestureEvent;

        // 横向滑动
        const isHorizontal = Math.abs(pan.offsetX) > Math.abs(pan.offsetY);
        if (!isHorizontal) {
          return GestureJudgeResult.CONTINUE;
        }

        // 未放大
        if (this.currScale <= 1) {
          return GestureJudgeResult.REJECT;
        }

        // 当前 scroll 偏移
        const xOffset = this.scroller.currentOffset().xOffset;

        // 左滑
        if (pan.offsetX < 0) {
          // 已经到最右
          if (this.scroller.isAtEnd()) {
            return GestureJudgeResult.REJECT;
          }
        }

        // 右滑
        if (pan.offsetX > 0) {
          // 已经到最左
          if (xOffset <= 0) {
            return GestureJudgeResult.REJECT;
          }
        }

        // 中间区域 Scroll
        return GestureJudgeResult.CONTINUE;
      }

      return GestureJudgeResult.CONTINUE;
    },
      true
    )
  }
}