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
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"1((3\\d)|(4[57])|(5[\\d&&[^4]])|(8[\\d&&[^134]]))\\d{8}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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
