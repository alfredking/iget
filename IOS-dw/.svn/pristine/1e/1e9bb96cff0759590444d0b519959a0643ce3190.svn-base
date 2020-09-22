//
//  IDMPQueryPwdModel.h
//  IDMPCMCC
//
//  Created by HGQ on 16/2/1.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPQueryModel : NSObject
typedef void (^accessBlock)(NSDictionary *paraments);


/**
 查询AppPassword

 @param userName 用户名
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
+ (void)queryAppPasswdWithUserName:(NSString *)userName finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;

/**
 网络校验appid，appkey

 @param appid appid
 @param appkey appkey
 @param traceId traceId
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
+ (void)checkWithAppId:(NSString *)appid andAppkey:(NSString *)appkey traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;


/**
 清除ks

 @param btid btid
 @param sqn sqn
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
+(void)cleanSsoSuccessNotificationWithBtid:(NSString *)btid andSqn:(NSString *)sqn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


/**
 缓存检查appid是否校验

 @return 校验结果
 */
+(BOOL)appidIsChecked;


/**
 获取配置

 @param completionBlock 完成回调
 */
+ (void)getConfigsWithCompletionBlock:(accessBlock)completionBlock;


@end
