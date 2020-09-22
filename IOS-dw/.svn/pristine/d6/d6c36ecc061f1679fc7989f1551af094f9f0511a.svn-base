//
//  IDMPRusultHandler.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/28.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPRusultHandler.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPToken.h"
#import "NSString+IDMPAdd.h"
#import "IDMPUtility.h"

@implementation IDMPRusultHandler

+ (void)getRusultByHandlerWWWAuthenticate:(NSDictionary *)wwwauthenticate userName:(NSString *)userName authType:(NSInteger)authType sipinfo:(NSString *)sipinfo traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!wwwauthenticate){
        NSLog(@"mac不一致");
        failBlock(@{IDMPResCode:@"103117",IDMPResStr:@"mac不一致"});
        return;
    }
    
    NSString *sourceid = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
    if(!sourceid && failBlock) {
         failBlock(@{IDMPResCode:@"102298",IDMPResStr:@"应用合法性校验失败"});
        return;
    }
    
    NSString *decUserName=nil;
    switch (authType) {
        case IDMPWP:
            userName = [wwwauthenticate objectForKey:ksUserName];
            NSLog(@"username is %@",userName);
            if(![IDMPUtility checkNSStringisNULL:userName]) {
                decUserName = [IDMPUtility rsaOrSM4DecryptWithEncData:userName];
                if (!decUserName) {
                    //电信协商不做国密改造
                    decUserName = [userName idmp_RSADecrypt];
                }
                NSLog(@"decUserName is %@",decUserName);
            }
            break;
        case IDMPHS:
            decUserName = [wwwauthenticate objectForKey:ksUserName];
            NSLog(@"username is %@",userName);
            break;
        case IDMPUP:
        case IDMPDUP:
            decUserName = userName;
            break;
    }

    
    NSString *token=[IDMPToken getTokenWithUserName:decUserName andSourceId:sourceid isTmpCache:isTmpCache];
    if (token == nil ) {
        NSDictionary *result = @{IDMPResCode:@"102317",IDMPResStr:@"token生成失败"};
        if (failBlock) {
            failBlock(result);
        }
        return;
    }

    
    NSString *passid=[wwwauthenticate objectForKey:IDMPPassID];
    NSDictionary *result=nil;
    NSString *isSipFromServer = (NSString *)[userInfoStorage getInfoWithKey:isSipApp];
    if ([sipinfo isEqualToString:isSip] && [isSipFromServer isEqualToString:isSip]) {
        NSString *passWd=[wwwauthenticate objectForKey:@"spassword"];
        NSLog(@"passWd is %@",passWd);
        NSString *decPassWd=nil;
        if(![IDMPUtility checkNSStringisNULL:passWd]) {
            decPassWd = [IDMPUtility rsaOrSM4DecryptWithEncData:passWd];
            if (!decPassWd) {
                decPassWd = [passWd idmp_RSADecrypt];
            }
            NSLog(@"decpasswd is %@",decPassWd);
        }
        if (!decPassWd) {
            NSLog(@"没有密码");
            result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",IDMPResCode,@"sip应用密码为空",IDMPResStr, nil];
            if (failBlock) {
                failBlock(result);
            }
            return ;
        }
        NSLog(@"有密码");
        NSString *openid = [wwwauthenticate objectForKey:IDMPOPENID];
        if ([IDMPUtility checkNSStringisNULL:openid]) {
//            NSLog(@"openid is nil from server");
//            NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:decUserName];
//            openid = [user objectForKey:@"openid"];
//            if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                NSLog(@"openid is nil from cache");
                openid = passid;
//            }
        }
        result=[NSDictionary dictionaryWithObjectsAndKeys:decUserName,ksUserName,decPassWd,sipPassword,passid,IDMPPassID,@"102000",IDMPResCode,token,@"token", openid, IDMPOPENID,@"success",IDMPResStr, nil];
        
    } else {
        NSString *userName = nil;
        if (authType == IDMPHS || authType == IDMPWP) {
            if ([[wwwauthenticate objectForKey:ksUserName] isEqualToString:[wwwauthenticate objectForKey:IDMPMsisdn]]) {
                userName = [decUserName idmp_hideMiddleFourFromEnd];
            }
        }
        result=[NSDictionary dictionaryWithObjectsAndKeys:token,@"token",@"102000",IDMPResCode,passid,IDMPPassID,@"success",IDMPResStr,userName,IDMPMsisdn, nil];
        
    }
    successBlock(result);
}




@end
