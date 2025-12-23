/**
 * @fileName : CountDownDemo.ets
 * @author : @cxy
 * @date : 2025/12/22
 * @description : 文件描述
 */
import { CountDownButton } from "./CountDownButton"

@Component
export struct CountDownDemo {
  @State startTimer: boolean = false

  build() {
    Stack() {
      CountDownButton({
        startTimer: $startTimer,
        countDownTime: 5
      })
        .onClick(() => {
          // TODO: 调用发送验证码接口，成功后开启倒计时
          this.startTimer = true
        })
    }
    .width('100%')
    .height(200)
  }
}