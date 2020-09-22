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
#import "IDMPNonce.h"
#import "IDMPMD5.h"
#import "IDMPDate.h"

@implementation IDMPQueryModel

+ (void)queryAppPasswdWithUserName:(NSString *)userName finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock

{
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", requestAppPsd,appidString, sipEncFlag,yesFlag,ksUserName,userName,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getAsynWithHeads:heads url:qapUrl timeOut:10
    successBlock:^(NSDictionary *parameters){
//         NSDictionary *response=request.responseHeaders;
         NSLog(@"查询password 结果 %@",parameters);
         NSInteger resultCode = [[parameters objectForKey:ksResultCode] integerValue];
         if(resultCode==IDMPResultCodeSuccess)
         {
             NSString *query = [parameters objectForKey:@"Query-Result"];
             NSDictionary *parament=[IDMPParseParament parseParamentFrom:query];
             NSLog(@"PASSWORD QUERY %@",parameters);
             NSString *apppassword= [parament objectForKey:@"appPassword"];
             NSString *decPassWd=nil;
             NSString *openid = [parament objectForKey:@"openid"];
             if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
                 NSLog(@"openid is nil from server");
                 NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
                 openid = [user objectForKey:@"openid"];
                 if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
                     NSLog(@"openid is nil from cache");
                     openid = @"";
                 }
             }
             if(![IDMPFormatTransform checkNSStringisNULL:apppassword])
             {
                 decPassWd=secRSA_Decrypt(apppassword);
                 NSLog(@"decpasswd is %@",decPassWd);
                 NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:decPassWd,sipPassword,openid,@"openid", nil];
                 successBlock(result);
                 
             }
         }
         else
         {
             NSLog(@"resultcode fail");
             if (failBlock)
             {
                 NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[parameters objectForKey:@"resultCode"],@"resultCode", nil];
                 failBlock(dic);
             }
         }
     } failBlock:^(NSDictionary *parameters){
//         NSLog(@"查询appid 结果 %@",request.responseHeaders);
//         if (failBlock)
//         {
//
//             NSDictionary *dic = nil;
//             if ([request.responseHeaders objectForKey:@"resultCode"])
//             {
//                 dic = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
//             }
//             else
//             {
//                 dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
//             }
//             failBlock(dic);
//         }
         if (failBlock) {
             failBlock(parameters);
         }
     }];

   
}


