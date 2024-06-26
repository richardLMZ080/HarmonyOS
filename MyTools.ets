import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

/*
 * Desc: 系统工具类，提供常用工具方法
 */
export class MyTools {

  /**
   * 获取当前日期时间字符串
   * @returns YYYY-MM-DD HH:mm:ss
   */
  getCurrentDateTime(): string {
    // 获取当前北京时间的时间戳（单位为毫秒）
    var stamp = new Date().getTime() + 8 * 60 * 60 * 1000;
    // 格式化北京时间为"YYYY-MM-DD HH:mm:ss"
    var beijingTime = new Date(stamp).toISOString().replace(/T/, ' ').replace(/\..+/, '').substring(0, 19);
    return beijingTime;
  }

  /**
   * 生成随机18位数字
   * @returns
   */
  getRandom18Digits(): string {
    // 使用Math.random()生成随机浮点数，范围在[0, 1)之间
    const randomFloat = () => Math.random();

    // 将随机浮点数转换为指定长度的随机整数
    const randomInteger = (length: number): number => {
      const max = Math.pow(10, length) - 1;
      return Math.floor(randomFloat() * max);
    };

    // 生成18位的随机数字字符串
    return Array.from({ length: 18 }, () => String(randomInteger(1))).join('');
  }

  /**
   * 跳转到目标页面的提示框
   * @param message 提示语
   * @param url 目标页面路径地址
   */
  goToPage(message: string, url: string, paramsValue?: {}) {
    AlertDialog.show({
      title: "提示：", //弹窗标题
      message: message, // 提示消息
      autoCancel: true, // 点击遮罩层即阴影，是否关闭弹窗。true是点击遮罩层弹窗关闭。
      alignment: DialogAlignment.Center, //弹窗位置
      offset: { dx: 0, dy: 0 }, // 相对弹窗位置即DialogAlignment.Bottom 在x轴和y轴偏移
      primaryButton: {
        value: "确定",
        fontColor: Color.Red,
        action: () => {
          router.pushUrl({
            url: url,
            params: paramsValue
          }, router.RouterMode.Single)
        }
      },
      cancel: () => { // 点击遮罩层后，遮罩层消失,弹窗自动关闭时候触发，此时必须autoCancel:true，为false则失效
        router.pushUrl({
          url: url,
        }, router.RouterMode.Single)
      }
    })
  }

  /**
   * 获取浮点数的小数位数
   * @param num 浮点数
   * @returns 小数位数
   */
  getPrecision(num: number) {
    const str = String(num);
    const decimalIndex = str.indexOf('.');
    return decimalIndex === -1 ? 0 : str.length - decimalIndex - 1;
  }

  /**
   * 乘法运算，确保精度
   * @param a 乘数
   * @param b 乘数
   * @returns 乘积
   */
  multiply(a: number, b: number) {
    const precision = this.getPrecision(a) + this.getPrecision(b);
    const multiplier = Math.pow(10, precision);
    return (Math.round(a * multiplier) * Math.round(b * multiplier)) / (multiplier * multiplier);
  }

  /**
   * 弹框提示
   * @param message 提示消息
   * @param time 提示消息显示时长（可选），默认为2000毫秒
   */
  alertMsg(message: string | Resource, time?: number) {
    promptAction.showToast({
      message: message, //message属性用于设置提示信息
      duration: time ? time : 2000, //duration属性用于设置提示信息停留时长，单位为毫秒，取值范围是[1500,10000]
      bottom: '360vp' //bottom属性用于设置提示信息到底部的距离
    })
  }

  /**
   * 减法运算，确保精度
   * @param arg1 被减数
   * @param arg2 减数
   * @returns 差值，确保精度
   */
  floatSub(arg1, arg2) {
    var r1, r2, m, n;
    try {
      r1 = arg1.toString().split(".")[1].length
    } catch (e) {
      r1 = 0
    }
    try {
      r2 = arg2.toString().split(".")[1].length
    } catch (e) {
      r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //动态控制精度长度
    n = (r1 >= r2) ? r1 : r2;
    return ((arg1 * m - arg2 * m) / m).toFixed(n);
  }
}
// 导出 MyTools 类的实例，方便全局使用
export const myTools = new MyTools();