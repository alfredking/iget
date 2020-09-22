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
#import "IDMPNonce.h"
#import "IDMPDataSms.h"
#import "IDMPMD5.h"

@implementation IDMPDataSMSMode

+ (void)getDataSmsMobileNumberWithAppid:(NSString *)appid appkey:(NSString *)appkey userName:(NSString *)userName SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"data sms start");
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *Rand= [NSString stringWithFormat:@"0%@%@",clientNonce,@"【中移统一认证】"];
    NSLog(@"new rand %@",Rand);
    NSArray *receiveList=[[NSArray alloc] initWithObjects:SmsAccessNum,nil];
    
    NSString *ompauth_realm = @"OMP";
    NSString *authtype = @"2";
    NSString *smskey = [NSString stringWithFormat:@"%@",clientNonce];
    NSString *codever = @"1.0";
    NSString *appver = @"1.0";
    NSString *sourceid = [[NSUserDefaults standardUserDefaults] objectForKey:source];
    NSString *hsmobile = userName.length > 0 ? [IDMPMD5 getMd5_32Bit_String:userName] : nil;
    NSString *deviceid = [IDMPDevice getDeviceID];
    NSString *mobilebrand = [[UIDevice currentDevice] model];
    NSString *mobilemodel = [IDMPDevice getCurrentDeviceModel];
    NSString *mobilesystem = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    NSString *clienttype = @"1";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *systemtime = [dateFormat stringFromDate:[NSDate date]];
    NSString *msgid = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",systemtime,deviceid]];
    NSString *networktype = [IDMPDevice GetCurrntNet];
    NSString *cnonce = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",systemtime,deviceid]];
    NSString *appsign = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@%@",appid,appkey,msgid]];
    NSString *codeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",authtype,appver,msgid,cnonce,networktype,appid,appsign];
    NSString *code =[[IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@",codeStr]] uppercaseString];

    NSString *authorization= [NSString stringWithFormat:@"OMPAUTH realm=\"%@\",authtype=%@,smskey=%@,codever=%@,appver=%@,sourceid=%@,hsmobile=%@,imei=%@,deviceid=%@,mobilebrand=%@,mobilemodel=%@,mobilesystem=%@,clienttype=%@,systemtime=%@,msgid=%@,networktype=%@,cnonce=%@,appid=%@,appsign=%@,code=%@",ompauth_realm,authtype,smskey,codever,appver,sourceid,hsmobile,deviceid,deviceid,mobilebrand,mobilemodel,mobilesystem,clienttype,systemtime,msgid,networktype,cnonce,appid,appsign,code];
    
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,@"Authorization", nil];
    
    NSArray *optionArr = [NSArray arrayWithObjects:heads, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IDMPDataSms sharedInstance] sendSMS:Rand recipientList:receiveList option:optionArr SuccessBlock:^(NSDictionary *paraments) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:paraments];
            [tempDic setObject:cnonce forKey:@"cnonce"];
            successBlock(tempDic);
        } failBlock:failBlock];
    });
    
    NSLog(@"%@",heads);
}



@end
