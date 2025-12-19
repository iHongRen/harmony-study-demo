/**
 * @fileName : EmotionImageView.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 表情组件
 */

import EmojiView from './EmojiView'
import { Emotion, EmotionImage } from './EmotionImage'

@Component
export struct EmotionComponent {
  @Link enableSend: boolean
  onSelectEmoji?: (value: string) => void
  onDeleteEmoji?: () => void
  onSendEmotion?: (e?: Emotion) => void
  @State selectedIndex: number = 0
  @Prop emotionHeight: number = 310

  build() {
    Column() {
      Row({ space: 8 }) {
        Image($r('app.media.chatbar_emoji'))
          .width(34)
          .height(34)
          .borderRadius(10)
          .backgroundColor(this.selectedIndex === 1 ? '#fff' : '#eee')
          .padding(6)
          .onClick(() => {
            this.selectedIndex = 0
          })
        Image($r('app.media.startIcon'))
          .width(34)
          .height(34)
          .borderRadius(10)
          .padding(5)
          .backgroundColor(this.selectedIndex === 0 ? '#fff' : '#eee')
          .onClick(() => {
            this.selectedIndex = 1
          })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .padding({ left: 15, top: 5, bottom: 5 })
      .backgroundColor('#fff')

      Swiper() {
        EmojiView({
          enableDel: this.enableSend,
          onSelect: this.onSelectEmoji,
          onDelete: this.onDeleteEmoji
        })

        EmotionImage({
          onSend: this.onSendEmotion
        })
      }
      .index(this.selectedIndex)
      .layoutWeight(1)
      .width('100%')
      .indicator(false)
      .loop(false)
      .backgroundColor('#efefef')
      .onChange((index: number) => {
        this.selectedIndex = index
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height(this.emotionHeight)
  }
}