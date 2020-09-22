
# 3.1.7.1
1. 国密改造，增加SM4，SM3。AES全部替换为SM4。Mac最后的哈希由md5改为SM3。
2. 网络传输时用到的RSA加密全部替换SM2。

#   3.2.3 同步3.1.7.0的更新
1. 增加无缓存签发token接口。
2. 接口都改为顺序执行。

#   3.1.7.0-state-secret
1. 修复日志上报中可能由于反复读写导致的崩溃，不重用nsuserdefault;
2. 密码加密改为国密;
3. 异步线程移到最外面，防止reachability在主线程调用超时崩溃。![链接](https://stackoverflow.com/questions/4461238/scnetworkreachabilitygetflags-in-reachability-sample-code-takes-too-long-to-retu);
4. 合并工具类（包括加解密等）到category;
5. 优化数据层类;
6. 优化字符串常量定义;
7. 优化用户管理接口;
8. 优化协商ks请求中参数生成类 ;
9. 日志上报中的日志全部使用json数组，增加操作系统字段用于定位
10. wap网络请求中102102说明的优化及有时没有102102说明的bug
11. 修复一个wifi和流量同时开启判断的bug
12. wap增加移动网络权限判断
13. 修改获取版本号接口返回字符串
#   3.2.2
1. 修复香港号码无回调问题

#   3.2.1
1. 二次鉴权修改弹窗，及文案修改
2. openssl库替换为1.0.2h
#   3.2.0
1. 增加异网wap登录
2. getaccesstoken返回掩码
3. 4g免流日志上报增加弹窗日志
4. socket网络层重构


