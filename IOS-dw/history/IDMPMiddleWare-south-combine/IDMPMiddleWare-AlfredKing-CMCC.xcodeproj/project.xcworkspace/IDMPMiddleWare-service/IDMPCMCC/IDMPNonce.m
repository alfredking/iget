//
//  IDMPNonce.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPNonce.h"
#import "IDMPMD5.h"

@implementation IDMPNonce

+(NSString *)getClientNonce
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    long long longTime = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *NSTime = [NSString stringWithFormat:@"%llu",longTime];
    
    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
    
    return [md5 getMd5_32Bit_String:NSTime];
}

@end
