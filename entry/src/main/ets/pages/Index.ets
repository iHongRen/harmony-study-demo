/**
 * @fileName : ExpandText.ets
 * @author : @cxy
 * @date : 2025/12/18
 * @description : 实现文本断行展开显示
 */
import { CountDownDemo } from './countdown/CountDownDemo'
import { EmotionComponent } from './emotion/EmotionComponent'
import { Emotion } from './emotion/EmotionImage'
import { EmotionView } from './emotion/EmotionView'
import { ExpandText } from './expandtext/ExpandText'
import { Irrectange } from './irrectangle/Irrectangele'
import { Location } from './location/Location'
import { MenuView } from './menu/MenuView'
import { NavbarGradient } from './navbargradient/NavbarGradient'
import { NotificationDemo } from './notification/NotificationDemo'
import { OssDemo } from './oss/OssDemo'
import { ScreenRotate } from './screenrotate/ScreenRotate'
import { SearchDemo } from './search/SearchDemo'
import { SelectableDemo } from './selectabletext/SelectableDemo'
import { SwiperAnimation } from './swiperanimation/SwiperAnimation'
import { Table } from './table/Table'
import { TranscoderDemo } from './transcoder/TranscoderDemo'
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
      // ScreenRotate()
      // Irrectange()
      // TranscoderDemo()
      // OssDemo()
      // SelectableDemo()
      // SearchDemo()
      // NavbarGradient()
      // Table()
      // CountDownDemo()

      NotificationDemo()
    }
  }
}

