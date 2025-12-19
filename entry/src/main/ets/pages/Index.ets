/**
 * @fileName : ExpandText.ets
 * @author : @cxy
 * @date : 2025/12/18
 * @description : 实现文本断行展开显示
 */
import { ExpandText } from './expandtext/ExpandText'

@Entry
@Component
struct Index {
  build() {
    Column() {
      ExpandText()
    }
  }
}