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
#import "IDMPHttpRequest.h"
#import "IDMPMD5.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPFormatTransform.h"
@implementation IDMPUPMode

-(void)getUPKSByUserName:(NSString *)userName andPassWd:(NSString *)passWd successBlock:(IDMPBlock)successBlock failBlock:(IDMPBlock)failBlock;
{
    
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce, pubKeyPath);
    NSString *encryptPassWd= RSA_encrypt(passWd,pubKeyPath);
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ksUP_clientversion,version,ksUserName,userName,ksEnClientNonce,encryptClientNonce,ksEnPasswd,encryptPassWd,ksIOS_ID,[IDMPDevice getDeviceID]];
    
    NSString *Signature = RSA_EVP_Sign(authorization, priKeyPath);
    
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:ksPW_GBA,ksPW_GBA_Value,authorization,ksAuthorization,Signature,ksSignature, nil];
    NSLog(@"%@",heads);
    
    IDMPHttpRequest *__block request=[IDMPHttpRequest getHttpByHeads:heads url:requestUrl
    successBlock:
    ^{
        successBlock();
        [self checkKSIsValid:request.responseHeaders userName:userName passWd:passWd clientNonce:clientNonce];
    }
    failBlock:
    ^{
        failBlock();
        NSLog(@"http fail");
    }];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
//        
//        //通知主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回调或者说是通知主线程刷新，
//        });
//        
//    });
//    [request setDelegate:self];
//    NSString *responseString = [request responseHeaders];
//    NSLog(@"first%@",responseString);

}

- (void)requestFinished:(ASIHTTPRequest *)request

{
    NSString *responseString = [request responseHeaders];
    NSLog(@"resdelegate%@",responseString);
}

- (void)requestFailed:(ASIHTTPRequest *)request

{
    NSError *error = [request error];
}


#pragma mark 验证ks是否有效，有效的话保存
-(BOOL)checkKSIsValid:(NSDictionary *)responseHeaders userName:(NSString *)userName passWd:(NSString *)passWd clientNonce:(NSString *)clientNonce
{
    NSLog(@"check %@",responseHeaders);
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
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksUP_nonce];
    unsigned char *ks=kdf_pw([Ha1 UTF8String],[ksUP_GBA UTF8String],[serverNonce UTF8String],[clientNonce UTF8String]);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
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
        NSLog(@"KS存储成功");
        return YES;
    }
    else
    {
        NSLog(@"KS验证错误");
        return NO;
    }
}


@end
