//
//  IDMPDataSMSMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-10-16.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPDataSMSMode.h"
#import "IDMPDevice.h"
#import "NSString+IDMPAdd.h"
#import "IDMPDataSms.h"
#import "userInfoStorage.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation IDMPDataSMSMode

-(void)getDataSmsKSWithSipInfo:(NSString *)sipinfo traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"data sms start");
    NSString *clientNonce = [NSString idmp_getClientNonce];
    NSString *Rand=[NSString stringWithFormat:@"0%@%@",clientNonce,@"系统将使用您当前号码发送一条免费短信验证您的身份！【中移统一认证】"];
    NSLog(@"rand length is %lu",(unsigned long)Rand.length);
    NSLog(@"new rand %@",Rand);
    NSString *smsAccessNumber = nil;
//    NSString *allowNonCMCCLogin = [(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPNON_CMCC_LOGIN_FLAG];
//    if ([allowNonCMCCLogin isEqualToString:@"0"]) {
//        NSLog(@"not allowed non cmcc login");
    //暂时不使用配置项
        smsAccessNumber = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCMCC_SMS] : DefaultSmsAccessNum;;
//    } else {
//        smsAccessNumber = [self checkCarrier];
//    }
    NSArray *receiveList=[[NSArray alloc] initWithObjects:smsAccessNumber,nil];
    NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:clientNonce,@"cNonce",sipinfo,sipFlag,traceId,IDMPTraceId, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IDMPDataSms sharedInstance] sendSMS:Rand recipientList:receiveList option:options isTmpCache:isTmpCache SuccessBlock:successBlock failBlock:failBlock];
    });
}

- (NSString*)getAccessNumber {
    OperatorName name = [IDMPDevice getChinaOperatorName];
    NSString *accessNumber = nil;
    switch (name) {
        case CMCC:
            accessNumber = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCMCC_SMS] : DefaultSmsAccessNum;
            break;
        case CTCC:
            accessNumber = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCTCC_SMS] : DefaultSmsAccessNum;
            break;
        case CUCC:
            accessNumber = [userInfoStorage getInfoWithKey:IDMPCONFIGS] ? (NSString *)[(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPCUCC_SMS] : DefaultSmsAccessNum;
            break;
        default:
            break;
    }
    return accessNumber;
}

@end
