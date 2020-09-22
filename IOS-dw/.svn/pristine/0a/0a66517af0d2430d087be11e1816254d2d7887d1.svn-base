//
//  IDMPRegisterMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/24.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPAccountManagerMode : NSObject

typedef void (^accessBlock)(NSDictionary *paraments);

+ (IDMPAccountManagerMode *)shareAccountManager;

- (void)registerUserWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;


- (void)resetPasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;

- (void)changePasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;

- (void)submitValidateWithAppId:(NSString *)appId appKey:(NSString *)appKey phoneNo:(NSString *)phoneNo validCode:(NSString *)validCode busiType:(NSString *)busiType succeedBlock:(accessBlock)successBlock  failedBlock:(accessBlock)failBlock;


- (void)setPasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo cert:(NSString *)cert password:(NSString *)password busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


@end
