/**
 * @fileName : Transcoder.ets
 * @author : @cxy
 * @date : 2025/12/20
 * @description : 视频转码
 */

import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';

export class Transcoder {
  processCallback?: (completed: boolean, progress: number, error?: BusinessError) => void
  private avTranscoder: media.AVTranscoder | undefined = undefined;
  private context: Context | undefined;
  private currentProgress: number = 0;
  private avConfig: media.AVTranscoderConfig = {
    audioBitrate: 100000, // 音频比特率。
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式。
    fileFormat: media.ContainerFormatType.CFT_MPEG_4, // 封装格式。
    videoBitrate: 200000, // 视频比特率。
    videoCodec: media.CodecMimeType.VIDEO_AVC, // 视频编码格式。
  };

  constructor(context: Context | undefined) {
    if (context != undefined) {
      this.context = context;
    }
  }

  static canIUse() {
    return canIUse('SystemCapability.Multimedia.Media.AVTranscoder')
  }


  // 注册avTranscoder回调函数。
  setAVTranscoderCallback() {
    if (Transcoder.canIUse()) {
      if (this.avTranscoder != undefined) {
        // 转码完成回调函数。
        this.avTranscoder.on('complete', async () => {
          console.log(`AVTranscoder is completed`);
          this.processCallback?.(true, this.currentProgress)
          await this.releaseTranscoderingProcess();
        });
        // 错误上报回调函数。
        this.avTranscoder.on('error', (err: BusinessError) => {
          console.error(`AVTranscoder failed, code is ${err.code}, message is ${err.message}`);
          this.processCallback?.(false, this.currentProgress, err)
        });
        // 进度上报回调函数
        this.avTranscoder.on('progressUpdate', (progress: number) => {
          console.info(`AVTranscoder progressUpdate = ${progress}`);
          this.currentProgress = progress;
          this.processCallback?.(false, this.currentProgress)
        })
      }
    }
  }

  // 开始转码对应的流程。
  async startTranscoderingProcess(srcPath: string, dstPath: string) {
    if (Transcoder.canIUse()) {
      if (this.avTranscoder != undefined) {
        await this.avTranscoder.release();
        this.avTranscoder = undefined;
      }
      // 1.创建转码实例。
      this.avTranscoder = await media.createAVTranscoder();
      this.setAVTranscoderCallback();
      // 2.获取转码源文件fd和目标文件fd赋予avTranscoder；参考FilePicker文档。
      if (this.context != undefined) {
        try {
          let fileDescriptor = await fileIo.open(srcPath, fileIo.OpenMode.READ_ONLY);
          this.avTranscoder.fdSrc = fileDescriptor;

          let file = await fileIo.open(dstPath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
          this.avTranscoder.fdDst = file.fd;
          this.currentProgress = 0;
        } catch (error) {
          console.error('error', error);
        }
      }
      // 3.配置转码参数完成准备工作。
      await this.avTranscoder.prepare(this.avConfig);
      // 4.开始转码。
      await this.avTranscoder.start();
    }
  }

  // 暂停转码对应的流程。
  async pauseTranscoderingProcess() {
    if (Transcoder.canIUse()) {
      if (this.avTranscoder != undefined) { // 仅在调用start返回后调用pause为合理调用。
        await this.avTranscoder.pause();
      }
    }
  }

  // 恢复对应的转码流程。
  async resumeTranscoderingProcess() {
    if (Transcoder.canIUse()) {
      if (this.avTranscoder != undefined) { // 仅在调用pause返回后调用resume为合理调用。
        await this.avTranscoder.resume();
      }
    }
  }

  // 释放转码流程。
  async releaseTranscoderingProcess() {
    if (Transcoder.canIUse()) {
      if (this.avTranscoder != undefined) {
        // 1.释放转码实例。
        await this.avTranscoder.release();
        this.avTranscoder = undefined;
        // 2.关闭转码目标文件fd。
        fileIo.closeSync(this.avTranscoder!.fdDst);
      }
    }
  }

  // 获取当前进度
  getCurrentProgress(): number {
    console.info(`getCurrentProgress = ${this.currentProgress}`);
    return this.currentProgress;
  }
}