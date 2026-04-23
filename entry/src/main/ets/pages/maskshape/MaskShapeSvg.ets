/**
 * @fileName : MaskShapeSvg.ets
 * @author : @cxy
 * @date : 2026/4/23
 * @description : PathShape 实现带斜切、圆角、渐变的图形
 */

import { PathShape } from "@kit.ArkUI"

@Component
export struct MaskShapeSvg {
  @State commands: string = ''
  @State shapeWidth: number = 250
  @State shapeHeight: number = 80
  @State shapeBorderWidth: number = 2
  @State isShowBorder: boolean = true

  build() {
    Column({ space: 30 }) {
      Row({ space: 20 }) {
        Text('修改宽度')
          .fontColor('#fff')
          .padding(10)
          .onClick(() => {
            this.shapeWidth += 10
          })

        Text('修改高度')
          .fontColor('#fff')
          .padding(10)
          .onClick(() => {
            this.shapeHeight += 10
          })

        Text('显隐边框')
          .fontColor('#fff')
          .padding(10)
          .onClick(() => {
            this.isShowBorder = !this.isShowBorder
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Shape() {
        if (this.isShowBorder) {
          Path()
            .width('100%')
            .height('100%')
            .stroke(Color.White)
            .strokeWidth(this.shapeBorderWidth)
            .commands(this.commands)
            .fill(Color.Transparent)
        }
      }
      .maskShape(new PathShape().commands(this.commands).fill(Color.White))
      .width(this.shapeWidth)
      .height(this.shapeHeight)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        const width = newValue.width as number
        const height = newValue.height as number
        this.updateCommands(width, height)
      })
      .linearGradient({
        direction: GradientDirection.Right,
        colors: [['#f11a76', 0], ['#ff7cb5', 1]]
      })
    }
    .backgroundColor('#999')
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  updateCommands(width: number, height: number) {
    this.commands = this.generateSvgPath(width, height)
  }

  /**
   * 带斜切和圆角的 SVG 路径字符串
   * @param width
   * @param height
   * @returns
   */
  generateSvgPath(width: number, height: number): string {
    const ctx = this.getUIContext()

    // 基础几何参数：通过这些变量可以控制整个形状的大小、位置和圆角
    const x = ctx.vp2px(0) // 左侧基准坐标
    const y = ctx.vp2px(0) // 顶部基准坐标
    const w = ctx.vp2px(width) // 顶部宽度（从左边界到右上圆角顶点的距离）
    const h = ctx.vp2px(height) // 整体高度
    const slant = ctx.vp2px(22) // 右侧斜边相对于顶部的水平偏移量

    // 四个角的圆角半径定义
    const rTopLeft = ctx.vp2px(10)
    const rTopRight = ctx.vp2px(10)
    const rBottomRight = ctx.vp2px(10)
    const rBottomLeft = ctx.vp2px(10)

    // 派生计算变量
    const rightTop = x + w // 右上角顶点 X 坐标
    const rightBottom = rightTop - slant // 右下角顶点 X 坐标
    const bottomY = y + h // 底部 Y 坐标
    const edgeOffset = ctx.vp2px(2) // 斜边圆角终点的水平偏移量，用于配合斜率确保过渡自然

    // 使用模板字符串构建 SVG 路径命令
    // M: 移动到起点 (左上圆角结束点)
    // L: 画直线到右上圆角起点
    // Q: 二次贝塞尔曲线实现圆角
    // Z: 闭合路径
    const rawCommands = `M ${x + rTopLeft} ${y}
                     L ${rightTop - rTopRight} ${y}
                     Q ${rightTop} ${y} ${rightTop - edgeOffset} ${y + rTopRight}
                     L ${rightBottom + edgeOffset} ${bottomY - rBottomRight}
                     Q ${rightBottom} ${bottomY} ${rightBottom - rBottomRight} ${bottomY}
                     L ${x + rBottomLeft} ${bottomY}
                     Q ${x} ${bottomY} ${x} ${bottomY - rBottomLeft}
                     L ${x} ${y + rTopLeft}
                     Q ${x} ${y} ${x + rTopLeft} ${y} Z`

    return rawCommands
  }
}