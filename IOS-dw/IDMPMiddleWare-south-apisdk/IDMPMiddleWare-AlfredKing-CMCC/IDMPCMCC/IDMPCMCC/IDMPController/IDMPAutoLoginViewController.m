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
#import "IDMPDevice.h"
#import "IDMPKsModel.h"
#import "IDMPTool.h"
#import "IDMPMD5.h"
#import "IDMPNonce.h"
#import "IDMPHttpRequest.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPAES128.h"
#import "IDMPParseParament.h"

@implementation IDMPAutoLoginViewController

+ (void)checkWithAppId:(NSString *)appid andAppkey:(NSString *)appkey successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    
    NSLog(@"query appid start ");
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,appid,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
//    NSString *Signature = RSA_EVP_Sign(Query);
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey,Signature,ksSignature, nil];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, nil];

    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    NSLog(@"heads:%@",heads);
    [request getHttpByHeads:heads url:ckRequestUrl
             successBlock:^{
                 NSDictionary *response=request.responseHeaders;
                 NSLog(@"查询appid 结果 %@",response);
                 NSInteger resultCode = [[response objectForKey:ksResultCode] integerValue];
                 if(resultCode == IDMPResultCodeSuccess)
                 {
                     NSString *query = [response objectForKey:@"Query-Result"];
                     NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
                     NSString *serverEncAppid = [parament objectForKey:eAppid];
                     NSLog(@"server appid %@",serverEncAppid);
                     
                     NSData *temp=[IDMPAES128 AESEncryptWithKey:appkey andData:appid];
                     NSString *localEncAppid= [IDMPAES128 base64EncodingWithData:temp];
                     NSLog(@"local appid %@",localEncAppid);
                     if ([localEncAppid isEqualToString:serverEncAppid])
                     {
                         [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:isChecked];
                         int result=[[NSUserDefaults standardUserDefaults] synchronize];
                         if(!result)
                         {
                             NSLog(@"synchronize fail");
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             NSLog(@"synchronize retry");
                         }
                         
                         NSString *query = [response objectForKey:@"Query-Result"];
                         NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
                         NSString *sourceid = [parament objectForKey:source];
                         NSLog(@"query sourceid result : %@",sourceid);
                         [[NSUserDefaults standardUserDefaults] setValue:sourceid forKey:source];
                         int synchronizeResult=[[NSUserDefaults standardUserDefaults] synchronize];
                         if(!synchronizeResult)
                         {
                             NSLog(@"synchronize fail");
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             NSLog(@"synchronize retry");
                         }
                         
                         if (successBlock)
                         {
                             NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@"103000",@"resultCode", nil];
                             successBlock(resultDic);
                         }
                         
                     }
                     else
                     {
                         NSLog(@"appkey/appid 错误");
                         if (failBlock)
                         {
                             NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@"102298",@"resultCode", nil];
                             failBlock(resultDic);
                         }
                     }
                 }
                 else
                 {
                     NSLog(@"resultcode fail");
                     if (failBlock)
                     {
                         NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
                         failBlock(resultDic);
                     }
                 }
             } failBlock:^{
                 NSLog(@"查询appid 结果 %@",request.responseHeaders);
                 NSString *resultCode = [request.responseHeaders objectForKey:@"resultCode"];
                 NSDictionary *resultDic = nil;
                 if (resultCode)
                 {
                     resultDic = @{@"resultCode":resultCode};
                 }
                 else
                 {
                     resultDic = @{@"resultCode":@"102102"};
                 }
                 if (failBlock)
                 {
                     failBlock(resultDic);
                 }
             }];
}


+ (NSDictionary *)cacheUseWithUserName:(NSString *)userName
{
    NSLog(@"使用缓存");
    
    NSString *sourceID = [[NSUserDefaults standardUserDefaults] objectForKey:source];;
    
    
    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userName]];
    
    NSString *passId=[user objectForKey:@"passid"];
    NSString *authType = [user objectForKey:@"authType"];
    NSString *expiretime = [user objectForKey:@"expiretime"];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *Token;
    
    Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceID];
    NSMutableDictionary *resultInfo = nil;
    
    resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,@"mobileNumber",passId,@"passid" ,authType,@"authType",@"102000",@"resultCode",expiretime,@"expiretime", uid, @"uid", nil];
    NSLog(@"resultInfo === %@",resultInfo);
    return resultInfo;
}


+ (void)logoutWithUserName:(NSString *)userName {
    [IDMPTool queryAndDeleteKs:userName isForced:NO];
}
    
