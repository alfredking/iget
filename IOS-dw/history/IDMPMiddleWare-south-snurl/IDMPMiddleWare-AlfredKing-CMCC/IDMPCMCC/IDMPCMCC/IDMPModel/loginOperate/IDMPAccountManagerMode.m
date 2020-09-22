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

@implementation IDMPAccountManagerMode

static IDMPAccountManagerMode *manager = nil;

+ (IDMPAccountManagerMode *)shareAccountManager
{
    if (manager == nil) {
        manager = [[IDMPAccountManagerMode alloc]init];
    }
    return manager;
}

- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(password);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Rgclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,Validcode,validCode,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:vcUrl successBlock:
     ^{
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

- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(password);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Rpclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,Validcode,validCode,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:vcUrl successBlock:
     ^{
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

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(password);
    NSString *encryptNewPassWd = RSA_encrypt(newpassword);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Cpclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,TMIsdn,phoneNo,Encoldpasswd,encryptPassWd,ksEnPasswd,encryptNewPassWd,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:vcUrl successBlock:
     ^{
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
