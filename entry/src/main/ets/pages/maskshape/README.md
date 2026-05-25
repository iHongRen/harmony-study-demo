# 如何使用 maskShape + PathShape 实现带斜切、圆角、渐变的图形

如图，右侧带有斜切效果，四角圆角过渡自然。

![](./maskshape.gif)

**实现细节：**

1. 使用 maskShape 为组件添加指定形状的遮罩，maskShape 支持 CircleShape | EllipseShape | PathShape | RectShape。
2. 本示例使用 PathShape，通过 commands 设置符合 SVG 路径描述规范的命令字符串来定义形状，单位为 px。
3. Shape 组件内嵌套 Path 绘制描边（白色边框），maskShape 绘制填充（白色遮罩），两者共用同一套 commands，确保描边与遮罩形状一致。
4. 通过 onAreaChange 监听组件尺寸变化，动态调用 vp2px 进行单位转换并重新生成 SVG 路径，适配不同宽高。
5. 使用二次贝塞尔曲线（Q 命令）实现四角圆角过渡，斜边处通过 edgeOffset 偏移量配合斜率确保圆角过渡自然。
6. 结合 linearGradient 实现渐变填充效果。



**关键技术点：**

- M：移动到起点
- L：画直线
- Q：二次贝塞尔曲线实现圆角
- Z：闭合路径
- vp2px：将 vp 单位转换为 px，因为 SVG commands 的单位为 px



**完整的demo：**

```extendtypescript
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

    const x = ctx.vp2px(0)
    const y = ctx.vp2px(0)
    const w = ctx.vp2px(width)
    const h = ctx.vp2px(height)
    const slant = ctx.vp2px(22)

    const rTopLeft = ctx.vp2px(10)
    const rTopRight = ctx.vp2px(10)
    const rBottomRight = ctx.vp2px(10)
    const rBottomLeft = ctx.vp2px(10)

    const rightTop = x + w
    const rightBottom = rightTop - slant
    const bottomY = y + h
    const edgeOffset = ctx.vp2px(2)

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
```