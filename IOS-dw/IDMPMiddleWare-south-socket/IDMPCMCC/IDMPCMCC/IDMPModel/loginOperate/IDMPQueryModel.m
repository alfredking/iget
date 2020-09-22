//
//  IDMPQueryPwdModel.m
//  IDMPCMCC
//
//  Created by HGQ on 16/2/1.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "IDMPQueryModel.h"
#import "IDMPDevice.h"
#import "IDMPParseParament.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPHttpRequest.h"
#import "IDMPAutoLoginViewController.h"
#import "IDMPDate.h"
#import "NSString+IDMPAdd.h"
#import "NSData+IDMPAdd.h"
#import "IDMPUtility.h"

#ifdef STATESECRET
#import "MskManager.h"
#import "MskUtil.h"
#endif

#define sourceidKey @"Query"
#define cleanPhoneID @"phoneId"
#define eAppid @"eappid"
#define requestAppid @"CK appid"
#define requestAppPsd @"QAP appid"
#define NCAAppid @"NCA appid"


@implementation IDMPQueryModel

#pragma mark - 查询AppPassword
+ (void)queryAppPasswdWithUserName:(NSString *)userName finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock {
    NSMutableString *query = [NSMutableString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", requestAppPsd,appidString, sipEncFlag,yesFlag,ksUserName,userName,ksClientversion,clientversionValue,sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];

#ifdef STATESECRET
    NSString *NCAKeyName = (NSString *)[userInfoStorage getInfoWithKey:NCANameKey];
    [query appendString:[NSString stringWithFormat:@",%@=\"%@\",%@=\"%@\"",@"encType",@"nca",@"keyName",NCAKeyName]];
#endif
    NSString *finalQuery = [query copy];
    NSString *signature = [finalQuery idmp_RSASign];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:finalQuery,sourceidKey, signature,ksSignature, nil];

    
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getAsynWithHeads:heads url:qapUrl timeOut:10
    successBlock:^(NSDictionary *parameters){
         NSLog(@"查询password 结果 %@",parameters);
         NSInteger resultCode = [[parameters objectForKey:IDMPResCode] integerValue];
         if(resultCode==IDMPResultCodeSuccess) {
             NSString *query = [parameters objectForKey:@"Query-Result"];
             NSDictionary *parament=[IDMPParseParament parseParamentFrom:query];
             NSLog(@"PASSWORD QUERY %@",parameters);
             NSString *appPassword= [parament objectForKey:@"appPassword"];
             NSString *decPassWd=nil;
             NSString *openid = [parament objectForKey:IDMPOPENID];
             if ([IDMPUtility checkNSStringisNULL:openid]) {
                 NSLog(@"openid is nil from server");
                 NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
                 openid = [user objectForKey:IDMPOPENID];
                 if ([IDMPUtility checkNSStringisNULL:openid]) {
                     NSLog(@"openid is nil from cache");
                     openid = @"";
                 }
             }
             if(![IDMPUtility checkNSStringisNULL:appPassword]) {
                 decPassWd = [IDMPUtility rsaOrSM4DecryptWithEncData:appPassword];
                 if (!decPassWd) {
                     decPassWd = [appPassword idmp_RSADecrypt];
                 }
                 NSLog(@"decpasswd is %@",decPassWd);
                 NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:decPassWd,sipPassword,openid,IDMPOPENID, nil];
                 successBlock(result);
             }
         } else {
             NSLog(@"resultcode fail");
             if (failBlock) {
                 failBlock(parameters);
             }
         }
     } failBlock:^(NSDictionary *parameters){
         if (failBlock) {
             failBlock(parameters);
         }
     }];

   
}

