//
//  IDMPMatch.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/18.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPMatch.h"

@implementation IDMPMatch

//手机号
+ (BOOL) validateMobile:(NSString *)mobile
{
    if (mobile.length == 11)
    {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,4,7-9])|(17[2,8])|(18[2-4,7-8]))\\d{8}|(170[3,5,6])\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[5,6])|(18[5,6]))\\d{8}|(170[7,8,9])|(171[8,9])\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(149)|(153)|(173)|(177)|(18[0,1,9]))\\d{8}|(170[0,1,2])\\d{7}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    if(passWord.length == 0)return NO;
    else if(passWord.length < 6||passWord.length > 16)return NO;
    else return YES;
}

//验证码
+ (BOOL) validateCheck:(NSString *)checkWord
{
    NSString *checkWordRegex = @"^[0-9]{6}+$";
    NSPredicate *checkWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",checkWordRegex];
    return [checkWordPredicate evaluateWithObject:checkWord];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//和ID
+ (BOOL) validatePassID:(NSString *)passId
{
    NSString *passIdRegex = @"^[1-9]\\d{8,14}$";
    NSPredicate *passIdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passIdRegex];
    return [passIdTest evaluateWithObject:passId];
}

@end
