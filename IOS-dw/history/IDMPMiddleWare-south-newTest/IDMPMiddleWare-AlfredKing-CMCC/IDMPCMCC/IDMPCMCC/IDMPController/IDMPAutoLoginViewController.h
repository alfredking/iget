//
//  IDMPAutoLoginViewController.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-15.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, Environment) {
    OnlineEnvironment = 0,
    DebugEnvironment = 1,
};

@interface IDMPAutoLoginViewController : NSObject

typedef void (^accessBlock)(NSDictionary *paraments);
typedef void (^UMCSDKCallBack)(id result);


/**
 *  获得当前登录的用户
 *
 *  @return 返回当前登陆的用户名
 */
+ (NSString *)getNowLoginUser;


/**
 *  此函数获取当前的网络状态
 *
 *  @return 返回为1，当前的网络为蜂窝网，返回2、3代表为wifi链接，但2有SIM卡，3没有，返回-1为错误
 */
+ (int)getAuthType;


/**
 *  接口用于获取统一认证的身份标识；如果为sip应用需要返回应用密码则调用getAppPassword接口来完成。
 *
 *  @param userName        指定用户登陆时的用户名
 *  @param loginType       可以指定登录方式，1表示wap方式，2表示数据短信方式，3表示UP方式
 *  @param isUserDefaultUI 设置是否使用默认界面，为YES时使用，否则用户要自定义界面
 *  @param successBlock    登录成功之后使用的block方法，由应用开发者自行实现。
 *  @param failBlock       登录失败之后使用的block方法，由应用开发者自行实现
 */
+ (void)getAccessTokenWithAppid:(NSString *)appid appkey:(NSString *)appkey userName:(NSString *)userName loginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;



/**
 *  接口用于第三方应用在已登录的情况下，需要切换其他账号登陆
 *
 *  @param userName     已登陆的用户名
 *  @param successBlock 获取缓存的用户列表成功的时候调用
 *  @param failBlock    获取缓存的用户列表失败的时候调用
 */
+ (void)changeAccountWithUserName:(NSString *)userName andFinishBlick:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 *  接口用于第三方应用获取中间件缓存的已登录账号列表。包括当前的登录用户
 *
 *  @param successBlock 获取缓存的用户列表成功的时候调用
 *  @param failBlock    获取缓存的用户列表失败的时候调用
 */
+ (void)getAccountListWithFinishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;



/**
 *  接口用于第三方应用在Token验证失败时调用此方法清理本地环境使用。
 *
 *  @return YES清除缓存成功
 */
+ (BOOL)cleanSSO;


/**
 *  接口用于根据用户名清除其对应的缓存
 *
 *  @param userName 输入的用户名
 *
 *  @return YES清除缓存成功
 */
+ (BOOL)cleanSSOWithUserName:(NSString *)userName;


+ (void)currentEdition;




/**
 *  接口用于创建续签
 *
 *  @paragm  certID
 *  @paragm  mobile
 *  @paragm  callBack
 */
+ (void)renewalAuthTokenWithAppid:(NSString *)appid appkey:(NSString *)appkey certID:(NSString *)certID mobile:(NSString *)mobile callBack:(UMCSDKCallBack)callBack;


/**
 *  获取token接口
 *
 *  @paragm certID
 *  @paragm mobile
 *
 *  @return id
 */
+ (id)getToken:(NSString *)certID mobile:(NSString *)mobile;


/**
 *  退出登录
 */
+ (void)logout;


/**
 *	设置日志是否打印(默认不打印  YES:打印;NO:不打印)
 */
+ (void)setIsPrintLocalLog:(BOOL)isLocalLog;


/**
 *	设置切换环境
 */
+ (void)setEnvironment:(Environment)environment;

@end



