//
//  IDMPRegisterMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/24.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAccountManagerMode.h"
#import "IDMPConst.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPMD5.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
#import "IDMPToken.h"
#import "IDMPHttpRequest.h"
#import "IDMPTempSmsMode.h"
#import "IDMPMatch.h"
#import "userInfoStorage.h"

@implementation IDMPAccountManagerMode

static IDMPAccountManagerMode *manager = nil;

+ (IDMPAccountManagerMode *)shareAccountManager
{
    if (manager == nil)
    {
        manager = [[IDMPAccountManagerMode alloc]init];
    }
    return manager;
}

- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSDictionary *result;
    if (phoneNo.length == 0)
    {
        result = @{@"resultCode":@"102303"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL userRet = [IDMPMatch validateMobile:phoneNo];
    if (!userRet)
    {
        result = @{@"resultCode":@"102307"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    if (password.length == 0)
    {
        result = @{@"resultCode":@"102304"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL pwdRet = [IDMPMatch validatePassword:password];
    if (!pwdRet)
    {
        result = @{@"resultCode":@"102311"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    if (validCode.length == 0)
    {
        result = @{@"resultCode":@"102308"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL isMessageCode = [IDMPMatch validateCheck:validCode];
    if (!isMessageCode)
    {
        result = @{@"resultCode":@"102309"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
    NSString *encryptPassWd= secRSA_Encrypt(password);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Rgclientversion,version,sdkversion,sdkversionValue,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,Validcode,validCode,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"registerUser heads %@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:vcUrl timeOut:20
    successBlock:
     ^{
         NSLog(@"messageCode success!");
         NSLog(@"message:%@",request.responseHeaders);
         NSLog(@"-------%@",request.responseStr);
         NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
         successBlock(result);
     }
    failBlock:
     ^{
         NSLog(@" request %@",vcUrl);
         NSDictionary *responseHeaders=request.responseHeaders;
         if ([responseHeaders objectForKey:@"resultCode"])
         {
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }
         else
         {
             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultCode);
         }
         NSLog(@"fail!");
     }];
    
}

- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSDictionary *result;
    if (phoneNo.length == 0)
    {
        result = @{@"resultCode":@"102303"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL userRet = [IDMPMatch validateMobile:phoneNo];
    if (!userRet)
    {
        result = @{@"resultCode":@"102307"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    if (password.length == 0)
    {
        result = @{@"resultCode":@"102304"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL pwdRet = [IDMPMatch validatePassword:password];
    if (!pwdRet)
    {
        result = @{@"resultCode":@"102311"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    if (validCode.length == 0)
    {
        result = @{@"resultCode":@"102308"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL isMessageCode = [IDMPMatch validateCheck:validCode];
    if (!isMessageCode)
    {
        result = @{@"resultCode":@"102309"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
    NSString *encryptPassWd= secRSA_Encrypt(password);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Rpclientversion,version,sdkversion,sdkversionValue,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,Validcode,validCode,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads  url:vcUrl  timeOut:20
    successBlock:
     ^{
         NSLog(@"messageCode success!");
         NSLog(@"message:%@",request.responseHeaders);
         NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
         successBlock(result);
     }
     failBlock:
     ^{
         NSDictionary *responseHeaders=request.responseHeaders;
         NSLog(@"%@",responseHeaders);
         if ([responseHeaders objectForKey:@"resultCode"])
         {
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             NSLog(@"resetPasswordWithAppId---fail----result:%@",result);
             failBlock(result);
         }
         else
         {
             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultCode);
         }
         NSLog(@"fail!");
     }];
}

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSDictionary *result;
    if (phoneNo.length == 0)
    {
        result = @{@"resultCode":@"102303"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL userRet = [IDMPMatch validateMobile:phoneNo];
    if (!userRet)
    {
        result = @{@"resultCode":@"102307"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    if (password.length == 0)
    {
        result = @{@"resultCode":@"102304"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL pwdRet = [IDMPMatch validatePassword:password];
    if (!pwdRet)
    {
        result = @{@"resultCode":@"102311"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    if (newpassword.length == 0)
    {
        result = @{@"resultCode":@"102304"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    BOOL newPwdRet = [IDMPMatch validatePassword:newpassword];
    if (!newPwdRet)
    {
        result = @{@"resultCode":@"102311"};
        if (failBlock)
        {
            failBlock(result);
            return;
        }
    }
    
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
    NSString *encryptPassWd= secRSA_Encrypt(password);
    NSString *encryptNewPassWd = secRSA_Encrypt(newpassword);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Cpclientversion,version,sdkversion,sdkversionValue,TMIsdn,phoneNo,Encoldpasswd,encryptPassWd,ksEnPasswd,encryptNewPassWd,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads  url:vcUrl  timeOut:20
    successBlock:
     ^{
         NSLog(@"messageCode success!");
         NSLog(@"message:%@",request.responseHeaders);
         NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
         successBlock(result);
     }
                  failBlock:
     ^{
         NSDictionary *responseHeaders=request.responseHeaders;
         NSLog(@"%@",responseHeaders);
         if ([responseHeaders objectForKey:@"resultCode"])
         {
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }
         else
         {
             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultCode);
         }
         NSLog(@"fail!");
     }];
}




@end