#pragma mark - ck校验
+ (void)checkWithAppId:(NSString *)appid andAppkey:(NSString *)appkey traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock {
    [IDMPQueryModel keyUploadWithAppid:appid appkey:appkey traceId:traceId successBlock:^(NSDictionary *paraments) {
        BOOL appidIsChecked = [self appidIsChecked];
        //如果已经校验过，则不再校验。
        if (appidIsChecked) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"103000",IDMPResCode,@"validate success",IDMPResStr, nil];
            successBlock(dic);
            return;
        }
        NSLog(@"check appid appid:%@",appid);
        if (appid.length == 0 || appkey.length == 0) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",IDMPResCode,@"输入参数错误",IDMPResStr, nil];
            if (failBlock) {
                failBlock(dic);
            }
            return;
        }
        NSLog(@"query appid start ");
        NSMutableString *query=[NSMutableString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,appid,ksClientversion,clientversionValue,sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
#ifdef STATESECRET
        NSString *NCAKeyName = (NSString *)[userInfoStorage getInfoWithKey:NCANameKey];
        [query appendString:[NSString stringWithFormat:@",%@=\"%@\",%@=\"%@\"",@"encType",@"nca",@"keyName",NCAKeyName]];
#endif
        NSString *signature = [query idmp_RSASign];
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:query,sourceidKey,signature,ksSignature, nil];
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
        NSString *standardAppkey = appkey;
        if ([appkey length] > 16) {
            standardAppkey = [appkey substringToIndex:16];
        }
        
        [request getAsynWithHeads:heads url:appCheckUrl timeOut:20 successBlock:^(NSDictionary *parameters){
             //        NSDictionary *response=request.responseHeaders;
             NSLog(@"查询appid 结果 %@",parameters);
             NSString *query = [parameters objectForKey:@"Query-Result"];
             NSDictionary *parament=[IDMPParseParament parseParamentFrom:query];
             NSString *serverEncAppid = [parament objectForKey:eAppid];
             serverEncAppid = [serverEncAppid stringByReplacingOccurrencesOfString:@" " withString:@""];
             NSLog(@"server appid %@",serverEncAppid);
             NSString *localEncAppid = [IDMPUtility aesORSM4EncryptRawData:appid key:standardAppkey];
             NSLog(@"local appid %@",localEncAppid);
             if ([localEncAppid isEqualToString:serverEncAppid]) {
                 [userInfoStorage setInfo:yesFlag withKey:isChecked];
                 NSString *sip = [parament objectForKey:isSipApp] ? [parament objectForKey:isSipApp] : noSip;
                 [userInfoStorage setInfo:sip withKey:isSipApp];
                 NSString *sourceid = [parament objectForKey:sourceIdsk];
                 NSLog(@"query sourceid result : %@",sourceid);
                 [userInfoStorage setInfo:sourceid withKey:sourceIdsk];
                 
                 if (successBlock) {
                     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"103000",IDMPResCode,@"validate success",IDMPResStr, nil];
                     successBlock(dic);
                 }
             } else {
                 [userInfoStorage setInfo:noFlag withKey:isChecked];
                 NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102298",IDMPResCode,@"应用合法性校验失败",IDMPResStr, nil];
                 if (failBlock) {
                     failBlock(result);
                 }
             }
         } failBlock:^(NSDictionary *parameters){
            if (failBlock) {
                [userInfoStorage setInfo:noFlag withKey:isChecked];
                failBlock(parameters);
            }
        }];
    } failBlock:^(NSDictionary *paraments) {
        failBlock(paraments);
    }];
}

+ (BOOL)appidIsChecked {
    return [(NSString *)[userInfoStorage getInfoWithKey:isChecked] boolValue];
}

#pragma mark - cleansso
+(void)cleanSsoSuccessNotificationWithBtid:(NSString *)btid andSqn:(NSString *)sqn successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"query appid start ");
    NSString *query=[NSString stringWithFormat:@"LT %@=\"%@\",%@=\"%@\",%@=\"%@\",forceclean=\"y\"",IDMPbtid,btid,IDMPSQN,sqn,cleanPhoneID,[IDMPDevice getDeviceID]];
    NSString *signature = [query idmp_RSASign];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:query,IDMPQuery,signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getAsynWithHeads:heads url:cleanSsoUrl timeOut:20
    successBlock:^(NSDictionary *parameters){
        successBlock(parameters);
    } failBlock:^(NSDictionary *parameters){
        failBlock(parameters);
    }];
}


