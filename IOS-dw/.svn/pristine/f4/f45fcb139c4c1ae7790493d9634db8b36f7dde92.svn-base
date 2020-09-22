//
//  IDMPUPMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPUPMode.h"
#import "IDMPConst.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPMD5.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
#import "IDMPToken.h"
#import "IDMPHttpRequest.h"
#import "userInfoStorage.h"



@implementation IDMPUPMode

- (void)getUPKSByUserName:(NSString *)userName andPassWd:(NSString *)passWd successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
{
    NSLog(@"up start");
    NSString *version = [IDMPDevice getAppVersion];
    NSLog(@"up version");
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSLog(@"up clientNonce");
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSLog(@"up encrypt");
    NSString *encryptPassWd= RSA_encrypt(passWd);
    NSLog(@"up pass");
    NSString *sip=[userInfoStorage getInfoWithKey:sipFlag];
    NSLog(@"up sip");
    
    
    NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName]];
    NSString *BTID;
    if([user count]>0)
    {
        BTID = [user objectForKey:ksBTID];
    }
    
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksUP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,sipFlag,sip,ksUserName,userName,ksEnClientNonce,encryptClientNonce,ksEnPasswd,encryptPassWd,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSLog(@"up authorization");
    NSString *Signature = RSA_EVP_Sign(authorization);
    NSLog(@"up Signature");
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSLog(@"RC_data %@",RC_data);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:ksPW_GBA,ksPW_GBA_Value,authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSLog(@"up heads %@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:requestUrl timeOut:20
                 successBlock:
     ^{
         NSDictionary *responseHeaders=request.responseHeaders;
         NSLog(@"%@",responseHeaders);
         if ([self checkKSIsValid:responseHeaders userName:userName passWd:passWd clientNonce:clientNonce])
         {
             NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
             NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
             NSString *passWd=[parament objectForKey:@"spassword"];
             NSString *decPassWd=nil;
             if(![IDMPFormatTransform checkNSStringisNULL:passWd])
             {
                 NSLog(@"passwd is not null %@",passWd);
                 decPassWd=RSA_decrypt(passWd);
                 NSLog(@"decpasswd is %@",decPassWd);
                 
             }
             NSString *passid=[parament objectForKey:@"passid"];
             NSDictionary *result=nil;
             NSString *sourceid=[userInfoStorage getInfoWithKey:sourceIdsk];
             NSLog(@"sourceid %@",sourceid);
             NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
             if ([sip isEqualToString:@"2"])
             {
                 if (!decPassWd)
                 {
                     result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                     failBlock(result);
                     return ;
                 }
                 result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,decPassWd,sipPassword,@"102000",@"resultCode",passid,@"passid",Token,@"token",nil];
                 
                 
                 
             }
             else
             {
                 result=[NSDictionary dictionaryWithObjectsAndKeys:Token,@"token",@"102000",@"resultCode",passid,@"passid", nil];
             }
             successBlock(result);
             
         }
         else
         {
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }
         
     }
                    failBlock:
     ^{
         NSDictionary *responseHeaders=request.responseHeaders;
         NSLog(@"%@",responseHeaders);
         if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
             NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
             failBlock(result);
         }
         else{
             NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultCode);
         }
         NSLog(@"http fail");
     }];
    
}



#pragma mark 验证ks是否有效，有效的话保存
-(BOOL)checkKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName passWd:(NSString *)passWd clientNonce:(NSString *)clientNonce
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
    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
    NSString *Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:%@",userName,ksDomainName,passWd]];
    NSLog(@"ha1: %@ username %@  domin  %@   pass  %@",Ha1,userName,ksDomainName,passWd);
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksUP_nonce];
    unsigned char *ks=kdf_pw((unsigned char *)[Ha1 UTF8String],(char *)[ksUP_GBA UTF8String],(char *)[serverNonce UTF8String],(char *)[clientNonce UTF8String]);
    NSLog(@"ks is");
    print_hex((char *)ks);
    
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    NSLog(@"native Mac is %@",nativeMac);
    if([nativeMac isEqualToString:serverMac])
    {
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
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
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:NO],@"isLocalNum",userName,@"userName", nil];
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
                NSLog(@"account:%d",accounts.count);
            }
            NSLog(@"count:%d",count);
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
            [userInfoStorage setInfo:accounts withKey:userList ];
            
        }
        [userInfoStorage setInfo:user withKey:userName ];
        [userInfoStorage setInfo:userName withKey:nowLoginUser];
        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
        free(ks);
        NSLog(@"KS存储成功");
        return YES;
    }
    else
    {
        free(ks);
        NSLog(@"KS验证错误");
        return NO;
    }
}

+(BOOL)checkUpdateKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName  clientNonce:(NSString *)clientNonce
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
    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
    NSString *Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:",userName,ksDomainName]];
    NSLog(@"ha1: %@ username %@  domin  %@   ",Ha1,userName,ksDomainName);
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksUP_nonce];
    unsigned char *ks=kdf_pw((unsigned char *)[Ha1 UTF8String],(char *)[ksUP_GBA UTF8String],(char *)[serverNonce UTF8String],(char *)[clientNonce UTF8String]);
    NSLog(@"server nonce is %@,clientnonce is %@",serverNonce,clientNonce);
    NSLog(@"ks is");
    print_hex((char *)ks);
    
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
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
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:NO],@"isLocalNum",userName,@"userName", nil];
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
                NSLog(@"account:%d",accounts.count);
            }
            NSLog(@"count:%d",count);
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
            [userInfoStorage setInfo:accounts withKey:userList ];
            
        }
        [userInfoStorage setInfo:user withKey:userName ];
        [userInfoStorage setInfo:userName withKey:nowLoginUser];
        free(ks);
        NSLog(@"KS存储成功");
        return YES;
    }
    else
    {
        free(ks);
        NSLog(@"KS验证错误");
        return NO;
    }
}

@end
