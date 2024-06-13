import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog'; // 导入 hilog 模块，用于记录日志
import window from '@ohos.window'; // 导入 window 模块，用于管理窗口
import PreferencesUtils from '../common/PreferencesUtils' // 导入 PreferencesUtils 类，用于处理首选项操作

export default class EntryAbility extends UIAbility {

  /**
   * 在能力创建时调用，用于执行初始化操作
   * @param want - 启动能力的意图
   * @param launchParam - 启动能力时携带的参数
   */
  onCreate(want, launchParam) {
    // 记录一条信息日志，表示能力已经创建
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 创建首选项
    PreferencesUtils.createPreferences(this.context)
  }

  /**
   * 在能力销毁时调用，用于释放资源
   */
  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  /**
   * 在窗口阶段创建时调用，用于加载主窗口内容
   * @param windowStage - 窗口阶段对象，表示窗口的状态和属性
   */
  onWindowStageCreate(windowStage: window.WindowStage) {
    // 记录一条信息日志，表示窗口阶段已经创建
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 加载主窗口的内容，设置能力的主页面为 'pages/Login'
    windowStage.loadContent('pages/Login', (err, data) => {
      if (err.code) {
        // 如果加载内容失败，则记录一条错误日志，并输出错误信息
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      // 如果加载内容成功，则记录一条信息日志，并输出加载的数据
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  /**
   * 在窗口阶段销毁时调用，用于释放 UI 相关资源
   */
  onWindowStageDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  /**
   * 在能力切换到前台时调用
   */
  onForeground() {
    // 记录一条信息日志，表示能力已经切换到前台
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  /**
   * 在能力切换到后台时调用
   */
  onBackground() {
    // 记录一条信息日志，表示能力已经切换到后台
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
