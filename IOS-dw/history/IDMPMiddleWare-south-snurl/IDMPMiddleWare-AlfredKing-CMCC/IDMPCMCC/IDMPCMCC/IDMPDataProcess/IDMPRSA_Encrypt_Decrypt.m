//
//  IDMPRSA_Encrypt_Decrypt.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPFormatTransform.h"
@implementation IDMPRSA_Encrypt_Decrypt

NSString * formatPublicKey(NSString *publicKey)
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

NSString *formatPrivateKey(NSString *privateKey)
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

NSString *RSA_encrypt(NSString *data)
{
    static NSLock *locken = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locken = [[NSLock alloc] init];
    });
    [locken lock];

    unsigned char *str=(unsigned char*)[data UTF8String];
    unsigned char *p_en;
    RSA *p_rsa;
    int rsa_len;
    NSString *public = formatPublicKey(PUBLIC_KEY);
    NSData *pub= [public dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pub bytes], [pub length]);
    p_rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    NSLog(@"bio free");
    BIO_free(bio);
    rsa_len=RSA_size(p_rsa);
    p_en=(unsigned char *)malloc(rsa_len+1);
    memset(p_en,0,rsa_len+1);
    int Result=RSA_public_encrypt((int)strlen((const char*)str),(unsigned char *)str,(unsigned char*)p_en,p_rsa,RSA_PKCS1_PADDING);
    if(Result<0)
        return NULL;
    NSLog(@"rsa free");
    RSA_free(p_rsa);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++)
        [result appendFormat:@"%02x", (unsigned char)p_en[i]];
    NSLog(@"p_en free");
    free(p_en);
    NSLog(@"completed free");
    p_en=NULL;
    [locken unlock];
    return result;
    
}

NSString *RSA_decrypt(NSString *data)
{
    static NSLock *lockde = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lockde = [[NSLock alloc] init];
    });
    [lockde lock];
    unsigned char *str = [IDMPFormatTransform hexStringToNSData:data];
    unsigned char *p_de;
    RSA *p_rsa;
    int rsa_len;
    NSString *private = formatPrivateKey(PRIVATE_KEY);
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes], [pri length]);
    p_rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    rsa_len=RSA_size(p_rsa);
    NSLog(@"rsa_len is %d",rsa_len);
    p_de=(unsigned char *)malloc(rsa_len+1);
    memset(p_de,0,rsa_len+1);
    int slen=rsa_len;
    if(RSA_private_decrypt(slen,(unsigned char *)str,(unsigned char*)p_de,p_rsa,RSA_PKCS1_PADDING)<0){
        return NULL;
    }
    RSA_free(p_rsa);
    NSString *result = [NSString stringWithUTF8String:p_de];
    free(p_de);
    p_de=NULL;
    [lockde unlock];
    return result;
    
}
@end
