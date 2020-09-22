//
//  IDMPAutoLoginViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-15.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAutoLoginViewController.h"
#import "IDMPConst.h"
#import "IDMPToken.h"
#import "IDMPWapMode.h"
#import "IDMPDevice.h"
#import "IDMPUPViewController.h"
#import "IDMPHttpRequest.h"
#import "IDMPLoadingView.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPParseParament.h"
#import "IDMPUPMode.h"
#import "IDMPTempSmsMode.h"
#import "IDMPAccountManagerMode.h"
#import "IDMPAES128.h"
#import "IDMPListUserView.h"
#import "IDMPDataSMSMode.h"
#import "IDMPHmacEncrypt.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPRSA509.h"

NSMutableDictionary *CollectDeviceDataDictionary = nil;

@implementation IDMPAutoLoginViewController

- (NSString *)queryAppPasswdWithUserName:(NSString *)userName
{
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", requestAppPsd,@"100000",ksUserName,userName,ksClientversion,[IDMPDevice getAppVersion],ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:qapUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request1.allHTTPHeaderFields = heads;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSDictionary *response=urlResponse.allHeaderFields;
    NSString *query = [response objectForKey:@"Query-Result"];
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
    NSString *apppassword= [parament objectForKey:@"appPassword"];
    return apppassword;
}

- (void)checkWithAppId:(NSString *)Appid andAppkey:(NSString *)Appkey finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSString *checked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if (!checked)
    {
        NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,Appid,ksClientversion,[IDMPDevice getAppVersion],ksIOS_ID,[IDMPDevice getDeviceID]];
        NSString *Signature = RSA_EVP_Sign(Query);
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
        NSLog(@"heads:%@",heads);
        [request getWithHeads:heads url:appCheckUrl successBlock:^{
            NSDictionary *response=request.responseHeaders;
            NSLog(@"appkey request %@",response);
            NSInteger resultCode = [[response objectForKey:ksResultCode] integerValue];
            if(resultCode==IDMPResultCodeSuccess)
            {
                NSString *query = [response objectForKey:@"Query-Result"];
                NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
                NSString *serverEncAppid = [parament objectForKey:eAppid];
                NSLog(@"server appid %@",serverEncAppid);
                
                NSData *temp=[IDMPAES128 AESEncryptWithKey:Appkey andData:Appid];
                NSString *localEncAppid= [IDMPAES128 base64EncodingWithData:temp];
                NSLog(@"local appid %@",localEncAppid);
                if ([localEncAppid isEqualToString:serverEncAppid])
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:isChecked];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self resultCodeSuccessWithResponse:response];
                }
                else
                {
                    NSLog(@"appkey/appid 错误");
                }
            }
            else
            {
                NSLog(@"resultcode fail");
            }
        } failBlock:^{
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
            failBlock(resultCode);
        }];
    }
}

- (void)makeSourceIdWithAppId:(NSString *)Appid failBlock:(accessBlock)failBlock
{
    NSString *sourceID=[[NSUserDefaults standardUserDefaults] objectForKey:source];
    if (!sourceID)
    {
        NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,Appid,ksClientversion,[IDMPDevice getAppVersion],ksIOS_ID,[IDMPDevice getDeviceID]];
        NSString *Signature = RSA_EVP_Sign(Query);
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
        [request getWithHeads:heads url:appCheckUrl successBlock:^{
            NSDictionary *response=request.responseHeaders;
            NSInteger resultCode = [[response objectForKey:ksResultCode] integerValue];
            if(resultCode==IDMPResultCodeSuccess)
            {
                [self resultCodeSuccessWithResponse:response];
            }
            else
            {
                NSLog(@"resultcode fail");
            }
        } failBlock:^{
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
            failBlock(resultCode);
        }];
    }
}

- (void)cacheNoUseByConditionWithLoginType:(NSInteger)loginType UserName:(NSString *)userName andPassWd:(NSString *)content successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");

    IDMPUPMode *upMode=[[IDMPUPMode alloc]init];
    IDMPTempSmsMode *tsMode=[[IDMPTempSmsMode alloc]init];
    switch (loginType)
    {
        case 1:
        {
            //            [upMode getUPKSByUserName:userName andPassWd:content successBlock:^(NSDictionary *paraments) {
            //                [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
            //                [[NSUserDefaults standardUserDefaults]synchronize];
            //                successBlock(paraments);
            //            }
            [upMode getUPKSByUserName:userName andPassWd:content successBlock:successBlock                failBlock:
             ^(NSDictionary *wapFail){
                 failBlock(wapFail);
                 NSLog(@"up fail!");
             }];
        }
            
            break;
        case 2:
        {
            //            [tsMode getTMKSWithUserName:userName messageCode:content successBlock:^(NSDictionary *paraments) {
            //                [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
            //                [[NSUserDefaults standardUserDefaults]synchronize];
            //                successBlock(paraments);
            //            }
            [tsMode getTMKSWithUserName:userName messageCode:content successBlock:successBlock
                              failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"msg fail");
                 failBlock(wapFail);
             }];
        }
            break;
        default:
            break;
    }
}


