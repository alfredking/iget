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
    printf("key is %s,data is %s,key length is  %d, data length is %d\n",key,data,key_len,data_len);
    unsigned char* cHMAC= (unsigned char*)malloc(CC_SHA256_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA256, key, key_len, data,data_len, cHMAC);
    return cHMAC;
}

@end
