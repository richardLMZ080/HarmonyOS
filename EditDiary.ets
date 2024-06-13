import { myTools } from '../common/MyTools';
import { Header } from '../component/Header'
import MyInput from '../component/MyInput'
import MyTextArea from '../component/MyTextArea';
import DiaryTable from '../database/tables/DiaryTable';
import DiaryData from '../viewmodel/DiaryData';
import router from '@ohos.router';
import Logger from '../common/Logger';

/**
 * Desc: 日记编辑详情页面
 */
@Entry
@Component
struct EditDiary {
  // 定义状态变量，用于存储页面的状态和日记数据
  @State flag: number = 0
  @State diaryData: DiaryData = new DiaryData();
  private DiaryTable = new DiaryTable(() => {
  });

  /**
   * 生命周期函数，在页面即将显示时调用。
   * 从路由参数中获取日记对象和操作标志（查看或编辑）。
   */
  aboutToAppear() {
    let dairyString = String(router.getParams()['diaryObj'])
    Logger.debug('dairyString=' + dairyString)
    this.diaryData = JSON.parse(dairyString);
    //1:详情；2:编辑
    this.flag = Number(router.getParams()['flag'])
  }

  build() {
    Column() {
      // 顶部标题栏
      Header({ title: $r('app.string.add_diary'), showBack: true, url: 'pages/Index' })

      // 日记标题输入框
      MyInput({
        title: $r('app.string.diary_title'),
        placeholder: $r('app.string.entry_diary_title'),
        defaultValue: this.diaryData.diaryTitle,
        change: (val) => {
          this.diaryData.diaryTitle = val
        }
      })
        .margin({ top: 20 })

      // 日记内容输入框
      MyTextArea({
        title: $r('app.string.diary_content'),
        placeholder: $r('app.string.entry_diary_content'),
        defaultValue: this.diaryData.diaryContent,
        change: (val) => {
          this.diaryData.diaryContent = val
        }
      })
        .margin({ top: 10 })

      // 如果是编辑模式，显示保存按钮
      if (this.flag == 2) {
        Button($r('app.string.save'), { type: ButtonType.Normal, stateEffect: true })
          .fontSize(18)
          .borderRadius(20) //设置按钮的圆角效果
          .width('50%') //设置按钮的宽度
          .height(40) //设置按钮的高度
          .margin({ top: 8 }) //设置按钮距离顶部的间距
          .backgroundColor('#ff1f3ffd') //设置按钮的背景颜色
          .onClick(() => {
            this.DiaryTable.getRdbStore(() => {
              this.diaryData.diaryTime = myTools.getCurrentDateTime();
              this.DiaryTable.updateData(this.diaryData, (id: number) => {
                myTools.alertMsg($r('app.string.edit_success'))
              });
            });
          })
          .margin({ top: 10 })
      }

    }
    .backgroundColor($r('app.color.page_bg')) // 页面背景颜色
    .width('100%')
    .height('100%')
  }
}