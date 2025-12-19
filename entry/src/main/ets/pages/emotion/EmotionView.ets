/**
 * @fileName : EmotionView.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 文件描述
 */
import { EmotionComponent } from "./EmotionComponent"
import { Emotion } from "./EmotionImage"

@Component
export struct EmotionView {
  @State enableSend: boolean = false
  @State content: string = ''
  private controller: TextInputController = new TextInputController()

  build() {
    Column() {
      TextInput({
        text: this.content,
        controller: this.controller
      })
        .onChange(() => {
          this.enableSend = this.content.length > 0
        })
        .fontSize(20)
        .padding({ left: 20, right: 20 })
        .width('100%')

      EmotionComponent({
        emotionHeight: 310,
        enableSend: this.enableSend,
        onSelectEmoji: (e: string) => {
          this.content = this.content + e
        },
        onDeleteEmoji: () => {
        },
        onSendEmotion: (e?: Emotion) => {
          console.dir(e)
        }
      })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
  }
}