//
//  IDMPUPMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPUPMode.h"
#import "IDMPConst.h"
#import "IDMPNonce.h"
#import "IDMPFormatTransform.h"
#import "IDMPHttpRequest.h"
#import "userInfoStorage.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"

@implementation IDMPUPMode

- (void)getUPKSWithSipInfo: (NSString *)sipinfo UserName:(NSString *)userName andPassWd:(NSString *)passWd traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
//    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
//    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
//    NSString *encryptPassWd= secRSA_Encrypt(passWd);
//    NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
//    NSLog(@"user is %@",user);
//    NSString *BTID = nil;
//    if([user count]>0) {
//        BTID = [user objectForKey:ksBTID];
//    }

//    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksUP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,sipFlag,sipinfo,ksUserName,userName,ksEnClientNonce,encryptClientNonce,ksEnPasswd,encryptPassWd,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
//
//    NSString *Signature = secRSA_EVP_Sign(authorization);
//
//    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
//
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:ksPW_GBA,ksPW_GBA_Value,authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    
    IDMPAuthModel *authModel = [[IDMPAuthModel alloc] initUPWithUserName:userName password:passWd sipInfo:sipinfo clientNonce:clientNonce traceId:traceId];
    NSDictionary *heads = authModel.heads;
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:requestUrl timeOut:20 successBlock:^(NSDictionary *parameters){
        @autoreleasepool {
            //         NSDictionary *responseHeaders=request.responseHeaders;
            NSDictionary *wwwauthenticate = [IDMPCheckKS checkUPKSIsValid:parameters clientNonce:clientNonce userName:userName passWd:passWd];
            [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:userName authType:IDMPUP sipinfo:sipinfo traceId:traceId successBlock:successBlock failBlock:failBlock];
//                NSString *wwwauthenticate = [parameters objectForKey:ksWWW_Authenticate];
//                NSDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//                NSString *passWd=[wwwauthenticate objectForKey:@"spassword"];
//
//                NSString *decPassWd=nil;
//                if(![IDMPFormatTransform checkNSStringisNULL:passWd]) {
//                    decPassWd=secRSA_Decrypt(passWd);
//                }
//                NSString *passid=[wwwauthenticate objectForKey:@"passid"];
//                NSDictionary *result=nil;
//                NSString *sourceid = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
//                NSLog(@"sourceid is %@",sourceid);
//                if(!sourceid) {
//                    if (failBlock) {
//                        NSDictionary *result = @{@"resultCode":@"102298"};
//                        failBlock(result);
//                    }
//                    return;
//                }
//
//
//
//                NSString *token=[IDMPToken getTokenWithUserName:userName andSourceId:sourceid andTraceId:traceId];
//                if (token == nil && failBlock) {
//                    NSDictionary *result = @{@"resultCode":@"102317"};
//                    failBlock(result);
//                    return;
//                }
//                if ([sipinfo isEqualToString:isSip]) {
//                    if (!decPassWd) {
//                        result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
//                        if (failBlock) {
//                            failBlock(result);
//                        }
//                        return ;
//                    }
//
//                    NSString *openid = [wwwauthenticate objectForKey:@"openid"];
//                    if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                        NSLog(@"openid is nil from server");
//                        NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
//                        openid = [user objectForKey:@"openid"];
//                        if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                            NSLog(@"openid is nil from cache");
//                            openid = passid;
//                        }
//                    }
//
//                    result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,decPassWd,sipPassword,@"102000",@"resultCode",passid,@"passid",token,@"token",openid, @"openid", nil];
//                } else {
//                    result=[NSDictionary dictionaryWithObjectsAndKeys:token,@"token",@"102000",@"resultCode",passid,@"passid", nil];
//                }
//                successBlock(result);
//
//            } else {
//                NSDictionary *result = @{@"resultCode":[parameters objectForKey:@"resultCode"]};
//                failBlock(result);
//            }
        }
        
    } failBlock:^(NSDictionary *parameters){
         //          NSDictionary *responseHeaders=request.responseHeaders;
         //          NSLog(@"up fail responseheaders %@",responseHeaders);
         //          if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
         //              NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
         //              failBlock(result);
         //          }
         //          else{
         //              NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
         //
         //              failBlock(resultCode);
         //          }
         //          NSLog(@"http fail");
         if (failBlock) {
             failBlock(parameters);
         }
     }];
    
}



