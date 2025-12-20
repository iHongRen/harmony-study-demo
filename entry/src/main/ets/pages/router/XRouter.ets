/**
 * @fileName : XRouter.ets
 * @author : @cxy
 * @date : 2025/12/20
 * @description : 实现一个简单的路由
 */

export class RouterInfo {
  name: string = ''
  params?: Record<string, Object> | Object
  onPop?: Callback<PopInfo>
  animated?: boolean = true
  needLogin?: boolean
}

export interface InterceptionShowCallbackData {
  from: NavDestinationContext | NavBar,
  to: NavDestinationContext | NavBar,
  operation: NavigationOperation
}

type RouterInterceptionCallback = (data: InterceptionShowCallbackData) => void

export class XRouter {
  private static navStack: NavPathStack
  private static interceptionMap = new Map<object, RouterInterceptionCallback>()
  public handleNeedLogin?: (popInfo: PopInfo) => boolean

  static create() {
    XRouter.navStack = new NavPathStack()
    XRouter.navStack.setInterception({
      willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
        operation: NavigationOperation, isAnimated: boolean) => {
        XRouter.emitInterception({
          from: from,
          to: to,
          operation: operation
        })
      }
    })
  }

  public static getRouter(): NavPathStack {
    if (!XRouter.navStack) {
      XRouter.create()
    }
    return XRouter.navStack
  }

  // 用于页面内监听路由变化，在OnShown中调用on，在OnHidden中调用off
  public static onInterception(observer: object, callback: RouterInterceptionCallback) {
    XRouter.interceptionMap.set(observer, callback)
  }

  public static offInterception(observer: object) {
    XRouter.interceptionMap.delete(observer)
  }

  public static emitInterception(data: InterceptionShowCallbackData) {
    XRouter.interceptionMap.forEach((v, k) => {
      v?.(data)
    })
  }

  public static push(routerInfo: RouterInfo): void {
    const params = routerInfo.params || {}
    XRouter.getRouter()
      .pushPathByName(routerInfo.name, params, routerInfo.onPop, routerInfo.animated)
  }

  public static pop(animated?: boolean): void {
    XRouter.getRouter().pop(animated)
  }

  public static popResult(result: Object, animated?: boolean): void {
    XRouter.getRouter().pop(result, animated)
  }

  public static popToName(name: string, animated?: boolean): void {
    XRouter.getRouter().popToName(name, animated)
  }

  public static replacePathByName(routerInfo: RouterInfo): void {
    const params = routerInfo.params || {}
    XRouter.getRouter().replacePathByName(routerInfo.name, params, routerInfo.animated)
  }

  public static removeByName(routerInfo: RouterInfo): void {
    XRouter.getRouter().removeByName(routerInfo.name)
  }

  public static clear() {
    XRouter.getRouter().clear()
  }

  // 路由栈中是否存在某个路由
  public static isExistRouteName(routeName: string): boolean {
    const indexs = XRouter.getRouter().getIndexByName(routeName)
    return indexs.length > 0
  }

  // 获取路由中第一个匹配的索引
  public static getRouteNameFirstIndex(routeName: string): number {
    const indexs = XRouter.getRouter().getIndexByName(routeName)
    if (indexs.length) {
      return indexs[0]
    }
    return -1
  }

  //所有路由
  public static getAllPathName() {
    return XRouter.getRouter().getAllPathName()
  }

  public static pushToUrl(url: string) {
    //解析url, 自定义跳转到指定的页面
  }
}

XRouter.create()