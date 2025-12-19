/**
 * @fileName : SwiperAnimation.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 文件描述
 */


@Component
export struct SwiperAnimation {
  @State list: string[] = [
    'https://picsum.photos/300/200?random=1',
    'https://picsum.photos/300/200?random=2',
    'https://picsum.photos/300/200?random=3',
    'https://picsum.photos/300/200?random=4',
    'https://picsum.photos/300/200?random=5']
  @State scaleList: number[] = [1];
  @State opacityList: number[] = [1];
  private indicatorController: IndicatorComponentController = new IndicatorComponentController();

  build() {
    Column() {
      Swiper() {
        ForEach(this.list, (item: string, index: number) => {
          Image(item)
            .width("calc(100%-120vp)")
            .height(200)
            .borderRadius(10)
            .scale({ x: this.scaleList[index] || 0.87, y: this.scaleList[index] || 0.87 })
            .opacity(this.opacityList[index] || 1)
        }, (item: string, index: number) => item + index)
      }
      .prevMargin(45)
      .nextMargin(45)
      .loop(true)
      .autoPlay(true)
      .interval(5000)
      .indicator(this.indicatorController)
      .indicatorInteractive(true)
      .width('100%')
      .onChange((index) => {
      })
      .customContentTransition({
        // 页面移除视窗时超时1000ms下渲染树
        timeout: 1000,
        // 对视窗内所有页面逐帧回调transition，在回调中修改opacity、scale、translate、zIndex等属性值，实现自定义动画
        transition: (proxy: SwiperContentTransitionProxy) => {
          const scale = 0.87
          const scaleFactor = 1 - scale * Math.abs(proxy.position); // 最小缩放为 scale
          this.scaleList[proxy.index] = Math.max(scaleFactor, scale);

          const opacity = 0.5
          const opacityFactor = 1 - opacity * Math.abs(proxy.position); // 最小透明度为 opacity
          this.opacityList[proxy.index] = Math.max(opacityFactor, opacity);
        }
      })

      IndicatorComponent(this.indicatorController)
        .initialIndex(1)
        .width('100%')
        .style(
          new DotIndicator()
            .itemWidth(6)
            .itemHeight(6)
            .selectedItemWidth(15)
            .selectedItemHeight(6)
            .color('#fff')
            .selectedColor('#ff0090ff')
        )
        .loop(true)
        .count(this.list.length)
        .onChange((index: number) => {
        })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .backgroundColor('#aaa')
    .padding({
      top: 20
    })
  }
}