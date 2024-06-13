import { myTools } from '../common/MyTools';
import DiaryTable from '../database/tables/DiaryTable';
import DiaryData from '../viewmodel/DiaryData';
import router from '@ohos.router';

/**
 * Desc: 日记列表首页
 */
@Entry
@Component
export struct Index {
  // 定义状态变量，用于存储页面数据和刷新状态
  @State dataList: any = []
  @State durationTime: number = 100
  @State translateY: number = 0
  @State text: Resource = $r('app.string.down_refresh')
  @State loading: boolean = false
  private DiaryTable = new DiaryTable(() => {
  });

  /**
   * 生命周期函数，在页面即将显示时调用，加载数据。
   */
  aboutToAppear() {
    this.loadData();
  }

  //加载页面数据，从数据库中查询日记数据。
  loadData() {
    this.DiaryTable.getRdbStore(() => {
      this.DiaryTable.query("0", (result: DiaryData[]) => {// 查询数据库中所有日记数据
        this.dataList = result;// 将查询结果赋值给dataList状态变量
      }, true);
    });
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      //刷新信息提示语
      Row() {
        if (this.loading) {
          LoadingProgress()
            .width(40)
            .aspectRatio(1)
        }
        Text(this.text)
          .fontColor('#ffff0000')
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
      }
      .height(60)

      //页面正文部分
      Column() {

        Row() {
          Text($r('app.string.system_title'))
            .height(33)
            .fontSize(24)

          Image($r('app.media.add'))
            .width(28)
            .aspectRatio(1)
            .onClick(() => {
              router.replaceUrl({
                url: 'pages/AddDiary',
              }, router.RouterMode.Single)
            })
        }
        .backgroundColor('#ffffff')
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(15)


        List() {
          ForEach(this.dataList, (item: DiaryData, index) => {//循环渲染遍历数组的方式构建列表
            ListItem() {
              Row() {
                Column({ space: 15 }) {
                  Text(getContext(this).resourceManager.getStringSync($r('app.string.diary_title')) + item.diaryTitle)
                  Text(getContext(this).resourceManager.getStringSync($r('app.string.diary_time')) + item.diaryTime)
                }
                .padding(10)
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Start)
                .width('100%')
              }
              .backgroundColor('#ffffff')
              .borderRadius(10)
              .margin({ top: 10 })
              .width('96%')
            }
            .bindMenu([
              {
                value: getContext(this).resourceManager.getStringSync($r('app.string.diary_detail')),// 点击“详情”菜单项的操作
                action: () => {
                  router.replaceUrl({
                    url: 'pages/EditDiary',
                    params: {
                      diaryObj: JSON.stringify(item),// 将日记对象转换为JSON字符串传递给编辑页面
                      flag: 1// 传递标志位1表示查看详情
                    },
                  }, router.RouterMode.Single)
                }
              },
              {
                value: getContext(this).resourceManager.getStringSync($r('app.string.diary_edit')),
                action: () => {
                  router.replaceUrl({
                    url: 'pages/EditDiary',
                    params: {
                      diaryObj: JSON.stringify(item),
                      flag: 2
                    },
                  }, router.RouterMode.Single)
                }
              },
              {
                value: getContext(this).resourceManager.getStringSync($r('app.string.diary_delete')),
                action: () => {
                  AlertDialog.show({
                    title: $r('app.string.sure_please'), //弹窗标题
                    message: $r('app.string.sure_delete'), // 提示消息
                    autoCancel: false, // 点击遮罩层即阴影，是否关闭弹窗。true是点击遮罩层弹窗关闭。
                    alignment: DialogAlignment.Center,
                    offset: { dx: 0, dy: 0 },
                    primaryButton: {
                      value: $r('app.string.sure_button'),
                      fontColor: Color.Red,
                      action: () => {
                        this.DiaryTable.deleteData(item, () => {
                          myTools.alertMsg($r('app.string.data_delete_success'))
                          this.loadData();
                        });
                      }
                    },
                    secondaryButton: {
                      value: $r('app.string.cancel_button'),
                      action: () => {
                      }
                    }
                  })
                }
              },
            ])
          }, item => JSON.stringify(item))
        }
        .layoutWeight(1)
        .alignListItem(ListItemAlign.Center) //设置子元素居中显示

      }
      .width('100%')
      .height('100%')
      .translate({ y: this.translateY })
      //gesture：绑定下拉手势，实现下拉刷新获取后台数据
      .gesture(
        //PanGesture：用于触发拖动手势事件，滑动的最小距离为5vp时拖动手势识别成功
        PanGesture()
          //Pan手势移动过程中回调
          .onActionUpdate((event: GestureEvent) => {
            this.translateY = this.ease(event.offsetY)
            if (this.translateY > 100) {
              this.text = $r('app.string.release_refresh')
            }
          })
            //Pan手势识别成功，手指抬起后触发回调
          .onActionEnd((event: GestureEvent) => {
            if (this.translateY > 100) {
              this.loading = true
              this.text = $r('app.string.refresh_success')
              animateTo({ duration: this.durationTime }, () => {
                this.translateY = 100
              })
              // 加载数据
              setTimeout(() => {
                this.loading = false
                this.text = $r('app.string.refreshing')
                animateTo({
                  duration: this.durationTime,
                  onFinish: () => this.text = $r('app.string.down_refresh')
                }, () => {
                  this.translateY = 0
                })
                //发请求
                this.loadData();
                myTools.alertMsg($r('app.string.refresh_success'))
              }, 1100)
            } else {
              animateTo({ duration: this.durationTime }, () => {
                this.translateY = 0
              })
            }
          })
      )
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg'))
  }

  /**
   * 缓动函数，用于手势滑动时的缓动效果
   * @param originValue 原始偏移值
   * @returns 缓动后的偏移值
   */
  ease(originValue: number = 0) {
    const space = 60
    const damp = 0.3
    if (originValue > space) {
      return space + (originValue - space) * damp
    }
    return originValue
  }
}