- (void)autoCustomGoWithLoginType:(NSInteger)loginType UserName:(NSString *)userName isUserDefaultUI:(BOOL)isUserDefaultUI successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    if ([self getAuthType] > loginType) {
        NSLog(@"比较%d  %d",[self getAuthType] ,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }

    int type = [self getAuthType];
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    IDMPDataSMSMode *smsMode=[[IDMPDataSMSMode alloc]init];
    long LoginType;
    if (type == -1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }else if (type == 2&& loginType == 7) {
        LoginType = 6;
    }else if (type == 3&&loginType == 7){
        LoginType = 4;
    }else if (type == 3&&loginType == 6){
        LoginType = 4;
    }else if (type != 1&&loginType == 5){
        LoginType = 4;
    }else if (type == 2&&loginType == 3){
        LoginType = 2;
    }else if ((type == 3&&(loginType == 3||loginType == 2||loginType == 1))||(type == 2&&loginType == 1)){
        LoginType = 0;
    }else{
        LoginType = loginType;
    }
    switch (LoginType)
    {
        case 7:
        {
            IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingV showInView:self.view];
            });
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 [smsMode getDataSmsKSWithSuccessBlock:successBlock
                                             failBlock:
                  ^(NSDictionary *smsFail){
                      NSLog(@"1 datasms fail!");
                      NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                      NSLog(@"resultCode:%@",resultCode);
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (isUserDefaultUI) {
                              IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                              [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
                          }else{
                              NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                              failBlock(notUserDefaultUI);
                          }
                          
                      });
                      
                  }];
             }];
            
        }
            break;
        case 6:
        {
            [smsMode getDataSmsKSWithSuccessBlock:(accessBlock)successBlock
                                        failBlock:
             ^(NSDictionary *smsFail){
                 NSLog(@"2 datasms fail!");
                 NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (isUserDefaultUI) {
                         IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                         [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
                     }else{
                         NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                         failBlock(notUserDefaultUI);
                     }
                 });
             }];
        }
            break;
        case 5:
        {
            IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingV showInView:self.view];
            });
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (isUserDefaultUI) {
                         IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                         [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
                     }else{
                         NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                         failBlock(notUserDefaultUI);
                     }
                 });
             }];
        }
            break;
        case 4:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isUserDefaultUI) {
                    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                    [upView showInView:self placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                }else{
                    NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                    failBlock(notUserDefaultUI);
                }
            });
        }
            break;
        case 3:
        {
            IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingV showInView:self.view];
            });
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 [smsMode getDataSmsKSWithSuccessBlock:successBlock failBlock:failBlock];
             }];
            
        }
            break;
        case 2:
        {
            [smsMode getDataSmsKSWithSuccessBlock:(accessBlock)successBlock
                                        failBlock:
             ^(NSDictionary *smsFail){
                 NSLog(@"datasms fail!");
                 NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                 NSLog(@"datasms resultCode:%@",resultCode);
                 failBlock(smsFail);
             }];
        }
            break;
            
        case 1:
        {
            __block IDMPLoadingView *loadingV;
            dispatch_async(dispatch_get_main_queue(), ^{
                loadingV = [[IDMPLoadingView alloc]init];
                [loadingV showInView:self.view];
            });
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"wap resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 failBlock(wapFail);
             }];
        }
            break;
        default:
        {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前环境不支持指定的登陆方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //                [alert show];
            //            });
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
            failBlock(result);
        }
            break;
    }
    
}


- (void)cacheNoUseWithLoginType:(NSInteger)loginType UserName:(NSString *)userName isUserDefaultUI:(BOOL)isUserDefaultUI successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    if ([self getAuthType] > loginType) {
        NSLog(@"比较%d  %d",[self getAuthType] ,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }

    if (loginType == 1) {
        if ([self getAuthType] != loginType) {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请切换到蜂窝网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //                [alert show];
            //            });
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
            failBlock(result);
            return;
        }
    }
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    IDMPDataSMSMode *smsMode=[[IDMPDataSMSMode alloc]init];
    __weak int LoginType=loginType;
    if (!LoginType)
    {
        LoginType=[self getAuthType];
        NSLog(@"loginType is:%d",LoginType);
    }
    switch (LoginType)
    {
        case 1:
        {
            IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingV showInView:self.view];
            });
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 [smsMode getDataSmsKSWithSuccessBlock:successBlock
                                             failBlock:
                  ^(NSDictionary *smsFail){
                      NSLog(@"1 datasms fail!");
                      NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                      NSLog(@"resultCode:%@",resultCode);
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (isUserDefaultUI) {
                              IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                              [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
                          }else{
                              NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                              failBlock(notUserDefaultUI);
                          }
                          
                      });
                      
                  }];
             }];
            
        }
            break;
        case 2:
        {
            [smsMode getDataSmsKSWithSuccessBlock:(accessBlock)successBlock
                                        failBlock:
             ^(NSDictionary *smsFail){
                 NSLog(@"2 datasms fail!");
                 NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (isUserDefaultUI) {
                         IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                         [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
                     }else{
                         NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                         failBlock(notUserDefaultUI);
                     }
                 });
             }];
            
        }
            break;
        case 3:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isUserDefaultUI) {
                    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                    [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
                }else{
                    NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                    failBlock(notUserDefaultUI);
                }
            });
        }
            break;
        default:
            break;
    }
    
}

