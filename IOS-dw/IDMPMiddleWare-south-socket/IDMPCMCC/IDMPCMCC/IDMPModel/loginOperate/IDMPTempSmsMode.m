//
//  IDMPTempSmsMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTempSmsMode.h"
#import "IDMPDevice.h"
#import "NSString+IDMPAdd.h"
#import "IDMPHttpRequest.h"
#import "IDMPParseParament.h"
#import "IDMPFormatTransform.h"
#import "NSString+IDMPAdd.h"
#import "userInfoStorage.h"
#import "IDMPQueryModel.h"
#import "IDMPCoreEngine.h"
#import "IDMPLogReportMode.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"
#import "IDMPUtility.h"

#define Vclientversion @"VC clientversion"
#define TMMsgType @"msgtype"


@implementation IDMPTempSmsMode

- (void)getSmsCodeWithUserName:(NSString*)userName busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    int authType = [[IDMPCoreEngine new] getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, IDMPUserName, busiType, @"busiType", nil];
    NSString *traceId = [NSString idmp_getClientNonce];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getSmsCode" requestParm:requestParam authType:authType traceId:traceId];
    [self getSmsCodeWithUserName:userName busiType:busiType traceId:traceId successBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

- (void)getSmsCodeWithUserName:(NSString*)userName busiType:(NSString *)busiType traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
        @autoreleasepool {
            [self requestSmsWithUserName:userName busiType:busiType traceId:traceId successBlock:successBlock failBlock:failBlock];
        }
    } failBlock:^(NSDictionary *paraments) {
        failBlock(paraments);
    }];

}


- (void)requestSmsWithUserName:(NSString*)userName busiType:(NSString *)busiType traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSDictionary *result;
    if (userName.length == 0) {
        result = @{IDMPResCode:@"102303",IDMPResStr:@"用户名为空"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    BOOL userRet = [userName idmp_isPhoneNum];
    if (!userRet) {
        result = @{IDMPResCode:@"102307",IDMPResStr:@"用户名格式错误"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    NSString *clientNonce = [NSString idmp_getClientNonce];
    NSString *encryptClientNonce= [IDMPUtility rsaOrSM4EncryptWithRawData:clientNonce];
    NSMutableString *userManage = [NSMutableString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Vclientversion,clientversionValue,sdkversion,sdkversionValue,kAPPID,appidString,TMMsgType,busiType,IDMPMsisdn,userName,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
#ifdef STATESECRET
    NSString *NCAKeyName = (NSString *)[userInfoStorage getInfoWithKey:NCANameKey];
    [userManage appendString:[NSString stringWithFormat:@",%@=\"%@\",%@=\"%@\"",@"encType",@"nca",@"keyName",NCAKeyName]];
#endif
    NSString *finalUserManage = [userManage copy];
    NSString *Signature = [finalUserManage idmp_RSASign];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:finalUserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:vcUrl timeOut:20 successBlock:^(NSDictionary *parameters){
        NSDictionary *result = @{IDMPResCode:@"102305",IDMPResStr:@"get temp sms code success"};
         successBlock(result);
     } failBlock:^(NSDictionary *parameters){
         if (failBlock) {
             failBlock(parameters);
         }
     }];
}

//提交验证码
-(void)getTMKSWithSipInfo:(NSString *)sipinfo UserName:(NSString *)userName messageCode:(NSString *)messageCode traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSDictionary *result;
    if (userName.length == 0){
        result = @{IDMPResCode:@"102303",IDMPResStr:@"用户名为空"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    BOOL userRet = [userName idmp_isPhoneNum];
    if (!userRet) {
        result = @{IDMPResCode:@"102307",IDMPResStr:@"用户名格式错误"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    if (messageCode.length == 0) {
        result = @{IDMPResCode:@"102308",IDMPResStr:@"验证码为空"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    NSString *clientNonce = [NSString idmp_getClientNonce];
    IDMPAuthModel *authModel = [[IDMPAuthModel alloc] initDUPWithUserName:userName messgeCode:messageCode sipInfo:sipinfo clientNonce:clientNonce traceId:traceId];
    NSDictionary *heads = authModel.heads;
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:requestUrl timeOut:20
    successBlock:^(NSDictionary *parameters){
        NSDictionary *wwwauthenticate = [IDMPCheckKS checkDUPKSIsValid:parameters clientNonce:clientNonce userName:userName passWd:messageCode];
        [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:userName authType:IDMPDUP sipinfo:sipinfo traceId:traceId isTmpCache:NO successBlock:successBlock failBlock:failBlock];
     } failBlock:^(NSDictionary *parameters){
         if (failBlock) {
             failBlock(parameters);
         }
     }];
    
}

@end
