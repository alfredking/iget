//
//  IDMPCheckKS.h
//  IDMPCMCC
//
//  Created by wj on 2017/8/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPCheckKS : NSObject

/**
 验证wapks
 
 @param responseHeaders 验证的信息
 @param clientNonce 客户端随机数
 @return 验证成功返回wwwauthenticate
 */
+ (NSDictionary *)checkWAPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce;

/**
 验证上行数据短信ks
 
 @param responseHeaders 验证的信息
 @param clientNonce 客户端随机数
 @return 验证成功返回wwwauthenticate
 */
+ (NSDictionary *)checkDataSmsKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce;

/**
 验证账户密码ks
 
 @param responseHeaders 验证的信息
 @param userName 用户名
 @param passWd 密码
 @param clientNonce 客户端随机数
 @return 验证成功返回wwwauthenticate
 */
+ (NSDictionary *)checkUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd;

/**
 验证短信验证码登录ks
 
 @param responseHeaders 验证的信息
 @param userName 用户名
 @param passWd 密码
 @param clientNonce 客户端随机数
 @return 验证成功返回wwwauthenticate
 */
+ (NSDictionary *)checkDUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd;

/**
 验证语音验证码登录ks
 
 @param responseHeaders 验证的信息
 @param userName 用户名
 @param passWd 密码
 @param clientNonce 客户端随机数
 @return 验证成功返回wwwauthenticate
 */
+ (NSDictionary *)checkVUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd;

/**
 验证更新的ks
 
 @param responseHeaders 验证的信息
 @param userName 用户名
 @param clientNonce 客户端随机数
 @return 验证成功返回wwwauthenticate
 */
+ (NSDictionary *)checkUpdateKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName;
@end