- (void)autoGoAndCacheNoUseWithLoginType:(NSInteger)loginType UserName:(NSString *)userName isUserDefaultUI:(BOOL)isUserDefaultUI successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    if ([self getAuthType] > loginType) {
        NSLog(@"比较%d  %d",[self getAuthType] ,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }

    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    IDMPDataSMSMode *smsMode=[[IDMPDataSMSMode alloc]init];
    __weak int LoginType=loginType;
    //    if (!LoginType)
    //    {
    //        LoginType=[self getAuthType];
    //        NSLog(@"loginType is:%d",LoginType);
    //    }
    switch (LoginType)
    {
        case 1:
        {
            __block IDMPLoadingView *loadingV;
            dispatch_async(dispatch_get_main_queue(), ^{
                loadingV = [[IDMPLoadingView alloc]init];
                [loadingV showInView:self.view];
            });
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"wap resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [loadingV dismissView];
                 });
             }];
        }
            break;
        case 2:
        {
            [smsMode getDataSmsKSWithSuccessBlock:(accessBlock)successBlock
                                        failBlock:
             ^(NSDictionary *smsFail){
                 NSLog(@"datasms fail!");
                 NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                 NSLog(@"datasms resultCode:%@",resultCode);
             }];
        }
            break;
            //        case 3:
            //        {
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //
            //                if (isUserDefaultUI) {
            //                    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
            //                    [upView showInView:self.view callBackBlock:successBlock];
            //                }else{
            //                    NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
            //                    failBlock(notUserDefaultUI);
            //                }
            //            });
            //        }
            //            break;
        default:
            break;
    }
    
}

- (NSDictionary *)cacheUseWithUserName:(NSString *)userName hasPassword:(BOOL)hasPW
{
    
    NSString *sourceID=[[NSUserDefaults standardUserDefaults] objectForKey:source];
    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userName]];
    
    NSString *passId=[user objectForKey:@"passid"];
    NSString *Token;
    Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceID];
    NSMutableDictionary *resultInfo = nil;
    if (hasPW)
    {
        
        NSString *passwd=[self queryAppPasswdWithUserName:userName];
        if (passwd == nil) {
            resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid",@"102102",@"resultCode",passwd,@"password", nil];
            
        }else{
            resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid",@"102000",@"resultCode",passwd,@"password", nil];
        }
        
    }else{
        resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid" ,@"102000",@"resultCode",nil];
    }
    return resultInfo;
}

- (NSString *)getLocalUserName
{
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    NSLog(@"user is %@",users);
    for (NSDictionary *user in users)
    {
        if ([[user objectForKey:@"isLocalNum"]boolValue])
        {
            return [user objectForKey:@"userName"];
        };
    }
    return nil;
}

- (void)getAutoLoginInfoWithsuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [loadingV showInView:self.view];
    });
    [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadingV dismissView];
         });
         
         successBlock(paraments);
     }
                            failBlock:
     ^(NSDictionary *wapFail){
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadingV dismissView];
         });
         failBlock(wapFail);
     }];
}


-(BOOL)cleanSSO
{
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    NSLog(@"userlist: %@",users);
    if (users.count) {
        
        //        for (NSDictionary *userInfo in users) {
        //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[userInfo objectForKey:@"userName"]];
        //        }
        for (int i=0; i<users.count; i++) {
            if ([users[i]isKindOfClass:[NSDictionary class]]) {
                NSString *name = [users[i]objectForKey:@"userName"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:name];
            }
        }
    }
    [users removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults]setObject:users forKey:userList];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:nowLoginUser];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"清除缓存成功");
    return YES;
}

-(BOOL) cleanSSOWithUserName:(NSString *)userName
{
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *accounts =[NSMutableArray arrayWithArray:[user objectForKey:userList]];
    if (accounts) {
        //        for (NSDictionary *userInfo in accounts) {
        //            if ([[userInfo objectForKey:@"userName"]isEqualToString:userName]) {
        //                [accounts removeObject:userInfo];
        //                [[NSUserDefaults standardUserDefaults]removeObjectForKey:userName];
        //            }
        //        }
        for (int i=0; i<accounts.count; i++) {
            if ([[accounts[i] objectForKey:@"userName"]isEqualToString:userName]) {
                [accounts removeObjectAtIndex:i];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:userName];
            }
        }
        [user setObject:accounts forKey:userList];
        if ([[user objectForKey:nowLoginUser]isEqualToString:userName]) {
            [user setObject:nil forKey:nowLoginUser];
        }
    }
    [user synchronize];
    return YES;

}

-(int )getAuthType
{
    if ([[IDMPDevice GetCurrntNet] isEqual:@"4g"]&[IDMPDevice checkChinaMobile])
    {
        return 1;
    }
    else if([IDMPDevice simExist]&[IDMPDevice connectedToNetwork]&[IDMPDevice checkChinaMobile])
    {
        return 2;
    }
    else if([IDMPDevice connectedToNetwork])
    {
        return 3;
    }
    else
    {
        return -1;
    }
    
}

