/**
 * Desc: 登录页面
 */
import CommonConstants from '../common/CommonConstants'
import Logger from '../common/Logger';
import { myTools } from '../common/MyTools';
import PreferencesUtils from '../common/PreferencesUtils'
import MyInput from '../component/MyInput';
import router from '@ohos.router';

@Entry
@Component
struct Login {
  @State message: string = 'Hello World'
  @State loginKey: string = ''

  /**
   * 生命周期函数，在页面即将显示时调用，获取保存的登录密钥。
   * aboutToAppear 是一个异步函数，目的是在页面加载前执行一些初始化操作。
   * 从偏好设置（PreferencesUtils）中异步获取存储的登录密钥。
   * 如果获取成功，将获取到的值（res）转换成字符串，并将其赋值给组件的状态变量 loginKey。
   * 这个操作会确保页面加载时显示已保存的登录密钥。
   */
  async aboutToAppear() {
    await PreferencesUtils.getData(CommonConstants.LOGIN_KEY).then(res => {
      Logger.debug('res=' + res)
      this.loginKey = String(res)
    })
  }

  build() {
    Column() {
      // 密码输入框
      MyInput({
        title: $r('app.string.diary_pwd'),
        defaultValue: this.loginKey,
        placeholder: $r('app.string.pwd_placeholder'),
        change: (val) => {
          this.loginKey = val;
        }
      })
        .margin({ top: 40 })
      // 确认按钮
      Button($r('app.string.sure_entry'), { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(20) //设置按钮的圆角效果
        .width('50%') //设置按钮的宽度
        .height(40) //设置按钮的高度
        .margin({ top: 8 }) //设置按钮距离顶部的间距
        .backgroundColor('#e8483c') //设置按钮的背景颜色
        .onClick(async () => {
          if (this.loginKey === '') {// 如果 loginKey 为空，提示用户先输入密码。
            myTools.alertMsg($r('app.string.entry_pwd_first'))
            return;
          }
          await PreferencesUtils.getData(CommonConstants.LOGIN_KEY).then(res => {// 从 Preferences 获取保存的登录密码。
            if (!res) {// 如果没有保存的密码，提示用户未设置密码。
              myTools.alertMsg($r('app.string.diary_pwd_no'))
              return;
            }
            if (this.loginKey === String(res)) {// 如果输入的密码与保存的密码匹配，则跳转到首页。
              router.replaceUrl({
                url: 'pages/Index',
              }, router.RouterMode.Single)
            } else {// 如果输入的密码不匹配，提示用户密码错误。
              myTools.alertMsg($r('app.string.diary_pwd_error'))
            }
          })
        })
      // 设置密码按钮
      Button($r('app.string.set_pwd'), { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(20) //设置按钮的圆角效果
        .width('50%') //设置按钮的宽度
        .height(40) //设置按钮的高度
        .margin({ top: 8 }) //设置按钮距离顶部的间距
        .backgroundColor('#ff183df3') //设置按钮的背景颜色
        .onClick(() => {
          if (this.loginKey === '') {
            myTools.alertMsg($r('app.string.entry_pwd_first'))
            return;
          }
          //密码存入 Preferences 首选项
          PreferencesUtils.saveData(CommonConstants.LOGIN_KEY, this.loginKey);
          myTools.alertMsg($r('app.string.pwd_set_success'))
        })

    }
    .backgroundColor($r('app.color.page_bg')) // 页面背景颜色
    .width('100%')
    .height('100%')
  }
}