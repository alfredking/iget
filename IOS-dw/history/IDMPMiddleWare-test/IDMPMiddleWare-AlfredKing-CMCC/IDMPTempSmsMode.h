//
//  IDMPTempSmsMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPTempSmsMode : NSObject

typedef void (^IDMPBlock)(void);
typedef void (^accessBlock)(NSDictionary *paraments);
//-(void)getSmsCodeWithUserName:(NSString *)userName successBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock;
/**
 *  接口用于第三方应用使用自定义登陆界面，通过临时密码登陆方式登陆时，获取临时登陆密码使用。
 *
 *  @param userName     <#userName description#>
 *  @param appId        <#appId description#>
 *  @param appKey       <#appKey description#>
 *  @param busiType     <#busiType description#>
 *  @param successBlock <#successBlock description#>
 *  @param failBlock    <#failBlock description#>
 */
- (void)getSmsCodeWithUserName:(NSString*)userName appId:(NSString *)appId appKey:(NSString *)appKey busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

-(void)getTMKSWithUserName:(NSString *)userName messageCode:(NSString *)messageCode successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;


@end