- (NSArray *)getUsersWithHasNowAccount:(BOOL)hasNowAccount
{
    NSMutableArray *usersDict = [[NSUserDefaults standardUserDefaults]objectForKey:userList];
    NSString *nowLoginAccount = [[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser];
    NSLog(@"nowlogin:%@",nowLoginAccount);
    NSMutableArray *users = [[NSMutableArray alloc]init];
    for (NSDictionary *user  in usersDict) {
        [users addObject:[user objectForKey:@"userName"]];
    }
    if (hasNowAccount) {
        return users;
    }
    else{
        [users removeObject:nowLoginAccount];
        return users;
    }
}

- (NSString *)getNowLoginUser
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser];
}

- (void)changeAccountWithUserName:(NSString *)userName andFinishBlick:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    
    
    NSLog(@"now:%@",[[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser]);
    NSLog(@"users:%@",[[NSUserDefaults standardUserDefaults]objectForKey:userList]);
    NSArray *users = [[NSUserDefaults standardUserDefaults]objectForKey:userList];
    
    if ([users count]==0) {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alert show];
        NSDictionary *result = @{@"resultCode":@"102302"};
        failBlock(result);
        return;
    }
    //    if ([[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser]==nil) {
    //        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
    //    }
    //    [self getAccountListWithAppid:nil Appkey:nil finishBlock:successBlock failBlock:failBlock];
    IDMPListUserView *listV = [[IDMPListUserView alloc]init];
    NSArray *usersName = [[NSArray alloc]initWithArray:[self getUsersWithHasNowAccount:NO]];
    if (usersName.count > 0) {
        listV.userInfoArr = [NSMutableArray arrayWithArray:usersName];
        NSLog(@"userInfo:%@",listV.userInfoArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [listV showInView:self];
            [listV.tableV reloadData];
        });
        listV.callBack = ^(NSDictionary *parament){
            NSString *changeUserName = [parament objectForKey:@"userName"];

        
            [[NSUserDefaults standardUserDefaults]setObject:changeUserName forKey:nowLoginUser];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSDictionary *result = [self cacheUseWithUserName:changeUserName hasPassword:NO];
            NSLog(@"result:%@",result);
            successBlock(result);
        };
    }
    else{
        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [upView showInView:self placedUserName:nil callBackBlock:successBlock callFailBlock:failBlock];
        });
    }
    
}

- (void)getAccountListWithAppid:(NSString *)Appid Appkey:(NSString *)Appkey finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    IDMPListUserView *listV = [IDMPListUserView sharedView];
    NSArray *users = [self getUsersWithHasNowAccount:YES];
    if (users.count > 0) {
        listV.userInfoArr = [NSMutableArray arrayWithArray:users];
        dispatch_async(dispatch_get_main_queue(), ^{
            [listV showInView:self];
            [listV.tableV reloadData];
        });
    }
}

- (void)resultCodeSuccessWithResponse:(NSDictionary *)response
{
    NSString *query = [response objectForKey:@"Query-Result"];
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
    NSString *sip = [parament objectForKey:SIP];
    NSString *sourceid = [parament objectForKey:source];
    [[NSUserDefaults standardUserDefaults] setValue:sip forKey:SIP];
    [[NSUserDefaults standardUserDefaults] setValue:sourceid forKey:source];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getAppPasswordByConditionWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName Content: (NSString *)content andLoginType:(NSUInteger) loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    //    if (userName.length == 0||content.length == 0) {
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //        [alert show];
    //        return;
    //    }
    if (userName.length == 0) {
        NSDictionary *result = @{@"resultCode":@"102303"};
        failBlock(result);
        return;
    }
    if (content.length == 0) {
        NSDictionary *result = @{@"resultCode":@"102304"};
        failBlock(result);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        BOOL __block isLocalNumber=YES;
        
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        
        __weak NSString *mUserName=userName;
        
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        [self makeSourceIdWithAppId:Appid failBlock:failBlock];
        //    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:SIP];
        /*
         NSMutableDictionary *user;
         if(!mUserName)
         {
         mUserName = [self getLocalUserNameWithisLocalNumber:isLocalNumber];
         }
         
         if (mUserName)
         {
         user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
         NSLog(@"user %@",user);
         
         }
         if([user count]>0)
         {
         NSString *expireTimeString=[user objectForKey:ksExpiretime];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
         NSDate *expireTime = [formatter dateFromString:expireTimeString];
         NSString *KS=[user objectForKey:@"KS"];
         if([expireTime compare:[NSDate date]]>0&&KS!=nil)
         {
         NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
         successBlock(resultInfo);
         }
         else
         {
         [self  cleanSSOWithUserName:mUserName];
         [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:successBlock failBlock:failBlock];
         }
         }
         else*/
        
        if([ischecked isEqualToString:@"1"])
        {
            [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:successBlock failBlock:failBlock];
        }
        else
        {
            NSLog(@"应用合法性校验失败");
        }
        
    });
    
}

-(void)getAccessTokenByConditionWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName Content: (NSString *)content andLoginType:(NSUInteger) loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    
    //    if (userName.length == 0||content.length == 0) {
    ////        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //            [alert show];
    //            return;
    ////        });
    //    }
    if (userName.length == 0) {
        NSDictionary *result = @{@"resultCode":@"102303"};//102303,用户名为空
        failBlock(result);
        return;
    }
    if (content.length == 0) {
        NSDictionary *result = @{@"resultCode":@"102304"};//102304,密码为空
        failBlock(result);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        [self makeSourceIdWithAppId:Appid failBlock:failBlock];
        //    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:SIP];
        if([ischecked isEqualToString:@"1"])
        {
            [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:^(NSDictionary *paraments) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                [dic removeObjectForKey:ksUserName];
                if (successBlock) {
                    successBlock(dic);
                }
            } failBlock:failBlock];
        }
        else{
            NSLog(@"应用合法性校验失败");
        }
    });
    
}



