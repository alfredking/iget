//
//  NSString+IDMPAdd.m
//  IDMPCMCC
//
//  Created by wj on 2018/1/23.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "NSString+IDMPAdd.h"
#import "NSData+IDMPAdd.h"
#import "IDMPDevice.h"
#include"openssl/pem.h"
#include<openssl/evp.h>
#include<openssl/rsa.h>
#include<openssl/err.h>
#import <openssl/bio.h>
#import "pem.h"
#import "err.h"
#import "IDMPFormatTransform.h"

typedef NS_ENUM(NSInteger, IDMPRSAKeyType) {
    Public = 0,
    Private
};

#pragma mark - 密钥
#define cmccKomectSecPUBLIC_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/YHP9utFGOhGk7Xf5L7jOgQz5v2JKxdrIE3yzYsHoZJwzKC7Ttx380UZmBFzr5I1k6FFMn/YGXd4ts6UHT/nzsCIcgZlTTem7Pjdm1V9bJgQ6iQvFHsvT+vNgJ3wAIRd+iCMXm8y96yZhD2+SH5odBYS2ZzwTYXBQDvB/rTfdjwIDAQAB"
#define cmccKomectSecPRIVATE_KEY @"MIICXgIBAAKBgQCkzAyTd86uiPMkvwGPevdr77TnoCAfpuruO5c6XnbcbaMevG3rPN6Dzx4OXVx7wYXoXG4rnjD8/qoIutmpS71CuafyhqGhqdsTMKKL7njWvn0KWbdLBl6croB68tFbAnIU8Nf95bHm1MW366riPKiN4yOgI+ig9qa4/lFFgH1RjQIDAQABAoGBAIC5wrkORKug3gw+BwIEk3AEddLYCT+wKqKceaxmTYIxQdGoblPp4AYlqtydoLgqmma+jHAVyT5VzouzKIJNXy+WqahMN3vmLIt7ois7Vpt6131eI5uapWVNUN7+Yv+u4FlvGiJIlKsmLJweIbAqVNOCOmJzP6ycgpxR8qDUSwYBAkEA1USGJq/3CLE4cXV6QraWWdHiwo6xk/8E6M+xv3IyMG8CdycgCl2Het/XAFdng1sX1P1ezIGrHVz1Bhyt+7imnQJBAMXRPuX3Tov/esVZSBeGxKWLOoZ4mmpoPAY603Ir680rzAbvY7Q/q6s7XEjpZC4iyQhwZ0d4FW7LnyQY+UJg67ECQQCDPKS03+nLnorWPu2aahOBeEfrY7XhFbhmr5B4+APsjBNfUWNFHaMGOQJsQlz/lynGNpiEjnLHIfHh7foegdV9AkEAqDETE6BELpBYKHeS7j3t8PsCFddxI0vgzUMzCP4DDX1Rigv8cAM6yOo9utiGDxwQZZZ8ma2mO3/xnVWGiUOy4QJAO3undOfAICj7yg0L/SqlXZ5VgeYr0mP1Y+yn5Ng3e6AxVJJ6wXQRkLEhmVTogfJFmQKXYeAoqNoMHkxtwJCTOQ=="


@implementation NSString (IDMPAdd)

#pragma mark - 手机号检测
- (BOOL)idmp_isPhoneNum {
    NSString *phoneRegex = @"^\\d{8,15}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ([self hasPrefix:@"+"]) {
        return [phoneTest evaluateWithObject:[self substringFromIndex:1]];
    } else {
        return [phoneTest evaluateWithObject:self];
    }
}

#pragma mark - 密码检测
- (BOOL)idmp_isPassword {
    if(self.length == 0) {
        return NO;
    } else if(self.length < 6 || self.length > 16) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)idmp_isIPAddress {
    NSString*ipurl=@"\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b";
    NSPredicate *urlCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipurl];
    return [urlCheck evaluateWithObject:self];
}



- (BOOL)idmp_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

#pragma mark - 隐藏手机号4位
- (NSString *)idmp_hideMiddleFourFromStart {
    NSUInteger userNameLen = self.length;
    if (userNameLen >= 7) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    } else {
        return self;
    }
}

- (NSString *)idmp_hideMiddleFourFromEnd {
    NSUInteger len = self.length;
    if (len>=8) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(len-8, 4) withString:@"****"];
    } else {
        return self;
    }
}


#pragma mark - AES
- (NSData *)idmp_aesEncryptWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] idmp_aesEncryptWithKey:key];
}

- (NSData *)idmp_aesDecryptWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] idmp_aesDecryptWithKey:key];
}



