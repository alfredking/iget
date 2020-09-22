//
//  IDMPTool.h
//  IDMPCMCC
//
//  Created by HGQ on 16/4/18.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^UMCSDKCallBack)(id result);

@interface IDMPTool : NSObject

/**
 *  手机号码解密
 */
+ (void)mobileDecodeWithCnonce:(NSString *)cnonce nonce:(NSString *)nonce callBack:(UMCSDKCallBack)callBack;

/**
 *	验证Token
 */
+ (void)tokenValidateWithAppid:(NSString *)appid token:(NSString *)token callBack:(UMCSDKCallBack)callBack;


+ (void)queryAndDeleteKs:(NSString *)userName isForced:(BOOL)isForced;
    

@end