#pragma mark ---增加ks可选加密方式的参数---
-(void)getAccessTokenByConditionWithEncryptWay:(NSInteger)encryptWay Appid:(NSString *)Appid Appkey:(NSString *)Appkey UserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    [[NSUserDefaults standardUserDefaults] setObject:Appid forKey:@"APPID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (userName.length == 0) {
        NSDictionary *result = @{@"resultCode":@"102303"};
        failBlock(result);
        return;
    }

    
    if (content.length == 0 && ![NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userName]].count)
    {
        //密码为空
        NSDictionary *result = @{@"resultCode":@"102304"};
        failBlock(result);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        
        NSMutableDictionary *user;
        
        user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
        NSLog(@"user  now %@",user);
        if([user count]>0)
        {
            NSLog(@"使用缓存");
            NSString *expireTimeString=[user objectForKey:ksExpiretime];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
            NSString *KS=[user objectForKey:@"KS"];
            if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
            {
                NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                
                NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:resultInfo];
                
                successBlock(resultDic);
            }
            else
            {
                [self  cleanSSOWithUserName:mUserName];
                [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:^(NSDictionary *paraments) {
                    NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:paraments];
                    
                    successBlock(resultDic);
                } failBlock:failBlock];
            }
        }
        else
            if([ischecked isEqualToString:@"1"])
            {
                [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:^(NSDictionary *paraments) {
                    NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:paraments];
                    
                    successBlock(resultDic);
                } failBlock:failBlock];
            }
            else{
                NSLog(@"应用合法性校验失败");
            }
    });
    
}




-(void)getAccessTokenWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock;
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];//102101,network error,网络错误
        failBlock(result);
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:Appid forKey:@"APPID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        [self makeSourceIdWithAppId:Appid failBlock:failBlock];
        //    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:SIP];
        //    if(!mUserName)
        //    {
        //        mUserName = [self getLocalUserNameWithisLocalNumber:isLocalNumber];
        //        NSLog(@"mUserName:%@",mUserName);
        //        if (mUserName == nil) {
        //            }
        //    }
        NSMutableDictionary *user;
        if (mUserName)
        {
            user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                NSString *expireTimeString=[user objectForKey:ksExpiretime];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
                //            NSDate *expireTime = [formatter dateFromString:expireTimeString];
                NSString *KS=[user objectForKey:@"KS"];
                if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
                    [dic removeObjectForKey:ksUserName];
                    if (successBlock) {
                        successBlock(dic);
                    }
                }
                else
                {
                    [self  cleanSSOWithUserName:mUserName];
                    [self autoCustomGoWithLoginType:loginType UserName:userName isUserDefaultUI:isUserDefaultUI successBlock:^(NSDictionary *paraments) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                        [dic removeObjectForKey:ksUserName];
                        if (successBlock) {
                            successBlock(dic);
                        }
                    } failBlock:failBlock];
                }
                
            }else{
                //            mUserName = [self getLocalUserName];
                //            if (mUserName == nil)
                //            {
                //                //自动协商
                //                __block NSString *userNameBlock = mUserName;
                //                [self getAutoLoginInfoWithsuccessBlock:^(NSDictionary *paraments) {
                //                    userNameBlock = [paraments objectForKey:@"username"];
                //                    if ([userNameBlock isEqualToString:userName])
                //                    {
                //                        //本地ks签发token
                //                        NSDictionary *resultInfo = [self cacheUseWithUserName:userNameBlock hasPassword:NO];
                //                        successBlock(resultInfo);
                //                    }
                //                    else
                //                    {
                //up界面
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:self placedUserName:userName callBackBlock:^(NSDictionary *paraments) {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                            [dic removeObjectForKey:ksUserName];
                            if (successBlock) {
                                successBlock(dic);
                            }
                        } callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
            
            //                } failBlock:^(NSDictionary *paraments) {
            //                    //up界面
            //                    if (isUserDefaultUI)
            //                    {
            //                        dispatch_async(dispatch_get_main_queue(), ^{
            //                            IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
            //                            [upView showInView:self.view placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
            //                        });
            //                    }
            //                    else
            //                    {
            //                        NSLog(@"Use your UI");
            //                        NSDictionary *failResult = [NSDictionary dictionary];
            //                        failBlock(failResult);
            //                    }
            //
            //                }];
            //            }
            //            else
            //            {
            //                //up界面
            //                if (isUserDefaultUI)
            //                {
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
            //                        [upView showInView:self.view placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
            //                    });
            //                }
            //                else
            //                {
            //                    NSLog(@"Use your UI");
            //                    NSDictionary *failResult = [NSDictionary dictionary];
            //                    failBlock(failResult);
            //                }
            //
            //            }
            //        }
        }
        else
        {
            //        if (loginType == 4) {
            //            if (isUserDefaultUI)
            //            {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
            //                    [upView showInView:self placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
            //                });
            //            }
            //            else
            //            {
            //                NSLog(@"Use your UI");
            //                NSDictionary *failResult = [NSDictionary dictionary];
            //                failBlock(failResult);
            //            }
            //        }else{
            mUserName = [self getLocalUserName];
            if (mUserName == nil) {
                //                if (loginType == 5||loginType == 6) {
                if ((loginType^4) < 4) {
                    //最近的签发token的ks
                
                    mUserName = [[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser];
                }
                if (mUserName == nil) {
                    //最近的签发token的ks不存在
                    if ([ischecked isEqualToString:@"1"]) {
                        [self autoCustomGoWithLoginType:loginType UserName:userName isUserDefaultUI:isUserDefaultUI successBlock:^(NSDictionary *paraments) {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                            [dic removeObjectForKey:ksUserName];
                            if (successBlock) {
                                successBlock(dic);
                            }
                        } failBlock:failBlock];
                    }else{
                        NSLog(@"应用合法性校验失败");
                    }
                }else{//使用最近一次签发token的ks
                    //                [self cacheUseWithUserName:mUserName hasPassword:NO];
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
                    [dic removeObjectForKey:ksUserName];
                    if (successBlock) {
                        successBlock(dic);
                    }
                }
            }else{
                //            [self cacheUseWithUserName:mUserName hasPassword:NO];
                NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
                [dic removeObjectForKey:ksUserName];
                if (successBlock) {
                    successBlock(dic);
                }
            }
        }
        //    }
    });
    
}


