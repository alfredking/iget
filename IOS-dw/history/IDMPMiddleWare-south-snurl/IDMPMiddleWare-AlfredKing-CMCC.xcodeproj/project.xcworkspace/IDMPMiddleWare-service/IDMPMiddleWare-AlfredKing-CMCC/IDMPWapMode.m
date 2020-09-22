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

@implementation IDMPWapMode

-(void)getWapKSWithSuccessBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock
{
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce, pubKeyPath);
    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksWP_clientversion,version,ksClientkek,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization, nil];
    IDMPHttpRequest  *__block request = [IDMPHttpRequest getHttpByHeads:heads url:requestUrl
    successBlock:
    ^{
        successBlock();
        [self checkKSIsValid:request.responseHeaders clientNonce:clientNonce];
    
    }
    failBlock:
    ^{
        failBlock();
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
    unsigned char *ks=kdf_sms([clientNonce UTF8String],[ksWP_GBA UTF8String],[serverNonce UTF8String]);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
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
        return userName;
    }
    else
    {
        return NO;
        NSLog(@"KS验证不正确");
    }
}

@end
