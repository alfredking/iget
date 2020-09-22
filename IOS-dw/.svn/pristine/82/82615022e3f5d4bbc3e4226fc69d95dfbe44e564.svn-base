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

@implementation IDMPTempSmsMode

-(void)getTMMessageCodeWithUserName:(NSString *)userName successBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock;
{
    __block int  i=0;
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce, pubKeyPath);
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",kDUP1_clientversion,version,ksUserName,userName,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(authorization, priKeyPath);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature, nil];
    NSLog(@"请求头部%@",heads);
   [IDMPHttpRequest getHttpByHeads:heads url:requestUrl successBlock:
    ^{
        NSLog(@"messageCode success!");
        successBlock();
    }
    failBlock:
    ^{
        NSLog(@"messageCode fail!");
        failBlock();
    }];
}

//提交验证码
-(void)getTMKSWithUserName:(NSString *)userName messageCode:(NSString *)messageCode successBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock;

{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce, pubKeyPath);
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", kDUP2_clientversion,version,ksUserName,userName,ksEnClientNonce,encryptClientNonce,kDUP_verificationcode,messageCode,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(authorization, priKeyPath);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,nil];
    IDMPHttpRequest *__block request = [IDMPHttpRequest getHttpByHeads:heads url:requestUrl successBlock:
        ^{
            successBlock();
            [self checkTMKSIsValid:request.responseHeaders userName:userName passWd:messageCode clientNonce:clientNonce];}
        failBlock:
        ^{
            failBlock();
            NSLog(@"fail!");
        }];
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
    unsigned char *ks=kdf_pw([Ha1 UTF8String],[ksUP_GBA UTF8String],[serverNonce UTF8String],[clientNonce UTF8String]);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
        //验证正确，存储ks
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        NSDate *expireTime = [formatter dateFromString:expireTimeString];
        NSString *rand =[md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce]];
        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
        [user setObject:expireTime forKey:@"expireTime"];
        [user setObject:[IDMPFormatTransform charToNSHex:ks length:16] forKey:@"KS"];
        [user setObject:rand forKey:@"Rand"];
        NSString *sqn=[parament objectForKey:ksSQN];
        NSString *BTID=[parament objectForKey:ksBTID];
        [user setObject: sqn forKey:@"sqn"];
        [user setObject: BTID forKey:@"BTID"];
        [user setObject:serverMac forKey:@"mac"];
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
        if(accounts)
        {
            [accounts addObject:userName];
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
        }
        else
        {
            NSMutableArray *accounts=[[NSMutableArray alloc]init];
            [accounts addObject:userName];
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
            
        }

        [[NSUserDefaults standardUserDefaults] setValue:user forKey:userName];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSLog(@"KS存储成功!");
        return YES;
    }
    else
    {
        NSLog(@"KS验证不正确");
        return NO;
    }
}



@end