#pragma mark ---增加ks可选加密方式的参数---
-(void)getAccessTokenWithEncryptWay:(NSInteger)encryptWay Appid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    [[NSUserDefaults standardUserDefaults] setObject:Appid forKey:@"APPID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        
        NSMutableDictionary *user;
        if (mUserName)
        {
            
            
            user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                NSString *expireTimeString=[user objectForKey:ksExpiretime];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
                NSString *KS=[user objectForKey:@"KS"];
                if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                    
                    NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:resultInfo];
                    
                    successBlock(resultDic);
                }
                else
                {
                    [self  cleanSSOWithUserName:mUserName];
                    [self autoGoAndCacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:^(NSDictionary *paraments) {
                        NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:paraments];
                        
                        successBlock(resultDic);
                    } failBlock:failBlock];
                }
            }else{
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:self placedUserName:userName callBackBlock:^(NSDictionary *paraments) {
                            NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:paraments];
                            
                            successBlock(resultDic);
                        } callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
        }
        else
        {
            if (loginType == 3) {
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:self placedUserName:userName callBackBlock:^(NSDictionary *paraments) {
                            NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:paraments];
                            
                            successBlock(resultDic);
                        } callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }else{
                mUserName = [self getLocalUserName];
                if (mUserName == nil) {
                    if ([ischecked isEqualToString:@"1"]) {
                        [self autoGoAndCacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:^(NSDictionary *paraments) {
                            NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:paraments];
                            
                            successBlock(resultDic);
                        } failBlock:failBlock];
                    }else{
                        NSLog(@"应用合法性校验失败");
                    }
                }else{
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                    
                    NSDictionary *resultDic = [self getKs_nafWithEncryptWay:encryptWay andAppid:Appid andDictionaary:resultInfo];
                    
                    successBlock(resultDic);
                }
            }
        }
    });
    
}




