/*
 * Desc: 页面头部组件，显示标题文本和可选的返回按钮。
 */
import router from '@ohos.router'

@Component
export struct Header {
  private title: ResourceStr //标题信息，类型为资源字符串
  private showBack?: boolean = false //是否显示返回按钮
  private sureDialog?: boolean = false //是否确认弹框提示
  private url?: string = '' //跳转路径

  build() {
    Row() {
      // 使用层叠布局来布局标题和返回按钮
      Stack() {
        // 标题行
        Row() {
          // 显示标题文本
          Text(this.title)
            .fontColor('#111111')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')

        // 返回按钮
        if (this.showBack) {
          Image($r('app.media.back'))// 返回按钮图标
            .offset({ x: '-46%', y: 0 })// 设置返回按钮偏移位置
            .height(22)
            .tabIndex(100)// 设置返回按钮的 tabIndex，便于键盘导航
            .onClick(() => {// 如果需要确认弹框提示
              if (this.sureDialog) {
                //返回弹框确认
                router.showAlertBeforeBackPage({
                  message: '确定返回上一页吗？'
                })
              }
              if (this.url != '') {// 如果设置了跳转路径
                router.replaceUrl({
                  url: this.url,
                }, router.RouterMode.Single)
              } else {
                //返回上一页
                router.back()
              }
            })
        }
      }
    }
    .width('100%')
    .height(60)
    .padding({
      left: 10,
      right: 10
    })
    .backgroundColor('#ffffff')
  }
}