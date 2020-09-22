//
//  IDMPLogReportMode.h
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDMPInterfaceLog;

@interface IDMPLogReportMode : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initLogWithrequestType:(NSString *)requestType requestParm:(NSDictionary *)requestParam authType:(int)authType traceId:(NSString *)traceId;

- (instancetype)initLogWithrequestType:(NSString *)requestType requestParm:(NSDictionary *)requestParam  appid:(NSString *)appid appkey:(NSString *)appkey authType:(int)authType traceId:(NSString *)traceId;

//上传日志
- (void)reportLogWithRepsonseParam:(NSDictionary *)responseParam;


@end
