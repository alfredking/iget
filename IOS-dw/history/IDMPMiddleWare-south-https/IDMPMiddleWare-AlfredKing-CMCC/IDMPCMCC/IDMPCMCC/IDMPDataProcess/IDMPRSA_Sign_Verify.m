//
//  IDMPRSA_Sign_Verify.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Sign_Verify.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import <CommonCrypto/CommonCrypto.h>
#import "IDMPFormatTransform.h"


@implementation IDMPRSA_Sign_Verify


NSString *secRSA_EVP_Sign(NSString *sourceString)
{
    static NSLock *locksi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locksi = [[NSLock alloc] init];
    });
    [locksi lock];
    
    NSString *privKey=PRIVATE_KEY;
    NSData *data=[sourceString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    if(!data || !privKey)
    {
        [locksi unlock];
        return nil;
    }
    
    SecKeyRef keyRef = [IDMPRSA_Encrypt_Decrypt addPrivateKey:privKey];
    if(!keyRef){
        NSLog(@"生成私钥失败");
        [locksi unlock];
        return backupRSA_EVP_Sign(sourceString);
    }
    
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    //    if(srclen > outlen - 11){
    //        return nil;
    //    }
    void *outbuf = malloc(outlen);
    
    OSStatus status = noErr;
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256((const void *)srcbuf, srclen, digest);
    status = SecKeyRawSign(keyRef,
                           kSecPaddingPKCS1SHA256,
                           digest,
                           CC_SHA256_DIGEST_LENGTH,
                           outbuf,
                           &outlen
                           );
    //    NSData *ret = nil;
    NSString *ret = nil;
    
    if (status != 0)
    {
        NSLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }
    else
    {
        
        ret =[[IDMPFormatTransform charToNSHex:outbuf length:outlen] lowercaseString];
        //        ret =[NSData dataWithBytes:outbuf length:outlen];
        
    }
    free(outbuf);
    [locksi unlock];
    return ret;
    
    
    
}


int secRSA_EVP_Verify(NSString *srcString,NSString *signature)
{
    static NSLock *lockve = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lockve = [[NSLock alloc] init];
    });
    [lockve lock];
    NSString *pubKey=PUBLIC_KEY;
    NSData *sourcedata=[IDMPFormatTransform hexStringToNSData:srcString];
    NSData *signdata=[IDMPFormatTransform hexStringToNSData:signature];
    
    if(!sourcedata || !pubKey||!signdata)
    {
        [lockve unlock];
        return nil;
    }
    
    SecKeyRef keyRef = [IDMPRSA_Encrypt_Decrypt addPublicKey:pubKey];
    if(!keyRef)
    {
        NSLog(@"生成私钥失败");
        [lockve unlock];
        return backupRSA_EVP_Verify(srcString,signature);
    }
    
    
    const uint8_t *srcbuf = (const uint8_t *)[sourcedata bytes];
    size_t srclen = (size_t)sourcedata.length;
    const uint8_t *signbuf = (const uint8_t *)[signdata bytes];
    size_t signlen = (size_t)signdata.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen > outlen - 11)
    {
        [lockve unlock];
        return nil;
    }
    void *outbuf = malloc(outlen);
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    OSStatus status = noErr;
    CC_SHA256((const void *)srcbuf, srclen, digest);
    status = SecKeyRawVerify(keyRef,
                             kSecPaddingPKCS1SHA256,
                             digest,
                             CC_SHA256_DIGEST_LENGTH,
                             signbuf,
                             signlen
                             );
    
    NSLog(@"验证结果 %d",(int)status);
    
    if (status != noErr)
    {
        NSLog(@"verify fail: %d", (int)status);
        free(outbuf);
        
        [lockve unlock];
        
        return NO;
        
    }
    else
    {
        NSLog(@"verify success: %d", (int)status);
        free(outbuf);
        [lockve unlock];
        return YES;
        
        
    }
    
    
}




NSString *backupRSA_EVP_Sign(NSString *data)
{
    static NSLock *locksi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locksi = [[NSLock alloc] init];
    });
    [locksi lock];
    unsigned char *Str=(unsigned char *)[data UTF8String];
    EVP_PKEY *prikey;
    NSString *private = formatPrivateKey(PRIVATE_KEY);
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes],(int)[pri length]);
    prikey = PEM_read_bio_PrivateKey(bio, NULL,NULL, NULL);
    BIO_free(bio);
    int strLen=(int)strlen((const char *)Str);
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


int backupRSA_EVP_Verify(NSString *srcString,NSString *signature)
{
    static NSLock *lockve = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lockve = [[NSLock alloc] init];
    });
    [lockve lock];
    char *Str=(char *)[srcString UTF8String];
    char *sign=(char *)[signature UTF8String];
    EVP_PKEY *pubkey;
    NSString *private = formatPrivateKey(PRIVATE_KEY);
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes], (int)[pri length]);
    pubkey = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    if(NULL==pubkey)
    {
        ERR_print_errors_fp(stdout);
    }
    EVP_MD_CTX mdctx;
    EVP_MD_CTX_init(&mdctx);
    int strLen=(int)strlen(Str);
    int signLen=(int)strlen(sign);
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
    int result=EVP_VerifyFinal(&mdctx,(const unsigned char *)sign,signLen,pubkey);
    EVP_PKEY_free(pubkey);
    EVP_MD_CTX_cleanup(&mdctx);
    [lockve unlock];
    return result;
}


@end