//#pragma mark 验证ks是否有效，有效的话保存
//-(BOOL)checkKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName passWd:(NSString *)passWd clientNonce:(NSString *)clientNonce
//{
//    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
//    if(resultCode!=IDMPResultCodeSuccess)
//    {
//        return NO;
//    }
//    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
//    NSString *serverMac = [responseHeaders objectForKey:ksMac];
//    if(!wwwauthenticate||!serverMac)
//    {
//        return NO;
//    }
//    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
//    NSString *Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:%@",userName,ksDomainName,passWd]];
//    //    NSLog(@"ha1: %@ username %@  domin  %@   pass  %@",Ha1,userName,ksDomainName,passWd);
//    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//
//    NSString *serverNonce= [parament objectForKey:ksUP_nonce];
//    unsigned char *ks=kdf_pw((unsigned char *)[Ha1 UTF8String],(char *)[ksUP_GBA UTF8String],(char *)[serverNonce UTF8String],(char *)[clientNonce UTF8String]);
//    //    NSLog(@"ks is");
//    //    print_hex((char *)ks);
//
//    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
//    //    NSLog(@"native Mac is %@",nativeMac);
//    if([nativeMac isEqualToString:serverMac])
//    {
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
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:NO],@"isLocalNum",userName,@"userName", nil];
//        if([accounts count]>0)
//        {
//            int count = 0;
//            for (NSDictionary *model in accounts)
//            {
//                if ([[model objectForKey:@"userName"]isEqualToString:userName])
//                {
//                    [accounts removeObject:model];
//                    [accounts addObject:userInfo];
//                    break;
//                }
//                count++;
//
//            }
//
//            if (count>=[accounts count])
//            {
//                [accounts addObject:userInfo];
//            }
//            [userInfoStorage setInfo:accounts withKey:userList];
//        }
//        else
//        {
//            NSMutableArray *accounts=[[NSMutableArray alloc]init];
//            [accounts addObject:userInfo];
//            [userInfoStorage setInfo:accounts withKey:userList ];
//
//        }
//
//        [userInfoStorage setInfo:user withKey:userName ];
//        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
//
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS存储成功");
//        return YES;
//    }
//    else
//    {
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS验证错误");
//        return NO;
//    }
//}
//
//+(BOOL)checkUpdateKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName  clientNonce:(NSString *)clientNonce
//{
//    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
//    if(resultCode!=IDMPResultCodeSuccess)
//    {
//        return NO;
//    }
//    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
//    NSString *serverMac = [responseHeaders objectForKey:ksMac];
//    if(!wwwauthenticate||!serverMac)
//    {
//        return NO;
//    }
//    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
//    NSString *Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:",userName,ksDomainName]];
//    NSLog(@"ha1: %@ username %@  domin  %@   ",Ha1,userName,ksDomainName);
//    NSMutableDictionary *parament=[self updateParseParamentFrom:wwwauthenticate];
//    NSString *serverNonce= [parament objectForKey:@"Nonce"];
//    NSString *caculateType=[parament objectForKey:@"KSRTYPE"];
//
//    NSLog(@"type is %@",caculateType);
//    unsigned char *ks;
//    if ([caculateType isEqualToString:@"WP"])
//    {
//        ks=kdf_sms((unsigned char*)[clientNonce UTF8String],(char*)[ksWP_GBA UTF8String],(char*)[serverNonce UTF8String]);
//        NSLog(@"WP ks is");
//
//    }
//    else if([caculateType isEqualToString:@"HS"])
//    {
//        ks=kdf_sms((unsigned char *)[clientNonce  UTF8String],(char *)[ksDS_GBA UTF8String],(char *)[serverNonce UTF8String]);
//        NSLog(@"sms ks is");
//    }
//    else
//    {
//        ks=kdf_pw((unsigned char *)[Ha1 UTF8String],(char *)[ksUP_GBA UTF8String],(char *)[serverNonce UTF8String],(char *)[clientNonce UTF8String]);
//    }
//
//    NSLog(@"server nonce is %@,clientnonce is %@",serverNonce,clientNonce);
//    NSLog(@"ks is");
//    //    print_hex((char *)ks);
//
//    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
//    if([nativeMac isEqualToString:serverMac])
//    {
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
//
//        NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
//        NSDictionary *userInfo;
//        if ([caculateType isEqualToString:@"WP"])
//        {
//            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
//
//        }
//        else if([caculateType isEqualToString:@"HS"])
//        {
//            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
//        }
//        else
//        {
//            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:NO],@"isLocalNum",userName,@"userName", nil];
//        }
//
//
//        if([accounts count]>0)
//        {
//            int count = 0;
//            for (NSDictionary *model in accounts)
//            {
//                if ([[model objectForKey:@"userName"]isEqualToString:userName])
//                {
//                    [accounts removeObject:model];
//                    [accounts addObject:userInfo];
//                    break;
//                }
//                count++;
//                NSLog(@"account:%d",accounts.count);
//            }
//            NSLog(@"count:%d",count);
//            if (count>=[accounts count])
//            {
//                [accounts addObject:userInfo];
//            }
//            [userInfoStorage setInfo:accounts withKey:userList];
//        }
//        else
//        {
//            NSMutableArray *accounts=[[NSMutableArray alloc]init];
//            [accounts addObject:userInfo];
//            [userInfoStorage setInfo:accounts withKey:userList ];
//
//        }
//        [userInfoStorage setInfo:user withKey:userName ];
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS存储成功");
//        return YES;
//    }
//    else
//    {
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS验证错误");
//        return NO;
//    }
//}
//
//
//+(NSMutableDictionary *) updateParseParamentFrom:(NSString *)wwwauthenticate
//{
//    NSArray *params = [wwwauthenticate componentsSeparatedByString:@","];
//    NSMutableDictionary *result=[[NSMutableDictionary alloc]init] ;
//    NSString *KSRTYPE=@"null";
//    for(NSString *object in params)
//    {
//        NSArray *KV= [object componentsSeparatedByString:@"\""];
//        NSString *key=(NSString *)KV[0];
//        key=[key substringToIndex:key.length-1];
//        NSRange range = [key rangeOfString:@"Nonce"];
//        if (range.location != NSNotFound)
//        {
//            NSArray *ksType = [key componentsSeparatedByString:@" "];
//            NSLog( @"array is %@",ksType);
//            KSRTYPE=[ksType objectAtIndex:0];
//            key=@"Nonce";
//        }
//        NSString *value=(NSString *)KV[1];
//        [result setObject: value forKey:key];
//    }
//    [result setObject: KSRTYPE forKey:@"KSRTYPE"];
//    return result;
//}

@end
