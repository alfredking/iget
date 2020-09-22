//
//  IDMPTempSmsMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTempSmsMode.h"
#import "IDMPConst.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPHttpRequest.h"
#import "IDMPParseParament.h"
#import "IDMPFormatTransform.h"
#import "IDMPMatch.h"
#import "userInfoStorage.h"
#import "IDMPQueryModel.h"
#import "IDMPAutoLoginViewController.h"
#import "IDMPLogReportMode.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"


@implementation IDMPTempSmsMode

- (void)getVOCWithUserName:(NSString*)userName busiType:(NSString *)busiType voiceVersion:(NSString *)voiceVersion successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
    
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",VOCclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,TMMsgType,busiType,TMIsdn,userName,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],@"voiceversion",voiceVersion];
    NSString *Signature = secRSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:getVoiceSmsURL timeOut:20 successBlock:^(NSDictionary *parameters){
        NSString *tempResult = parameters[@"Query-Result"];
        if (!tempResult) {
            successBlock(@{@"resultCode":@"103000"});
        } else {
            NSString *query = [NSString stringWithCString:[tempResult cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
            successBlock(@{@"resultCode":@"103000",@"smsCode":query});
        }

    } failBlock:failBlock];
}

-(void)getVOCKSWithSipInfo:(NSString *)sipinfo userName:(NSString *)userName messageCode:(NSString *)messageCode voiceVersion:(NSString *)voiceVersion traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *clientNonce = [IDMPNonce getClientNonce];
    IDMPAuthModel *authModel = [[IDMPAuthModel alloc] initSUPWithUserName:userName messgeCode:messageCode sipInfo:sipinfo clientNonce:clientNonce voiceVersion:voiceVersion traceId:clientNonce];
    NSDictionary *heads = authModel.heads;
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:voiceAuthRequest timeOut:20 successBlock:^(NSDictionary *parameters){
        NSDictionary *wwwauthenticate = [IDMPCheckKS checkVUPKSIsValid:parameters clientNonce:clientNonce userName:userName passWd:messageCode];
        [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:userName authType:IDMPVUP sipinfo:sipinfo traceId:clientNonce successBlock:successBlock failBlock:failBlock];
    } failBlock:^(NSDictionary *parameters) {
        NSLog(@"%@",parameters);
        failBlock(parameters);
    }];
}

