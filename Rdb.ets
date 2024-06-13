
import relationalStore from '@ohos.data.relationalStore';
import CommonConstants from '../common/CommonConstants';
import Logger from '../common/Logger';

export default class Rdb {
  private rdbStore: relationalStore.RdbStore | null = null;//关系数据库存储对象，初始值为 null
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;

  /**
   * 构造函数，用于初始化表名、创建表的 SQL 语句及列名
   * @param tableName 表名
   * @param sqlCreateTable 创建表的 SQL 语句
   * @param columns 列名数组
   */
  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  /**
   * 获取 RDB Store 实例
   * @param callback 获取 RDB Store 实例后的回调函数
   */
  getRdbStore(callback: Function = () => {
  }) {
    // 检查回调函数是否存在并且有效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'getRdbStore() has no callback!');
      return;
    }
    // 如果 rdbStore 实例已经存在，直接调用回调函数并返回
    if (this.rdbStore !== null) {
      Logger.info(CommonConstants.RDB_TAG, 'The rdbStore exists.');
      callback();
      return
    }
    // 获取上下文对象
    let context: Context = getContext(this) as Context;
    // 调用 relationalStore.getRdbStore 方法获取数据库存储实例
    relationalStore.getRdbStore(context, CommonConstants.STORE_CONFIG, (err, rdb) => {
      if (err) {
        // 获取失败，记录错误日志并返回
        Logger.error(CommonConstants.RDB_TAG, `gerRdbStore() failed, err: ${err}`);
        return;
      }
      // 获取成功，设置 rdbStore 实例，并执行创建表的 SQL 语句
      this.rdbStore = rdb;
      this.rdbStore.executeSql(this.sqlCreateTable);
      // 记录成功日志，并调用回调函数
      Logger.info(CommonConstants.RDB_TAG, 'getRdbStore() finished.');
      callback();
    });
  }

  /**
   * 插入数据
   * @param data 要插入的数据，以键值对形式存储在 ValuesBucket 对象中。
   * @param callback 插入操作完成后的回调函数。回调函数会传入插入操作的结果。
   */
  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    // 检查回调函数是否存在并且有效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'insertData() has no callback!');
      return;
    }
    // 初始化插入结果标志为 false
    let resFlag: boolean = false;
    const valueBucket: relationalStore.ValuesBucket = data;
    // 检查 rdbStore 实例是否存在
    if (this.rdbStore) {
      // 执行插入操作
      this.rdbStore.insert(this.tableName, valueBucket, (err, ret) => {
        if (err) {
          // 如果插入失败，记录错误日志并调用回调函数传入 false
          Logger.error(CommonConstants.RDB_TAG, `insertData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        // 如果插入成功，记录成功日志并调用回调函数传入插入结果
        Logger.info(CommonConstants.RDB_TAG, `insertData() finished: ${ret}`);
        callback(ret);
      });
    }
  }

  /**
   * 删除数据
   * @param predicates 用于指定删除条件的 RdbPredicates 对象。
   * @param callback 删除操作完成后的回调函数。回调函数会传入删除操作的结果。
   */
  deleteData(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    // 检查回调函数是否存在并且有效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'deleteData() has no callback!');
      return;
    }
    // 初始化删除结果标志为 false
    let resFlag: boolean = false;
    // 检查 rdbStore 实例是否存在
    if (this.rdbStore) {
      // 执行删除操作
      this.rdbStore.delete(predicates, (err, ret) => {
        if (err) {
          // 如果删除失败，记录错误日志并调用回调函数传入 false
          Logger.error(CommonConstants.RDB_TAG, `deleteData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        // 如果删除成功，记录成功日志并调用回调函数传入 true
        Logger.info(CommonConstants.RDB_TAG, `deleteData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  /**
   * 更新数据
   * @param predicates 用于指定更新条件的 RdbPredicates 对象。
   * @param data 包含更新数据的 ValuesBucket 对象。
   * @param callback 更新操作完成后的回调函数。回调函数会传入更新操作的结果。
   */
  updateData(predicates: relationalStore.RdbPredicates, data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    // 检查回调函数是否存在并且有效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'updateDate() has no callback!');
      return;
    }
    // 初始化更新结果标志为 false
    let resFlag: boolean = false;
    // 确保数据的类型是 ValuesBucket
    const valueBucket: relationalStore.ValuesBucket = data;
    // 检查 rdbStore 实例是否存在
    if (this.rdbStore) {
      // 执行更新操作
      this.rdbStore.update(valueBucket, predicates, (err, ret) => {
        if (err) {
          // 如果更新失败，记录错误日志并调用回调函数传入 false
          Logger.error(CommonConstants.RDB_TAG, `updateData() failed, err: ${err}`);
          callback(resFlag);
          return;
        }
        // 如果更新成功，记录成功日志并调用回调函数传入 true
        Logger.info(CommonConstants.RDB_TAG, `updateData() finished: ${ret}`);
        callback(!resFlag);
      });
    }
  }

  /**
   * 查询数据
   * @param predicates 用于指定查询条件的 RdbPredicates 对象。
   * @param callback 查询操作完成后的回调函数。回调函数会传入查询结果的 ResultSet 对象。
   */
  query(predicates: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    // 检查回调函数是否存在并且有效
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      Logger.info(CommonConstants.RDB_TAG, 'query() has no callback!');
      return;
    }
    // 检查 rdbStore 实例是否存在
    if (this.rdbStore) {
      // 执行查询操作
      this.rdbStore.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          // 如果查询失败，记录错误日志并提前返回
          Logger.error(CommonConstants.RDB_TAG, `query() failed, err:  ${err}`);
          return;
        }
        // 如果查询成功，记录成功日志并调用回调函数传入查询结果的 ResultSet 对象
        Logger.info(CommonConstants.RDB_TAG, 'query() finished.');
        callback(resultSet);
        // 关闭查询结果的 ResultSet 对象，释放资源
        resultSet.close();
      });
    }
  }
}