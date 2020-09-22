//
//  IDMPWapMode.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-21.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPWapMode.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"
#import "IDMPHttpRequest.h"
#import "IDMPMD5.h"
#import "IDMPTool.h"
#import "IDMPKsModel.h"

@implementation IDMPWapMode

+ (void)getWapMobileNumberWithAppid:(NSString *)appid appkey:(NSString *)appkey userName:(NSString *)username successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    NSString *ompauth_realm = @"OMP";
    NSString *authtype = @"1";
    NSString *appver = @"1.0";
    NSString *sourceid = [[NSUserDefaults standardUserDefaults] objectForKey:source];;
    NSString *hsmobile = username.length > 0 ? [IDMPMD5 getMd5_32Bit_String:username] : nil;
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
    
    
    NSString *authorization= [NSString stringWithFormat:@"OMPAUTH realm=\"%@\",authtype=%@,appver=%@,sourceid=%@,hsmobile=%@,deviceid=%@,mobilebrand=%@,mobilemodel=%@,mobilesystem=%@,clienttype=%@,systemtime=%@,msgid=%@,networktype=%@,cnonce=%@,appid=%@,appsign=%@,code=%@",ompauth_realm,authtype,appver,sourceid,hsmobile,deviceid,mobilebrand,mobilemodel,mobilesystem,clienttype,systemtime,msgid,networktype,cnonce,appid,appsign,code];
    
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization, nil];
    
    __block IDMPHttpRequest  *request=[[IDMPHttpRequest alloc]init];
    
    [request getWapHttpByHeads:heads url:httpAuthLoginUrl
               successBlock:
     ^{
         NSLog(@"%@",request.responseStr);
         
         if (successBlock && request.responseStr)
         {
             NSMutableDictionary *responseDic = [NSMutableDictionary dictionaryWithDictionary:request.responseStr];
             [responseDic setObject:cnonce forKey:@"cnonce"];
             successBlock(responseDic);
         }
     }
                  failBlock:
     ^{
         NSDictionary *result = request.responseStr;
         NSLog(@"%@",result);
         if ([result objectForKey:@"resultcode"])
         {
             NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"resultcode"],@"resultCode", nil];
             failBlock(resultDic);
         }
         else
         {
             NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
             
             failBlock(resultDic);
         }
     }];
}


@end
