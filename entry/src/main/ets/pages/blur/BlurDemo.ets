/**
 * @fileName : BlurDemo.ets
 * @author : @cxy
 * @date : 2026/4/17
 * @description : 负一屏实现
 */
import { display, window } from "@kit.ArkUI"

@Component
export struct BlurDemo {
  @State private translateX: number = 0
  private startTime: number = 0
  private startTranslateX: number = 0
  private contentWidth: number = 0
  private maxBlur: number = 50
  private duration: number = 300
  private threshold: number = 0.5
  private panOption: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Left | PanDirection.Right
  })

  // 判断是否为快速滑动
  isSwipeGesture(distance: number, duration: number): boolean {
    const speed = distance / duration;
    return speed > 0.5; // 速度阈值
  }

  blurRadius(): number {
    return Math.max(0,
      Math.min(this.maxBlur, (this.contentWidth + this.translateX) / this.contentWidth * this.maxBlur))
  }

  shouldShowBlur(): boolean {
    return this.translateX > -this.contentWidth
  }

  aboutToAppear(): void {
    const width = this.getUIContext().px2vp(display.getDefaultDisplaySync().width)
    this.contentWidth = width
    this.translateX = -width

    const context = this.getUIContext().getHostContext()
    if (context) {
      // 开启沉浸式全屏
      window.getLastWindow(context).then((win) => {
        win.setWindowLayoutFullScreen(true)
      })
    }
  }

  build() {
    Column() {
      Stack() {
        this.mainBuilder()
        this.blurBuilder()
        this.sideBuilder()
      }
      // 使用单个PanGesture，通过速度判断区分拖拽和滑动
      .gesture(
        PanGesture(this.panOption)
          .onActionStart(() => {
            this.startTranslateX = this.translateX
            this.startTime = Date.now()
          })
          .onActionUpdate((event: GestureEvent) => {
            if (event) {
              this.updateOffsetByGesture(event.offsetX)
            }
          })
          .onActionEnd((event: GestureEvent) => {
            const duration = Date.now() - this.startTime
            const distance = Math.abs(event.offsetX)

            // 根据速度判断是滑动还是拖拽
            if (this.isSwipeGesture(distance, duration)) {
              // 快速滑动，执行切换操作
              this.handleSwipeGesture(event)
            } else {
              // 慢速移动，保持拖拽位置并吸附到边界
              this.snapToEdge()
            }
          })
      )
    }
  }

  @Builder
  mainBuilder() {
    Image($r('app.media.phone_bg'))
      .width('100%')
      .height('100%')
  }

  @Builder
  blurBuilder() {
    Stack()
      .width('100%')
      .height('100%')
      .backdropBlur(this.blurRadius())
      .visibility(this.shouldShowBlur() ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  sideBuilder() {
    List({ space: 20 }) {
      ListItem() {
        this.sectionHeader()
      }

      ListItem() {
        this.weatherCard()
      }

      ListItem() {
        this.memoCard()
      }

      ListItem() {
        this.healthCard()
      }

      ListItem() {
        this.newsCard()
      }
    }
    .padding({ left: 20, right: 20 })
    .contentStartOffset(50)
    .contentEndOffset(50)
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .translate({ x: this.translateX })
  }

  @Builder
  sectionHeader() {
    Column({ space: 8 }) {
      Text('今日卡片')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')

      Text('向右滑动打开负一屏，向左滑动隐藏它')
        .fontSize(14)
        .fontColor('#6e6e73')
        .lineHeight(20)
    }
    .width('100%')
  }

  @Builder
  weatherCard() {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 6 }) {
          Text('天气提醒')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1c1c1e')

          Text('今天多云，最高 21℃，适合出行')
            .fontSize(14)
            .fontColor('#6e6e73')
            .lineHeight(20)
        }

        Stack() {
          Text('☀')
            .fontSize(20)
            .fontColor(Color.White)
        }
        .width(42)
        .height(42)
        .borderRadius('50%')
        .backgroundColor('#FF9F0A')

      }
      .justifyContent(FlexAlign.SpaceBetween)

      this.cardDivider()

      Row({ space: 12 }) {
        this.smallInfoBlock('风速', '5 km/h', '#34C759')
        this.smallInfoBlock('湿度', '62%', '#5AC8FA')
      }
    }
    .width('100%')
    .padding({
      top: 22,
      bottom: 22,
      left: 18,
      right: 18
    })
    .backgroundColor('rgba(255,255,255,0.95)')
    .borderRadius(20)
    .shadow({
      color: 'rgba(0,0,0,0.08)',
      offsetY: 10,
      radius: 22
    })
  }

  @Builder
  memoCard() {
    Column({ space: 12 }) {
      Text('备忘录')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1c1c1e')

      Text('15:00 产品评审会议17:30 线上读书会')
        .fontSize(14)
        .fontColor('#6e6e73')
        .lineHeight(22)

      Row({ space: 10 }) {
        Text('今天')
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor('#ffffff')
          .backgroundColor('#34C759')
          .padding({
            left: 10,
            right: 10,
            top: 4,
            bottom: 4
          })
          .borderRadius(12)

        Text('会议')
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor('#ffffff')
          .backgroundColor('#007AFF')
          .padding({
            left: 10,
            right: 10,
            top: 4,
            bottom: 4
          })
          .borderRadius(12)
      }
    }
    .width('100%')
    .padding({
      top: 22,
      bottom: 22,
      left: 18,
      right: 18
    })
    .backgroundColor('rgba(255,255,255,0.95)')
    .borderRadius(20)
    .shadow({
      color: 'rgba(0,0,0,0.08)',
      offsetY: 10,
      radius: 22
    })
  }

  @Builder
  healthCard() {
    Column({ space: 14 }) {
      Text('健康目标')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1c1c1e')

      Row({ space: 14 }) {
        this.statBlock('步数', '8,432', '#34C759')
        this.statBlock('睡眠', '7.5h', '#5AC8FA')
      }
    }
    .width('100%')
    .padding({
      top: 22,
      bottom: 22,
      left: 18,
      right: 18
    })
    .backgroundColor('rgba(255,255,255,0.95)')
    .borderRadius(20)
    .shadow({
      color: 'rgba(0,0,0,0.08)',
      offsetY: 10,
      radius: 22
    })
  }

  @Builder
  newsCard() {
    Column({ space: 12 }) {
      Row() {
        Text('今日要闻')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1c1c1e')

        Text('查看更多')
          .fontSize(13)
          .fontColor('#007AFF')
      }
      .justifyContent(FlexAlign.SpaceBetween)

      Text('直播带货热潮继续，关注购物节优惠与物流动态。')
        .fontSize(14)
        .fontColor('#6e6e73')
        .lineHeight(20)
    }
    .width('100%')
    .padding({
      top: 22,
      bottom: 22,
      left: 18,
      right: 18
    })
    .backgroundColor('rgba(255,255,255,0.95)')
    .borderRadius(20)
    .shadow({
      color: 'rgba(0,0,0,0.08)',
      offsetY: 10,
      radius: 22
    })
  }

  @Builder
  cardDivider() {
    Stack()
      .width('100%')
      .height(1)
      .backgroundColor('rgba(0,0,0,0.08)')
  }

  @Builder
  smallInfoBlock(title: string, value: string, color: string) {
    Column({ space: 6 }) {
      Text(title)
        .fontSize(12)
        .fontColor('#6e6e73')

      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
    }
    .width('50%')
    .padding({
      top: 14,
      bottom: 14,
      left: 14,
      right: 14
    })
    .backgroundColor('rgba(255,255,255,0.95)')
    .borderRadius(18)
  }

  @Builder
  statBlock(title: string, value: string, color: string) {
    Column({ space: 6 }) {
      Text(title)
        .fontSize(12)
        .fontColor('#6e6e73')

      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
    }
    .width('48%')
    .padding({
      top: 16,
      bottom: 16,
      left: 16,
      right: 16
    })
    .backgroundColor('rgba(255,255,255,0.95)')
    .borderRadius(18)
  }

  @Builder
  cardItem(title: string, subtitle: string, accentColor: string) {
    Column({ space: 10 }) {
      Row() {
        Stack()
          .width(8)
          .height(8)
          .borderRadius('50%')
          .backgroundColor(accentColor)

        Column({ space: 4 }) {
          Text(title)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1c1c1e')

          Text(subtitle)
            .fontSize(13)
            .fontColor('#8e8e93')
            .lineHeight(20)
        }
      }
      .width('100%')

      Stack()
        .width('100%')
        .height(1)
        .backgroundColor('rgba(0,0,0,0.06)')
    }
    .width('100%')
    .padding({
      top: 18,
      bottom: 18,
      left: 18,
      right: 18
    })
    .backgroundColor('rgba(255,255,255,0.9)')
    .borderRadius(22)
    .shadow({
      color: 'rgba(0,0,0,0.08)',
      offsetY: 10,
      radius: 24
    })
  }

  private handleSwipeGesture(event: GestureEvent) {
    // 计算滑动角度
    const angle = Math.atan2(event.offsetY, event.offsetX) * 180 / Math.PI

    if (Math.abs(angle) < 45) {
      // 向右快速滑动，打开负一屏
      if (this.translateX < 0) {
        this.getUIContext().animateTo({
          duration: this.duration,
          curve: Curve.Friction
        }, () => {
          this.translateX = 0
        })
      }
    } else if (Math.abs(angle) > 135) {
      // 向左快速滑动，关闭负一屏
      this.getUIContext().animateTo({
        duration: this.duration,
        curve: Curve.Friction
      }, () => {
        this.translateX = -this.contentWidth
      })
    }
  }

  private updateOffsetByGesture(offsetX: number) {
    const newOffset = this.startTranslateX + offsetX
    // 直接限制在有效范围内，使拖动更跟手
    this.translateX = Math.max(-this.contentWidth, Math.min(0, newOffset))
  }

  private snapToEdge() {
    const threshold = -this.contentWidth * this.threshold

    let targetOffset: number = this.translateX

    if (this.translateX > threshold) {
      // 打开负一屏，执行动画到0
      targetOffset = 0
    } else {
      // 关闭负一屏，执行动画到-contentWidth
      targetOffset = -this.contentWidth
    }

    this.getUIContext().animateTo({
      duration: this.duration,
      curve: Curve.Friction
    }, () => {
      this.translateX = targetOffset
    })
  }
}