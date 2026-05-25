# 如何实现横竖屏切换？

在视频播放或者股票行情图横竖屏切换如何实现？

预览效果：
![](./screenrotate.gif)

1、在全屏展示时，通常需要开启沉浸式效果

```extendtypescript
window.getLastWindow(this.getUIContext().getHostContext()).then(win => {
  win.setWindowLayoutFullScreen(true)
});
```

2、使用 setPreferredOrientation 方法实现屏幕旋转

```extendtypescript
window.getLastWindow(this.getUIContext().getHostContext()).then(win => {
  this.isFullScreen = !this.isFullScreen;
  win.setPreferredOrientation(this.isFullScreen ? window.Orientation.AUTO_ROTATION_LANDSCAPE :
    window.Orientation.PORTRAIT)
});
```

完整的demo:

```extendtypescript
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
```
