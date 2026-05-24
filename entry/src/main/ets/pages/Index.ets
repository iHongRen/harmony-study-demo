/**
 * @fileName : Index.ets
 * @author : @cxy
 * @date : 2025/12/18
 * @description : harmonyos=study-demo
 */
import { CountDownDemo } from './countdown/CountDownDemo'
import { EmotionView } from './emotion/EmotionView'
import { ExpandText } from './expandtext/ExpandText'
import { Irrectange } from './irrectangle/Irrectangele'
import { Location } from './location/Location'
import { MenuView } from './menu/MenuView'
import { NavbarGradient } from './navbargradient/NavbarGradient'
import { NotificationDemo } from './notification/NotificationDemo'
import { OssDemo } from './oss/OssDemo'
import { PipDemo } from './pip/PipDemo'
import { ScreenRotate } from './screenrotate/ScreenRotate'
import { SearchDemo } from './search/SearchDemo'
import { SelectableDemo } from './selectabletext/SelectableDemo'
import { SwiperAnimation } from './swiperanimation/SwiperAnimation'
import { Table } from './table/Table'
import { TranscoderDemo } from './transcoder/TranscoderDemo'
import { WebFont } from './webfont/WebFont'
import { BlurDemo } from './blur/BlurDemo'
import { MaskShapeSvg } from './maskshape/MaskShapeSvg'
import { TabScroll } from './tabscroll/tabscroll'
import { PullDownHeaderDemo } from './pulldownheader/PullDownHeader'
import { HdsTabDemo } from './hdstab/HdsTab'
import { SaveFileToDoc } from './savefile/SaveFileToDoc'
import { ImageLoadDemo } from './imageload/ImageLoad'
import { CanvasImage } from './canvas/CanvasImage'
import { MyEmitterComponent } from './myemitter/myemitter'

// Global @Builder functions for routerMap - each wraps component in NavDestination
@Builder
function CountDownDemoBuilder() {
  NavDestination() {
    CountDownDemo()
  }
  .hideTitleBar(false)
  .title('倒计时按钮')
}

@Builder
function EmotionViewBuilder() {
  NavDestination() {
    EmotionView()
  }.title('表情面板')
}

@Builder
function ExpandTextBuilder() {
  NavDestination() {
    ExpandText()
  }.title('文本展开收起')
}

@Builder
function IrrectangeBuilder() {
  NavDestination() {
    Irrectange()
  }.title('异形Banner')
}

@Builder
function LocationBuilder() {
  NavDestination() {
    Location()
  }.title('位置信息获取')
}

@Builder
function MenuViewBuilder() {
  NavDestination() {
    MenuView()
  }.title('金刚区菜单')
}

@Builder
function MyEmitterComponentBuilder() {
  NavDestination() {
    MyEmitterComponent()
  }.title('自定义Emitter')
}

@Builder
function NavbarGradientBuilder() {
  NavDestination() {
    NavbarGradient()
  }.title('导航栏渐变')
}

@Builder
function NotificationDemoBuilder() {
  NavDestination() {
    NotificationDemo()
  }.title('本地通知')
}

@Builder
function OssDemoBuilder() {
  NavDestination() {
    OssDemo()
  }.title('OSS文件上传')
}

@Builder
function PipDemoBuilder() {
  NavDestination() {
    PipDemo()
  }.title('画中画')
}

@Builder
function ScreenRotateBuilder() {
  NavDestination() {
    ScreenRotate()
  }.title('横竖屏切换')
}

@Builder
function SearchDemoBuilder() {
  NavDestination() {
    SearchDemo()
  }.title('搜索高亮')
}

@Builder
function SelectableDemoBuilder() {
  NavDestination() {
    SelectableDemo()
  }.title('文本选择菜单')
}

@Builder
function SwiperAnimationBuilder() {
  NavDestination() {
    SwiperAnimation()
  }.title('Swiper动画')
}

@Builder
function TableBuilder() {
  NavDestination() {
    Table()
  }.title('表格布局')
}

@Builder
function TranscoderDemoBuilder() {
  NavDestination() {
    TranscoderDemo()
  }.title('视频转码')
}

@Builder
function WebFontBuilder() {
  NavDestination() {
    WebFont()
  }.title('Web字体调整')
}

@Builder
function BlurDemoBuilder() {
  NavDestination() {
    BlurDemo()
  }.title('负一屏')
}

@Builder
function MaskShapeSvgBuilder() {
  NavDestination() {
    MaskShapeSvg()
  }.title('MaskShape图形')
}

@Builder
function TabScrollBuilder() {
  NavDestination() {
    TabScroll()
  }.title('Tab嵌套Scroll')
}

