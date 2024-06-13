import hilog from '@ohos.hilog';

const LOGGER_PREFIX: string = 'bobo_log';// 定义日志前缀

/*
 * Desc: 日志封装类，提供一个封装的、统一的日志记录接口，用于记录不同级别的日志信息。通过这个类，可以方便地记录调试信息、普通信息、警告信息和错误信息。
 */
class Logger {
  private domain: number;// 服务域
  private prefix: string;// 日志前缀

  // format 表示日志格式字符串
  private format: string = '%{public}s';// 用于格式化日志信息的字符串模板

  /**
   * 构造函数.
   *
   * @param prefix 标识日志标签.
   * @param domain 表示服务域，这是一个范围从0x0到0xFFFFF的十六进制整数
   * @param args 表示日志参数.
   */
  constructor(prefix: string = '', domain: number = 0xFF00) {
    this.prefix = prefix;// 初始化日志前缀
    this.domain = domain;// 初始化服务域
  }

  /**
   * 打印 debug 级别的日志.
   * @param args 表示日志参数.
   */
  debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);// 使用 hilog.debug 打印调试日志
  }

  /**
   * 打印 info 级别的日志.
   * @param args 表示日志参数.
   */
  info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);// 使用 hilog.info 打印信息日志
  }

  /**
   * 打印 warn 级别的日志.
   * @param args 表示日志参数.
   */
  warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);// 使用 hilog.warn 打印警告日志
  }

  /**
   * 打印 error 级别的日志.
   * @param args 表示日志参数.
   */
  error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);// 使用 hilog.error 打印错误日志
  }
}
// 导出一个 Logger 实例，具有特定的日志前缀和服务域
export default new Logger(LOGGER_PREFIX, 0xFF02);