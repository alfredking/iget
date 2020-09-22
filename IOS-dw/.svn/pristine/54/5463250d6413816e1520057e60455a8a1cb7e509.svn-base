//
//  IDMPTempSmsMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTempSmsMode.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPHttpRequest.h"
#import "IDMPKsModel.h"
#import "IDMPMD5.h"

@interface IDMPTempSmsMode ()
{
    NSString *mobilenumber;
    NSString *tempElementName;
    NSMutableDictionary *tempDic;
    accessBlock callBackSuccessBlock;
    accessBlock callBackFailBlock;
}
@end

@implementation IDMPTempSmsMode

+ (void)getSmsCodeWithUserName:(NSString*)userName busiType:(NSString *)busiType successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    /*
     <SendSMSCodeRequest>
     <MSGID></MSGID>
     <SystemTime></SystemTime>
     <Vesion></Vesion>
     <SourceID></SourceID>
     <AppId></AppId>
     <FuncType></FuncType>
     <MobileNumber></MobileNumber>
     <UserIP></UserIP>
     <Rand></Rand>
     </SendSMSCodeRequest>
     */
    NSString *deviceid = [IDMPDevice getDeviceID];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *systemtime = [dateFormat stringFromDate:[NSDate date]];
    NSString *msgid = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",systemtime,deviceid]];
    NSString *version = [IDMPDevice getAppVersion];
    
    NSString *sourceIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:source];
    
    NSString *para = [NSString stringWithFormat:@"<SendSMSCodeRequest><msgid>%@</msgid><systemTime>%@</systemTime><appVersion>%@</appVersion><sourceID>%@</sourceID><appType>5</appType><funcType>1</funcType><mobileNumber>%@</mobileNumber><userIP>127.0.0.1</userIP></SendSMSCodeRequest>",msgid,systemtime,version,sourceIDStr,userName];
    
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request xmlHttpRequestWithXml:para url:getSmsCodeUrl successBlock:successBlock failBlock:failBlock];
}





//提交验证码
+ (void)getTMKSWithUserName:(NSString *)userName messageCode:(NSString *)messageCode successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock

{
    NSString *deviceid = [IDMPDevice getDeviceID];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *systemtime = [dateFormat stringFromDate:[NSDate date]];
    NSString *msgid = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",systemtime,deviceid]];
    NSString *version = [IDMPDevice getAppVersion];
    NSString *sourceIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:source];
    NSString *appType = @"5";
    
    NSString *para = [NSString stringWithFormat:@"<CheckSMSCodeRequest><msgid>%@</msgid><systemTime>%@</systemTime><appVersion>%@</appVersion><sourceID>%@</sourceID><appType>%@</appType><funcType>1</funcType><mobileNumber>%@</mobileNumber><smscode>%@</smscode><userIP>127.0.0.1</userIP></CheckSMSCodeRequest>",msgid,systemtime,version,sourceIDStr,appType,userName,messageCode];
    
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request xmlHttpRequestWithXml:para url:checkSmsUrl successBlock:^(NSDictionary *paraments) {
        if (paraments)
        {
            [paraments setValue:userName forKey:@"mobileNumber"];
            if (successBlock)
            {
                successBlock(paraments);
            }
        }
    } failBlock:failBlock];
}


@end
