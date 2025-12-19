/**
 * @fileName : EmojiView.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : emoji 组件
 */
import { BaseDataSource } from "./BaseDataSource";


function emojiList(): string[] {
  return [
    "😎", "😍", "😘", "😚", "🙂", "🤗", "🤔", "😑",
    "🙄", "😏", "😣", "😥", "🤐", "😯", "😪", "😫",
    "😴", "😜", "😝", "🤤", "😳", "🤭", "😂", "😄",
    "😭", "❤️", "🤗", "🌞", "🀄", "💰", "👌", "🤞",
    "🐮", "🍀", "😁", "🤣", "😅", "😆", "😉", "😊",
    "😋", "😓", "😒", "😔", "😕", "🙃", "🤑", "😲",
    "👍", "🙁", "😖", "😤", "😢", "😨", "😩", "😬",
    "😰", "😱", "😵", "😡", "😠", "💪", "🤝", "🤩",
    "🥰", "💝", "🌷", "🌼", "🌻", "🌺", "💯", "🙏",
    "🏆", "🌛", "💣", "🚀", "🎉", "😷", "🤒", "🤕",
    "🤢", "🤧", "😇", "🤠", "🍺", "🌹", "🤡", "🤥",
    "🤓", "😈", "👹", "👺", "💀", "👻", "👽", "🤖",
    "💩", "😾", "😸", "😹", "😻", "😼", "😽", "🙀",
    "😿"
  ]
}

export class EmojiDataSource extends BaseDataSource<string> {
  list: string[] = [];

  public totalCount(): number {
    return this.list.length;
  }

  public getData(index: number): string {
    return this.list[index];
  }

  public initList(data: string[]): void {
    this.list.push(...data);
    this.notifyDataAdd(0, this.list.length)
  }
}

@Component
export default struct EmojiView {
  @Link enableDel: boolean
  onSelect?: (emoji: string) => void
  onDelete?: () => void
  private dataSource: EmojiDataSource = new EmojiDataSource()

  aboutToAppear(): void {
    this.dataSource.initList(emojiList())
  }

  build() {
    Stack() {
      Grid() {
        LazyForEach(this.dataSource, (e: string) => {
          GridItem() {
            Text(e).fontSize(22).textAlign(TextAlign.Center).width('100%').aspectRatio(1)
          }.onClick(() => {
            this.onSelect?.(e)
          })
        })
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .width('100%')
      .height('100%')
      .cachedCount(16)
      .columnsTemplate('1fr '.repeat(8))
      .maxCount(this.dataSource.totalCount())

      Row() {
        Image($r('app.media.chat_em_del'))
          .width(16)
          .opacity(this.enableDel ? 1 : 0.3)
      }
      .borderRadius(5)
      .backgroundColor('#fff')
      .padding({
        left: 14,
        right: 14,
        top: 12,
        bottom: 12
      })
      .offset({ x: -15, y: -10 })
      .onClick(() => {
        if (this.enableDel) {
          this.onDelete?.()
        }
      })
    }
    .height('100%')
    .width('100%')
    .align(Alignment.BottomEnd)
  }
}