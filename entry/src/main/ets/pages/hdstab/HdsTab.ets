/**
 * @fileName : HdsTab.ets
 * @author : @cxy
 * @date : 2026/5/15
 * @description : 文件描述
 */

import {
  HdsNavigation,
  HdsNavigationTitleMode,
  HdsTabs,
  HdsTabsController,
  hdsMaterial
} from '@kit.UIDesignKit';

@Component
export struct HdsTabDemo {
  private controller: HdsTabsController = new HdsTabsController();
  @State private currentIndex: number = 0
  @State private showAI: boolean = false

  build() {
    HdsNavigation() {
      HdsTabs({ controller: this.controller }) {
        TabContent() {

        }
        .backgroundColor('#80eeeeee')
        .tabBar(this.tabItem('首页', 0))

        TabContent() {
        }
        .backgroundColor('#80ffff00')
        .tabBar(this.tabItem('免费', 1))

        TabContent() {
        }
        .tabBar(this.tabItem('问AI', 2))

        TabContent() {
        }
        .backgroundColor('#800000ff')
        .tabBar(this.tabItem('会员', 3))

        TabContent() {
        }
        .backgroundColor('#80ff00ff')
        .tabBar(this.tabItem('我的', 4))
      }
      .scrollable(false)
      .animationDuration(0)
      .barOverlap(true)
      .vertical(false)
      .barPosition(BarPosition.End)
      .onContentWillChange((currentIndex, comingIndex) => {
        if (comingIndex == 2) {
          this.showAI = true
          return false;
        }
        return true;
      })
      .barFloatingStyle({
        barBottomMargin: 28,
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE // 底部悬浮页签沉浸光感效果跟随系统策略自适应
        }
      })
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .backgroundColor('#eee')
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
    .titleMode(HdsNavigationTitleMode.MINI)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
  }

  @Builder
  tabItem(title: string, index: number) {
    if (title === '问AI') {
      Text(title)
        .fontColor(this.showAI ? '#fff' : '#4F9860')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .backgroundColor(this.showAI ? '#ff17d042' : '#D5F1DB')
        .borderRadius('50%')
        .padding(10)
        .bindPopup(this.showAI, {
          builder: this.aiBuilder,
          placement: Placement.Top,
          popupColor: '#eee',
          backgroundBlurStyle: BlurStyle.NONE,
          offset: { y: -10 },
          onStateChange: (e) => {
            if (!e.isVisible) {
              this.showAI = false
            }
          }
        })
    } else {
      Text(title)
        .fontColor(index === this.currentIndex ? '#4F9860' : '#51473F')
        .fontSize(18)
        .fontWeight(index === this.currentIndex ? FontWeight.Medium : FontWeight.Normal)
    }
  }

  @Builder
  aiBuilder() {
    Column({ space: 5 }) {
      Image($r('app.media.startIcon')).width(24)
      Text('This is ai Popup').fontSize(15)
    }
    .width('100%')
    .padding(20)
  }
}

