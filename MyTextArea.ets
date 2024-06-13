/*
 * Desc: 多行输入框-自定义组件，支持标题、图标、占位符、默认值、最大长度和输入类型的配置，同时支持输入值变化时的回调处理。
 */
@Component
export default struct MyTextArea {
  @State isFocus: boolean = false
  title: string | Resource // 标题
  icon?: Resource
  placeholder: string | Resource // 占位符文本，可以是字符串或资源
  enabledStatus?: boolean = true //输入框是否可编辑，默认可编辑
  maxLength?: number = 50
  inputType: InputType = InputType.Normal
  @Prop defaultValue: string // 默认值，通过 @Prop 装饰器传递
  change = (val: string) => { // 输入值变化时的回调函数
  }

  build() {
    Column() {
      // 使用列布局
      Flex({ alignItems: ItemAlign.Center }) { // 使用弹性布局，垂直居中对齐
        Text(this.title)
          .textAlign(TextAlign.Center)
          .width(110)
          .fontSize(16)
          .fontWeight(500)
          .fontColor('#ff000000')

        if (this.icon) {
          Image(this.icon)
            .width(30)
            .height(30)
            .margin({ right: 5 })
        }
        // 多行输入框
        TextArea({
          placeholder: this.placeholder, // 设置占位符文本
          text: this.defaultValue // 设置默认值
        })
          .enabled(this.enabledStatus) // 设置是否可编辑
          .onFocus(() => {
            this.isFocus = true // 输入框获得焦点时，设置 isFocus 为 true
          })
          .onBlur(() => {
            this.isFocus = false // 输入框失去焦点时，设置 isFocus 为 false
          })
          .onChange((val: string) => {
            this.change(val) // 输入值变化时，调用 change 回调函数
          })
          .borderRadius(10)
          .placeholderColor(`rgba(0,40,132,0.6)`)
          .backgroundColor('#ffffff')
          .height(300)
      }
      .height(300)
      .padding({ left: 10, right: 10 })
      .borderRadius(10)
    }
    .width('99%')
  }
}