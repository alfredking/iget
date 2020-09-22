//
//  IDMPWapMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPWapMode.h"
#import "IDMPConst.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPHttpRequest.h"
#import "IDMPMD5.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
#import "IDMPToken.h"
#import "userInfoStorage.h"


@implementation IDMPWapMode

-(void)getWapKSWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *sip=[userInfoStorage getInfoWithKey:sipFlag];
    NSMutableArray *users=[NSMutableArray arrayWithArray:[userInfoStorage getInfoWithKey:userList]];
    NSString *BTID;
    for (NSDictionary *user in users)
    {
        if ([[user objectForKey:@"isLocalNum"] boolValue])
        {
            BTID = [user objectForKey:ksBTID];
        };
    }
    
    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksWP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,yesFlag,httpsFlag,yesFlag, ksBTID,BTID,sipFlag,sip,ksClientkek,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(authorization);
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSLog(@"---heads:%@",heads);
    __block IDMPHttpRequest  *request=[[IDMPHttpRequest alloc]init];
    [request getWapAsynWithHeads:heads  url:wapURL timeOut:20
                    successBlock:
     ^{
         NSDictionary *responseHeaders=request.responseHeaders;
         NSLog(@"%@",responseHeaders);
         if ([self checkKSIsValid:responseHeaders clientNonce:clientNonce])
         {
             NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
             NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
             NSString *userName = [parament objectForKey:ksUserName];
             NSString *passWd=[parament objectForKey:@"spassword"];
             NSString *passid=[parament objectForKey:@"passid"];
             NSString *decPassWd=nil;
             NSString *decUserName=nil;
             
             if(![IDMPFormatTransform checkNSStringisNULL:passWd])
             {
                 decPassWd=RSA_decrypt(passWd);
                 NSLog(@"decpasswd is %@",decPassWd);
                 
             }
             if(![IDMPFormatTransform checkNSStringisNULL:userName])
             {
                 decUserName=RSA_decrypt(userName);
                 NSLog(@"decpasswd is %@",decPassWd);
                 
             }
             
             
             NSDictionary *result=nil;
             
             NSString *sourceid=[userInfoStorage getInfoWithKey:sourceIdsk];
             if(sourceid)
             {
                 NSLog(@"sourceid 存在");
                 NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
                 if ([sip isEqualToString:@"2"])
                 {
                     if (!decPassWd)
                     {
                         result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                         failBlock(result);
                         return ;
                     }
                     result=[NSDictionary dictionaryWithObjectsAndKeys:decUserName,ksUserName,decPassWd,sipPassword,passid,@"passid",@"102000",@"resultCode",Token,@"token",nil];
                     
                 }
                 else
                 {
                     result=[NSDictionary dictionaryWithObjectsAndKeys:Token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
                 }
                 
                 successBlock(result);
                 
             }
             else
             {
                 result = [NSDictionary dictionaryWithObjectsAndKeys:@"103118",@"resultCode", nil];
                 failBlock(result);
                 return ;
                 
             }
             
         }
         else
         {
             NSLog(@"mac不一致");
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }
         
     }
                       failBlock:
     ^{
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

-(BOOL)checkKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce
{
    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
    if(resultCode!=IDMPResultCodeSuccess)
    {
        return NO;
    }
    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
    NSString *serverMac = [responseHeaders objectForKey:ksMac];
    if(!wwwauthenticate||!serverMac)
    {
        return NO;
    }
    //计算ks
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksWP_nonce];
    NSString *userName = [parament objectForKey:ksUserName];
    unsigned char *ks=kdf_sms((unsigned char*)[clientNonce UTF8String],(char*)[ksWP_GBA UTF8String],(char*)[serverNonce UTF8String]);
    NSLog(@"ks is");
    print_hex((char*)ks);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    NSLog(@"native mac %@",nativeMac);
    if([nativeMac isEqualToString:serverMac])
    {
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
        NSString *rand =[md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce]];
        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
        [user setObject:expireTimeString forKey:ksExpiretime];
        [user setObject:[IDMPFormatTransform charToNSHex:ks length:16] forKey:@"KS"];
        [user setObject:rand forKey:@"Rand"];
        NSString *passid=[parament objectForKey:@"passid"];
        [user setObject:passid forKey:@"passid"];
        NSString *sqn=[parament objectForKey:ksSQN];
        NSString *BTID=[parament objectForKey:ksBTID];
        [user setObject: sqn forKey:@"sqn"];
        [user setObject: BTID forKey:@"BTID"];
        [user setObject:serverMac forKey:@"mac"];
        
        
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[userInfoStorage getInfoWithKey:userList]];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
        if([accounts count]>0)
        {
            int count = 0;
            for (NSDictionary *model in accounts)
            {
                if ([[model objectForKey:@"userName"]isEqualToString:userName])
                {
                    [accounts removeObject:model];
                    [accounts addObject:userInfo];
                    break;
                }
                count++;
            }
            if (count>=[accounts count])
            {
                [accounts addObject:userInfo];
            }
            [userInfoStorage setInfo:accounts withKey:userList];
            
        }
        else
        {
            NSMutableArray *accounts=[[NSMutableArray alloc]init];
            [accounts addObject:userInfo];
            [userInfoStorage setInfo:accounts withKey:userList];
            
        }
        [userInfoStorage setInfo:user withKey:userName];
        
        [userInfoStorage setInfo:userName withKey:nowLoginUser];
        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
        free(ks);
        NSLog(@"KS存储成功!");
        return YES;
    }
    else
    {
        free(ks);
        return NO;
        NSLog(@"KS验证不正确");
    }
}

@end
