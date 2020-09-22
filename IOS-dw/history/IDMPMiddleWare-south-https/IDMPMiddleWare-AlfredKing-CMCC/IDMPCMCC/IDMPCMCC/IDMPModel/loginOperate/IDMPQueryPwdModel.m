//
//  IDMPQueryPwdModel.m
//  IDMPCMCC
//
//  Created by HGQ on 16/2/1.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import "IDMPQueryPwdModel.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPParseParament.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"

@implementation IDMPQueryPwdModel

+ (NSString *)queryAppPasswdWithUserName:(NSString *)userName
{
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", requestAppPsd,@"100000",sipEncFlag,yesFlag,ksUserName,userName,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:qapUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request1.allHTTPHeaderFields = heads;
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"PASSWORD QUERY error:%@",[error localizedDescription]);
    NSDictionary *response=urlResponse.allHeaderFields;
    NSLog(@"PASSWORD QUERY %@",response);
    NSString *query = [response objectForKey:@"Query-Result"];
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
    NSString *apppassword= [parament objectForKey:@"appPassword"];
    NSString *decPassWd=nil;
    if(![IDMPFormatTransform checkNSStringisNULL:apppassword])
    {
        decPassWd=RSA_decrypt(apppassword);
        NSLog(@"decpasswd is %@",decPassWd);
        
    }

    return decPassWd;
}


@end
