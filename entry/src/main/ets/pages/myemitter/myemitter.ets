/**
 * @fileName : myemitter.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 自定义emitter,支持Object对象作为key
 */


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