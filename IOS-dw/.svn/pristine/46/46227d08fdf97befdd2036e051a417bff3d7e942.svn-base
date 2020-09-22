//
//  IDMPRusultHandler.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/28.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPRusultHandler.h"
#import "IDMPConst.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPToken.h"

@implementation IDMPRusultHandler

+ (void)getRusultByHandlerWWWAuthenticate:(NSDictionary *)wwwauthenticate userName:(NSString *)userName authType:(NSInteger)authType sipinfo:(NSString *)sipinfo traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!wwwauthenticate){
        NSLog(@"mac不一致");
        failBlock(@{@"resultCode":@"103117"});
        return;
    }
    
    NSString *sourceid = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
    if(!sourceid && failBlock) {
         failBlock(@{@"resultCode":@"102298"});
        return;
    }
    
    NSString *decUserName=nil;
    switch (authType) {
        case IDMPWP:
            userName = [wwwauthenticate objectForKey:ksUserName];
            NSLog(@"username is %@",userName);
            if(![IDMPFormatTransform checkNSStringisNULL:userName]) {
                decUserName=secRSA_Decrypt(userName);
                NSLog(@"decUserName is %@",decUserName);
            }
            break;
        case IDMPHS:
            decUserName = [wwwauthenticate objectForKey:ksUserName];
            NSLog(@"username is %@",userName);
            break;
        case IDMPUP:
        case IDMPDUP:
        case IDMPVUP:
            decUserName = userName;
            break;
    }

    
    NSString *token=[IDMPToken getTokenWithUserName:decUserName andSourceId:sourceid andTraceId:traceId];
    if (token == nil ) {
        NSDictionary *result = @{@"resultCode":@"102317"};
        failBlock(result);
        return;
    }

    
    NSString *passid=[wwwauthenticate objectForKey:@"passid"];
    

    NSDictionary *result=nil;


    NSLog(@"token is %@",token);
    if ([sipinfo isEqualToString:isSip]) {
        NSString *passWd=[wwwauthenticate objectForKey:@"spassword"];
        NSLog(@"passWd is %@",passWd);
        NSString *decPassWd=nil;
        if(![IDMPFormatTransform checkNSStringisNULL:passWd]) {
            decPassWd=secRSA_Decrypt(passWd);
            NSLog(@"decpasswd is %@",decPassWd);
        }
        if (!decPassWd) {
            NSLog(@"没有密码");
            result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
            if (failBlock) {
                failBlock(result);
            }
            return ;
        }
        NSLog(@"有密码");
        NSString *openid = [wwwauthenticate objectForKey:@"openid"];
        if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//            NSLog(@"openid is nil from server");
//            NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:decUserName];
//            openid = [user objectForKey:@"openid"];
//            if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                NSLog(@"openid is nil from cache");
                openid = passid;
//            }
        }
        result=[NSDictionary dictionaryWithObjectsAndKeys:decUserName,ksUserName,decPassWd,sipPassword,passid,@"passid",@"102000",@"resultCode",token,@"token", openid, @"openid", nil];
        
    } else {
        result=[NSDictionary dictionaryWithObjectsAndKeys:token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
        
    }
    successBlock(result);
}
@end
