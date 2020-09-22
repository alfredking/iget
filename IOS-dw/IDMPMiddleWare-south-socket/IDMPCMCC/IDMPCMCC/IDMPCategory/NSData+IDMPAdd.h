//
//  NSData+IDMPAdd.h
//  IDMPCMCC
//
//  Created by wj on 2018/1/23.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IDMPRSAOperatorType) {
    Encrypt = 0,
    Decrypt,
    Sign,
};

@interface NSData (IDMPAdd)


/**
 aes加密
 
 @param key 密钥
 @return 加密结果
 */
- (NSData *)idmp_aesEncryptWithKey:(NSString *)key;
/**
 aes解密
 
 @param key 密钥
 @return 解密结果
 */
- (NSData *)idmp_aesDecryptWithKey:(NSString *)key;


/**
 base64编码

 @return 编码结果
 */
- (NSString *)idmp_base64Encoding;


/**
 md5

 @return md5结果
 */
- (NSString *)idmp_getMd5String;


/**
 转换为16进制字符串

 @return 16进制字符串
 */
- (NSString *)idmp_hexEncodedString;


/**
 RSA加密

 @param pubKey 公钥
 @return 加密结果
 */
- (NSData *)idmp_encryptWithPublicKey:(NSString *)pubKey;


/**
 RSA解密

 @param privKey 私钥
 @return 解密结果
 */
- (NSData *)idmp_decryptWithPrivateKey:(NSString *)privKey;


/**
 RSA签名

 @param privKey 私钥
 @return 签名
 */
- (NSData *)idmp_signWithPrivateKey:(NSString *)privKey;

@end
