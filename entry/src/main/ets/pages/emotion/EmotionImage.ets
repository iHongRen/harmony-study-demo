/**
 * @fileName : EmotionImage.ets
 * @author : @cxy
 * @date : 2025/12/19
 * @description : 表情图片
 */

import { BaseDataSource } from './BaseDataSource';

export class Emotion {
  name: string = ''
  url: ResourceStr = ''

  constructor(name: string, url: ResourceStr) {
    this.name = name
    this.url = url
  }
}

export class EmotionDataSource extends BaseDataSource<Emotion> {
  list: Emotion[] = [];

  public totalCount(): number {
    return this.list.length;
  }

  public getData(index: number): Emotion {
    return this.list[index];
  }

  public initList(data: Emotion[]): void {
    this.list.push(...data);
    this.notifyDataAdd(0, this.list.length)
  }
}

export const EmotionList: Emotion[] = [
  new Emotion('笑脸', $r('app.media.startIcon')),
  new Emotion('笑哭', $r('app.media.startIcon')),
  new Emotion('捂脸', $r('app.media.startIcon')),
  new Emotion('比心', $r('app.media.startIcon')),
  new Emotion('加油', $r('app.media.startIcon')),
  new Emotion('生气', $r('app.media.startIcon')),
  new Emotion('委屈', $r('app.media.startIcon')),
  new Emotion('害羞', $r('app.media.startIcon')),
  new Emotion('吃瓜', $r('app.media.startIcon')),
  new Emotion('狗头', $r('app.media.startIcon')),
  new Emotion('点赞', $r('app.media.startIcon')),
  new Emotion('发财', $r('app.media.startIcon')),
  new Emotion('摆烂', $r('app.media.startIcon'))
];

@Component
export struct EmotionImage {
  onSend?: (e?: Emotion) => void
  private dataSource: EmotionDataSource = new EmotionDataSource()

  async aboutToAppear(): Promise<void> {
    this.dataSource.initList(EmotionList)
  }

  build() {
    Grid() {
      GridItem() {
        Text('所有表情').fontSize(13).fontColor('#666').width('100%')
      }
      .columnStart(0)
      .columnEnd(this.columnCount() - 1)

      LazyForEach(this.dataSource, (e: Emotion) => {
        GridItem() {
          Column({ space: 4 }) {
            Image(e.url).width('100%').aspectRatio(1)
            Text(e.name).fontSize(9).fontColor('#999').maxLines(1)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .onClick(() => {
          this.onSend?.(e)
        })
      })
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .cachedCount(4)
    .width('100%')
    .height('100%')
    .rowsGap(5)
    .columnsGap(5)
    .columnsTemplate('1fr '.repeat(this.columnCount()))
    .padding({
      top: 10,
      left: 10,
      right: 10
    })
    .maxCount(this.dataSource.totalCount() + 1)
  }

  columnCount(): number {
    return 5
  }
}