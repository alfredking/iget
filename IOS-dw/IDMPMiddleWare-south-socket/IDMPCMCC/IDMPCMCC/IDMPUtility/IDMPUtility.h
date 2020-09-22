//
//  IDMPUtility.h
//  IDMPCMCC
//
//  Created by wj on 2018/5/15.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef STATESECRET
#import "MskManager.h"
#import "MskUtil.h"
#endif
typedef NS_ENUM(NSInteger, IDMPSM4Operation) {
    SM4Encrypt = 0,
    SM4Decrypt
};

@interface IDMPUtility : NSObject

/**
 判断字符串是否为空
 
 @param string 字符串
 @return 校验结果
 */
+ (BOOL)checkNSStringisNULL:(NSString *)string;

/**
 MD5或者SM3哈希。普通版本为MD5哈希,国密版本为SM3哈希

 @param rawData 原始数据
 @return 哈希结果
 */
//+ (NSString *)md5OrSM3WithRawData:(NSString *)rawData;


/**
 RSA或者SM2加密。普通版本为RSA加密,国密版本为SM2加密

 @param rawData 原始数据
 @return 加密数据
 */
+ (NSString *)rsaOrSM2EncryptWithRawData:(NSString *)rawData;


/**
 RSA或者SM4解密。普通版本为RSA解密，国密版本为SM4解密

 @param encData 加密数据
 @return 解密数据
 */
+ (NSString *)rsaOrSM4DecryptWithEncData:(NSString *)encData;

/**
 RSA或者SM4加密。普通版本为RSA加密，国密版本为SM4加密
 
 @param rawData 原始数据
 @return 解密数据
 */
+ (NSString *)rsaOrSM4EncryptWithRawData:(NSString *)rawData;

/**
 AES或者SM4加密。普通版本为AES加密,国密版本为SM4加密
 
 @param rawData 原始数据
 @param key 国密版本加密数据与key一起作为加密内容，用国密密码来加密。
 @return 加密数据
 */
+ (NSString *)aesORSM4EncryptRawData:(NSString *)rawData key:(NSString *)key;

#ifdef STATESECRET
+ (NSString *)getMskName;

+ (void)inputMskManager:(MskManager *)mskManager keyValue:(NSString *)keyValue checkValue:(NSString *)checkValue;

+ (NSString *)sm3WithRawData:(NSString *)rawData;

#endif

@end
