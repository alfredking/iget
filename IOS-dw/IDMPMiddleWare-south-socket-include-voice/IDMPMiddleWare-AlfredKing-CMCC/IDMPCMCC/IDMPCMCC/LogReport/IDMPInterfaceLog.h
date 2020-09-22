//
//  IDMPInterfaceLog.h
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPInterfaceLog : NSObject

@property (nonatomic, strong, readonly) NSString *responseTime;
@property (nonatomic, strong, readonly) NSDictionary *response;
@property (nonatomic, strong, readonly) NSString *traceId;
@property (nonatomic, strong, readonly) NSString *appid;
@property (nonatomic, strong, readonly) NSString *sdkVersion;
@property (nonatomic, strong, readonly) NSString *deviceId;
@property (nonatomic, strong, readonly) NSString *networkType;
@property (nonatomic, strong, readonly) NSString *requestType;
@property (nonatomic, strong, readonly) NSString *requestTime;
@property (nonatomic, strong, readonly) NSDictionary *request;

- (instancetype)initWithRequestType:(NSString *)requestType requestTime:(NSString *)requestTime requestParam:(NSDictionary *)requestParam networkType:(NSString *)networkType traceId:(NSString *)traceId;

- (void)setResponseTime:(NSString *)responseTime responseParam:(NSDictionary *)responseParam;

- (NSDictionary *)dictionary;

@end
