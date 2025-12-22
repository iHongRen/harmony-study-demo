/**
 * @fileName : SearchBar.ets
 * @author : @cxy
 * @date : 2025/12/22
 * @description : 搜索框
 */


@Component
export struct SearchBar {
  @Prop placeholder: string = '请输入搜索内容'
  @Prop text: string = ''
  onChanged?: (value: string) => void

  @Builder
  inputItemBuilder() {
    Row({ space: 5 }) {
      Image($r('[reslib].media.ic_search')).width(12)
      TextInput({ placeholder: this.placeholder || '请输入搜索内容', text: this.text })
        .placeholderColor('#999')
        .borderRadius(0)
        .backgroundColor(Color.Transparent)
        .fontSize(15)
        .placeholderFont({ size: 15 })
        .fontColor('#333')
        .maxLength(20)
        .padding(0)
        .enterKeyType(EnterKeyType.Search)
        .onChange((value: string) => {
          this.onChanged?.(value.trim())
        })
        .layoutWeight(1)
        .height(32)
    }
    .layoutWeight(1)
    .padding({ left: 10 })
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .height(32)
    .borderRadius('50%')
    .backgroundColor('#f6f6f6')
  }

  build() {
    Row() {
      this.inputItemBuilder()
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(44)
    .backgroundColor('#fff')
  }
}