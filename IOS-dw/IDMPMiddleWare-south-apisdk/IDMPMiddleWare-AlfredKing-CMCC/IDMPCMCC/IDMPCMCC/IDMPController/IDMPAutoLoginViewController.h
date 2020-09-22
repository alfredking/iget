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

typedef void (^accessBlock)(NSDictionary *paraments);
typedef void (^UMCSDKCallBack)(id result);

@interface IDMPAutoLoginViewController : NSObject


/**
 *  此函数获取当前的网络状态
 *
 *  @return 返回为1，当前的网络为蜂窝网，返回2、3代表为wifi链接，但2有SIM卡，3没有，返回-1为错误
 */
+ (int)getAuthType;


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


///**
// *  退出登录，如果缓存还有效，则不清除
// */
//+ (BOOL)logout;

/**
 *  指定用户名退出登录，如果缓存还有效，则不清除
 *  @param userName 输入的用户名
 */
+ (void)logoutWithUserName:(NSString *)userName;

/**
 *  指定用户名退出登录，即时缓存有效也清除
 *  @param userName 输入的用户名
 */
+ (void)logoutForcedWithUserName:(NSString *)userName;

/**
 *  接口用于根据用户名清除其对应的缓存
 *
 *  @param userName 输入的用户名
 *
 *  @return YES清除缓存成功
 */
//+ (BOOL)cleanSSOWithUserName:(NSString *)userName;


/**
 *	设置日志是否打印(默认不打印  YES:打印;NO:不打印)
 */
+ (void)setIsPrintLocalLog:(BOOL)isLocalLog;


/**
 *	设置切换环境
 */
+ (void)setEnvironment:(Environment)environment;

@end



