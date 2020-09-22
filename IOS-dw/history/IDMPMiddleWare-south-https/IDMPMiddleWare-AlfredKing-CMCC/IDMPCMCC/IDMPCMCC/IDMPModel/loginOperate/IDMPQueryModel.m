//
//  IDMPQueryPwdModel.m
//  IDMPCMCC
//
//  Created by HGQ on 16/2/1.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "IDMPQueryModel.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPParseParament.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPHttpRequest.h"
#import "IDMPAES128.h"
#import "IDMPAutoLoginViewController.h"

@implementation IDMPQueryModel

+ (void)queryAppPasswdWithUserName:(NSString *)userName finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock

{
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", requestAppPsd,@"100000",sipEncFlag,yesFlag,ksUserName,userName,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    NSLog(@"heads:%@",heads);
    [request getAsynWithHeads:heads url:qapUrl timeOut:10
    successBlock:^{
         NSDictionary *response=request.responseHeaders;
         NSLog(@"查询password 结果 %@",response);
         NSInteger resultCode = [[response objectForKey:ksResultCode] integerValue];
         if(resultCode==IDMPResultCodeSuccess)
         {
             NSString *query = [response objectForKey:@"Query-Result"];
             NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
             NSLog(@"PASSWORD QUERY %@",response);
             NSString *apppassword= [parament objectForKey:@"appPassword"];
             NSString *decPassWd=nil;
             if(![IDMPFormatTransform checkNSStringisNULL:apppassword])
             {
                 decPassWd=secRSA_Decrypt(apppassword);
                 NSLog(@"decpasswd is %@",decPassWd);
                 NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:decPassWd,sipPassword, nil];
                 successBlock(result);
                 
             }
         }
         else
         {
             NSLog(@"resultcode fail");
             if (failBlock)
             {
                 NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
                 failBlock(dic);
             }
         }
     } failBlock:^{
         NSLog(@"查询appid 结果 %@",request.responseHeaders);
         if (failBlock)
         {
             
             NSDictionary *dic = nil;
             if ([request.responseHeaders objectForKey:@"resultCode"])
             {
                 dic = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
             }
             else
             {
                 dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             }
             failBlock(dic);
         }
     }];

   
}


+ (void)checkWithAppId:(NSString *)Appid andAppkey:(NSString *)Appkey finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock
{
    NSLog(@"check appid appid:%@,appkey:%@",Appid,Appkey);
    if (Appid.length == 0 || Appkey.length == 0)
    {
        
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock)
        {
            failBlock(dic);
        }
        return;
    }

    
    NSLog(@"query appid start ");
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,Appid,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey,Signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    NSLog(@"heads:%@",heads);
    [request getAsynWithHeads:heads url:appCheckUrl timeOut:10
    successBlock:^{
        NSDictionary *response=request.responseHeaders;
        NSLog(@"查询appid 结果 %@",response);
        NSString *query = [response objectForKey:@"Query-Result"];
        NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
        NSString *serverEncAppid = [parament objectForKey:eAppid];
        NSLog(@"server appid %@",serverEncAppid);
        
        NSData *temp=[IDMPAES128 AESEncryptWithKey:Appkey andString:Appid];
        NSString *localEncAppid= [IDMPAES128 base64EncodingWithData:temp];
        NSLog(@"local appid %@",localEncAppid);
        if ([localEncAppid isEqualToString:serverEncAppid])
        {
            [userInfoStorage setInfo:yesFlag withKey:isChecked];
            
            NSString *query = [response objectForKey:@"Query-Result"];
            NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
            NSString *sip = [parament objectForKey:sipFlag];
            NSString *sourceid = [parament objectForKey:sourceIdsk];
            NSLog(@"query sourceid result : %@",sourceid);
            [userInfoStorage setInfo:sip withKey:sipFlag];
            [userInfoStorage setInfo:sourceid withKey:sourceIdsk];
            NSLog(@"check with appid %@",successBlock);
            
            if (successBlock)
            {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"103000",@"resultCode", nil];
                successBlock(dic);
            }
        }
        else
        {
            [userInfoStorage setInfo:noFlag withKey:isChecked];
            NSLog(@"appkey/appid 校验错误");
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102298",@"resultCode", nil];
            if (failBlock)
            {
                failBlock(result);
            }
        }
    }
    failBlock:^{
        NSLog(@"查询appid 结果 %@",request.responseHeaders);
        if (failBlock)
        {
            [userInfoStorage setInfo:noFlag withKey:isChecked];
            
            NSDictionary *dic = nil;
            if ([request.responseHeaders objectForKey:@"resultCode"])
            {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
            }
            else
            {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
            }
            failBlock(dic);
        }
    }];
}


@end
