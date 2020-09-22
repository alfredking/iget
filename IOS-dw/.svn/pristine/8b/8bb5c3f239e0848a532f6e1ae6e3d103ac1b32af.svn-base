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

@interface IDMPWapMode()

{
    BOOL hasCallBack;
}

@end

@implementation IDMPWapMode

-(void)getWapKSWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:getType];
    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksWP_clientversion,version,SIP,sip, ksClientkek,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(authorization);
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSLog(@"wap heads：%@",heads);
    __block IDMPHttpRequest  *request= [[IDMPHttpRequest alloc]init];
    
    //并发任务
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t aQueueGroup = dispatch_group_create();
    
    //任务一
    dispatch_group_async(aQueueGroup, aQueue, ^{
        NSLog(@"11111111");
        [request getHttpByHeads:heads url:requestUrl
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
                 NSDictionary *result=nil;
                 NSString *sourceid=[[NSUserDefaults standardUserDefaults] objectForKey:source];
                 NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
                 
                 
                 if ([sip isEqualToString:@"1"])
                 {
                     if (!passWd) {
                         result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                         if (!hasCallBack) {
                             failBlock(result);
                             hasCallBack = YES;
                         }
                         return ;
                     }
                     
                     result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,Token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
                 }
                 else
                 {
                     result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,passWd,@"password",passid,@"passid",@"102000",@"resultCode",Token,@"token",nil];
                     
                 }
                 if (!hasCallBack) {
                     successBlock(result);
                     hasCallBack = YES;
                 }
                 
                 
             }
             else
             {
                 NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                 if (!hasCallBack) {
                     failBlock(result);
                     hasCallBack = YES;
                 }
             }
             
         }
                      failBlock:
         ^{
             NSDictionary *responseHeaders=request.responseHeaders;
             NSLog(@"%@",responseHeaders);
             if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                 responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:[responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
                 if (!hasCallBack) {
                     failBlock(responseHeaders);
                     hasCallBack = YES;
                 }
             }else{
                 NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                 if (!hasCallBack) {
                     failBlock(resultCode);
                     hasCallBack = YES;
                 }
             }
             NSLog(@"http fail");
         }];
    });
    
    //任务二
    dispatch_group_async(aQueueGroup, aQueue, ^{
        NSLog(@"22222222");
        [request getHttpByHeads:heads url:requestUrl
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
                 NSDictionary *result=nil;
                 NSString *sourceid=[[NSUserDefaults standardUserDefaults] objectForKey:source];
                 NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
                 
                 
                 if ([sip isEqualToString:@"1"])
                 {
                     if (!passWd) {
                         result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                         if (!hasCallBack) {
                             failBlock(result);
                             hasCallBack = YES;
                         }
                         return ;
                     }
                     
                     result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,Token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
                 }
                 else
                 {
                     result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,passWd,@"password",passid,@"passid",@"102000",@"resultCode",Token,@"token",nil];
                     
                 }
                 if (!hasCallBack) {
                     successBlock(result);
                     hasCallBack = YES;
                 }
                 
                 
             }
             else
             {
                 NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                 if (!hasCallBack) {
                     failBlock(result);
                     hasCallBack = YES;
                 }
             }
             
         }
                      failBlock:
         ^{
             NSDictionary *responseHeaders=request.responseHeaders;
             NSLog(@"%@",responseHeaders);
             if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                 responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:[responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
                 if (!hasCallBack) {
                     failBlock(responseHeaders);
                     hasCallBack = YES;
                 }
             }else{
                 NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                 if (!hasCallBack) {
                     failBlock(resultCode);
                     hasCallBack = YES;
                 }
             }
             NSLog(@"http fail");
         }];
    });
    
    //任务三
    dispatch_group_async(aQueueGroup, aQueue, ^{
        NSLog(@"33333333");
        [request getHttpByHeads:heads url:requestUrl
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
                 NSDictionary *result=nil;
                 NSString *sourceid=[[NSUserDefaults standardUserDefaults] objectForKey:source];
                 NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
                 
                 
                 if ([sip isEqualToString:@"1"])
                 {
                     if (!passWd) {
                         result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                         if (!hasCallBack) {
                             failBlock(result);
                             hasCallBack = YES;
                         }
                         return ;
                     }
                     
                     result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,Token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
                 }
                 else
                 {
                     result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,passWd,@"password",passid,@"passid",@"102000",@"resultCode",Token,@"token",nil];
                     
                 }
                 if (!hasCallBack) {
                     successBlock(result);
                     hasCallBack = YES;
                 }
                 
                 
             }
             else
             {
                 NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                 if (!hasCallBack) {
                     failBlock(result);
                     hasCallBack = YES;
                 }
             }
             
         }
                      failBlock:
         ^{
             NSDictionary *responseHeaders=request.responseHeaders;
             NSLog(@"%@",responseHeaders);
             if ([responseHeaders objectForKey:@"resultCode"]!=nil) {
                 responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:[responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
                 if (!hasCallBack) {
                     failBlock(responseHeaders);
                     hasCallBack = YES;
                 }
             }else{
                 NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                 if (!hasCallBack) {
                     failBlock(resultCode);
                     hasCallBack = YES;
                 }
             }
             NSLog(@"http fail");
         }];
    });
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
    unsigned char *ks=kdf_sms([clientNonce UTF8String],[ksWP_GBA UTF8String],[serverNonce UTF8String]);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
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
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
        
        
        
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
        if([accounts count]>0)
        {
            int count = 0;
            for (NSDictionary *model in accounts) {
                if ([[model objectForKey:@"userName"]isEqualToString:userName]) {
                    [accounts removeObject:model];
                    [accounts addObject:userInfo];
                    break;
                }
                count++;
            }
            if (count>=[accounts count]) {
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
        [user setObject:@"一键登录" forKey:@"getKSWay"];
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:userName];
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"KS存储成功!");
        return userName;
    }
    else
    {
        return NO;
        NSLog(@"KS验证不正确");
    }
}



@end
