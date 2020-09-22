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
#import "userInfoStorage.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation IDMPDataSMSMode

-(void)getDataSmsKSWithSipInfo:(NSString *)sipinfo traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"data sms start");
//    NSString *version = [IDMPDevice getAppVersion];
    NSString *clientNonce = [IDMPNonce getClientNonce];
//    NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);

    NSString *Rand=[NSString stringWithFormat:@"0%@%@",clientNonce,@"系统将使用您当前号码发送一条免费短信验证您的身份！【中移统一认证】"];
    NSLog(@"rand length is %d",Rand.length);
    NSLog(@"new rand %@",Rand);
    NSString *smsAccessNumber = nil;
    NSString *allowNonCMCCLogin = [(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPNON_CMCC_LOGIN_FLAG];
    if ([allowNonCMCCLogin isEqualToString:@"0"]) {
        NSLog(@"not allowed non cmcc login");
        smsAccessNumber = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCMCC_SMS] : DefaultSmsAccessNum;;
    } else {
        smsAccessNumber = [self checkCarrier];
    }
    NSArray *receiveList=[[NSArray alloc] initWithObjects:smsAccessNumber,nil];
    
//    NSString *BTID;
//    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",ksDS_clientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,yesFlag,ksBTID,BTID,sipFlag,sipinfo,ksEnClientkek,encryptClientNonce,ksRAND,clientNonce,ksIOS_ID,[IDMPDevice getDeviceID]];
//    NSString *Signature = secRSA_EVP_Sign(authorization);
//    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
//    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature,RC_data,kRC_data, nil];
    NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:clientNonce,@"cNonce",sipinfo,sipFlag,traceId,IDMPTraceId, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IDMPDataSms sharedInstance] sendSMS:Rand recipientList:receiveList option:options SuccessBlock:successBlock failBlock:failBlock];
    });
}

- (NSString*)checkCarrier
{
    NSString *ret = [[NSString alloc] init];
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if ( carrier == nil )
    {
        return nil;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code isEqualToString:@""])
    {
        return nil;
    }
    
    if ( [code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"] )
    {
        ret = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCMCC_SMS] : DefaultSmsAccessNum;
    }
    
    if ( [code isEqualToString:@"01"] || [code isEqualToString:@"06"] )
    {
        ret = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCUCC_SMS] : DefaultSmsAccessNum;
    }
    
    if ( [code isEqualToString:@"03"] || [code isEqualToString:@"05"] || [code isEqualToString:@"11"])
    {
        ret = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCTCC_SMS] : DefaultSmsAccessNum;
    }
    
    return ret;
}

@end
