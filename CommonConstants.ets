import relationalStore from '@ohos.data.relationalStore';// 导入 @ohos.data.relationalStore 模块，用于操作关系型数据库
import { DiaryTable } from '../viewmodel/DiaryTable';// 导入 DiaryTable 接口，用于定义数据库表结构
/**
 * 用于存储项目中的常量配置
 */
export default class CommonConstants {

  /**
   * 登录密钥常量，用于存储和检索用户登录密钥。
   */
  static readonly LOGIN_KEY = 'login_key';

  /**
   * Rdb 数据库配置。
   * 包含数据库的名称和安全级别。
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db', // 数据库文件名
    securityLevel: relationalStore.SecurityLevel.S1 //// 数据库安全级别
  };

  /**
   * 日记表的配置。
   * 包含表名、创建表的 SQL 语句和表的列名。
   */
  static readonly DAIRY_TABLE: DiaryTable = {
    tableName: 'diaryTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS diaryTable(id INTEGER PRIMARY KEY AUTOINCREMENT, diaryTitle TEXT, diaryContent TEXT, diaryTime TEXT)',
    columns: ['id', 'diaryTitle', 'diaryContent', 'diaryTime']
  };

  /**
   * 搜索组件的搜索文本
   */
  static readonly SEARCH_TEXT = '搜索';

  /**
   * 提示组件的 toast 文本
   */
  static readonly TOAST_TEXT_1 = '日记标题不能为空！';
  static readonly TOAST_TEXT_2 = '日记内容不能为空！';

  /**
   * 组件的尺寸配置
   */
  static readonly FULL_WIDTH = '100%';// 组件的全宽度
  static readonly FULL_HEIGHT = '100%';// 组件的全高度
  static readonly DIALOG_HEIGHT = '55%';// 对话框的高度
  static readonly TABS_HEIGHT = '45%';// 标签栏的高度
  static readonly MINIMUM_SIZE = 0;// 组件的最小尺寸
  static readonly FULL_SIZE = 1;// 组件的全尺寸
  static readonly PROMPT_BOTTOM = '70vp';// 提示框距底部的距离

  /**
   * 组件的位置配置
   */
  static readonly EDIT_POSITION_X = '80%';// 编辑按钮在 x 轴的位置
  static readonly EDIT_POSITION_Y = '90%';// 编辑按钮在 y 轴的位置
  static readonly DELETE_POSITION_X = '50%';
  static readonly DELETE_POSITION_Y = '90%';

  /**
   * 日志标签
   */
  static readonly RDB_TAG = '[Debug.Rdb]';// Rdb 日志标签
  static readonly TABLE_TAG = '[Debug.DiaryTable]';// DiaryTable 日志标签
  static readonly INDEX_TAG = '[Debug.Index]';// Index 日志标签
}