+ (void)logoutForcedWithUserName:(NSString *)userName {
    [IDMPTool queryAndDeleteKs:userName isForced:YES];
}
    

+ (BOOL)cleanSSO{
    
//    [IDMPTool queryAndDeleteKs];

    return YES;
}


+ (BOOL)cleanSSOWithUserName:(NSString *)userName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *accounts =[NSMutableArray arrayWithArray:[user objectForKey:userList]];
    
    if (accounts)
    {
        for (int i=0; i<accounts.count; i++)
        {
            if ([[accounts[i] objectForKey:@"userName"]isEqualToString:userName])
            {
                [accounts removeObjectAtIndex:i];
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:userName];
            }
        }
        [user setObject:accounts forKey:userList];
        
        if ([[user objectForKey:nowLoginUser]isEqualToString:userName])
        {
            [user setObject:nil forKey:nowLoginUser];
        }
    }
    [user synchronize];
    return YES;
}


+ (int)getAuthType
{
    if ([[IDMPDevice GetCurrntNet] isEqual:@"4g"] && [IDMPDevice checkChinaMobile])
    {
        return 1;
    }
    else if([IDMPDevice connectedToNetwork] && [IDMPDevice checkChinaMobile])
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


#pragma mark 创建续签ks接口
+ (void)renewalAuthTokenWithAppid:(NSString *)appid appkey:(NSString *)appkey certID:(NSString *)certID mobile:(NSString *)mobile callBack:(UMCSDKCallBack)callBack
{
    if (mobile.length == 0 || certID.length == 0)
    {
        if (callBack)
        {
            NSDictionary *result = @{@"resultCode":@"102203"};
            callBack(result);
        }
        return;
    }
    
    if ([IDMPAutoLoginViewController getAuthType] < 0)
    {
        if (callBack)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            callBack(result);
        }
        return;
    }
    
    BOOL appidChecked = [[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if (appidChecked) {
        NSLog(@"------appid is checked");
        [IDMPKsModel renewKsWithAppid:appid appkey:appkey certID:certID mobile:mobile callBack:callBack];
    } else {
        [self checkWithAppId:appid andAppkey:appkey successBlock:^(NSDictionary *paraments) {
            [IDMPKsModel renewKsWithAppid:appid appkey:appkey certID:certID mobile:mobile callBack:callBack];
        } failBlock:^(NSDictionary *paraments) {
            callBack(paraments);
        }];
    }

}


+ (id)getToken:(NSString *)certID mobile:(NSString *)mobile
{
    NSDictionary *result = nil;
    
    if (mobile.length == 0 || certID.length == 0)
    {
        result = @{@"resultCode":@"102203"};
        return result;
    }
    
    if ([IDMPAutoLoginViewController getAuthType] < 0)
    {
        result = @{@"resultCode":@"102101"};
        return result;
    }
    
    NSMutableDictionary *userDic=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mobile]];
    NSLog(@"user %@",userDic);
    
    if ([userDic count] == 0)
    {
        result = @{@"resultCode":@"102206"};
        return result;
    }
    
    NSString *expiretime = [userDic objectForKey:@"expiretime"];
    
    if([[NSDate dateWithTimeIntervalSince1970:[expiretime doubleValue]] compare:[NSDate date]] > 0)
    {
        NSLog(@"ks仍在有效期");
        result = [IDMPAutoLoginViewController cacheUseWithUserName:mobile];;
        return result;
    }
    else
    {
        //NSLog(@"ks已失效");
        result = @{@"resultCode":@"102114"};
        return result;
    }
}


//+ (void)logout
//{
//    [IDMPAutoLoginViewController cleanSSO];
//}


+ (void)setIsPrintLocalLog:(BOOL)isPrintLocalLog
{
    [[NSUserDefaults standardUserDefaults] setObject:@(isPrintLocalLog) forKey:@"IDMPSetIsLogPrint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setEnvironment:(Environment)environment
{
    NSString *IDMP_environment_mark = @"";
    switch (environment) {
        case OnlineEnvironment:
        {
            //线上环境
            IDMP_environment_mark = @"online";
        }
            break;
        case DebugEnvironment:
        {
            //联调环境
            IDMP_environment_mark = @"debug";
        }
            break;
        default:
        {
            //线上环境
            IDMP_environment_mark = @"online";
        }
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:IDMP_environment_mark forKey:@"IDMP_environment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
