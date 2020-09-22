//
//  NSString+Extension.m
//  cloud_monitor
//
//  Created by wanggp on 2017/3/8.
//  Copyright © 2017年 wanggp. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(BOOL)isEmpty:(NSString *)s
{
    if ([s isKindOfClass:[NSString class]]) {
        NSString *temp = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([temp length] == 0) {
            return YES;
        }
    }
    if(s==nil||s==NULL || [@"" isEqualToString:s]||[@"null" isEqualToString:s]||[@"(null)" isEqualToString:s] || [@"<null>" isEqualToString:s] || [@"(nil)" isEqualToString:s] || [s isKindOfClass:[NSNull class]])
        return YES;
    else
        return NO;
}

+(BOOL)isNotEmpty:(NSString *)s
{
    return  ![NSString isEmpty:s];
}

-(int)indexOf:(NSString*)text state:(BOOL)isFirst{
    
    if (isFirst) {
        if ([[self substringToIndex:1] isEqualToString:[text substringToIndex:1]])  {
            return 1;
        }
        else
        {
            return -1;
        }
        
        
    }else
    {
        NSRange range=[self rangeOfString:text];
        if(range.length>0){
            return (int)range.location;
        }
        else{
            return -1;
        }
    }
    
    
}

//判断是否为整形：

+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];}


//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

//获取url参数
+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)replaceStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length {
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}

/**
 *对两个相等长度的字符串进行异或运算
 */
+ (NSString *)twoStringXor:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length)
    {
        return nil;
    }
    
    const char *panchar = [pan UTF8String];
    const char *pinvchar = [pinv UTF8String];
    
    
    NSString *temp = [[NSString alloc] init];
    
    for (int i = 0; i < pan.length; i++)
    {
        int panValue = [self charToint:panchar[i]];
        int pinvValue = [self charToint:pinvchar[i]];
        
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",panValue^pinvValue]];
    }
    return temp;
    
}

+ (int)charToint:(char)tempChar
{
    if (tempChar >= '0' && tempChar <='9')
    {
        return tempChar - '0';
    }
    else if (tempChar >= 'A' && tempChar <= 'F')
    {
        return tempChar - 'A' + 10;
    }
    
    return 0;
}





@end
