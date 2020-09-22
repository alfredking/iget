//
//  IDMPKsModel.m
//  IDMPCMCC
//
//  Created by HGQ on 16/3/30.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "IDMPKsModel.h"
#import "IDMPConst.h"
#import "IDMPNonce.h"
#import "IDMPHttpRequest.h"
#import "IDMPToken.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPMD5.h"
#import "IDMPFormatTransform.h"
#import "IDMPOpensslDigest.h"

@implementation IDMPKsModel

+ (void)renewKsWithAppid:(NSString *)appid appkey:(NSString *)appkey certID:(NSString *)certID mobile:(NSString *)mobile callBack:(UMCSDKCallBack)callBack
{
    //authorization:CK_SDK cnonce="xxx",cert="xxxx",appid ="xxxx", appkey=”xx”
    
    NSString *clientNonce = [IDMPNonce getClientNonce];
    NSString *sip=[[NSUserDefaults standardUserDefaults] objectForKey:getType];
    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", ks_CK_SDK_cnonce,clientNonce,ks_cert,certID,ks_appid,appid,ks_appkey,appkey];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization, nil];
    NSLog(@"---heads:%@",heads);
    
    __block IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getHttpByHeads:heads url:createKSUrl successBlock:^{
        NSDictionary *responseHeaders=request.responseHeaders;
        NSLog(@"createKSUrl成功:%@",responseHeaders);
        /*
         {
         Connection = close;
         "Content-Length" = 0;
         Date = "Wed, 30 Mar 2016 01:38:38 GMT";
         Server = nginx;
         "Www-Authenticate" = "CK_SDK Nonce=\"9IqwFteNWsmDxNSluOEmmaQwLtnbisSE\",BTID=\"ODY2QUJBQUQyM0UxRTEyRDhF@http://192.168.16.207/\",uid=\"izTrPBw6Cm\",authType=\"1\",passid=\"23902438562922497\",msisdn=\"18867103515\",sqn=\"78928927\",expiretime=\"1461893918641\"";
         mac = 2c2e4488122b596bb73f0db21ddfe0045d388488087fc238008b44fef80bfe09;
         resultCode = 103000;
         }
         */
        NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
        NSLog(@"wwwauthenticate:%@",wwwauthenticate);
        NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
        NSLog(@"parament:%@",parament);
        NSString *cnonce = [parament objectForKey:@"cnonce"];
        NSDictionary *result=nil;
        if ([self checkKSIsValid:responseHeaders clientNonce:cnonce])
        {
            
            NSString *msisdn = [parament objectForKey:@"msisdn"];
            if (![msisdn isEqualToString:mobile]) {
                NSLog(@"手机号与cert不匹配");
                result = [NSDictionary dictionaryWithObjectsAndKeys:@"102314",@"resultCode", nil];
                if (callBack) {
                    callBack(result);
                    return;
                }
            }
            
            NSString *userName = [parament objectForKey:TMIsdn];
            NSString *passid=[parament objectForKey:@"passid"];
            NSString *authType = [parament objectForKey:@"authType"];
            NSString *sourceid= [[NSUserDefaults standardUserDefaults] objectForKey:source];
            NSString *expiretime = [parament objectForKey:@"expiretime"];
            NSString *uid = [parament objectForKey:@"uid"];
            
            if(sourceid)
            {
                NSLog(@"sourceid 存在");
                NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
                if ([sip isEqualToString:@"1"])
                {
                    
                    result=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"mobileNumber",Token,@"token",authType,@"authType",@"102000",@"resultCode",passid,@"passid",expiretime,@"expiretime",uid, @"uid",nil];
                }
                else
                {
                    NSLog(@"sip not exsit")
                    result=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"mobileNumber",passid,@"passid",authType,@"authType",@"102000",@"resultCode",Token,@"token",expiretime,@"expiretime",uid, @"uid",nil];
                }
            }
            else
            {
                result = [NSDictionary dictionaryWithObjectsAndKeys:@"103118",@"resultCode", nil];
            }
        }
        else
        {
            NSLog(@"mac不一致");
            result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
        }
        if (callBack)
        {
            callBack(result);
        }
    } failBlock:^{
        NSDictionary *responseHeaders=request.responseHeaders;
        NSLog(@"createKSUrl失败:%@",responseHeaders);
        if (callBack)
        {
            NSString *resultCode = [responseHeaders objectForKey:@"resultCode"] ? [responseHeaders objectForKey:@"resultCode"]:@"102101";
            NSDictionary *result = @{@"resultCode":resultCode};
            callBack(result);
        }
    }];
}

