//
//  IDMPInterfaceLog.m
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPInterfaceLog.h"
#import "IDMPDevice.h"
#import <objc/runtime.h>

@interface IDMPInterfaceLog()

@property (nonatomic, strong) NSString *responseTime;
@property (nonatomic, strong) NSDictionary *response;
@property (nonatomic, strong) NSString *traceId;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *sdkVersion;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *networkType;
@property (nonatomic, strong) NSString *requestType;
@property (nonatomic, strong) NSString *requestTime;
@property (nonatomic, strong) NSDictionary *request;
@property (nonatomic, strong) NSString *systemName;

@end

@implementation IDMPInterfaceLog

- (instancetype)initWithRequestType:(NSString *)requestType requestTime:(NSString *)requestTime requestParam:(NSDictionary *)requestParam appid:(NSString *)appid appkey:(NSString *)appkey networkType:(NSString *)networkType traceId:(NSString *)traceId {
    if (self = [super init]) {
        self.appid = appid;
        self.sdkVersion = sdkversionValue;
        self.requestTime = requestTime;
        self.requestType = requestType;
        self.request = requestParam;
        self.networkType = networkType;
        self.traceId = traceId;
        self.deviceId = [IDMPDevice getDeviceID];
        self.systemName = [IDMPDevice getSystemName];
    }
    return self;
}

- (void)setResponseTime:(NSString *)responseTime responseParam:(NSDictionary *)responseParam {
    self.responseTime = responseTime;
    self.response = responseParam;
}

- (NSDictionary *)dictionary {
    unsigned int count = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        if (value == nil) {
            // nothing todo
        }
        else if ([value isKindOfClass:[NSNumber class]]
                 || [value isKindOfClass:[NSString class]]
                 || [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableArray class]]) {
            // TODO: extend to other types
            [dictionary setObject:value forKey:key];
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            [dictionary setObject:[value dictionary] forKey:key];
        }
        else {
            NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
        }
    }
    free(properties);
    return dictionary;
}



@end