#pragma mark - 获取配置
+ (void)getConfigsWithCompletionBlock:(accessBlock)completionBlock {
//    NSDate *lastDate = (NSDate *)[userInfoStorage getInfoWithKey:IDMPLastGetConfigDate];
//    BOOL isSameDay = [IDMPDate isSameDay:lastDate date2:[NSDate date]];
//    NSDictionary *cacheConfigs = (NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS];
//    BOOL appidIsChecked = [self appidIsChecked];
//    if (isSameDay && cacheConfigs && appidIsChecked) {  //如果时间间隔没有超过一天，并且缓存存在。直接读缓存。
        completionBlock(@{IDMPResCode:[NSString stringWithFormat:@"%d",IDMPConfigsNoExcessData]});
//        return;
//    }
//    NSString *query= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", @"clientversion",clientversionValue,sdkversion,sdkversionValue,kAPPID,appidString,ksIOS_ID,[IDMPDevice getDeviceID]];
//    NSString *signature = [query idmp_RSASign];
//    NSString *rcData = [IDMPDevice getLocalUserDeviceData];
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:query,IDMPQuery,signature,ksSignature,rcData,kRC_data, nil];
//    IDMPHttpRequest *request=[[IDMPHttpRequest alloc]init];
//    [request getAsynWithHeads:heads url:configsUrl timeOut:15 successBlock:^(NSDictionary *parameters) {
//        [userInfoStorage setInfo:[NSDate date] withKey:IDMPLastGetConfigDate];
//        NSDictionary *configs = [IDMPParseParament dicionaryWithjsonString:parameters[@"Query-Result"]];
//        if (![configs isKindOfClass:[NSDictionary class]]) {
//            completionBlock(@{IDMPResCode:[NSString stringWithFormat:@"%d",IDMPConfigsNoChange]});
//            return;
//        }
//        NSDictionary *cacheConfigs = (NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS];
//        if ([configs isEqualToDictionary:cacheConfigs]) {
//            completionBlock(@{IDMPResCode:[NSString stringWithFormat:@"%d",IDMPConfigsNoChange]});
//        } else {
//            [userInfoStorage setInfo:configs withKey:IDMPCONFIGS];
//            completionBlock(@{IDMPResCode:@"103000"});
//        }
//    } failBlock:completionBlock];

}

#pragma mark - 国密上传
+ (void)keyUploadWithAppid:(NSString *)appid appkey:(NSString *)appkey traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    //如果是国密版本才会上传，其他版本直接成功返回。
#ifdef STATESECRET

    MskManager *mskManager = [MskManager shareInstance];
    NSString *mskName = [IDMPUtility getMskName];
    BOOL isMskExist = [mskManager isExist:mskName];
    NSString *NCAKeyName = (NSString *)[userInfoStorage getInfoWithKey:NCANameKey];
    if (isMskExist && NCAKeyName) {
        //如果已经存在msk，并且成功读取到NCANameKey则直接返回。
        successBlock(@{IDMPResCode:@"103000",IDMPResStr:@"success"});
        return;
    }
    
    MskResponse *response = [mskManager createMsk:mskName pk:sm2PUBLIC_KEY pin:PinCode];
    NSString *mk = [response getStringValue:@"mk"];
    NSString *cv = [response getStringValue:@"cv"];
    
    if (!mk || !cv) {
        [mskManager deleteMsk:[IDMPUtility getMskName] pin:PinCode];
        MskResponse *response = [mskManager createMsk:mskName pk:sm2PUBLIC_KEY pin:PinCode];
        mk = [response getStringValue:@"mk"];
        cv = [response getStringValue:@"cv"];
        //生成mk cv失败，则返回失败
//        failBlock(@{IDMPResCode:@"102402",IDMPResStr:@"NCA gen fail"});
//        return;
    }
    
    NSString *query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",NCAAppid,appid,ksClientversion,clientversionValue,sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId,@"mk",mk,@"cv",cv];
    NSString *signature = [[NSString stringWithFormat:@"%@%@",query,appkey] idmp_RSASign];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:query,IDMPQuery,signature,ksSignature, nil];
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getAsynWithHeads:heads url:DefaultKeyUploadURL timeOut:20 successBlock:^(NSDictionary *parameters){
        NSDictionary *paramDic = [IDMPParseParament parseParamentFrom:parameters[@"Query-Result"]];
        NSString *keyValue = paramDic[@"keyValue"];
        NSString *checkValue = paramDic[@"checkValue"];
        NSString *NCAKeyName = paramDic[@"NCA keyName"];
        if (keyValue && checkValue && NCAKeyName) {
            [IDMPUtility inputMskManager:mskManager keyValue:keyValue checkValue:checkValue];
            //存储keyname并返回
            [userInfoStorage setInfo:NCAKeyName withKey:NCANameKey];
            successBlock(@{IDMPResCode:@"103000",IDMPResStr:@"success"});
        } else {
            //服务端返回值缺失
            failBlock(@{IDMPResCode:@"102403",IDMPResStr:@"not get kv&cv&keyname"});
        }
    } failBlock:^(NSDictionary *parameters){
        failBlock(parameters);
        //如果上传失败则删除msk
        [mskManager deleteMsk:[IDMPUtility getMskName] pin:PinCode];
    }];
#else
    //其他版本直接成功回调
    successBlock(@{IDMPResCode:@"103000",IDMPResStr:@"success"});
#endif

}


@end
