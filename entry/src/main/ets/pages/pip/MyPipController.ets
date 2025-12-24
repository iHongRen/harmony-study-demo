/**
 * @fileName : MyPipController.ets
 * @author : @cxy
 * @date : 2025/12/24
 * @description : 画中画控制器
 */

import { PiPWindow } from '@kit.ArkUI';

export class MyPipController {
  pip?: PiPWindow.PiPController = undefined;
  onStateChange?: (state: PiPWindow.PiPState, reason: string) => void
  onActionEvent?: (event: PiPWindow.PiPActionEventType, status?: number) => void

  setAutoStart(enable: boolean) {
    this.pip?.setAutoStartEnabled(enable)
  }

  startPip() {
    try {
      this.pip?.startPiP()
    } catch (e) {
    }
  }

  async init(context: Context, xComponentController: XComponentController, navigationId?: string) {
    if (!PiPWindow.isPiPEnabled()) {
      return;
    }
    if (this.pip) {
      await this.stopPip()
    }

    const config: PiPWindow.PiPConfiguration = {
      context: context,
      componentController: xComponentController,
      // 当前page导航id
      // 1、UIAbility使用Navigation管理页面，需要设置Navigation控件的id属性，并将该id设置给画中画控制器，确保还原场景下能够从画中画窗口恢复到原页面
      // 2、UIAbility使用Router管理页面时（画中画场景不推荐该导航方式），无需设置navigationId。注意：该场景下启动画中画后，不要进行页面切换，否则还原场景可能出现异常
      // 3、UIAbility只有单页面时，无需设置navigationId，还原场景下也能够从画中画窗口恢复到原页面
      navigationId: navigationId,
      templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY, // 对于视频通话、视频会议等场景，需要设置相应的模板类型
      // contentWidth: 1920, // 可选，创建画中画控制器时系统可通过XComponent组件大小设置画中画窗口比例
      // contentHeight: 1080, // 可选，创建画中画控制器时系统可通过XComponent组件大小设置画中画窗口比例
      controlGroups: [PiPWindow.VideoPlayControlGroup.FAST_FORWARD_BACKWARD], // 可选，对于视频通话、视频会议和视频直播场景，可通过该属性选择对应模板类型下需显示的的控件组
      // customUIController: this.nodeController, // 可选，如果需要在画中画显示内容上方展示自定义UI，可设置该参数。
    };
    // 步骤1：创建画中画控制器，通过create接口创建画中画控制器实例
    PiPWindow.create(config).then((controller: PiPWindow.PiPController) => {
      this.configController(controller);
    })
  }

  // 步骤3：视频内容变化时，向画中画控制器更新视频尺寸信息，用于调整画中画窗口比例
  updateContentSize(width: number, height: number) {
    if (this.pip) {
      this.pip.updateContentSize(width, height);
    }
  }

  // 步骤4：当不再需要显示画中画时，通过stopPiP接口关闭画中画
  async stopPip() {
    if (this.pip) {
      try {
        this.pip.setAutoStartEnabled(false)
        await this.pip.stopPiP();
      } catch (e) {
      }
      this.pip?.off('stateChange'); // 如果已注册stateChange回调，停止画中画时取消注册该回调
      this.pip?.off('controlPanelActionEvent'); // 如果已注册controlPanelActionEvent回调，停止画中画时取消注册该回调
      this.pip = undefined
    }
  }

  private configController(controller: PiPWindow.PiPController) {
    this.pip = controller
    // 通过setAutoStartEnabled接口设置是否需要在应用返回桌面时自动启动画中画，注册stateChange和controlPanelActionEvent回调
    this.pip?.setAutoStartEnabled(true);

    this.pip?.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
      this.onStateChange?.(state, reason);
    });
    this.pip?.on('controlPanelActionEvent', (event: PiPWindow.PiPActionEventType, status?: number) => {
      this.onActionEvent?.(event, status);
    });
  }
}