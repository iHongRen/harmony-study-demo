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
import { Navbar } from './Navbar'
import { RouterInfo, XRouter } from './router/XRouter'

// Global @Builder functions for routerMap - each wraps component in NavDestination
@Builder
function CountDownDemoBuilder() {
  NavDestination() {
    Navbar({ title: '倒计时按钮' })
    CountDownDemo()
  }
  .hideTitleBar(true)
}

@Builder
function EmotionViewBuilder() {
  NavDestination() {
    Navbar({ title: '表情面板' })
    EmotionView().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function ExpandTextBuilder() {
  NavDestination() {
    Navbar({ title: '文本展开收起' })
    ExpandText()
  }
  .hideTitleBar(true)
}

@Builder
function IrrectangeBuilder() {
  NavDestination() {
    Navbar({ title: '异形Banner' })
    Irrectange()
  }
  .hideTitleBar(true)
}

@Builder
function LocationBuilder() {
  NavDestination() {
    Navbar({ title: '位置信息获取' })
    Location()
  }
  .hideTitleBar(true)
}

@Builder
function MenuViewBuilder() {
  NavDestination() {
    Navbar({ title: '金刚区菜单' })
    MenuView()
  }
  .hideTitleBar(true)
}

@Builder
function MyEmitterComponentBuilder() {
  NavDestination() {
    Navbar({ title: '自定义Emitter' })
    MyEmitterComponent()
  }
  .hideTitleBar(true)
}

@Builder
function NavbarGradientBuilder() {
  NavDestination() {
    // Navbar({ title: '导航栏渐变' })
    NavbarGradient()
  }
  .hideTitleBar(true)
}

@Builder
function NotificationDemoBuilder() {
  NavDestination() {
    Navbar({ title: '本地通知' })
    NotificationDemo()
  }
  .hideTitleBar(true)
}

@Builder
function OssDemoBuilder() {
  NavDestination() {
    Navbar({ title: 'OSS文件上传' })
    OssDemo()
  }
  .hideTitleBar(true)
}

@Builder
function PipDemoBuilder() {
  NavDestination() {
    Navbar({ title: '画中画' })
    PipDemo().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function ScreenRotateBuilder() {
  NavDestination() {
    Navbar({ title: '横竖屏切换' })
    ScreenRotate().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function SearchDemoBuilder() {
  NavDestination() {
    Navbar({ title: '搜索高亮' })
    SearchDemo()
  }
  .hideTitleBar(true)
}

@Builder
function SelectableDemoBuilder() {
  NavDestination() {
    Navbar({ title: '文本选择菜单' })
    SelectableDemo()
  }
  .hideTitleBar(true)
}

@Builder
function SwiperAnimationBuilder() {
  NavDestination() {
    Navbar({ title: 'Swiper动画' })
    SwiperAnimation()
  }
  .hideTitleBar(true)
}

@Builder
function TableBuilder() {
  NavDestination() {
    Navbar({ title: '表格布局' })
    Table().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function TranscoderDemoBuilder() {
  NavDestination() {
    Navbar({ title: '视频转码' })
    TranscoderDemo()
  }
  .hideTitleBar(true)
}

@Builder
function WebFontBuilder() {
  NavDestination() {
    Navbar({ title: 'Web字体调整' })
    WebFont().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function BlurDemoBuilder() {
  NavDestination() {
    Navbar({ title: '负一屏' })
    BlurDemo().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function MaskShapeSvgBuilder() {
  NavDestination() {
    Navbar({ title: 'MaskShape图形' })
    MaskShapeSvg()
  }
  .hideTitleBar(true)
}

@Builder
function TabScrollBuilder() {
  NavDestination() {
    Navbar({ title: 'Tab嵌套Scroll' })
    TabScroll().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function CanvasImageBuilder() {
  NavDestination() {
    Navbar({ title: 'Canvas绘图' })
    CanvasImage()
  }
  .hideTitleBar(true)
}

@Builder
function HdsTabDemoBuilder() {
  NavDestination() {
    Navbar({ title: 'HDS Tab导航栏' })
    HdsTabDemo().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function ImageLoadDemoBuilder() {
  NavDestination() {
    Navbar({ title: '图片加载' })
    ImageLoadDemo()
  }
  .hideTitleBar(true)
}

@Builder
function PullDownHeaderDemoBuilder() {
  NavDestination() {
    Navbar({ title: '下拉放大Header' })
    PullDownHeaderDemo().layoutWeight(1)
  }
  .hideTitleBar(true)
}

@Builder
function SaveFileToDocBuilder() {
  NavDestination() {
    Navbar({ title: '沙箱文件夹压缩导出' })
    SaveFileToDoc().layoutWeight(1)
  }
  .hideTitleBar(true)
}

interface DemoItem {
  title: string
  desc: string
  routeName: string
}

@Entry
@Component
struct Index {
  @StorageProp('topHeight') topHeight: number = 0
  @StorageProp('bottomHeight') bottomHeight: number = 0
  private pathStack: NavPathStack = XRouter.getRouter()
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
      Navbar({ title: 'HarmonyOS 学习示例' })

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
            const routerInfo: RouterInfo = { name: item.routeName }
            XRouter.push(routerInfo)
          })
        }, (item: DemoItem) => item.routeName)
      }
      .layoutWeight(1)
      .width('100%')
      .divider({
        strokeWidth: 0.5,
        color: '#EEEEEE',
        startMargin: 16,
        endMargin: 16
      })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}
