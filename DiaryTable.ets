import relationalStore from '@ohos.data.relationalStore';
import CommonConstants from '../../common/CommonConstants';
import DiaryData from '../../viewmodel/DiaryData';
import Rdb from '../Rdb';
/**
 * Desc: 用于对日记数据库表进行操作，包括插入、删除、更新和查询日记数据。它使用了 @ohos.data.relationalStore 模块来与关系型数据库进行交互。
 */
export default class DiaryTable {
  // 创建一个 Rdb 实例，用于操作数据库
  private diaryTable = new Rdb(
    CommonConstants.DAIRY_TABLE.tableName, // 表名
    CommonConstants.DAIRY_TABLE.sqlCreate, // 创建表的 SQL 语句
    CommonConstants.DAIRY_TABLE.columns // 表的列名
  );

  /**
   * 构造函数
   * @param callback 初始化完成后的回调函数
   */
  constructor(callback: Function = () => {
  }) {
    this.diaryTable.getRdbStore(callback); // 获取 RdbStore
  }

  /**
   * 获取 RdbStore 的方法
   * @param callback 获取 RdbStore 后的回调函数
   */
  getRdbStore(callback: Function = () => {
  }) {
    this.diaryTable.getRdbStore(callback);
  }

  /**
   * 插入数据到日记表中
   * @param object 包含日记数据的对象
   * @param callback 插入完成后的回调函数
   */
  insertData(object: DiaryData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(object); // DiaryData 对象转换为 ValuesBucket 对象
    this.diaryTable.insertData(valueBucket, callback); //将数据插入到数据库中
  }

  /**
   * 从日记表中删除数据
   * @param object 包含要删除的日记数据的对象
   * @param callback 删除完成后的回调函数
   */
  deleteData(object: DiaryData, callback: Function) {
    // 创建一个 RdbPredicates 实例，用于指定删除操作的条件
    let predicates = new relationalStore.RdbPredicates(CommonConstants.DAIRY_TABLE.tableName);
    // 设置删除条件，指定要删除的日记数据的 id
    predicates.equalTo('id', object.id);
    // 根据条件删除数据
    this.diaryTable.deleteData(predicates, callback);
  }

  /**
   * 更新日记表中的数据
   * @param object 包含要更新的日记数据的对象
   * @param callback 更新完成后的回调函数
   */
  updateData(object: DiaryData, callback: Function) {
    // 生成一个 ValuesBucket 实例，包含要更新的数据
    const valueBucket: relationalStore.ValuesBucket = generateBucket(object);
    // 创建一个 RdbPredicates 实例，用于指定更新操作的条件
    let predicates = new relationalStore.RdbPredicates(CommonConstants.DAIRY_TABLE.tableName);
    predicates.equalTo('id', object.id); // 根据 id 匹配要删除的数据
    // 根据条件更新数据
    this.diaryTable.updateData(predicates, valueBucket, callback);
  }

  /**
   * 查询日记表中的数据
   * @param diaryTitle 查询的日记标题
   * @param callback 查询完成后的回调函数
   * @param isAll 是否查询所有数据，默认为 true
   */
  query(diaryTitle: string, callback: Function, isAll: boolean = true) {
    // 创建一个 RdbPredicates 实例，用于指定查询操作的条件
    let predicates = new relationalStore.RdbPredicates(CommonConstants.DAIRY_TABLE.tableName);
    if (!isAll) { // 如果不是查询所有数据，根据日记标题匹配要查询的数据
      predicates.equalTo('diaryTitle', diaryTitle); // 根据日记标题匹配要查询的数据
    }
    // 调用 diaryTable 实例的 query 方法，执行查询操作
    this.diaryTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount; // 获取查询结果的行数
      // 如果查询结果为空，或行数为字符串类型，打印日志并调用回调函数返回空数组
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow(); // 查询结果不为空，移动到第一行
        const result: DiaryData[] = []; // 创建一个数组用于存储查询结果
        // 遍历查询结果，将每一行数据转换为 DiaryData 对象并存储到结果数组中
        for (let i = 0; i < count; i++) {
          let tmp: DiaryData = {
            id: 0, diaryTitle: '', diaryContent: '', diaryTime: ''
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.diaryTitle = resultSet.getString(resultSet.getColumnIndex('diaryTitle'));
          tmp.diaryContent = resultSet.getString(resultSet.getColumnIndex('diaryContent'));
          tmp.diaryTime = resultSet.getString(resultSet.getColumnIndex('diaryTime'));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        // 调用回调函数返回查询结果
        callback(result);
      }
    });
  }
}

/**
 * 生成 ValuesBucket，用于插入和更新数据
 * @param object 包含日记数据的对象
 * @returns ValuesBucket 对象
 */
function generateBucket(object: DiaryData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.diaryTitle = object.diaryTitle;
  obj.diaryContent = object.diaryContent;
  obj.diaryTime = object.diaryTime;
  return obj;// 返回构造好的 ValuesBucket 对象
}