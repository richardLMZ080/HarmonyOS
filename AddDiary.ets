import { myTools } from '../common/MyTools';
import { Header } from '../component/Header'
import MyInput from '../component/MyInput'
import MyTextArea from '../component/MyTextArea';
import DiaryTable from '../database/tables/DiaryTable';
import DiaryData from '../viewmodel/DiaryData';
/**
 * Desc: 新增日记页面
 */
@Entry
@Component
struct AddDiary {
  // 定义状态变量，用于存储页面的消息和日记数据
  @State message: string = 'Hello World'
  @State diaryData: DiaryData = new DiaryData();
  private DiaryTable = new DiaryTable(() => {
  });

  build() {
    Column() {// 使用 Column 布局来组织页面组件
      // 顶部标题栏
      Header({ title: $r('app.string.add_diary'), showBack: true, url: 'pages/Index' })
      // 日记标题输入框
      MyInput({
        title: $r('app.string.diary_title'),
        placeholder: $r('app.string.entry_diary_title'),
        defaultValue: this.diaryData.diaryTitle,
        change: (val) => {// 当输入框的值发生变化时触发的回调函数
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
      // 保存按钮
      Button($r('app.string.save'), { type: ButtonType.Normal, stateEffect: true })
        .fontSize(18)
        .borderRadius(20) //设置按钮的圆角效果
        .width('50%') //设置按钮的宽度
        .height(40) //设置按钮的高度
        .margin({ top: 8 }) //设置按钮距离顶部的间距
        .backgroundColor('#ff1f3ffd') //设置按钮的背景颜色
        .onClick(() => {
          this.DiaryTable.getRdbStore(() => {// 点击按钮时，执行保存操作
            this.diaryData.diaryTime = myTools.getCurrentDateTime();// 获取当前日期时间
            this.DiaryTable.insertData(this.diaryData, (id: number) => {// 插入数据到数据库
              this.diaryData.id = id;// 设置日记条目的 ID
              myTools.alertMsg($r('app.string.add_success'))// 显示成功消息
            });
          });
        })
        .margin({ top: 10 })

    }
    // 设置页面的背景颜色、宽度和高度
    .backgroundColor($r('app.color.page_bg')) // 页面背景颜色
    .width('100%')
    .height('100%')
  }
}