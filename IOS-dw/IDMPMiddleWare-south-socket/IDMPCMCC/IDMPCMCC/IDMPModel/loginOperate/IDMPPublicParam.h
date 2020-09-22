//
//  IDMPPublicParam.h
//  IDMPCMCC
//
//  Created by wj on 2018/2/1.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPPublicParam : NSObject

+ (NSMutableString *)genPublicParamWithTraceId:(NSString *)traceId;

@end
