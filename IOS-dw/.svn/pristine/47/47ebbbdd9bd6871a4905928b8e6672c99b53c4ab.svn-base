//
//  NSString+Extension.h
//  cloud_monitor
//
//  Created by wanggp on 2017/3/8.
//  Copyright © 2017年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 可以判断全是空格的情况 */
+(BOOL)isEmpty:(NSString *)s;

+(BOOL)isNotEmpty:(NSString *)s;

-(int)indexOf:(NSString*)text state:(BOOL)isFirst;


//判断是否为整形：
+(BOOL)isPureInt:(NSString*)string;

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

//获取url参数
+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length;

/**
 *对两个相等长度的字符串进行异或运算
 */
+ (NSString *)twoStringXor:(NSString *)pan withPinv:(NSString *)pinv;

@end
