/**
 * @fileName : PipDemo.ets
 * @author : @cxy
 * @date : 2025/12/24
 * @description : 画中画demo
 */
import { MyPipController } from "./MyPipController";
import { PiPWindow } from "@kit.ArkUI";


// xxx.ets
@Component
export struct PipDemo {
  // $rawfile('video1.mp4')、$r('app.media.poster1')需要分别替换为开发者所需的视频、图片资源文件。
  @State videoSrc: Resource = $rawfile('video_sample3.mp4')
  // @State previewUri: Resource = $r('app.media.poster1');
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;
  @State isAutoPlay: boolean = true;
  @State showControls: boolean = true;
  @State isShortcutKeyEnabled: boolean = true;
  @State showFirstFrame: boolean = true;
  private controller: VideoController = new VideoController();
  private pip: MyPipController = new MyPipController()

  aboutToAppear(): void {

    this.pip.onStateChange = ((state: PiPWindow.PiPState, reason: string) => {

    })

    this.pip.onActionEvent = ((event: PiPWindow.PiPActionEventType, status?: number) => {

    })
  }

  build() {
    Column() {
      Video({
        src: this.videoSrc,
        // previewUri: this.previewUri, // 设置预览图。
        currentProgressRate: this.curRate, // 设置播放速度。
        controller: this.controller,
        posterOptions: { showFirstFrame: this.showFirstFrame } // 首帧送显。
      })
        .width('100%')
        .aspectRatio(16 / 9)
        .autoPlay(this.isAutoPlay)
        .controls(this.showControls)
        .enableShortcutKey(this.isShortcutKeyEnabled)

      Row() {
        Button('start').onClick(() => {
          this.controller.start(); // 开始播放。
        }).margin(2)
        Button('pause').onClick(() => {
          this.controller.pause(); // 暂停播放。
        }).margin(2)
        Button('stop').onClick(() => {
          this.controller.stop(); // 结束播放。
        }).margin(2)
        Button('reset').onClick(() => {
          this.controller.reset(); // 重置AVPlayer。
        }).margin(2)

      }
    }
  }
}

