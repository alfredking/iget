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
#import "IDMPDataSms.h"

@implementation IDMPDataSMSMode

- (void)getDataSmsKSWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
{
    NSLog(@"data sms start");
    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *encryptClientNonce= RSA_encrypt(clientNonce);
    NSString *Rand=[NSString stringWithFormat:@"0%@%@",clientNonce,@"【中移统一认证】"];
    NSLog(@"new rand %@",Rand);
    NSArray *receiveList=[[NSArray alloc] initWithObjects:SmsAccessNum,nil];
    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:getType];
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",ksDS_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,SIP,sip,ksEnClientkek,encryptClientNonce,ksRAND,clientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(authorization);
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:clientNonce,@"cNonce",heads,@"head",sip,SIP,nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IDMPDataSms sharedInstance] sendSMS:Rand recipientList:receiveList option:options SuccessBlock:successBlock failBlock:failBlock];
    });

    NSLog(@"%@",heads);
}



@end
