//
//  IDMPCoreEngine.h
//  IDMPCMCC
//
//  Created by wj on 2017/12/28.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^accessBlock)(NSDictionary *paraments);



@interface IDMPCoreEngine : NSObject

- (void)requestValidateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime traceId:(NSString *)traceId finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock;

-(void)requestAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType sip:(NSString *)sip traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

-(void)requestTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType sip:(NSString *)sip traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

//- (void)requestAccountWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password validCodeOrNewPwd:(NSString *)validCodeOrNewPwd option:(NSUInteger)option traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;

- (void)requestRegisterUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

- (void)requestResetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

- (void)requestChangePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

-(void)requestCheckIsLocalNumberWith:(NSString *)userName traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;

- (void)requestReAuthenticationWithUserName:(NSString *)userName traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

- (void)requestCleanSSOWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

- (void)requestCleanSSOWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

- (int)getAuthType;

- (int)getOperatorType;

- (void)noCacheLoginWithLoginType:(NSInteger)loginType traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
@end
