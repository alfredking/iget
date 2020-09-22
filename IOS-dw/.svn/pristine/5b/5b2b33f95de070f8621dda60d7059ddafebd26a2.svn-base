//
//  IDMPRSA_Sign_Verify.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Sign_Verify.h"
#import "IDMPRSA_Encrypt_Decrypt.h"


@implementation IDMPRSA_Sign_Verify
NSString * formatPublic(NSString *publicKey)
{
    
    NSMutableString *result = [NSMutableString string];
    
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    
    int count = 0;
    
    for (int i = 0; i < [publicKey length]; ++i) {
        
        unichar c = [publicKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == 64) {
            [result appendString:@"\n"];
            count = 0;
        }
        
    }
    
    [result appendString:@"\n-----END PUBLIC KEY-----\n"];
    
    return result;
    
}

NSString *formatPrivate(NSString *privateKey)
{
    
    const char *pstr = [privateKey UTF8String];
    int len = [privateKey length];
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
    int index = 0;
    int count = 0;
    while (index < len) {
        char ch = pstr[index];
        if (ch == '\r' || ch == '\n') {
            ++index;
            continue;
        }
        [result appendFormat:@"%c", ch];
        if (++count == 64)
        {
            [result appendString:@"\n"];
            count = 0;
        }
        index++;
    }
    [result appendString:@"\n-----END RSA PRIVATE KEY-----"];
    return result;
}

NSString *RSA_EVP_Sign(NSString *data)
{
    static NSLock *locksi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locksi = [[NSLock alloc] init];
    });
    [locksi lock];
    unsigned char *Str=[data UTF8String];
    EVP_PKEY *prikey;
    NSString *private = formatPrivate(PRIVATE_KEY);
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes], [pri length]);
    prikey = PEM_read_bio_PrivateKey(bio, NULL,NULL, NULL);
    BIO_free(bio);
    int strLen=strlen(Str);
    EVP_MD_CTX mdctx;
    EVP_MD_CTX_init(&mdctx);
    if(!EVP_SignInit_ex(&mdctx, EVP_sha256(), NULL))
    {
        printf("error\n");
        EVP_PKEY_free(prikey);
    }
    if(!EVP_SignUpdate(&mdctx, Str, strLen))
    {
        printf("error\n");
        EVP_PKEY_free(prikey);
        
    }
    unsigned int signLen=EVP_PKEY_size(prikey);
    unsigned char* signBuf=(unsigned char *)calloc(signLen+1, sizeof(unsigned char));
    
    if(!EVP_SignFinal(&mdctx, signBuf, &signLen, prikey))
    {
        printf("error\n");
        EVP_PKEY_free(prikey);
    }
    EVP_MD_CTX_cleanup(&mdctx);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++)
        [result appendFormat:@"%02x", signBuf[i]];
     [locksi unlock];
    EVP_PKEY_free(prikey);
    free(signBuf);
    return result;
    
}


int RSA_EVP_Verify(NSString *srcString,NSString *signature)
{
    static NSLock *lockve = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lockve = [[NSLock alloc] init];
    });
    [lockve lock];
    char *Str=[srcString UTF8String];
    char *sign=[signature UTF8String];
    EVP_PKEY *pubkey;
    NSString *private = formatPrivate(PRIVATE_KEY);
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes], [pri length]);
    pubkey = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    if(NULL==pubkey)
    {
        ERR_print_errors_fp(stdout);
    }
    EVP_MD_CTX mdctx;
    EVP_MD_CTX_init(&mdctx);
    int strLen=strlen(Str);
    int signLen=strlen(sign);
    if(!EVP_VerifyInit_ex(&mdctx, EVP_sha256(), NULL))
    {
        printf("error\n");
        EVP_PKEY_free(pubkey);
    }
    if(!EVP_VerifyUpdate(&mdctx, Str, strLen))
    {
        printf("error\n");
        EVP_PKEY_free(pubkey);
        
    }
    int result=EVP_VerifyFinal(&mdctx,sign,signLen,pubkey);
    EVP_PKEY_free(pubkey);
    EVP_MD_CTX_cleanup(&mdctx);
     [lockve unlock];
    return result;
}


@end
