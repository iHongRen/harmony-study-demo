/**
 * @fileName : EmotionView.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 表情面板示例
 */
import { EmotionComponent } from "./EmotionComponent"
import { Emotion } from "./EmotionImage"
import { window } from "@kit.ArkUI"
import { KeyboardAvoidMode } from '@kit.ArkUI';

enum ShowType {
  None = 0,
  Text = 1,
  Emotion = 2
}

@Component
export struct EmotionView {
  @State enableSend: boolean = false
  @State showType: ShowType = ShowType.None
  @State keybordHeight: number = 314
  @State bottomSafeHeight: number = 34 //TODO：监听avoidAreaChange获取
  private controller: RichEditorController = new RichEditorController()

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext()
    if (context) {
      this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.NONE)

      window.getLastWindow(context).then((win) => {
        win.setWindowLayoutFullScreen(true)
        win.on('keyboardHeightChange', this.keyboardHeightChange)
      })
    }
  }

  aboutToDisappear(): void {
    const context = this.getUIContext().getHostContext()
    if (context) {
      window.getLastWindow(context).then((win) => {
        win.off('keyboardHeightChange', this.keyboardHeightChange)
      })
    }
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        RichEditor({
          controller: this.controller
        })
          .id('richEditorId')
          .backgroundColor('#f0f0f0')
          .borderRadius(6)
          .onEditingChange((isEditing) => {
            if (isEditing) {
              this.showType = ShowType.Text
            } else {
              if (this.showType === ShowType.Text) {
                this.showType = ShowType.None
              }
            }
          })
          .onDidChange((rangeBefore: TextRange, rangeAfter: TextRange) => {
            this.enableSend = this.controller.getSpans().length > 0
          })
          .layoutWeight(1)

        Text(this.showType === ShowType.Emotion ? '文本' : '表情')
          .fontSize(20)
          .onClick(() => {
            if (this.showType === ShowType.Emotion) {
              this.showType = ShowType.Text
              focusControl.requestFocus('richEditorId');
            } else {
              this.controller.stopEditing()
              this.showType = ShowType.Emotion
            }
          })
      }
      .alignItems(VerticalAlign.Center)
      .padding(10)

      EmotionComponent({
        emotionHeight: this.keybordHeight,
        enableSend: this.enableSend,
        onSelectEmoji: (e: string) => {
          this.controller.addTextSpan(e)
        },
        onDeleteEmoji: () => {
          // TODO： 删除
          // this.controller.deleteSpans()
        },
        onSendEmotion: (e?: Emotion) => {
          console.dir(e)
        }
      })
        .visibility(this.showType === ShowType.Emotion ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
    .padding({
      bottom: this.getBottomHeight()
    })

  }

  getBottomHeight(): number {
    if (this.showType === ShowType.Text) {
      return this.keybordHeight
    }
    if (this.showType === ShowType.Emotion) {
      return 0
    }
    return this.bottomSafeHeight //底部安全区域高度，
  }

  private keyboardHeightChange = (data: number) => {
    if (data > 0) {
      this.keybordHeight = this.getUIContext().px2vp(data)
    }
  }
}