@Builder
function CanvasImageBuilder() {
  NavDestination() {
    CanvasImage()
  }.title('Canvas绘图')
}

@Builder
function HdsTabDemoBuilder() {
  NavDestination() {
    HdsTabDemo()
  }.title('HDS Tab导航栏')
}

@Builder
function ImageLoadDemoBuilder() {
  NavDestination() {
    ImageLoadDemo()
  }.title('图片加载')
}

@Builder
function PullDownHeaderDemoBuilder() {
  NavDestination() {
    PullDownHeaderDemo()
  }.title('下拉放大Header')
}

@Builder
function SaveFileToDocBuilder() {
  NavDestination() {
    SaveFileToDoc()
  }.title('沙箱文件夹压缩导出')
}

interface DemoItem {
  title: string
  desc: string
  routeName: string
}

@Entry
@Component
struct Index {
  private pathStack: NavPathStack = new NavPathStack()
  private demoList: DemoItem[] = [
    { title: '倒计时按钮', desc: '发送验证码倒计时', routeName: 'CountDownDemo' },
    { title: '表情面板', desc: 'Emoji和图片表情选择', routeName: 'EmotionView' },
    { title: '文本展开收起', desc: '文本展开和收起功能', routeName: 'ExpandText' },
    { title: '异形Banner', desc: '非矩形异形轮播图', routeName: 'Irrectange' },
    { title: '位置信息获取', desc: '获取地理位置信息', routeName: 'Location' },
    { title: '金刚区菜单', desc: '带滚动下标的菜单', routeName: 'MenuView' },
    { title: '自定义Emitter', desc: '支持Object类型key的事件发射器', routeName: 'MyEmitterComponent' },
    { title: '导航栏渐变', desc: '沉浸式导航栏渐变效果', routeName: 'NavbarGradient' },
    { title: '本地通知', desc: '自定义提示音本地通知', routeName: 'NotificationDemo' },
    { title: 'OSS文件上传', desc: '阿里云OSS图片上传', routeName: 'OssDemo' },
    { title: '画中画', desc: '视频画中画功能', routeName: 'PipDemo' },
    { title: '横竖屏切换', desc: '视频播放横竖屏切换', routeName: 'ScreenRotate' },
    { title: '搜索高亮', desc: '搜索关键词高亮显示', routeName: 'SearchDemo' },
    { title: '文本选择菜单', desc: '长按文本选择和复制', routeName: 'SelectableDemo' },
    { title: 'Swiper动画', desc: '中间放大两边缩小轮播', routeName: 'SwiperAnimation' },
    { title: '表格布局', desc: '上下左右滚动表格', routeName: 'Table' },
    { title: '视频转码', desc: 'HDR视频转SDR', routeName: 'TranscoderDemo' },
    { title: 'Web字体调整', desc: 'Web页面字体动态调整', routeName: 'WebFont' },
    { title: '负一屏', desc: '右滑打开负一屏', routeName: 'BlurDemo' },
    { title: 'MaskShape图形', desc: '斜切圆角渐变自定义图形', routeName: 'MaskShapeSvg' },
    { title: 'Tab嵌套Scroll', desc: 'Tab嵌套Scroll滑动冲突', routeName: 'TabScroll' },
    { title: 'Canvas绘图', desc: '离屏绘图并保存到相册', routeName: 'CanvasImage' },
    { title: 'HDS Tab导航栏', desc: 'HDS规范底部Tab导航', routeName: 'HdsTabDemo' },
    { title: '图片加载', desc: '网络图片加载与尺寸适配', routeName: 'ImageLoadDemo' },
    { title: '下拉放大Header', desc: '列表下拉Header放大回弹', routeName: 'PullDownHeaderDemo' },
    { title: '沙箱文件夹压缩导出', desc: '沙箱目录压缩导出到手机存储', routeName: 'SaveFileToDoc' },
  ]

  build() {
    Navigation(this.pathStack) {
      List() {
        ForEach(this.demoList, (item: DemoItem) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                Text(item.desc)
                  .fontSize(13)
                  .fontColor('#999999')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Image($r('sys.media.ohos_ic_public_arrow_right'))
                .width(16)
                .height(16)
                .fillColor('#999999')
            }
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 12,
              bottom: 12
            })
          }
          .onClick(() => {
            this.pathStack.pushPath({ name: item.routeName })
          })
        }, (item: DemoItem) => item.routeName)
      }
      .width('100%')
      .divider({
        strokeWidth: 0.5,
        color: '#EEEEEE',
        startMargin: 16,
        endMargin: 16
      })
    }
    .title('HarmonyOS 学习示例')
    .mode(NavigationMode.Stack)
  }
}
