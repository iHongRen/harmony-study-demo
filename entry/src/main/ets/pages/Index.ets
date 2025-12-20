/**
 * @fileName : ExpandText.ets
 * @author : @cxy
 * @date : 2025/12/18
 * @description : 实现文本断行展开显示
 */
import { EmotionComponent } from './emotion/EmotionComponent'
import { Emotion } from './emotion/EmotionImage'
import { EmotionView } from './emotion/EmotionView'
import { ExpandText } from './expandtext/ExpandText'
import { Location } from './location/Location'
import { MenuView } from './menu/MenuView'
import { ScreenRotate } from './screenrotate/ScreenRotate'
import { SwiperAnimation } from './swiperanimation/SwiperAnimation'
import { WebFont } from './webfont/WebFont'

@Entry
@Component
struct Index {
  @State isShowPageTwo: boolean = false

  build() {
    Column() {
      // ExpandText()
      // Location()
      // MyEmitterComponent()
      // EmotionView()
      // MenuView()
      // SwiperAnimation()
      // WebFont()
      ScreenRotate()
    }
  }
}