+ (void)checkWithAppId:(NSString *)Appid andAppkey:(NSString *)Appkey traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock {
    BOOL appidIsChecked = [self appidIsChecked];
    //如果已经校验过，则不再校验。
    if (appidIsChecked) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"103000",@"resultCode", nil];
        successBlock(dic);
        return;
    }
    NSLog(@"check appid appid:%@,appkey:%@",Appid,Appkey);
    if (Appid.length == 0 || Appkey.length == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock) {
            failBlock(dic);
        }
        return;
    }
    NSLog(@"query appid start ");
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,Appid,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
    NSString *Signature = secRSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey,Signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    NSLog(@"heads:%@",heads);
    
    if ([Appkey length] > 16) {
        Appkey = [Appkey substringToIndex:16];
    }
    
    [request getAsynWithHeads:heads url:appCheckUrl timeOut:10
    successBlock:^(NSDictionary *parameters){
//        NSDictionary *response=request.responseHeaders;
        NSLog(@"查询appid 结果 %@",parameters);
        NSString *query = [parameters objectForKey:@"Query-Result"];
        NSDictionary *parament=[IDMPParseParament parseParamentFrom:query];
        NSString *serverEncAppid = [parament objectForKey:eAppid];
        serverEncAppid = [serverEncAppid stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"server appid %@",serverEncAppid);
        NSData *temp=[IDMPAES128 AESEncryptWithKey:Appkey andString:Appid];
        NSString *localEncAppid= [IDMPAES128 base64EncodingWithData:temp];
        NSLog(@"local appid %@",localEncAppid);
        if ([localEncAppid isEqualToString:serverEncAppid])
        {
            [userInfoStorage setInfo:yesFlag withKey:isChecked];
            
            NSString *query = [parameters objectForKey:@"Query-Result"];
            NSDictionary *parament=[IDMPParseParament parseParamentFrom:query];
            NSString *sourceid = [parament objectForKey:sourceIdsk];
            NSLog(@"query sourceid result : %@",sourceid);
            [userInfoStorage setInfo:sourceid withKey:sourceIdsk];
            
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
    failBlock:^(NSDictionary *parameters){
//        NSLog(@"查询appid 结果 %@",request.responseHeaders);
//        if (failBlock)
//        {
//            [userInfoStorage setInfo:noFlag withKey:isChecked];
//
//            NSDictionary *dic = nil;
//            if ([request.responseHeaders objectForKey:@"resultCode"])
//            {
//                dic = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
//            }
//            else
//            {
//                dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
//            }
//            failBlock(dic);
//        }
        if (failBlock) {
            [userInfoStorage setInfo:noFlag withKey:isChecked];
            failBlock(parameters);
        }
    }];
}

+(void)cleanSsoSuccessNotificationWithBtid:(NSString *)btid andSqn:(NSString *)sqn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"query appid start ");
    NSString *Query=[NSString stringWithFormat:@"LT %@=\"%@\",%@=\"%@\",%@=\"%@\",forceclean=\"y\"",cleanBTID,btid,cleanSqn,sqn,cleanPhoneID,[IDMPDevice getDeviceID]];
    NSString *Signature = secRSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,cleanQuery,Signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getAsynWithHeads:heads url:cleanSsoUrl timeOut:10
    successBlock:^(NSDictionary *parameters){
//        NSDictionary *response=request.responseHeaders;
//        NSLog(@"cleanSsoSuccessNotification 结果 %@",parameters);
        successBlock(parameters);

    }
    failBlock:^(NSDictionary *parameters){
//        NSDictionary *response=request.responseHeaders;
//        NSLog(@"cleanSsoSuccessNotification 结果 %@",parameters);
        failBlock(parameters);
    }];
}
+ (BOOL)appidIsChecked
{
    static NSString *ischecked = nil;
    
    NSLog(@"ischecked is %@",ischecked);
    if([ischecked isEqualToString:yesFlag])
    {
        
        NSLog(@"check cache exist");
        return [ischecked boolValue];
    }
    else
    {
        ischecked = (NSString *)[userInfoStorage getInfoWithKey:isChecked];
        NSLog(@"get check cache from file");
        return [ischecked boolValue];
    }
    
}



+ (void)getConfigsWithCompletionBlock:(accessBlock)completionBlock {
//    NSDate *lastDate = (NSDate *)[userInfoStorage getInfoWithKey:IDMPLastGetConfigDate];
//    BOOL isSameDay = [IDMPDate isSameDay:lastDate date2:[NSDate date]];
//    NSDictionary *cacheConfigs = (NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS];
//    BOOL appidIsChecked = [self appidIsChecked];
//    if (isSameDay && cacheConfigs && appidIsChecked) {  //如果时间间隔没有超过一天，并且缓存存在。直接读缓存。
//        completionBlock(@{@"resultCode":[NSString stringWithFormat:@"%d",IDMPConfigsNoExcessData]});
//        return;
//    }
//    NSString *version = [IDMPDevice getAppVersion];
//    NSString *query= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", @"clientversion",version,sdkversion,sdkversionValue,@"appid",appidString,ksIOS_ID,[IDMPDevice getDeviceID]];
//    NSString *signature = secRSA_EVP_Sign(query);
//    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:query,@"query",signature,ksSignature,RC_data,kRC_data, nil];
//    NSLog(@"---heads:%@",heads);
//    IDMPHttpRequest *request=[[IDMPHttpRequest alloc]init];
//    [request getAsynWithHeads:heads url:configsUrl timeOut:15 successBlock:^(NSDictionary *parameters) {
//        [userInfoStorage setInfo:[NSDate date] withKey:IDMPLastGetConfigDate];
//        NSDictionary *configs = [IDMPParseParament dicionaryWithjsonString:parameters[@"Query-Result"]];
//        if (![configs isKindOfClass:[NSDictionary class]]) {
//            completionBlock(@{@"resultCode":[NSString stringWithFormat:@"%d",IDMPConfigsNoChange]});
//            return;
//        }
//        NSDictionary *cacheConfigs = (NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS];
//        if ([configs isEqualToDictionary:cacheConfigs]) {
//            completionBlock(@{@"resultCode":[NSString stringWithFormat:@"%d",IDMPConfigsNoChange]});
//        } else {
//            [userInfoStorage setInfo:configs withKey:IDMPCONFIGS];
            completionBlock(@{@"resultCode":@"103000"});
//        }
//    } failBlock:completionBlock];

}
@end
