/**
 * @fileName : CountDownController.ets
 * @author : @cxy
 * @date : 2025/12/23
 * @description : 倒计时控制器
 */


export class CountDownController {
  private countdownTime: number = 60;
  // 定时器ID
  private countdownInterval: number = -1;
  // 结束回调函数
  private onCountdownFinish: () => void;
  // 倒计时tick的回调函数
  private onCountdownTick: (remainingTime: number) => void;

  constructor(onCountdownFinish: () => void, onCountdownTick?: (remainingTime: number) => void) {
    this.onCountdownFinish = onCountdownFinish;
    this.onCountdownTick = onCountdownTick || (() => {
    });
    this.countdownInterval = -1;
  }

  start(countdownTime: number): void {
    this.stop()
    this.countdownTime = countdownTime

    this.countdownInterval = setInterval(() => {
      this.countdownTime--;
      this.onCountdownTick(Math.max(this.countdownTime, 0));
      if (this.countdownTime <= 0) {
        this.stop();
        this.onCountdownFinish();
      }
    }, 1000);
  }

  stop(): void {
    if (this.countdownInterval > -1) {
      clearInterval(this.countdownInterval);
      this.countdownInterval = -1;
    }
  }
}