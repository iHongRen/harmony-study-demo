# 如何修改web资讯页字体大小

web资讯页，点击设置字体，弹出窗动态调整字体大小

1、使用分段空间 Segment 作为字号选择组件
2、通过设置web的 textZoomRatio 属性调整字体大小

其他方案，通过runJavaScript 执行js代码，修改document.body.style。
const jsCode = `
  document.body.style.transform = 'scale(${scale})';
  document.body.style.transformOrigin = '0 0';
  document.body.style.width = 'calc(100% / ${scale})';
  `
this.controller.runJavaScript(jsCode)

```extendtypescript
/**
 * @fileName : WebFont.ets
 * @author : @cxy
 * @date : 2025/12/20
 * @description : 修改web资讯页字体大小
 */
import { webview } from "@kit.ArkWeb"
import { ItemRestriction, SegmentButton, SegmentButtonOptions, SegmentButtonTextItem } from "@kit.ArkUI";

@Component
export struct WebFont {
@State isShowPopup: boolean = false
@State tabOptions: SegmentButtonOptions = SegmentButtonOptions.tab({
  buttons: [{ text: '小号' }, { text: '中号' }, { text: '大号' },
    { text: '超大号' }] as ItemRestriction<SegmentButtonTextItem>,
  backgroundBlurStyle: BlurStyle.BACKGROUND_THICK
});
@State @Watch('onSegmentButtonChange') tabSelectedIndexes: number[] = [1];
@State textZoomRatio: number = 100
private controller: WebviewController = new webview.WebviewController()
private fontScaleList: number[] = [80, 100, 120, 140]

aboutToAppear(): void {
  webview.WebviewController.setWebDebuggingAccess(true)
}

onSegmentButtonChange() {
  const index = this.tabSelectedIndexes[0]
  const scale = this.fontScaleList[index] as number
  this.textZoomRatio = scale

  // 另一种方案
  // const jsCode = `
  //   document.body.style.transform = 'scale(${scale})';
  //   document.body.style.transformOrigin = '0 0';
  //   document.body.style.width = 'calc(100% / ${scale})';
  // `
  // this.controller.runJavaScript(jsCode)
}

build() {
  Column() {
    Row() {
      Text('Web修改字体大小')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text() {
          SymbolSpan($r('sys.symbol.textformat_size_square'))
            .fontWeight(FontWeight.Medium)
            .fontSize(22)
        }
      }
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.isShowPopup = true
      })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding(15)

    Web({ src: 'https://baijiahao.baidu.com/s?id=1851809572329822689', controller: this.controller })
      .layoutWeight(1)
      .textZoomRatio(this.textZoomRatio)
  }
  .bindSheet($$this.isShowPopup, this.fontBuilder, {
    height: 250,
    title: {
      title: '字体大小设置'
    }
  })
}

@Builder
fontBuilder() {
  Column({ space: 30 }) {
    Text('点击下方滑块，可设置Web字体大小')
    SegmentButton({
      options: this.tabOptions,
      selectedIndexes: $tabSelectedIndexes
    })
      .height(44)
  }
  .padding(20)
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .width('100%')
}
}
```