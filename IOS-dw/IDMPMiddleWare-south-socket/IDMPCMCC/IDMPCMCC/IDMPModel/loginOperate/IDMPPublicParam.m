//
//  IDMPPublicParam.m
//  IDMPCMCC
//
//  Created by wj on 2018/2/1.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "IDMPPublicParam.h"
#import "IDMPDevice.h"

@implementation IDMPPublicParam

+ (NSMutableString *)genPublicParamWithTraceId:(NSString *)traceId {
    NSMutableString *publicParam = [NSMutableString string];
    [publicParam appendString:[NSString stringWithFormat:@",%@=\"%@\"",sdkversion, sdkversionValue]];
    [publicParam appendString:[NSString stringWithFormat:@",%@=\"%@\"",IDMPTraceId, traceId]];
    [publicParam appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksIOS_ID, [IDMPDevice getDeviceID]]];
    return publicParam;
}

@end