+ (BOOL)checkKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce
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
    NSString *serverNonce= [parament objectForKey:@"CK_SDK Nonce"];
    NSString *userName = [parament objectForKey:TMIsdn];
    NSString *md5_username = [IDMPMD5 getMd5_32Bit_String:userName];
    
    NSString *tempString = [NSString stringWithFormat:@"%@%@%@",ksUP_GBA,serverNonce,clientNonce];
    NSLog(@"tempString:%@",tempString);
    NSString *hmac_sha256_String = [IDMPOpensslDigest hmac_sha256:tempString withKey:md5_username];
    NSString *ks = [hmac_sha256_String substringToIndex:32];
    NSLog(@"ks:%@",ks);
    //计算mac时用char类型，存时用十六进制字符串
    unsigned char* ksChar = [IDMPFormatTransform hexStringToNSData:hmac_sha256_String];
    
    NSString *nativeMac=[IDMPKDF getNativeMac:ksChar data:wwwauthenticate];
    NSLog(@"native mac %@",nativeMac);
    NSLog(@"server mac %@",serverMac);
    if([nativeMac isEqualToString:serverMac])
    {
        NSLog(@"~~~~~~~~%@",parament);
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        NSString *rand =[IDMPMD5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce]];
        NSString *authType = [parament objectForKey:@"authType"];
        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
        [user setObject:expireTimeString forKey:ksExpiretime];
        [user setObject:[IDMPFormatTransform charToNSHex:ksChar length:16] forKey:@"KS"];
        [user setObject:rand forKey:@"Rand"];
        NSString *passid=[parament objectForKey:@"passid"];
        [user setObject:passid forKey:@"passid"];
        NSString *uid = [parament objectForKey:@"uid"];
        NSLog(@"~~~~~~~  uid ==== %@",uid);
        [user setObject:uid forKey:@"uid"];
        NSString *sqn=[parament objectForKey:ksSQN];
        NSString *BTID=[parament objectForKey:ksBTID];
        [user setObject: sqn forKey:@"sqn"];
        [user setObject: BTID forKey:@"BTID"];
        [user setObject:serverMac forKey:@"mac"];
        [user setObject:authType forKey:@"authType"];
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
        if([accounts count]>0)
        {
            int count = 0;
            for (NSDictionary *model in accounts)
            {
                if ([[model objectForKey:@"userName"]isEqualToString:userName]) {
                    [accounts removeObject:model];
                    [accounts addObject:userInfo];
                    break;
                }
                count++;
            }
            if (count>=[accounts count])
            {
                [accounts addObject:userInfo];
            }
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
            
        }
        else
        {
            NSMutableArray *accounts=[[NSMutableArray alloc]init];
            [accounts addObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
            
        }
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:userName];
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSLog(@"KS存储成功!");
        return YES;
    }
    else
    {
        NSLog(@"KS验证不正确");
        return NO;
    }
}


+ (void)getToken:(NSString *)certID mobile:(NSString *)mobile callBack:(UMCSDKCallBack)callBack
{
    NSMutableDictionary *userDic=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mobile]];
    NSLog(@"user %@",userDic);
    
    if ([userDic count] == 0)
    {
        if (callBack)
        {
            NSDictionary *result = @{@"resultCode":@"102206"};
            callBack(result);
        }
        return;
    }
    
    NSString *ks = [userDic objectForKey:@"KS"];
    
    NSString *rand = [IDMPNonce getClientNonce];
    NSString *hmacStr = [IDMPOpensslDigest hmac_sha256:rand withKey:ks];
    //authorization:QK_SDK hmac="xxx",cert="xxxx",rand ="xxxx",appid ="xxxx", appkey=”xx”
    NSString *authorization= [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", KS_QK_SDK_hmac,hmacStr,ks_cert,certID,ksRAND,rand,ks_appid,appidString,ks_appkey,appkeyString];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization, nil];
    NSLog(@"---heads:%@",heads);
    
    __block IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
    [request getHttpByHeads:heads url:queryKSUrl successBlock:^{
        NSDictionary *responseHeaders=request.responseHeaders;
        NSLog(@"%@",responseHeaders);
        /*
         resultCode:103000
         expiretime:xxxxxxx
         */
        
        NSInteger resultCode = [[responseHeaders objectForKey:@"resultCode"] integerValue];
        if (resultCode == 103000)
        {
            if (callBack)
            {
                NSDictionary *result = @{@"resultCode":@"103000"};
                callBack(result);
            }
        }
    } failBlock:^{
        NSDictionary *responseHeaders=request.responseHeaders;
        NSLog(@"%@",responseHeaders);
        
        if (callBack)
        {
            NSString *resultCode = [responseHeaders objectForKey:@"resultCode"] ? [responseHeaders objectForKey:@"resultCode"]:@"102101";
            NSDictionary *result = @{@"resultCode":resultCode};
            callBack(result);
        }
    }];
}

@end