- (void)getSmsCodeWithUserName:(NSString*)userName busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    int authType = [[IDMPAutoLoginViewController new] getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", busiType, @"busiType", nil];
    NSString *traceId = [IDMPNonce getClientNonce];
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
        result = @{@"resultCode":@"102303"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    BOOL userRet = [IDMPMatch validateMobile:userName];
    if (!userRet) {
        result = @{@"resultCode":@"102307"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
    
    NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Vclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,TMMsgType,busiType,TMIsdn,userName,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
    NSString *Signature = secRSA_EVP_Sign(UserManage);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:vcUrl timeOut:20 successBlock:^(NSDictionary *parameters){
         NSDictionary *result = @{@"resultCode":@"102305"};
         successBlock(result);
     } failBlock:^(NSDictionary *parameters){
//         NSDictionary *responseHeaders=request.responseHeaders;
//         NSLog(@"%@",responseHeaders);
//         if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
//             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
//             failBlock(result);
//         }
//         else
//         {
//             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
//
//             failBlock(resultCode);
//         }
//         NSLog(@"fail!");
         if (failBlock) {
             failBlock(parameters);
         }
     }];
}

//提交验证码
-(void)getTMKSWithSipInfo:(NSString *)sipinfo UserName:(NSString *)userName messageCode:(NSString *)messageCode traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSDictionary *result;
    if (userName.length == 0){
        result = @{@"resultCode":@"102303"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    BOOL userRet = [IDMPMatch validateMobile:userName];
    if (!userRet) {
        result = @{@"resultCode":@"102307"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
    if (messageCode.length == 0) {
        result = @{@"resultCode":@"102308"};
        if (failBlock) {
            failBlock(result);
            return;
        }
    }
    
//        BOOL isMessageCode = [IDMPMatch validateCheck:messageCode];
//        if (!isMessageCode)
//        {
//            result = @{@"resultCode":@"102309"};
//            if (failBlock)
//            {
//                failBlock(result);
//                return;
//            }
//        }
    
//    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
//    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
    
//    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
//    NSString *BTID = user ? [user objectForKey:ksBTID] : nil;
    
//    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",DUPclientversion,version,sipFlag,sipinfo,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,ksUserName,userName,ksEnClientNonce,encryptClientNonce,kDUP_verificationcode,messageCode,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
//    NSString *Signature = secRSA_EVP_Sign(authorization);
//    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data,nil];
//    NSLog(@"提交验证码head:%@",heads);
    IDMPAuthModel *authModel = [[IDMPAuthModel alloc] initDUPWithUserName:userName messgeCode:messageCode sipInfo:sipinfo clientNonce:clientNonce traceId:traceId];
    NSDictionary *heads = authModel.heads;
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:requestUrl timeOut:20
    successBlock:^(NSDictionary *parameters){
//             NSDictionary *responseHeaders=request.responseHeaders;
        NSDictionary *wwwauthenticate = [IDMPCheckKS checkDUPKSIsValid:parameters clientNonce:clientNonce userName:userName passWd:messageCode];
        [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:userName authType:IDMPDUP sipinfo:sipinfo traceId:traceId successBlock:successBlock failBlock:failBlock];
//        if (wwwauthenticate) {
//             NSString *wwwauthenticate = [parameters objectForKey:ksWWW_Authenticate];
//             NSDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//             NSString *passWd=[wwwauthenticate objectForKey:@"spassword"];
//             NSString *passid=[wwwauthenticate objectForKey:@"passid"];
//             NSString *decPassWd=nil;
//             if(![IDMPFormatTransform checkNSStringisNULL:passWd]) {
//                 decPassWd=secRSA_Decrypt(passWd);
//                 NSLog(@"decpasswd is %@",decPassWd);
//             }
//             NSDictionary *result=nil;
//             NSString *sourceid = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
//             if(!sourceid) {
//                 if (failBlock) {
//                     NSDictionary *result = @{@"resultCode":@"102298"};
//                     failBlock(result);
//                 }
//                 return;
//             }
//             NSString *token=[IDMPToken getTokenWithUserName:userName andSourceId:sourceid andTraceId:traceId];
//             if (token == nil && failBlock) {
//                 NSDictionary *result = @{@"resultCode":@"102317"};
//                 failBlock(result);
//                 return;
//             }
//             if ([sipinfo isEqualToString:isSip]) {
//                 if (!decPassWd) {
//                     result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
//                     if (failBlock) {
//                         failBlock(result);
//                     }
//                     return ;
//                 }
//
//                 NSString *openid = [wwwauthenticate objectForKey:@"openid"];
//                 if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                     NSLog(@"openid is nil from server");
//                     NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
//                     openid = [user objectForKey:@"openid"];
//                     if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                         NSLog(@"openid is nil from cache");
//                         openid = passid;
//                     }
//                 }
//
//                 result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,decPassWd,sipPassword,@"102000",@"resultCode",passid,@"passid",token,@"token",openid, @"openid", nil];
//             } else {
//                 result=[NSDictionary dictionaryWithObjectsAndKeys:token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
//             }
//
//            successBlock(result);
//         } else {
//             NSDictionary *result = @{@"resultCode":[parameters objectForKey:@"resultCode"]};
//             failBlock(result);
//         }
     } failBlock:^(NSDictionary *parameters){
//             NSDictionary *responseHeaders=request.responseHeaders;
//             NSLog(@"%@",responseHeaders);
//             if ([responseHeaders objectForKey:@"resultCode"])
//             {
//                 NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
//                 failBlock(result);
//             }
//             else
//             {
//                 NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
//
//                 failBlock(resultCode);
//             }
//             NSLog(@"fail!");
         if (failBlock) {
             failBlock(parameters);
         }
     }];
    
}

//验证ks
//-(BOOL)checkTMKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName passWd:(NSString *)passWd clientNonce:(NSString *)clientNonce {
//    NSLog(@"%@",responseHeaders);
//    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
//    if(resultCode!=IDMPResultCodeSuccess) {
//        NSLog(@"resultcode fail");
//        return NO;
//    }
//    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
//    NSString *serverMac = [responseHeaders objectForKey:ksMac];
//    if(!wwwauthenticate||!serverMac) {
//        return NO;
//    }
//    //计算KS
//    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
//    NSString *Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:%@",userName,ksDomainName,passWd]];
//    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//    NSString *serverNonce= [parament objectForKey:ksTS_nonce];
//    unsigned char *ks=kdf_pw((unsigned char*)[Ha1 UTF8String],(char*)[ksUP_GBA UTF8String],(char*)[serverNonce UTF8String],(char*)[clientNonce UTF8String]);
//    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
//    if([nativeMac isEqualToString:serverMac]) {
//        //验证正确，存储ks
//        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
//        NSString *rand =[md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce]];
//        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
//        [user setObject:expireTimeString forKey:ksExpiretime];
//        [user setObject:[IDMPFormatTransform charToNSHex:ks length:16] forKey:@"KS"];
//        [user setObject:rand forKey:@"Rand"];
//        NSString *passid=[parament objectForKey:@"passid"];
//        [user setObject:passid forKey:@"passid"];
//        NSString *sqn=[parament objectForKey:ksSQN];
//        NSString *BTID=[parament objectForKey:ksBTID];
//        [user setObject: sqn forKey:@"sqn"];
//        [user setObject: BTID forKey:@"BTID"];
//        [user setObject:serverMac forKey:@"mac"];
//
//        NSString *openid = [parament objectForKey:@"openid"];
//        if (![IDMPFormatTransform checkNSStringisNULL:openid]) {
//            [user setObject:openid forKey:@"openid"];
//        }
//
//        NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
//
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:NO],@"isLocalNum",userName,@"userName",nil];
//        if([accounts count]>0) {
//            int count = 0;
//            for (NSDictionary *model in accounts) {
//                if ([[model objectForKey:@"userName"]isEqualToString:userName]) {
//                    [accounts removeObject:model];
//                    [accounts addObject:userInfo];
//                    break;
//                }
//                count++;
//            }
//            if (count>=[accounts count]) {
//                [accounts addObject:userInfo];
//            }
//            [userInfoStorage setInfo:accounts withKey:userList];
//        } else {
//            NSMutableArray *accounts=[[NSMutableArray alloc]init];
//            [accounts addObject:userInfo];
//            [userInfoStorage setInfo:accounts withKey:userList];
//        }
//        [userInfoStorage setInfo:user withKey:userName ];
//        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
//
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS存储成功!");
//        return YES;
//    } else {
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS验证不正确");
//        return NO;
//    }
//}
@end
