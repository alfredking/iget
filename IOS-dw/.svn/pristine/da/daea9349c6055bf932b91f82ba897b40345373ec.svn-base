//
//  IDMPOpensslDigest.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-18.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPOpensslDigest.h"
#import <CommonCrypto/CommonCrypto.h>
#import "IDMPFormatTransform.h"

@implementation IDMPOpensslDigest

unsigned char* sha256WithKeyAndData(char* key,int key_len,char *data,int  data_len)
{
    NSLog(@"key is");
    print_hex(key);
    NSLog(@"data is");
    print_hex(data);
    unsigned char* cHMAC= (unsigned char*)malloc(CC_SHA256_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA256, key, key_len, data,data_len, cHMAC);
    return cHMAC;
}

@end
