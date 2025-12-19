/**
 * @fileName : ExpandText.ets
 * @author : @cxy
 * @date : 2025/12/18
 * @description : 实现文本断行显示展开收起功能
 */
import { display, LengthMetrics } from '@kit.ArkUI'


@Component
export struct ExpandText {
  @State message: string = ''
  @State isCollapseStatus: boolean = false //是否是折叠状态
  @State breakContent: string = ''
  private content = '这个demo演示了限制文本行数，超出部分显示...展开，文本高亮，点击展开后显示全部文本并显示收起按钮，点击后收起到指定行。未超出时，显示原文本。'
  private expand: string = '展开'
  private collapse: string = '收起'
  private fSize: number = 15
  private limitLine: number = 2

  build() {
    Column() {
      Text() {
        Span(this.message)
        if (this.breakContent) {
          Span(this.isCollapseStatus ? this.expand : this.collapse)
            .fontColor(Color.Blue)
            .onClick(() => {
              this.isCollapseStatus = !this.isCollapseStatus
              this.message = this.isCollapseStatus ? this.breakContent : this.content
            })
        }
      }
      .lineSpacing(LengthMetrics.vp(8))
      .fontSize(this.fSize)
      .width('100%')
    }
    .width('100%')
    .padding(40)
  }

  onDidBuild(): void {
    this.handleContent()
  }

  private handleContent() {
    const context = this.getUIContext()
    const screen = display.getDefaultDisplaySync()
    const screenWidth = context.px2vp(screen.width)

    const width = screenWidth - 40 * 2
    const textSizeShowHeight = this.getContentHeight(this.content, width, this.fSize, this.limitLine)
    const isOver2Line = this.isOverMaxLines(this.content, width, textSizeShowHeight, this.fSize, this.limitLine)
    if (isOver2Line) {
      this.isCollapseStatus = true
      const text = this.content.slice(0, 70) //超过70字的部分去掉，减少不必要的递归
      this.breakContent = this.getBreakText(text, this.expand, width, textSizeShowHeight, this.fSize, this.limitLine)
      this.message = this.breakContent
    } else {
      this.isCollapseStatus = false
      this.message = this.content
    }
  }

  /**
   * 获取文本所需高度
   * @param content 文本内容
   * @param width 文本宽度
   * @param fontSize 文本字体大小
   * @param maxLines 文本显示行数
   * @returns 所占高度
   */
  private getContentHeight(content: string, width: number, fontSize: number, maxLines: number): number {
    const context = this.getUIContext()
    const textSizeShow: SizeOptions = context.getMeasureUtils().measureTextSize({
      textContent: content,
      constraintWidth: width,
      fontSize: fontSize,
      overflow: TextOverflow.Ellipsis,
      maxLines: maxLines
    })
    return textSizeShow.height as number || 0
  }

  /**
   * 判断文本内容是否超出指定行数
   * @param content 文本内容
   * @param width  文本宽度
   * @param height  指定行数后计算得到的高度
   * @param fontSize 文本字体
   * @param maxLines 指定行数
   * @returns
   */
  private isOverMaxLines(content: string, width: number, height: number, fontSize: number, maxLines: number): boolean {
    const textSizeShowHeight2 = this.getContentHeight(content, width, fontSize, 2000000)
    if (textSizeShowHeight2 > height) {
      return true
    }
    return false
  }

  /**
   * 获取折段后的文本
   * @param content 文本内容
   * @param tail 尾部拼接文本
   * @param width  文本宽度
   * @param height  指定行数后计算得到的高度
   * @param fontSize 文本字体
   * @param limitLines 限制行数
   * @returns
   */
  private getBreakText(content: string, tail: string, width: number, height: number, fontSize: number,
    limitLines: number): string {
    const isOver2Line = this.isOverMaxLines(content + '...' + tail, width, height, fontSize, limitLines)
    if (isOver2Line) {
      const newContent = content.slice(0, -1)
      return this.getBreakText(newContent, tail, width, height, fontSize, limitLines)
    }
    return content + '...'
  }
}