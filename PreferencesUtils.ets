import dataPreferences from '@ohos.data.preferences'
import Logger from './Logger'

const PREFERENCES_NAME = 'boboPreferences' // 首选项名字

/**
 * Desc: 工具类，用于操作首选项存储，在应用中实现数据的持久化存储和读取。
 */
export default class PreferencesUtils {
  // 静态变量，保存 Preferences 实例
  static preference = null

  /**
   * 创建 Preferences 实例
   * @param context 应用上下文
   */
  static async createPreferences(context) {
    // 获取 Preferences 实例
    this.preference = await dataPreferences.getPreferences(context, PREFERENCES_NAME)
  }

  /**
   * 保存数据到 Preferences 中
   * @param key 数据的键
   * @param data 数据的值
   */
  static saveData(key: string, data: string) {
    // 日志记录保存的数据
    Logger.debug(`保存数据到 Preferences:[${key} = ${data}]`);
    this.preference.put(key, data)
    // 只有调用该方法，才能持久化存储
    this.preference.flush()
  }

  /**
   * 从 Preferences 中获取数据
   * @param key 数据的键
   * @returns 获取到的数据值
   */
  static async getData(key: string) {
    // 从 Preferences 中获取数据，默认为空字符串
    let data = this.preference.get(key, "");
    // 日志记录获取到的数据
    Logger.debug(`从 Preferences 中获取数据:[${key} = ${data}]`);
    return data;
  }
}