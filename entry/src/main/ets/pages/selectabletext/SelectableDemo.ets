/**
 * @fileName : SelectableDemo.ets
 * @author : @cxy
 * @date : 2025/12/22
 * @description : 长按复制选择弹窗
 */

import {
  MenuContainer, SelectableMenuItem, SelectableModel, SelectableText
} from '@cxy/selecteablemenu'

enum MessageType {
  Text = 0,
  Image = 1
}

/**
 * ChatMessage 需要继承至 SelectableModel
 */
@Observed
class ChatMessage extends SelectableModel {
  id: number = 0
  type: MessageType = MessageType.Text
  text: string = ''
  imageUrl: ResourceStr = ''

  constructor(id: number) {
    super()
    this.id = id
  }

  /**
   * 覆盖父类方法，消息是否可以复制
   * @returns
   */
  public canCopy(): boolean {
    return this.type === MessageType.Text && this.text.length > 0
  }

  /**
   * 覆盖父类方法，消息可复制的文本
   * @returns
   */
  public copyText(): string {
    return this.text
  }

  /**
   * 覆盖父类方法，消息的弹出菜单项
   * @returns 菜单数组
   */
  public getMenus(): SelectableMenuItem[] {
    const menus: SelectableMenuItem[] = []

    if (this.canCopy()) {
      menus.push({
        title: '复制',
        icon: $r("app.media.copy"),
        action: () => {
          // 复制文本到剪贴板
          const text = this.copyText()
          // TODO: 调用系统复制API
          // ...

          this.onDidMenuItem?.(true)
        }
      })
    }

    if (this.canCopy() && this.selectionStart >= 0 && this.selectionEnd > 0 &&
      this.selectionEnd - this.selectionStart < this.copyText().length) {
      menus.push({
        title: '全选',
        icon: $r("app.media.edit"),
        action: () => {
          this.onDidMenuItem?.(false, true)
        }
      })
    }

    menus.push({
      title: '转发',
      icon: $r("app.media.forward"),
      action: () => {
        // TODO: 处理转发逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    menus.push({
      title: '收藏',
      icon: $r("app.media.favor"),
      action: () => {
        // TODO: 处理收藏逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    menus.push({
      title: '删除',
      icon: $r("app.media.delete"),
      action: () => {
        // TODO: 处理删除逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    menus.push({
      title: '多选',
      icon: $r("app.media.sort"),
      action: () => {
        // TODO： 处理多选逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    return menus
  }
}

@Component
export struct SelectableDemo {
  @State messages: Array<ChatMessage> = []

  aboutToAppear(): void {
    this.initMessages()
  }

  initMessages() {
    const message1 = new ChatMessage(1)
    message1.text = '这是一条可以长按选择的文本消息'

    const message2 = new ChatMessage(2)
    message2.type = MessageType.Image
    message2.imageUrl = $r('app.media.startIcon')

    const message3 = new ChatMessage(3)
    message3.text = 'Hello, SelectableMenu：https://github.com/iHongRen/SelectableMenu'

    const message4 = new ChatMessage(4)
    message4.text = `SelectableMenu - 鸿蒙文本选择菜单组件
文本选择菜单组件，主要用于聊天对话框中的长按文本选择和操作功能。

功能特性

文本选择：支持长按选择文本自动全选：长按时默认选中全部文本内容自定义菜单：支持自定义菜单项，包括图标、标题和操作
安装使用
ohpm install @cxy/selecteablemenu
或在项目 oh-package.json5 添加依赖，然后同步项目`

    this.messages.push(message1)
    this.messages.push(message2)
    this.messages.push(message3)
    this.messages.push(message4)
  }

  build() {
    Column() {
      List({ space: 12 }) {
        ForEach(this.messages, (message: ChatMessage) => {
          ListItem() {
            if (message.type === MessageType.Text) {
              // 文本消息
              Column() {
                SelectableText({
                  model: message,
                  // text: message.text,
                  fontSize: 16,
                  fontColor: '#333333',
                  caretColor: '#007AFF',
                  selectedBackgroundColor: '#33007AFF',
                  enableDataDetector: true
                }) {
                  Span(message.text) //SelectableText子组件与Text的子组件一致
                }
              }
              .backgroundColor('#ffffff')
              .borderRadius(12)
              .padding(16)
              .alignItems(HorizontalAlign.Start)

            } else if (message.type === MessageType.Image) {
              // 图片消息
              MenuContainer({
                model: message,

              }) {
                Image(message.imageUrl)
                  .width(150)
              }
            }
          }

        }, (message: ChatMessage) => message.id.toString())
      }
      .backgroundColor('#f5f5f5')
      .padding(15)
      .layoutWeight(1)
    }
    .parallelGesture(
      TapGesture()
        .onAction((event) => {
          SelectableModel.onPageTap?.(event)
        })
    )
  }
}