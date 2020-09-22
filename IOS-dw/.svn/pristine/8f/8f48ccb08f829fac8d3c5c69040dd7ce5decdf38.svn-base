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
    int len = (int)[privateKey length];
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

NSString *RSA_EVP_Sign(NSString *sourceString)
{
    static NSLock *locksi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locksi = [[NSLock alloc] init];
    });
    [locksi lock];
    
    NSString *privKey=PRIVATE_KEY;
    NSData *data=[sourceString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    if(!data || !privKey){
        return nil;
    }
    
    SecKeyRef keyRef = [IDMPRSA_Encrypt_Decrypt addPrivateKey:privKey];
    if(!keyRef){
        NSLog(@"生成私钥失败");
        return nil;
    }
    
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    //    if(srclen > outlen - 11){
    //        CFRelease(keyRef);
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
    CFRelease(keyRef);
    [locksi unlock];
    return ret;
    
    
    
}


int RSA_EVP_Verify(NSString *srcString,NSString *signature)
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
    
    if(!sourcedata || !pubKey||!signdata){
        return nil;
    }
    
    SecKeyRef keyRef = [IDMPRSA_Encrypt_Decrypt addPublicKey:pubKey];
    if(!keyRef){
        NSLog(@"生成私钥失败");
        return nil;
    }
    
    
    const uint8_t *srcbuf = (const uint8_t *)[sourcedata bytes];
    size_t srclen = (size_t)sourcedata.length;
    const uint8_t *signbuf = (const uint8_t *)[signdata bytes];
    size_t signlen = (size_t)signdata.length;
    
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen > outlen - 11){
        CFRelease(keyRef);
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
        CFRelease(keyRef);
        
        [lockve unlock];
        
        return NO;
        
    }
    else
    {
        NSLog(@"verify success: %d", (int)status);
        free(outbuf);
        CFRelease(keyRef);
        
        [lockve unlock];
        return YES;
        
        
    }
    
    
}


@end
