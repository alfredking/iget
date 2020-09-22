//
//  NSString+IDMPAdd.h
//  IDMPCMCC
//
//  Created by wj on 2018/1/23.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (IDMPAdd)
/**
 判断是否是手机号

 @return 结果
 */
- (BOOL)idmp_isPhoneNum;

/**
 判断是否是密码

 @return 结果
 */
- (BOOL)idmp_isPassword;
/**
 判断字符串是否为IP地址
 
 @return 结果
 */
- (BOOL)idmp_isIPAddress;

/**
 判断是否包含子串

 @param string 子字符串
 @return 结果
 */
- (BOOL)idmp_containsString:(NSString *)string;


/**
 隐藏字符串从头开始的中间4位

 @return 隐藏4位的字符串
 */
- (NSString *)idmp_hideMiddleFourFromStart;


/**
 隐藏字符串从尾开始的中间4位

 @return 隐藏4位的字符串
 */
- (NSString *)idmp_hideMiddleFourFromEnd;


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
- (NSData *)idmp_dataWithBase64Encoded;


/**
 md5

 @return md5结果
 */
- (NSString *)idmp_getMd5String;


/**
 生成md5(idfv+时间)的随机数

 @return 随机数
 */
+ (NSString *)idmp_getClientNonce;

/**
 字符转换为十六进制字符串
 
 @param str 字符
 @param length 字符长度
 @return 十六进制字符串
 */
+ (NSString *)idmp_hexStringWithChar:(unsigned char *)char32 length:(int)length;

/**
 十六进制字符串转换为字符
 
 @param hexStr 十六进制字符串
 @return 字符
 */
- (unsigned char *)idmp_hexStringToChar;

/**
 十六进制字符串转换为NSData
 
 @param hexStr 十六进制字符串
 @return NSData
 */
- (NSData *)idmp_hexStringToNSData;


/**
 RSA加密
 
 @return 十六进制字符串
 */
- (NSString *)idmp_RSAEncrypt;

/**
 RSA解密
 
 @return utf8字符串
 */
- (NSString *)idmp_RSADecrypt;

/**
 RSA签名
 
 @return 十六进制字符串
 */
- (NSString *)idmp_RSASign;

@end


