//
//  NSString2Hex.h
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-1.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPFormatTransform : NSObject

//char *charToHex(char *str,int length);


/**
 字符串转换为十六进制字符串

 @param str 字符串
 @param length 字符串长度
 @return 十六进制字符串
 */
+ (NSString *)charToNSHex:(unsigned char *)str length:(int)length;

void print_hex(char* buff);


/**
 十六进制字符串转换为byte字符串

 @param sourceString 十六进制字符串
 @param sourceLen 字符串长度
 @return 字符串
 */
unsigned char * HexStrToByte(const char* sourceString,int sourceLen);


/**
 十六进制字符串转换为NSData

 @param hexStr 十六进制字符串
 @return NSData
 */
+ (NSData *)hexStringToNSData:(NSString *)hexStr;


/**
 十六进制字符串转换为字符串

 @param hexStr 十六进制字符串
 @return 字符串
 */
+ (unsigned char *)hexStringToChar:(NSString *)hexStr;


/**
 判断字符串是否为空

 @param string 字符串
 @return 校验结果
 */
+(BOOL)checkNSStringisNULL:(NSString *)string;


/**
 判断字符串是否为IP地址

 @param url 字符串
 @return 校验结果
 */
+(BOOL)checkIsIp:(NSString *)url;

@end
