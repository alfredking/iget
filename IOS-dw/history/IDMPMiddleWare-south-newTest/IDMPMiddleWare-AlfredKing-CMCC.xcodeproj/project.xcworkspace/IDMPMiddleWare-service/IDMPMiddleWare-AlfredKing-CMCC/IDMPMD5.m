//
//  IDMPMD5.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPMD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation IDMPMD5


- (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), md5);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", md5[i]];
    
    return result;
}


@end
