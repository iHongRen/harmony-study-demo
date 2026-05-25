# 如何实现自定义的Emitter

为特定的功能实现一个自定义的Emitter，支持监听Object类型的对象。比如用户登录状态变化，关注状态变化，方便各个页面独自处理业务逻辑。

实现支持Object类型作为key的Emitter,与框架中的Emitter相比使用起来更方便。可以使用this作为key,不需要定义字符串，off时也不需要传回调函数。

```
// 回调类型的泛型定义
type UserCallback<T> = (data: T) => void;

export class UserEmitter {
  private static map = new Map<Object, UserCallback<ESObject>>();

  /**
   * 注册观察者回调
   * @param observer 观察者对象
   * @param callback 回调函数，泛型T
   */
  public static on<T>(observer: Object, callback: UserCallback<T>): void {
    UserEmitter.map.set(observer, callback as UserCallback<T>);
  }

  /**
   * 移除观察者
   * @param observer 观察者对象
   */
  public static off(observer: Object): void {
    UserEmitter.map.delete(observer);
  }

  /**
   * 触发观察者回调
   * @param data 要传递的数据，泛型T
   */
  public static emit<T>(data: T): void {
    UserEmitter.map.forEach((v, k) => {
      v(data);
    });
  }
}
```

使用自定义的UserEmitter，在 aboutToAppear 和 aboutToDisappear 生命周期方法中监听和取消监听。

```
interface UserLoginData {
  isLogin: boolean
}

@Component
export struct MyEmitterComponent {
  aboutToAppear(): void {
    UserEmitter.on<UserLoginData>(this, (data) => {
      console.dir(data)
    })
  }

  aboutToDisappear(): void {
    UserEmitter.off(this)
  }

  build() {
    Button('emit')
      .margin({ top: 100 })
      .onClick(() => {
        UserEmitter.emit<UserLoginData>({
          isLogin: true
        })
      })
  }
}
```