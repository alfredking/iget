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

- (void)registerUserWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
        NSString *version = [IDMPDevice getAppVersion];
        NSString *clientNonce = [IDMPNonce getClientNonce];
        NSString *encryptClientNonce= RSA_encrypt(clientNonce);
        NSString *encryptPassWd= RSA_encrypt(password);
        NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Rgclientversion,version,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,Validcode,validCode,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
        NSString *Signature = RSA_EVP_Sign(UserManage);
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
        NSLog(@"请求头部%@",heads);
        IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
        [request getHttpByHeads:heads url:vcUrl successBlock:
                                           ^{
                                               NSLog(@"messageCode success!");
                                               NSLog(@"message:%@",request.responseHeaders);
                                               NSLog(@"-------%@",request.responseStr);
                                               NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                                               successBlock(result);
                                           }
                                                                failBlock:
                                           ^{
                                               NSDictionary *responseHeaders=request.responseHeaders;
                                               NSLog(@"%@",responseHeaders);
                                               if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                                                   NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                                                   failBlock(result);
                                               }else{
                                                   NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                                                   
                                                   failBlock(resultCode);
                                               }
                                               NSLog(@"fail!");
                                           }];

    
}

- (void)resetPasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(password);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Rpclientversion,version,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,Validcode,validCode,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:vcUrl successBlock:
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
                                           if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                                               NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                                               failBlock(result);
                                           }else{
                                               NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                                               
                                               failBlock(resultCode);
                                           }
                                           NSLog(@"fail!");
                                       }];


}

- (void)changePasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(password);
    NSString *encryptNewPassWd = RSA_encrypt(newpassword);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Cpclientversion,version,TMIsdn,phoneNo,Encoldpasswd,encryptPassWd,ksEnPasswd,encryptNewPassWd,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:vcUrl successBlock:
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
                                           if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                                               NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                                               failBlock(result);
                                           }else{
                                               NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                                               
                                               failBlock(resultCode);
                                           }
                                           NSLog(@"fail!");
                                       }];
}

#pragma mark -----验证手机验证码获取cert接口-----
- (void)submitValidateWithAppId:(NSString *)appId appKey:(NSString *)appKey phoneNo:(NSString *)phoneNo validCode:(NSString *)validCode busiType:(NSString *)busiType succeedBlock:(accessBlock)successBlock  failedBlock:(accessBlock)failBlock{
    
    
    NSString *version = [IDMPDevice getAppVersion];
    
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",CVlientversion,version,TMIsdn,phoneNo,ksIOS_ID,[IDMPDevice getDeviceID],Validcode,validCode,TMMsgType,busiType];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"submitValidateWithAppId------请求头部%@",heads);
    
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:validateUrl successBlock:
     ^{
         //NSLog(@"messageCode success!");
         NSLog(@"submitValidateWithAppId----messageCode success----message:%@",request.responseHeaders);
         NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"],@"cert":[request.responseHeaders objectForKey:@"cert"]};
         successBlock(result);
     }
                  failBlock:
     ^{
         NSDictionary *responseHeaders=request.responseHeaders;
         NSLog(@"submitValidateWithAppId-------fail-----%@",responseHeaders);
         if ([responseHeaders objectForKey:@"resultCode"]!=nil)
         {
             
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }
         else
         {
             
             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultCode);
         }
         NSLog(@"failBlock");
     }];
    
}

#pragma mark -----注册设置密码及重置密码接口-----
- (void)setPasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo cert:(NSString *)cert password:(NSString *)password busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSString *clientversion = @"";
    
    if ([busiType isEqualToString:@"1"]) {
        
        clientversion = Rgclientversion;
        
    } else {
        
        clientversion = Rpclientversion;
    }
    
    
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(password);
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",clientversion,version,TMIsdn,phoneNo,ksEnPasswd,encryptPassWd,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],kBusiType,busiType,kcert,cert];
    NSString *Signature = RSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:validateUrl successBlock:
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
         if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }else{
             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultCode);
         }
         NSLog(@"fail!");
     }];
    
}

@end
