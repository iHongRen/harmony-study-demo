## XRouter 使用说明

`XRouter` 是基于 `NavPathStack` 的静态路由封装，统一管理页面跳转、返回、路由栈查询和路由拦截监听。

源码位置：
- [XRouter.ets](/Users/cxy/Desktop/CXY/harmony-study-demo/entry/src/main/ets/pages/router/XRouter.ets)

## 1. 数据结构

### RouterInfo

```ts
export class RouterInfo {
  name: string = ''
  params?: Record<string, Object> | Object
  onPop?: Callback<PopInfo>
  animated?: boolean = true
  needLogin?: boolean
}
```

- `name`：路由名（必填，对应 `routerMap` 中注册的页面名）
- `params`：跳转参数
- `onPop`：目标页返回时的回调
- `animated`：是否启用转场动画，默认 `true`
- `needLogin`：预留字段（当前未在 `XRouter` 内部使用）

### InterceptionShowCallbackData

```ts
export interface InterceptionShowCallbackData {
  from: NavDestinationContext | NavBar,
  to: NavDestinationContext | NavBar,
  operation: NavigationOperation
}
```

- `from`：来源页面上下文
- `to`：目标页面上下文
- `operation`：本次导航操作类型

## 2. 初始化与获取路由栈

`XRouter` 在文件底部已执行 `XRouter.create()`，通常无需手动初始化。

```ts
XRouter.create()
```

获取路由栈：

```ts
const pathStack = XRouter.getRouter()
```

在页面中可直接用于 `Navigation`：

```ts
Navigation(XRouter.getRouter()) {
  // 页面内容
}
```

## 3. 路由跳转与返回

### push：跳转到新页面

```ts
XRouter.push({
  name: 'DetailPage',
  params: { id: 1001 },
  animated: true,
  onPop: (popInfo: PopInfo) => {
    // 接收返回结果
  }
})
```

### pop：返回上一个页面

```ts
XRouter.pop()
XRouter.pop(false) // 不使用动画
```

### popResult：返回并携带结果

```ts
XRouter.popResult({ refresh: true })
```

### popToName：返回到指定路由名

```ts
XRouter.popToName('HomePage')
```

### replacePathByName：替换当前路由

```ts
XRouter.replacePathByName({
  name: 'LoginPage',
  params: { from: 'mine' },
  animated: true
})
```

### removeByName：按路由名移除路由

```ts
XRouter.removeByName({ name: 'TempPage' })
```

### clear：清空路由栈

```ts
XRouter.clear()
```

## 4. 路由栈查询

### 判断路由是否存在

```ts
const exists = XRouter.isExistRouteName('DetailPage')
```

### 获取首个匹配路由索引

```ts
const index = XRouter.getRouteNameFirstIndex('DetailPage')
// 不存在时返回 -1
```

### 获取全部路由名

```ts
const allNames = XRouter.getAllPathName()
```

## 5. 路由拦截监听

`XRouter.create()` 内部调用了 `setInterception`，在 `willShow` 时分发拦截事件。  
建议在页面 `onShown` 注册，在 `onHidden` 注销。

```ts
aboutToAppear() {
  XRouter.onInterception(this, (data) => {
    // data.from / data.to / data.operation
  })
}

aboutToDisappear() {
  XRouter.offInterception(this)
}
```

可用方法：

- `XRouter.onInterception(observer, callback)`：注册监听
- `XRouter.offInterception(observer)`：移除监听
- `XRouter.emitInterception(data)`：手动触发分发（通常无需业务侧直接调用）

## 6. 与自定义 Navbar 配合

项目中的自定义导航栏返回按钮已默认调用：

```ts
XRouter.pop()
```

也支持自定义返回逻辑：

```ts
Navbar({
  title: '详情页',
  onBack: () => {
    // 先做业务处理
    XRouter.pop()
  }
})
```

## 7. 说明

- `pushToUrl(url: string)` 当前为预留方法，尚未实现 URL 解析跳转。
- `handleNeedLogin` 当前为预留属性，未接入统一登录拦截流程。