-(void)getAppPasswordWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    NSLog(@"type:%d",[self getAuthType]);
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        [self makeSourceIdWithAppId:Appid failBlock:failBlock];
        //    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:SIP];
        
        NSMutableDictionary *user;
        if (mUserName)
        {
            NSLog(@"%@",mUserName);
            
            user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                NSString *expireTimeString=[user objectForKey:ksExpiretime];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
                //            NSDate *expireTime = [formatter dateFromString:expireTimeString];
                NSString *KS=[user objectForKey:@"KS"];
                if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
                    NSLog(@"缓存 resultInfo %@",resultInfo);
                    successBlock(resultInfo);
                }
                else
                {
                    [self  cleanSSOWithUserName:mUserName];
                    [self autoCustomGoWithLoginType:loginType UserName:userName isUserDefaultUI:YES successBlock:successBlock failBlock:failBlock];
                }
                
            }
            else
            {
                //            mUserName = [self getLocalUserName];
                //            if (mUserName == nil)
                //            {
                //                //自动协商
                //                __block NSString *userNameBlock = mUserName;
                //                [self getAutoLoginInfoWithsuccessBlock:^(NSDictionary *paraments) {
                //                    userNameBlock = [paraments objectForKey:@"username"];
                //                    if ([userNameBlock isEqualToString:userName])
                //                    {
                //                        //本地ks签发token
                //                        NSDictionary *resultInfo = [self cacheUseWithUserName:userNameBlock hasPassword:YES];
                //                        successBlock(resultInfo);
                //                    }
                //                    else
                //                    {
                //up界面
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:self placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
            
            //                } failBlock:^(NSDictionary *paraments) {
            //                    //up界面
            //                    if (isUserDefaultUI)
            //                    {
            //                        dispatch_async(dispatch_get_main_queue(), ^{
            //                            IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
            //                            [upView showInView:self.view placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
            //                        });
            //                    }
            //                    else
            //                    {
            //                        NSLog(@"Use your UI");
            //                        NSDictionary *failResult = [NSDictionary dictionary];
            //                        failBlock(failResult);
            //                    }
            //
            //                }];
            //            }
            //            else
            //            {
            //                NSLog(@"cache has local num");
            //                //up界面
            //                if (isUserDefaultUI)
            //                {
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
            //                        [upView showInView:self.view placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
            //                    });
            //                }
            //                else
            //                {
            //                    NSLog(@"Use your UI");
            //                    NSDictionary *failResult = [NSDictionary dictionary];
            //                    failBlock(failResult);
            //                }
            //
            //            }
            //        }
        }
        else
        {
            if (loginType == 4) {
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:self placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }else{
                mUserName = [self getLocalUserName];
                NSLog(@"musername %@",mUserName);
                if (mUserName == nil) {
                    if ([ischecked isEqualToString:@"1"]) {
                        [self autoCustomGoWithLoginType:loginType UserName:userName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
                    }else{
                        NSLog(@"应用合法性校验失败");
                    }
                }
                else{
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
                    successBlock(resultInfo);
                }
            }
        }
    });
    
}
/*
 if (mUserName) {
 if ([mUserName isEqualToString:userName]) {
 //本地ks签发token
 NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
 successBlock(resultInfo);
 }else{
 //up界面
 if (isUserDefaultUI) {
 dispatch_async(dispatch_get_main_queue(), ^{
 IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
 [upView showInView:self.view placedUserName:userName callBackBlock:successBlock];
 });
 }else{
 NSLog(@"Use your UI");
 NSDictionary *failResult = [NSDictionary dictionary];
 failBlock(failResult);
 }
 }
 }else{
 //up界面
 if (isUserDefaultUI) {
 dispatch_async(dispatch_get_main_queue(), ^{
 IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
 [upView showInView:self.view placedUserName:userName callBackBlock:successBlock];
 });
 }else{
 NSLog(@"Use your UI");
 NSDictionary *failResult = [NSDictionary dictionary];
 failBlock(failResult);
 }
 }
 }*/
//    }


-(void)getAccessTokenUseAutoGoWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        [self makeSourceIdWithAppId:Appid failBlock:failBlock];
        //        NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:SIP];
        if(!mUserName)
        {
            mUserName = [self getLocalUserName];
        }
        NSMutableDictionary *user;
        if (mUserName)
        {
            
            user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
            NSLog(@"user %@",user);
        };
        if([user count]>0)
        {
            NSString *expireTimeString=[user objectForKey:ksExpiretime];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
            //            NSDate *expireTime = [formatter dateFromString:expireTimeString];
            NSString *KS=[user objectForKey:@"KS"];
            if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
            {
                NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                successBlock(resultInfo);
            }
            else
            {
                [self  cleanSSOWithUserName:mUserName];
                [self cacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
            }
        }
        else if([ischecked isEqualToString:@"1"])
        {
            [self cacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
        }
        else
        {
            NSLog(@"应用合法性校验失败");
        }
    });
    
}



-(void)getAppPasswordUseAutoGoWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self checkWithAppId:Appid andAppkey:Appkey finishBlock:nil failBlock:failBlock];
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        [self makeSourceIdWithAppId:Appid failBlock:failBlock];
        //        NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:SIP];
        if(!mUserName)
        {
            mUserName = [self getLocalUserName];
        }
        
        NSMutableDictionary *user;
        if (mUserName)
        {
            
        user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
        NSLog(@"user %@",user);
        };
        if([user count]>0)
        {
            NSString *expireTimeString=[user objectForKey:ksExpiretime];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
            NSString *KS=[user objectForKey:@"KS"];
            if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
            {
                NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
                successBlock(resultInfo);
            }
            else
            {
                [self  cleanSSOWithUserName:mUserName];
                [self cacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
            }
            
        }
        else if([ischecked isEqualToString:@"1"])
        {
            [self cacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
        }
        else
        {
            NSLog(@"应用合法性校验失败");
        }
    });
    
    
}


- (void)registerUserWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    [self checkWithAppId:appid andAppkey:appkey finishBlock:successBlock failBlock:failBlock];
    NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if([ischecked isEqualToString:@"1"]){
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager registerUserWithAppId:appid AppKey:appkey phoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
    }else{
        NSLog(@"应用合法性校验失败");
    }
}


- (void)resetPasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    [self checkWithAppId:appid andAppkey:appkey finishBlock:nil failBlock:failBlock];
    NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if([ischecked isEqualToString:@"1"]){
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager resetPasswordWithAppId:appid AppKey:appkey phoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
    }else{
        NSLog(@"应用合法性校验失败");
    }
}

- (void)changePasswordWithAppId:(NSString *)appid AppKey:(NSString *)appkey phoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    if ([self getAuthType]==-1) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102101",@"resultCode", nil];
        failBlock(result);
        return;
    }
    [self checkWithAppId:appid andAppkey:appkey finishBlock:nil failBlock:failBlock];
    NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if([ischecked isEqualToString:@"1"]){
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager changePasswordWithAppId:appid AppKey:appkey phoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
    }else{
        NSLog(@"应用合法性校验失败");
    }
}


