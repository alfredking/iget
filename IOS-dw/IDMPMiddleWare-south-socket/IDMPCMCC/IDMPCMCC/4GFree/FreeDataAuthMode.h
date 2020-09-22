//
//  FreeDataAuthMode.h
//  IDMPCMCC
//
//  Created by wj on 2017/11/30.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^accessBlock)(NSDictionary *paraments);


@interface FreeDataAuthMode : NSObject


/**
 4g免流查询

 @param traceId 日志上报id
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
+ (void)freeDataAuthWithTraceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

@end
