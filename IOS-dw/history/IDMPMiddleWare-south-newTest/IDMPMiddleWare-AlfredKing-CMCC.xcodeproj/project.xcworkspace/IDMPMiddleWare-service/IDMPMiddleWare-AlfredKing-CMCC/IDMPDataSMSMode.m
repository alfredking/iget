//
//  IDMPDataSMSMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-10-16.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPDataSMSMode.h"
#import "IDMPDevice.h"
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

@implementation IDMPDataSMSMode

NSDictionary *heads;
NSString *Rand;
NSString *clientNonce;
BOOL didLogin=NO;

-(void)getDataSmsKS
{
    NSString *version = [IDMPDevice getAppVersion];
    clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce, pubKeyPath);
    Rand=[NSString stringWithFormat:@"TSXXRX30%@",clientNonce];
    NSArray *receiveList=[[NSArray alloc] initWithObjects:@"1065840401",nil];
    [self sendSMS:Rand recipientList:receiveList];
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",ksDS_clientversion,version,ksEnClientkek,encryptClientNonce,ksRAND,clientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization, nil];
    NSLog(@"%@",heads);
    IDMPHttpRequest *__block request= [IDMPHttpRequest getHttpByHeads:heads url:requestUrl
        successBlock:
        ^{
           if([self checkDataSmsKSIsValid:request.responseHeaders  clientNonce:clientNonce])
            NSLog(@"dataSMS success");
        
        }
        failBlock:
        ^{
        NSLog(@"fail");}
        ];
}

-(BOOL)checkDataSmsKSIsValid:(NSDictionary *)responseHeaders  clientNonce:(NSString *)clientNonce
{
    NSLog(@"%@",responseHeaders);
    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
    if(resultCode!=IDMPResultCodeSuccess)
    {
        return NO;
    }
    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
    NSString *serverMac = [responseHeaders objectForKey:ksMac];
    if(!wwwauthenticate||!serverMac)//服务返回错误，返回nil
    {
        return NO;
    }
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksDS_nonce];
    NSString *userName = [parament objectForKey:ksUserName];
    unsigned char *ks=kdf_sms([clientNonce UTF8String],[ksDS_GBA UTF8String],[serverNonce UTF8String]);
    
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        NSDate *expireTime = [formatter dateFromString:expireTimeString];
        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
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
        NSLog(@"ks存储成功");
        return YES;
    }
    else{
        return NO;
        NSLog(@"ks验证不正确");
    }
}

-(void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController: controller animated:YES completion:nil];
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultCancelled:
            //取消发短信功能
            NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            //发送短信
        {
            NSLog(@"Result: Sent");
        }
            break;
        case MessageComposeResultFailed:
            //发送失败
            NSLog(@"Result: Failed");
            break;
        default:
            break;
    }
}


@end
