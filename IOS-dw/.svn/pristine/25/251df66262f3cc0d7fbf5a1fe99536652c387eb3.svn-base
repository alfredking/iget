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

+ (void)queryAppPasswdWithUserName:(NSString *)userName finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;
+ (void)checkWithAppId:(NSString *)Appid andAppkey:(NSString *)Appkey traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock;
+(void)cleanSsoSuccessNotificationWithBtid:(NSString *)btid andSqn:(NSString *)sqn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
+(BOOL)appidIsChecked;
+ (void)getConfigsWithCompletionBlock:(accessBlock)completionBlock;


@end