static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#pragma mark - base64
- (NSData *)idmp_dataWithBase64Encoded {
    if (self == nil)
        [NSException raise:NSInvalidArgumentException format:@"string is nil"];
    if ([self length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([self length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

#pragma mark - md5
- (NSString *)idmp_getMd5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] idmp_getMd5String];
}

#pragma mark - 随机数生成
+ (NSString *)idmp_getClientNonce {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [[NSString stringWithFormat:@"%f%@",time,[IDMPDevice getDeviceID]] idmp_getMd5String];
}

#pragma mark - 十六进制相关
+ (NSString *)idmp_hexStringWithChar:(unsigned char *)char32 length:(int)length {
    NSMutableString *result= [[NSMutableString alloc] init];
    for(int i = 0; i < length; i++) {
        [result appendFormat:@"%02X",char32[i]];
    }
    return [result copy];
}

- (unsigned char *)idmp_hexStringToChar {
    return (unsigned char*)[[self idmp_hexStringToNSData] bytes];
}

- (NSData *)idmp_hexStringToNSData {
    NSString *temp = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([temp length] / 2); i++) {
        byte_chars[0] = [temp characterAtIndex:i*2];
        byte_chars[1] = [temp characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    //NSLog(@"%@", data);
    return [data copy];
}

#pragma mark - RSA by security.framework
/**
 RSA加密
 
 @param pubKey 公钥
 @return 十六进制字符串
 */
- (NSString *)idmp_RSAEncrypt {
    NSData *data = [[self dataUsingEncoding:NSUTF8StringEncoding] idmp_encryptWithPublicKey:cmccKomectSecPUBLIC_KEY];
    if (data) {
        return [data idmp_hexEncodedString];
    } else {
        return [self backupRSAEncryptWithPublicKey:cmccKomectSecPUBLIC_KEY];
    }
}

/**
 RSA解密
 
 @param privKey 私钥
 @return utf8字符串
 */
- (NSString *)idmp_RSADecrypt {
    NSData *data = [[self idmp_hexStringToNSData] idmp_decryptWithPrivateKey:cmccKomectSecPRIVATE_KEY];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        return [self backupRSADecryptWithPrivateKey:cmccKomectSecPRIVATE_KEY];
    }
}

/**
 RSA签名
 
 @param privKey 公钥
 @return 十六进制字符串
 */
- (NSString *)idmp_RSASign {
    NSData *data = [[self dataUsingEncoding:NSUTF8StringEncoding] idmp_signWithPrivateKey:cmccKomectSecPRIVATE_KEY];
    if (data) {
        return [data idmp_hexEncodedString];
    } else {
        return [self backupRSASignWithPrivateKey:cmccKomectSecPRIVATE_KEY];
    }
}


#pragma mark - backup RSA by openssl
- (NSString *)backupRSAEncryptWithPublicKey:(NSString *)pubKey {
    unsigned char *str=(unsigned char*)[self UTF8String];
    unsigned char *p_en;
    RSA *p_rsa;
    int rsa_len;
    NSString *public = [self formatRSAKey:pubKey keyType:Public];
    NSData *pub= [public dataUsingEncoding:NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pub bytes],(int)[pub length]);
    p_rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    rsa_len=RSA_size(p_rsa);
    p_en=(unsigned char *)malloc(rsa_len+1);
    memset(p_en,0,rsa_len+1);
    int Result=RSA_public_encrypt((int)strlen((const char*)str),(unsigned char *)str,(unsigned char*)p_en,p_rsa,RSA_PKCS1_PADDING);
    if(Result<0) {
        RSA_free(p_rsa);
        free(p_en);
        p_en=NULL;
        return NULL;
    }
    
    RSA_free(p_rsa);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++)
        [result appendFormat:@"%02x", (unsigned char)p_en[i]];
    free(p_en);
    p_en=NULL;
    return result;
    
}

- (NSString *)backupRSADecryptWithPrivateKey:(NSString *)privKey {
    unsigned char *str = [self idmp_hexStringToChar];
    unsigned char *p_de;
    RSA *p_rsa;
    int rsa_len;
    NSString *private = [self formatRSAKey:privKey keyType:Private];
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes],(int)[pri length]);
    p_rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    rsa_len=RSA_size(p_rsa);
    p_de=(unsigned char *)malloc(rsa_len+1);
    memset(p_de,0,rsa_len+1);
    int slen=rsa_len;
    if(RSA_private_decrypt(slen,(unsigned char *)str,(unsigned char*)p_de,p_rsa,RSA_PKCS1_PADDING)<0) {
        RSA_free(p_rsa);
        free(p_de);
        p_de=NULL;
        return NULL;
    }
    RSA_free(p_rsa);
    NSString *result = [NSString stringWithUTF8String:(const char *)p_de];
    free(p_de);
    p_de=NULL;
    return result;
}

- (NSString *)backupRSASignWithPrivateKey:(NSString *)privKey {

    unsigned char *Str=(unsigned char *)[self UTF8String];
    EVP_PKEY *prikey;
    NSString *private = [self formatRSAKey:privKey keyType:Private];;
    NSData *pri= [private dataUsingEncoding: NSUTF8StringEncoding];
    BIO *bio = BIO_new_mem_buf((void *)[pri bytes],(int)[pri length]);
    prikey = PEM_read_bio_PrivateKey(bio, NULL,NULL, NULL);
    BIO_free(bio);
    int strLen=(int)strlen((const char *)Str);
    EVP_MD_CTX mdctx;
    EVP_MD_CTX_init(&mdctx);
    if(!EVP_SignInit_ex(&mdctx, EVP_sha256(), NULL)) {
        printf("error\n");
        EVP_PKEY_free(prikey);
    }
    if(!EVP_SignUpdate(&mdctx, Str, strLen)) {
        printf("error\n");
        EVP_PKEY_free(prikey);
    }
    unsigned int signLen=EVP_PKEY_size(prikey);
    unsigned char* signBuf=(unsigned char *)calloc(signLen+1, sizeof(unsigned char));
    
    if(!EVP_SignFinal(&mdctx, signBuf, &signLen, prikey)) {
        printf("error\n");
        EVP_PKEY_free(prikey);
    }
    EVP_MD_CTX_cleanup(&mdctx);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++) {
        [result appendFormat:@"%02x", signBuf[i]];
    }
    EVP_PKEY_free(prikey);
    free(signBuf);
    return result;
}

- (NSString *)formatRSAKey:(NSString *)key keyType:(IDMPRSAKeyType)keyType {
    const char *pstr = [key UTF8String];
    int len = (int)[key length];
    NSMutableString *result = [NSMutableString string];
    if (keyType == Public) {
        [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    } else {
        [result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
    }
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
    if (keyType == Public) {
        [result appendString:@"\n-----END PUBLIC KEY-----\n"];
    } else {
        [result appendString:@"\n-----END RSA PRIVATE KEY-----"];
    }
    return [result copy];
}





@end
