/**
 * @fileName : NotificationDemo.ets
 * @author : @cxy
 * @date : 2025/12/23
 * @description : 发送通知
 */

import { notificationManager } from '@kit.NotificationKit';
import { bundleManager, common, wantAgent } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

@Component
export struct NotificationDemo {
  @State isTwicePopup: boolean = false

  build() {
    Column() {
      Button('触发通知')
        .onClick(() => {
          this.requestNotificationEnabled()
        })
    }
    .width('100%')
    .height('100%')
    .onFocus(() => {
      // 组件聚焦的回调
      if (this.isTwicePopup) {
        // 做一些自己的操作
        console.log('应用通知页面关闭')
        // 重置组件聚焦状态
        this.isTwicePopup = !this.isTwicePopup
      }
    })
  }

  requestNotificationEnabled() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    // 通知是否授权
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      if (!data) {
        // 一次授权，拉起通知弹窗，向用户请求通知授权。
        notificationManager.requestEnableNotification(context).then(() => {
          this.onSendNotification()
        }).catch((err: BusinessError) => {
          // 二次授权，拉起通知管理半模态弹窗，向用户再次申请通知授权。
          notificationManager.openNotificationSettings(context).then(() => {
            this.isTwicePopup = true
          }).catch((err: BusinessError) => {
          });
        });
      } else {
        this.onSendNotification()
      }
    }).catch((err: BusinessError) => {
    });
  }

  async onSendNotification() {
    const bundle = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)

    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          deviceId: '',
          bundleName: bundle.name,
          abilityName: 'EntryAbility',
          action: '',
          entities: [],
          uri: 'myurl://www.xianyin?name=cxy', //传递参数，用于点击后根据参数跳转
          parameters: {
            'name': 'cxy' //传递参数，用于点击后根据参数跳转
          }
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY, //拉起App
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    };

    // 创建WantAgent
    const wantAgentObj = await wantAgent.getWantAgent(wantAgentInfo)

    const notificationRequest: notificationManager.NotificationRequest = {
      id: 1,
      notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
        normal: {
          title: '这是一个标题',
          text: '这是普通文本类型消息的内容',
        }
      },
      wantAgent: wantAgentObj,
      sound: 'sfx_draw_sword_sharp.wav', //自定义提示音 https://developer.huawei.com/consumer/cn/design/harmonyos-sound/
    };

    notificationManager.publish(notificationRequest, (err: BusinessError) => {
      if (err) {
        return;
      }
    });
  }
}