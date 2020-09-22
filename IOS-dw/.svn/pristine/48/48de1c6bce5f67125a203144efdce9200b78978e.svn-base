//
//  IDMPWapMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPWapMode.h"
#import "IDMPConst.h"
#import "IDMPNonce.h"
#import "IDMPHttpRequest.h"
#import "userInfoStorage.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"


@implementation IDMPWapMode

-(void)getWapKSWithSipInfo:(NSString *)sipinfo traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
//    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
//    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
//    NSString *BTID;
//    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksWP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,yesFlag,httpsFlag,yesFlag, ksBTID,BTID,sipFlag,sipinfo,ksClientkek,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],IDMPTraceId,traceId];
//    NSString *Signature = secRSA_EVP_Sign(authorization);
//    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSDictionary *heads = [[IDMPAuthModel alloc] initWPWithSipInfo:sipinfo clientNonce:clientNonce traceId:traceId].heads;
    __block IDMPHttpRequest  *request=[[IDMPHttpRequest alloc]init];
    [request getWapAsynWithHeads:heads  url:wapURL timeOut:20 successBlock:^{
        @autoreleasepool {
            NSDictionary *responseHeaders=request.responseHeaders;
            NSLog(@"%@",responseHeaders);
            NSDictionary *wwwauthenticate = [IDMPCheckKS checkWAPKSIsValid:responseHeaders clientNonce:clientNonce];
            [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:nil authType:IDMPWP sipinfo:sipinfo traceId:traceId successBlock:successBlock failBlock:failBlock];
            
            
//                NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
//                NSDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//                NSString *userName = [wwwauthenticate objectForKey:ksUserName];
//                NSLog(@"username is %@",userName);
//                NSString *passWd=[wwwauthenticate objectForKey:@"spassword"];
//                NSLog(@"passWd is %@",passWd);
//                NSString *passid=[wwwauthenticate objectForKey:@"passid"];
//                NSString *decPassWd=nil;
//                NSString *decUserName=nil;
//
//                if(![IDMPFormatTransform checkNSStringisNULL:passWd]) {
//                    decPassWd=secRSA_Decrypt(passWd);
//                    NSLog(@"decpasswd is %@",decPassWd);
//                }
//                if(![IDMPFormatTransform checkNSStringisNULL:userName]) {
//                    decUserName=secRSA_Decrypt(userName);
//                    NSLog(@"decUserName is %@",decUserName);
//                }
//                NSDictionary *result=nil;
//                NSString *sourceid = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
//                if(!sourceid) {
//                    if (failBlock) {
//                        NSDictionary *result = @{@"resultCode":@"102298"};
//                        failBlock(result);
//                    }
//                    return;
//                 }
//
//                NSString *token=[IDMPToken getTokenWithUserName:decUserName andSourceId:sourceid andTraceId:traceId];
//                if (token == nil && failBlock) {
//                    NSDictionary *result = @{@"resultCode":@"102317"};
//                    failBlock(result);
//                    return;
//                }
//                NSLog(@"token is %@",token);
//                if ([sipinfo isEqualToString:isSip]) {
//                    if (!decPassWd) {
//                        NSLog(@"没有密码");
//                        result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
//                        if (failBlock) {
//                            failBlock(result);
//                        }
//                        return ;
//                    }
//                    NSLog(@"有密码");
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
//                    result=[NSDictionary dictionaryWithObjectsAndKeys:decUserName,ksUserName,decPassWd,sipPassword,passid,@"passid",@"102000",@"resultCode",token,@"token", openid, @"openid", nil];
//
//                } else {
//                    result=[NSDictionary dictionaryWithObjectsAndKeys:token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
//
//                }
//                NSLog(@"result is %@",result);
//                successBlock(result);
//            } else {
//                NSLog(@"mac不一致");
//                NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
//                failBlock(result);
//            }
        }
        
    } failBlock:^{
        NSDictionary *responseHeaders=request.responseHeaders;
        NSLog(@"%@",responseHeaders);
        if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
            responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:[responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
            failBlock(responseHeaders);
        }else{
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
            
            failBlock(resultCode);
        }
        NSLog(@"http fail");
    }];
    
}



//-(BOOL)checkKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce
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
//    //计算ks
//    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//    NSString *serverNonce= [parament objectForKey:ksWP_nonce];
//    NSString *userName = [parament objectForKey:ksUserName];
//    if(![IDMPFormatTransform checkNSStringisNULL:userName])
//    {
//        userName=secRSA_Decrypt(userName);
//
//    }
//
//    unsigned char *ks=kdf_sms((unsigned char*)[clientNonce UTF8String],(char*)[ksWP_GBA UTF8String],(char*)[serverNonce UTF8String]);
//    NSLog(@"ks is");
//    //    print_hex((char*)ks);
//    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
//    NSLog(@"native mac %@",nativeMac);
//    NSLog(@"server mac %@",serverMac);
//    if([nativeMac isEqualToString:serverMac])
//    {
//        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
//        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
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
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
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
//            }
//            if (count>=[accounts count])
//            {
//                [accounts addObject:userInfo];
//            }
//            [userInfoStorage setInfo:accounts withKey:userList];
//
//        }
//        else
//        {
//            NSMutableArray *accounts=[[NSMutableArray alloc]init];
//            [accounts addObject:userInfo];
//            [userInfoStorage setInfo:accounts withKey:userList];
//
//        }
//        [userInfoStorage setInfo:user withKey:userName];
//        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
//        free(ks);
//        ks=NULL;
//        NSLog(@"KS存储成功!");
//        return YES;
//    }
//    else
//    {
//        free(ks);
//        ks=NULL;
//        return NO;
//        NSLog(@"KS验证不正确");
//    }
//}

@end
