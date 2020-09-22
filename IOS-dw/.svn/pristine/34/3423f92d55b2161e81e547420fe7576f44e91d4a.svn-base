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

@implementation IDMPUPMode

-(void)getUPKSByUserName:(NSString *)userName andPassWd:(NSString *)passWd successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
{
    NSLog(@"up start");
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *encryptPassWd= RSA_encrypt(passWd);
    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:getType];
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksUP_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,SIP,sip,ksUserName,userName,ksEnClientNonce,encryptClientNonce,ksEnPasswd,encryptPassWd,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(authorization);
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:ksPW_GBA,ksPW_GBA_Value,authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSLog(@"up heads %@",heads);
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getHttpByHeads:heads url:requestUrl
   successBlock:
    ^{
        NSDictionary *responseHeaders=request.responseHeaders;
        NSLog(@"%@",responseHeaders);
        if ([self checkKSIsValid:responseHeaders userName:userName passWd:passWd clientNonce:clientNonce])
        {
            NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
            NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
            NSString *passWd=[parament objectForKey:@"spassword"];
             NSString *passid=[parament objectForKey:@"passid"];
            NSDictionary *result=nil;
            NSString *sourceid=[[NSUserDefaults standardUserDefaults] objectForKey:source];
            NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
            if ([sip isEqualToString:@"1"])
            {
                if (!passWd)
                {
                    result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                    failBlock(result);
                    return ;
                }
                result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,Token,@"token",@"102000",@"resultCode",passid,@"passid", nil];
            }
            else
            {
                result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,passWd,@"password",@"102000",@"resultCode",passid,@"passid",Token,@"token",nil];
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
          if ([responseHeaders objectForKey:@"resultCode"])
          {
              NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
              failBlock(result);
          }
          else
          {
              NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
              failBlock(resultCode);
          }
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
    unsigned char *ks=kdf_pw([Ha1 UTF8String],[ksUP_GBA UTF8String],[serverNonce UTF8String],[clientNonce UTF8String]);
    NSLog(@"ks is");
    print_hex(ks);
   
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
        
        
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
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
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
        }
        else
        {
            NSMutableArray *accounts=[[NSMutableArray alloc]init];
            [accounts addObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
        }
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:userName];
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