#pragma mark ---联调环境与现网环境切换---
- (void)setTest:(BOOL)isTest
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (isTest)
    {
        [user setObject:riskControlIntranetUrl forKey:riskURL];
    }
    else
    {
        [user setObject:riskControlOuternetUrl forKey:riskURL];
    }
    
    [user synchronize];
}




- (void)currentEdition
{
    NSLog(@"版本:IDMPIV1C00B08  时间:2015.03.09");
    
    IDMPRSA509 *instance=[[IDMPRSA509 alloc]init];
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDN2CQ+ZcsbHVrLSJ+/v0BA6kgoa+riowfZErlGdlMjUhf4UTos1ZzKfavQjctIQjlEStxBWAZ+gtmtYakUmjWFBupks6RWcR/ho+VEePpzxhSis8M6zHDhf9Dl8u6uvSAdk+CM3NgGle0bC8WnMxy2k9k3MSrX93AKZV36DCMtUQIDAQAB-----END PUBLIC KEY-----";
    NSString *privkey = @"-----BEGIN RSA PRIVATE KEY-----MIICWwIBAAKBgQDN2CQ+ZcsbHVrLSJ+/v0BA6kgoa+riowfZErlGdlMjUhf4UTos1ZzKfavQjctIQjlEStxBWAZ+gtmtYakUmjWFBupks6RWcR/ho+VEePpzxhSis8M6zHDhf9Dl8u6uvSAdk+CM3NgGle0bC8WnMxy2k9k3MSrX93AKZV36DCMtUQIDAQABAoGACBp+MsanHEYnkOEnCNFqoiOW+6Bj+tAYOv91s8RsuXM95lSsSZ+PMJmJ7gfm/M0+m+Wmjhv9BXX5Q84Ybes0OBpS9qk2Rq6mQooXqo+6BaPlJb/UD160ULiQJIA7P2x2XX/Z8xW7goq6r13i4VOZj4GHxRnlfvtCyKKso2U4qMECQQD2bBrY+1O1Du7DB6jjJC0rnZMQllIlex9zftvIgr69qvQcWoCKukBUjmx8gw7Pall33sRgJbhMj0yfqLBn6GplAkEA1dhJcJhZ9euFsjWnjXG5g5CyRO5HPJ9Kfoqw04aQX7oHHRXUyVNUH4L9FsbXQBYS+rXrtJUcas1Ns7inhamyfQJAXwvndxXJfaaa1ULZE3NasN4AYX95g9dvlB60Kyyy4XlU2rLVrayVL4gXtBbg2YPNqnyUBfnGklEbXuGz2QA+OQJAUOiQgMVj5CPEZfTe/Ck3I4wvptzwnwM10ELxPFcBcPaVkm+cHsAkZ/fLgj6hWmH/tFP4Zk60fcRHzePjnjLikQJAcaztmnB32RZNP3T0EWDT/ByFKjUl53epXX8YIfxipa1MsWH66CeJ3S1o8G3CORXOPSJbhDCRBQnWLH+Dp3LovQ==-----END RSA PRIVATE KEY-----";
    
    NSString *originString = @"hello world!";
    NSString *encWithPubKey;
    NSString *decWithPrivKey;
    
    NSLog(@"Original string: %@", originString);
    
    // Demo: encrypt with public key
    encWithPubKey = [instance encryptWithData:[originString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Enctypted with public key: %@", encWithPubKey);
    // Demo: decrypt with private key
    decWithPrivKey = [IDMPRSA_Encrypt_Decrypt decryptString:encWithPubKey privateKey:privkey];
    NSLog(@"Decrypted with private key: %@", decWithPrivKey);
    
    NSString *signedString=[IDMPRSA_Encrypt_Decrypt signString:originString privateKey:privkey];
    BOOL result=[IDMPRSA_Encrypt_Decrypt verifySouceString:originString signedString:signedString privateKey:pubkey];
    NSLog(@"签名结果 : %d",result);
}

#pragma mark ------------加密Ks-------------
- (NSDictionary *)getKs_nafWithEncryptWay:(NSInteger)encryptWay andAppid:(NSString *)appid andDictionaary:(NSDictionary *)dictionary
{
    
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSMutableDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:nowLoginUser]];
    NSString *KS=[userInfo objectForKey:@"KS"];
    NSString *BTID = [userInfo objectForKey:@"BTID"];
    NSString *APPID_BTID = [NSString stringWithFormat:@"%@%@",appid,BTID];
    
    NSString *Ks_naf = nil;
    if (encryptWay == 1)
    {
        Ks_naf = [IDMPHmacEncrypt hmac_MD5:APPID_BTID withKey:KS];
    }
    else if (encryptWay == 2)
    {
        Ks_naf = [IDMPHmacEncrypt hmac_sha1:APPID_BTID withKey:KS];
    }
    else if (encryptWay == 3)
    {
        Ks_naf = [IDMPHmacEncrypt hmac_sha512:APPID_BTID withKey:KS];
    }
    else
    {
        Ks_naf = [IDMPHmacEncrypt hmac_sha256:APPID_BTID withKey:KS];
    }
    
    [tempDic setObject:Ks_naf forKey:@"Ks_naf"];
    
    return tempDic;
}


@end
