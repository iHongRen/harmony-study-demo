/**
 * @fileName : CountDownButton.ets
 * @author : @cxy
 * @date : 2025/12/23
 * @description : 倒计时按钮
 */


import { CountDownController } from './CountDownController'

@Component
export struct CountDownButton {
  @Prop countDownTime: number = 60 //默认60秒
  @State remainingTime: number = this.countDownTime
  @Link @Watch("onStartTimer") startTimer: boolean;
  @Prop fontSize: number = 18
  private countDownController = new CountDownController(() => {
    this.startTimer = false
  }, (time) => {
    this.remainingTime = time
  })

  onStartTimer() {
    if (this.startTimer) {
      this.remainingTime = this.countDownTime
      this.countDownController.start(this.countDownTime)
    } else {
      this.countDownController.stop()
    }
  }

  build() {
    Button() {
      Text(this.startTimer ? `重新获取(${this.remainingTime}s)` : '获取验证码')
        .fontSize(this.fontSize)
        .fontColor(this.startTimer ? '#444444' : '#0066ff')
    }
    .enabled(!this.startTimer)
    .backgroundColor(Color.Transparent)
    .padding(10)
    .borderRadius(6)
    .borderWidth(1)
    .borderColor(this.startTimer ? '#444444' : '#0066ff')
  }
}