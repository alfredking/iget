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
#import "IDMPMD5.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
#import "IDMPToken.h"
#import "IDMPMatch.h"
#import "userInfoStorage.h"


@implementation IDMPTempSmsMode

- (void)getSmsCodeWithUserName:(NSString*)userName busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    NSString *ischecked=[userInfoStorage getInfoWithKey: isChecked];
    if([ischecked isEqualToString:yesFlag])
    {
        
        NSDictionary *result;
        if (userName.length == 0)
        {
            result = @{@"resultCode":@"102303"};
            if (failBlock)
            {
                failBlock(result);
                return;
            }
        }
        
        BOOL userRet = [IDMPMatch validateMobile:userName];
        if (!userRet)
        {
            result = @{@"resultCode":@"102307"};
            if (failBlock)
            {
                failBlock(result);
                return;
            }
        }
        
        
        
        NSString *version = [IDMPDevice getAppVersion];
        NSString *clientNonce = [IDMPNonce getClientNonce];
        NSString *encryptClientNonce= RSA_encrypt(clientNonce);
        
        NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName]];
        NSString *BTID;
        if([user count]>0)
        {
            BTID = [user objectForKey:ksBTID];
        }
        
        NSString *UserManage = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",Vclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,ksBTID,BTID,TMMsgType,busiType,TMIsdn,userName,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
        NSString *Signature = RSA_EVP_Sign(UserManage);
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:UserManage,TMUserManage,Signature,ksSignature, nil];
        NSLog(@"请求头部%@",heads);
        IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
        [request getAsynWithHeads:heads url:vcUrl timeOut:20
                     successBlock:
         ^{
             NSLog(@"request success!");
             NSLog(@"message:%@",request.responseHeaders);
             NSDictionary *result = @{@"resultCode":@"102305"};
             successBlock(result);
         }
                        failBlock:
         ^{
             NSDictionary *responseHeaders=request.responseHeaders;
             NSLog(@"%@",responseHeaders);
             if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                 NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                 failBlock(result);
             }
             else
             {
                 NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                 
                 failBlock(resultCode);
             }
             NSLog(@"fail!");
         }];
    }else{
        NSLog(@"应用合法性校验失败");
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102298"};
            failBlock(result);
            return;
        }
    }
}

//提交验证码
-(void)getTMKSWithUserName:(NSString *)userName messageCode:(NSString *)messageCode successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

{
    
    NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked];
    if([ischecked isEqualToString:yesFlag])
    {
        
        NSDictionary *result;
        if (userName.length == 0)
        {
            result = @{@"resultCode":@"102303"};
            if (failBlock)
            {
                failBlock(result);
                return;
            }
        }
        
        BOOL userRet = [IDMPMatch validateMobile:userName];
        if (!userRet)
        {
            result = @{@"resultCode":@"102307"};
            if (failBlock)
            {
                failBlock(result);
                return;
            }
        }
        
        if (messageCode.length == 0)
        {
            result = @{@"resultCode":@"102308"};
            if (failBlock)
            {
                failBlock(result);
                return;
            }
        }
        
        BOOL isMessageCode = [IDMPMatch validateCheck:messageCode];
        if (!isMessageCode)
        {
            result = @{@"resultCode":@"102309"};
            if (failBlock)
            {
                failBlock(result);
                return;
            }
        }
        
        NSString *version = [IDMPDevice getAppVersion];
        NSString *clientNonce = [IDMPNonce getClientNonce];
        NSString *encryptClientNonce= RSA_encrypt(clientNonce);
        NSString *sip=[userInfoStorage getInfoWithKey:sipFlag];
        
        NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName]];
        NSString *BTID = user ? [user objectForKey:ksBTID] : nil;
        
        NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",DUPclientversion,version,sipFlag,sip,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,ksUserName,userName,ksEnClientNonce,encryptClientNonce,kDUP_verificationcode,messageCode,ksIOS_ID,[IDMPDevice getDeviceID]];
        NSString *Signature = RSA_EVP_Sign(authorization);
        NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data,nil];
        NSLog(@"提交验证码head:%@",heads);
        IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
        [request getAsynWithHeads:heads url:requestUrl timeOut:20
                     successBlock:
         ^{
             NSDictionary *responseHeaders=request.responseHeaders;
             NSLog(@"%@",responseHeaders);
             if ([self checkTMKSIsValid:request.responseHeaders userName:userName passWd:messageCode clientNonce:clientNonce])
             {
                 NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
                 NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
                 NSString *passWd=[parament objectForKey:@"spassword"];
                 NSString *passid=[parament objectForKey:@"passid"];
                 NSString *decPassWd=nil;
                 if(![IDMPFormatTransform checkNSStringisNULL:passWd])
                 {
                     decPassWd=RSA_decrypt(passWd);
                     NSLog(@"decpasswd is %@",decPassWd);
                     
                 }
                 
                 NSDictionary *result=nil;
                 NSString *sourceid=[userInfoStorage getInfoWithKey:sourceIdsk];
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
                     
                     result=[NSDictionary dictionaryWithObjectsAndKeys:Token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
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
             NSLog(@"fail!");
         }];
    }
    else
    {
        NSLog(@"应用合法性校验失败");
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102298"};
            failBlock(result);
            return;
        }
    }
}

//验证ks
-(BOOL)checkTMKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName passWd:(NSString *)passWd clientNonce:(NSString *)clientNonce
{
    NSLog(@"%@",responseHeaders);
    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
    if(resultCode!=IDMPResultCodeSuccess)
    {
        NSLog(@"resultcode fail");
        return NO;
    }
    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
    NSString *serverMac = [responseHeaders objectForKey:ksMac];
    if(!wwwauthenticate||!serverMac)
    {
        return NO;
    }
    //计算KS
    IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
    NSString *Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:%@",userName,ksDomainName,passWd]];
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksTS_nonce];
    unsigned char *ks=kdf_pw((unsigned char*)[Ha1 UTF8String],(char*)[ksUP_GBA UTF8String],(char*)[serverNonce UTF8String],(char*)[clientNonce UTF8String]);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
        //验证正确，存储ks
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
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:NO],@"isLocalNum",userName,@"userName",nil];
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
            [userInfo setValue:accounts forKey:userList ];
            
        }
        else
        {
            NSMutableArray *accounts=[[NSMutableArray alloc]init];
            [accounts addObject:userInfo];
            [userInfoStorage setInfo:accounts withKey:userList];
            
        }
        [userInfoStorage setInfo:user withKey:userName ];
        [userInfoStorage setInfo:userName withKey:nowLoginUser];
        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
        
        free(ks);
        NSLog(@"KS存储成功!");
        return YES;
    }
    else
    {
        free(ks);
        NSLog(@"KS验证不正确");
        return NO;
    }
}



@end
