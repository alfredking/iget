//
//  IDMPOpensslDigest.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-18.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPOpensslDigest.h"

@implementation IDMPOpensslDigest

unsigned char* sha256WithKeyAndData(char* key,char *data)
{
    unsigned char* md= (unsigned char*)malloc(EVP_MAX_MD_SIZE);
    unsigned int md_length=EVP_MAX_MD_SIZE;
    HMAC_CTX ctx;
    HMAC_CTX_init(&ctx);
    HMAC_Init_ex(&ctx,key,strlen(key),EVP_sha256(),NULL);
    HMAC_Update(&ctx,(unsigned char*)data,strlen(data));
    HMAC_Final(&ctx,md,&md_length);
    HMAC_CTX_cleanup(&ctx);
    return md;
    
}

@end
