//
//  IDMPMobileDecode.m
//  IDMPCMCC
//
//  Created by HGQ on 16/4/18.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "IDMPTool.h"
#import "IDMPHttpRequest.h"
#import "IDMPDevice.h"
#import "IDMPNonce.h"
#import "IDMPConst.h"
#import "IDMPMD5.h"

@interface IDMPTool ()<NSXMLParserDelegate>
{
    NSString *tempElementName;
    NSMutableDictionary *tempDic;
    UMCSDKCallBack callBackBlock;
}

@end

@implementation IDMPTool

#pragma mark =====手机号码解密
+ (void)mobileDecodeWithCnonce:(NSString *)cnonce nonce:(NSString *)nonce callBack:(UMCSDKCallBack)callBack{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *systemTime = [dateFormat stringFromDate:[NSDate date]];
    NSString *deviceid = [IDMPDevice getDeviceID];
    
    NSString *msgid = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",systemTime,deviceid]];
    NSString *appVersion = [IDMPDevice getAppVersion];
    NSString *sourceID = [[NSUserDefaults standardUserDefaults] objectForKey:source];
    NSString *appType = @"5";
    NSLog(@"------cnonce:%@\n------nonce:%@",cnonce,nonce);
    NSString *hCode = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",cnonce,nonce]];
    
    NSString *para = [NSString stringWithFormat:@"<MobileDecodeRequest><msgid>%@</msgid><systemTime>%@</systemTime><appVersion>%@</appVersion><sourceID>%@</sourceID><appType>%@</appType><hCode>%@</hCode><userIP>%@</userIP><responseTime>%@</responseTime></MobileDecodeRequest>",msgid,systemTime,appVersion,sourceID,appType,hCode,@"127.0.0.1",systemTime];
    
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request xmlHttpRequestWithXml:para url:mobileDecodeUrl successBlock:callBack failBlock:callBack];
}


#pragma mark =====验证token
+ (void)tokenValidateWithAppid:(NSString *)appid token:(NSString *)token callBack:(UMCSDKCallBack)callBack{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *systemTime = [dateFormat stringFromDate:[NSDate date]];
    NSString *deviceid = [IDMPDevice getDeviceID];
    
    NSString *msgid = [IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",systemTime,deviceid]];
    NSString *appVersion = [IDMPDevice getAppVersion];
    NSString *sourceID = [[NSUserDefaults standardUserDefaults] objectForKey:source];
    NSString *appType = @"5";
    
    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:appVersion,@"version",msgid,@"msgid",systemTime,@"systemtime",sourceID,@"sourceid",appid,@"appid",appType,@"apptype", nil];
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:header,@"header",body,@"body", nil];
    
    IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getHttpWithDict:parameter url:tokenValidateUrl successBlock:^{
        NSLog(@"token success response:%@",request.responseStr);
        
        NSDictionary *headerDic = [request.responseStr objectForKey:@"header"];
        NSDictionary *bodyDic = [request.responseStr objectForKey:@"body"];
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
        
        [resultDic addEntriesFromDictionary:bodyDic];
        
        callBack(resultDic);
        
    } failBlock:^{
        NSLog(@"token fail response:%@",request.responseStr);
        NSDictionary *headerDic = [request.responseStr objectForKey:@"header"];
        callBack(headerDic);
    }];
}



+ (void)queryAndDeleteKs
{
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    
    NSLog(@"userlist: %@",users);
    if (users.count) {
        
        for (int i=0; i<users.count; i++) {
            
            NSDictionary *dic = users[i];
            
            NSLog(@"users[i]: %@",dic);
            
            NSString *name = [dic objectForKey:@"userName"];
            
            NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:name]];
            
            NSString *version = [IDMPDevice getAppVersion];
            NSString *btid = [user objectForKey:ksBTID];
            NSString *ks = [user objectForKey:@"KS"];
            NSString *rand = [IDMPNonce getClientNonce];
            
            NSString *ks_rand = [NSString stringWithFormat:@"%@,%@",ks,rand];
            NSString *encKS = [IDMPMD5 getMd5_32Bit_String:ks_rand];
            
            NSString *authorization = [NSString stringWithFormat:@"QK_SDK clientversion=\"%@\",rand=\"%@\",btid=\"%@\",encKS=\"%@\"",version,rand,btid,encKS];
            NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization, nil];
            
            IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
            NSLog(@"heads:%@",heads);
            [request getWithHeads:heads url:queryKSUrl successBlock:^{
                NSDictionary *response=request.responseHeaders;
                NSLog(@"success结果 %@",response);
                
                
                
            } failBlock:^{
                NSDictionary *response=request.responseHeaders;
                NSLog(@"fail结果 %@",response);
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:name];
                [users removeObject:dic];
                [[NSUserDefaults standardUserDefaults] setObject:users forKey:userList];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:nowLoginUser];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"清除缓存成功");
}



@end
