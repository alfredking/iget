//
//  IDMPOpensslDigest.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-18.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPOpensslDigest.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation IDMPOpensslDigest

unsigned char *sha256WithKeyAndData(char* key,int key_len,char *data,int  data_len)
{
    unsigned char* cHMAC= (unsigned char*)malloc(CC_SHA256_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA256, key, key_len, data,data_len, cHMAC);
    return cHMAC;
}



+ (NSString *)hmac_sha256:(NSString *)plaintext withKey:(NSString *)key{
    
    NSString *data = plaintext;
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [self convertDataToHexStr:HMAC];
    NSLog(@"%@", hash);
    return hash;
}



//NSData转十六进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (NSData*)hexStringToNSData:(NSString*)hexStr
{
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([hexStr length] / 2); i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    NSLog(@"%@", data);
    return data;
}

@end
