//
//  IDMPAutoLoginViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-15.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAutoLoginViewController.h"
#import "IDMPConst.h"
#import "IDMPToken.h"
#import "IDMPWapMode.h"
#import "IDMPDataSMSMode.h"
#import "IDMPDevice.h"
#import "IDMPHttpRequest.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPParseParament.h"
#import "IDMPUPMode.h"
#import "IDMPTempSmsMode.h"
#import "IDMPAccountManagerMode.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPDevice.h"
#import "IDMPQueryModel.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPNonce.h"
#import "secFileStorage.h"
#include <pthread.h>
#import "IDMPLogReportMode.h"
//#import "IDMPDateFormatter.h"
#import "IDMPPopTool.h"
#import "IDMPReAuthViewController.h"
#import "IDMPAuthModel.h"
#import "IDMPDate.h"
#import "IDMPCheckKS.h"

NSMutableDictionary *CollectDeviceDataDictionary = nil;

@implementation IDMPAutoLoginViewController

static dispatch_queue_t tokenQueue ;
static pthread_mutex_t queueLock = PTHREAD_MUTEX_INITIALIZER;

typedef NS_ENUM(NSUInteger, IDMPAccountOption) {
    IDMPRegister,
    IDMPChangePwd,
    IDMPResetPwd,
};


#pragma makr - life cycle
- (id)init {
    static dispatch_once_t autoLoginOnceToken;
    self = [super init];
    if (self) {
        dispatch_once(&autoLoginOnceToken, ^{
            tokenQueue= dispatch_queue_create("token", NULL);
        });
    }
    return self;
}

#pragma mark - validateAppid

- (void)validateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock {
    int authType = [self getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:appid, @"appid",appkey,@"appkey", [NSString stringWithFormat:@"%f",aTime], @"aTime", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"init" requestParm:requestParam authType:authType traceId:traceId];
    [self requestValidateWithAppid:appid appkey:appkey timeoutInterval:aTime traceId:(NSString *)traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlcok(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

- (void)requestValidateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime traceId:(NSString *)traceId finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock {
    NSLog(@"init with appid start");
    if (appid.length == 0 || appkey.length == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock) {
            failBlock(dic);
        }
        return;
    }
    
    NSLog(@"appid :%@,appkey :%@",appid,appkey);
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        NSString *lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastVersion"];
        NSLog(@"lastVersion is %@",lastVersion);
        
        //全新安装需要清除keychain数据
        if (!lastVersion) {
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath = [rootPath stringByAppendingPathComponent:@"userInfo"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
                NSLog(@"userinfo 存在");
            } else {
                NSLog(@"userinfo 不存在");
                NSString *currentVersion=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"lastVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self cleanKeychainSSO];
            }
        }
        
        // 如果有旧版本的缓存，先将缓存加密存储再使用
        [IDMPParseParament changeDataStorage];
        
       NSString *cacheAppid = (NSString *)[userInfoStorage getInfoWithKey:IDMP_APPIDsk];
        if (![cacheAppid isEqualToString:appid]) {
            NSLog(@"has no cache appid and save new setting");
            [userInfoStorage setInfo:appid withKey:IDMP_APPIDsk];
            [userInfoStorage setInfo:appkey withKey:IDMP_APPKEYsk];
            [userInfoStorage setInfo:@(aTime) withKey:secDataSmsHttpTimesk];
            [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
            [userInfoStorage setInfo:yesFlag withKey:currentIsNorth];
            [userInfoStorage setInfo:noFlag withKey:isChecked];
            
        }

        [IDMPQueryModel getConfigsWithCompletionBlock:^(NSDictionary *paraments) {
            [IDMPQueryModel checkWithAppId:appid andAppkey:appkey traceId:traceId finishBlock:successBlcok failBlock:failBlock];
//            if(![IDMPQueryModel appidIsChecked]) {
//                [userInfoStorage setInfo:appid withKey:IDMP_APPIDsk];
//                [userInfoStorage setInfo:appkey withKey:IDMP_APPKEYsk];
//                [userInfoStorage setInfo:@(aTime) withKey:secDataSmsHttpTimesk];
//                [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
//                [userInfoStorage setInfo:yesFlag withKey:currentIsNorth];
//
//                [IDMPQueryModel checkWithAppId:appid andAppkey:appkey traceId:traceId finishBlock:successBlcok failBlock:failBlock];
//            } else {
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"103000",@"resultCode", nil];
//                if (successBlcok) {
//                    successBlcok(dic);
//                }
//            }
        }];
    });
}

- (BOOL)cleanKeychainSSO {
    pthread_mutex_lock(&queueLock);
    NSMutableArray *userKs=[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getAppInfoWithKey:userList]];
    NSMutableArray *users=[[NSMutableArray alloc]init];
    NSLog(@"userlist: %@",users);
    [userInfoStorage setAppInfo:users withKey:userList];
    [userInfoStorage setAppInfo:noFlag withKey:isChecked];
    NSLog(@"清除缓存成功");
    
    NSLog(@"userlist: %@",userKs);
    if (userKs.count) {
        for (int i=0; i<userKs.count; i++) {
            if ([userKs[i]isKindOfClass:[NSDictionary class]]) {
                NSString *name = [userKs[i] objectForKey:@"userName"];
                [userInfoStorage removeAppInfoWithKey:name];
            }
        }
    }
    [userInfoStorage removeAppInfoWithKey:IDMPLastGetConfigDate];
    [userInfoStorage removeAppInfoWithKey:IDMPCONFIGS];
    [userInfoStorage removeAppInfoWithKey:IDMP_APPIDsk];
    [userInfoStorage removeAppInfoWithKey:IDMP_APPKEYsk];
    [userInfoStorage removeAppInfoWithKey:secDataSmsHttpTimesk];
    [userInfoStorage removeAppInfoWithKey:currentIsDomain];
    [userInfoStorage removeAppInfoWithKey:currentIsNorth];

    pthread_mutex_unlock(&queueLock);
    return YES;
}

#pragma mark - getAccessTokenByConditon & getAppPasswordByConditon

-(void)getAppPasswordByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    int authType = [self getAuthType];
    if (authType < 0) {
        failBlock(@{@"resultCode":@"102101"});
        return;
    }
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName",content,@"content", [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAppPasswordByConditon" requestParm:requestParam authType:authType traceId:traceId];
    [self requestAccessTokenByConditionWithUserName:userName Content:content andLoginType:loginType isSipApp:isSip traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

-(void)getAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    int authType = [self getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName",content,@"content", [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAccessTokenByConditon" requestParm:requestParam authType:authType traceId:traceId];
    [self requestAccessTokenByConditionWithUserName:userName Content:content andLoginType:loginType isSipApp:noSip traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

-(void)requestAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType isSipApp:(NSString *)isSipApp traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (userName.length == 0) {
        if (failBlock) {
            NSDictionary *result = @{@"resultCode":@"102303"};
            failBlock(result);
        }
        return;
    }
    
    if (content.length == 0) {
        if (failBlock) {
            NSDictionary *result = @{@"resultCode":@"102304"};
            failBlock(result);
        }
        return;
    }
    if (loginType > 2) {
        if (failBlock) {
            NSDictionary *result = @{@"resultCode":@"102205"};
            failBlock(result);
        }
        return;
    }
    
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        pthread_mutex_lock(&queueLock);
        @autoreleasepool {
//            if ([self getAuthType] < 0) {
//                if (failBlock) {
//                    NSDictionary *result = @{@"resultCode":@"102101"};
//                    failBlock(result);
//                }
//                pthread_mutex_unlock(&queueLock);
//                return;
//            }
            
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
                @autoreleasepool {
                    [self noCacheLoginByConditionWithUserName:userName andPassWd:content sipInfo:isSipApp LoginType:loginType traceId:traceId successBlock:^(NSDictionary *paraments) {
                        if (successBlock) {
                            successBlock(paraments);
                        }
                        pthread_mutex_unlock(&queueLock);
                    } failBlock:^(NSDictionary *paraments) {
                        if (failBlock) {
                            failBlock(paraments);
                        }
                        pthread_mutex_unlock(&queueLock);
                    }];
                }
            } failBlock:^(NSDictionary *paraments) {
                if (failBlock) {
                    failBlock(paraments);
                }
                pthread_mutex_unlock(&queueLock);
            }];
        }
    });
}

- (void)noCacheLoginByConditionWithUserName:(NSString *)userName andPassWd:(NSString *)content sipInfo:(NSString *)sipinfo LoginType:(NSInteger)loginType traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"不使用缓存");
    switch (loginType) {
        case 1:
        {
            IDMPUPMode *upMode=[[IDMPUPMode alloc]init];
            [upMode getUPKSWithSipInfo:sipinfo UserName:userName andPassWd:content traceId:traceId successBlock:successBlock failBlock:failBlock];
        }
            
            break;
        case 2:
        {
            IDMPTempSmsMode *tsMode=[[IDMPTempSmsMode alloc]init];
            [tsMode getTMKSWithSipInfo:sipinfo UserName:userName messageCode:content traceId:traceId successBlock:successBlock failBlock:failBlock];
        }
            break;
        default:
            break;
    }
}

-(void)updateKSEverdayWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo traceId:(NSString *)traceId finishBlock:(IDMPBlock) successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"update ks start ");
    NSDate *ksupdatedate = (NSDate *)[userInfoStorage getInfoWithKey:ksUpdateDate];
    NSLog(@"ksupdate time is %@",ksupdatedate);
//    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    BOOL isSameDay = [IDMPDate isSameDay:ksupdatedate date2:[NSDate date]];
    if (!ksupdatedate || !isSameDay) {
//        if ((int)([[NSDate date] timeIntervalSince1970] + timezoneFix) -
//            (int)([ksupdatedate timeIntervalSince1970] + timezoneFix)
//            < 86400) {
        NSLog(@"ksupdate exceeded for one day or date not exist");
        
//            NSLog(@"fetch new ks");
//            NSString *version = [IDMPDevice getAppVersion];
        
        NSString *clientNonce = [IDMPNonce getClientNonce];
        
//            NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
//
//            NSDateFormatter *dateFormat = [IDMPDateFormatter cachedDateFormatter];
//            NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
        
//        NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
//        NSString *BTID;
//        if([user objectForKey:ksBTID]&&[user objectForKey:@"KS"]&&[user objectForKey:ksSQN]) {
//            BTID = [user objectForKey:ksBTID];
//        } else {
//            NSLog(@"缓存不存在");
//            NSDictionary *result = @{@"resultCode":@"102314"};
//            failBlock(result);
//            return;
//        }
//            NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", updateKSClientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,sipFlag,sipinfo,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],systemTime,currentDateStr,httpsFlag,yesFlag,IDMPTraceId,traceId];
//            NSString *Signature = secRSA_EVP_Sign(authorization);
//            NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature, nil];
        NSDictionary *heads = [[IDMPAuthModel alloc] initUPDKSWithUserName:userName sipInfo:sipinfo clientNonce:clientNonce traceId:traceId].heads;
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
        [request getAsynWithHeads:heads url:updateUrl timeOut:20 successBlock:^(NSDictionary *parameters){
             //NSDictionary *responseHeaders=request.responseHeaders;
             NSLog(@"updateKSEverdayWithUserName %@",parameters);
            NSDictionary *wwwauthenticate = [IDMPCheckKS checkUpdateKSIsValid:parameters clientNonce:clientNonce userName:userName];
            if (wwwauthenticate) {
                [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
                successBlock();
            } else {
                failBlock(@{@"resultCode":@"102298"});
            }

         } failBlock: ^(NSDictionary *parameters){
//                 NSDictionary *responseHeaders=request.responseHeaders;
//                 NSLog(@"updateks failBlock %@",responseHeaders);
//                 NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
             NSInteger resultCode = [[parameters objectForKey:ksResultCode] integerValue];
             if (resultCode==IDMPResultCodeRecentlyUpdated) {
                 successBlock();
                 [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
             }
             else if (resultCode==0) {
                 successBlock();
             }
             else {
                 [self cleanSSO];
                 NSDictionary *result = @{@"resultCode":parameters[@"resultCode"]};
                 failBlock(result);
             }
         }];
    } else {
        successBlock();
    }
}

- (NSString *)getLocalUserName {
    NSMutableArray *users=[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
    NSLog(@"userList is %@",users);
    for (NSDictionary *user in users) {
        if ([[user objectForKey:@"isLocalNum"] boolValue]) {
            return [user objectForKey:@"userName"];
        };
    }
    return nil;
}

#pragma mark - getAccessToken & getAppPassword
-(void)getAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    int authType = [self getAuthType];
    if (authType < 0) {
        failBlock(@{@"resultCode":@"102101"});
        return;
    }
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:((userName==nil) ? @"" : userName), @"userName", [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAccessToken" requestParm:requestParam authType:authType traceId:traceId];
    [self requestTokenWithUserName:userName andLoginType:loginType isSipApp:noSip traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}


-(void)getAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    int authType = [self getAuthType];
    if (authType < 0) {
        failBlock(@{@"resultCode":@"102101"});
        return;
    }
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:((userName==nil) ? @"" : userName), @"userName", [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAppPassword" requestParm:requestParam authType:authType traceId:traceId];
    [self requestTokenWithUserName:userName andLoginType:loginType isSipApp:isSip traceId:traceId  finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

-(void)requestTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isSipApp:(NSString *)isSipApp traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (loginType > 2) {
        if (failBlock) {
            NSDictionary *result = @{@"resultCode":@"102205"};
            failBlock(result);
        }
        return;
    }
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        pthread_mutex_lock(&queueLock);
        @autoreleasepool {
//            if ([self getAuthType] < 0) {
//                if (failBlock) {
//                    NSDictionary *result = @{@"resultCode":@"102101"};
//                    failBlock(result);
//                }
//                pthread_mutex_unlock(&queueLock);
//                return;
//            }
            
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
                @autoreleasepool {
                    [self checkCacheBeforeLoginUseWithUserName:userName sipInfo:isSipApp LoginType:loginType isUserDefaultUI:YES traceId:traceId finishBlock:^(NSDictionary *paraments) {
                        if (successBlock) {
                            successBlock(paraments);
                        }
                        pthread_mutex_unlock(&queueLock);
                    } failBlock:^(NSDictionary *paraments) {
                        if (failBlock) {
                            failBlock(paraments);
                        }
                        pthread_mutex_unlock(&queueLock);
                    }];
                }
            } failBlock:^(NSDictionary *paraments) {
                if (failBlock) {
                    failBlock(paraments);
                }
                pthread_mutex_unlock(&queueLock);
            }];
            
        }
    });
    
}

- (void)checkCacheBeforeLoginUseWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo LoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    if (userName) {
        NSMutableArray *users = [NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
        BOOL cacheEffective=NO;
        for (int i=0; i<users.count; i++) {
            if ([users[i]isKindOfClass:[NSDictionary class]]) {
                NSString *nameList = [users[i] objectForKey:@"userName"];
                if([nameList isEqualToString:userName]) {
                    cacheEffective=YES;
                }
            }
        }
        if (cacheEffective) {
            NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:userName];
            NSLog(@"cache test user %@",user);
            if([user objectForKey:ksBTID]&&[user objectForKey:@"KS"]&&[user objectForKey:ksSQN]) {
                [self cacheUseWithUserName:userName sipInfo: sipinfo traceId:traceId finishBlock:successBlock failBlock:failBlock];
            } else {
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
            }
        } else {
            NSDictionary *result = @{@"resultCode":@"102314"};
            failBlock(result);
        }
    } else {
        NSString *localUserName = [self getLocalUserName];
        if (localUserName == nil) {
            [self noCacheLoginWithUserName:localUserName sipInfo: sipinfo LoginType:loginType  isUserDefaultUI:isUserDefaultUI traceId:traceId successBlock:successBlock failBlock:failBlock];
        } else {
            NSDictionary *user= (NSDictionary *)[userInfoStorage getInfoWithKey:localUserName];
            
            if([user objectForKey:ksBTID]&&[user objectForKey:@"KS"]&&[user objectForKey:ksSQN]) {
                [self cacheUseWithUserName:localUserName sipInfo: sipinfo traceId:traceId finishBlock:successBlock failBlock:failBlock];
            } else {
                NSLog(@"user error is %@",user);
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
            }
        }
    }
    
}

- (void)cacheUseWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    NSMutableDictionary  *__block resultInfo = nil;
    NSLog(@"使用缓存");
    [self updateKSEverdayWithUserName:userName sipInfo:sipinfo traceId:traceId finishBlock:^ {
        NSLog(@"update success");
        NSString *sourceID = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
        if(!sourceID) {
            if (failBlock) {
                NSDictionary *result = @{@"resultCode":@"102298"};
                failBlock(result);
            }
            return;
        }
        NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
        NSLog(@"cacheUseWithUserName user is %@",user);
        NSString *passid=[user objectForKey:@"passid"];
        NSString *token;
        if([user objectForKey:ksBTID]&&[user objectForKey:@"KS"]&&[user objectForKey:ksSQN]) {
            token=[IDMPToken getTokenWithUserName:userName andSourceId:sourceID andTraceId:traceId];
            if (token == nil && failBlock) {
                NSDictionary *result = @{@"resultCode":@"102317"};
                failBlock(result);
                return;
            }
        } else {
            if (failBlock) {
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
            }
            return;
        }
        if ([sipinfo isEqualToString:isSip]) {
            [IDMPQueryModel queryAppPasswdWithUserName:userName finishBlock:^(NSDictionary *paraments){
                NSString *passwd=[paraments objectForKey:sipPassword];
                NSString *openid = [paraments objectForKey:@"openid"];
                resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",userName,ksUserName,passid,@"passid",@"102000",@"resultCode",passwd,sipPassword, openid, @"openid", nil];
                successBlock(resultInfo);
            } failBlock:^(NSDictionary *paraments) {
                NSString *passwd=[paraments objectForKey:sipPassword];
                NSString *resultcode=[paraments objectForKey:@"resultCode"];
                resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",userName,ksUserName,passid,@"passid",resultcode,@"resultCode",passwd,sipPassword, nil];
                failBlock(resultInfo);
            }];
        } else {
            resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",passid,@"passid" ,@"102000",@"resultCode", nil];
            successBlock(resultInfo);
        }
        
    } failBlock:^(NSDictionary *paraments) {
        failBlock(paraments);
    }];
}

- (void)noCacheLoginWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo LoginType:(NSInteger)loginType  isUserDefaultUI:(BOOL)isUserDefaultUI traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"不使用缓存");
    int currentAuthType = [self getAuthType];
    if ((loginType < 2 && (currentAuthType != 1 && currentAuthType != 0)) || (loginType == 2 && (currentAuthType > 2 || currentAuthType < 0))) {
        NSLog(@"支持类型:%d  传入类型:%d",currentAuthType,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }
    switch (loginType) {
        case 0:
        {
            IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
            [wapMode getWapKSWithSipInfo:sipinfo traceId:traceId successBlock:successBlock failBlock:failBlock];
            break;
        }
        case 1:
        {
            IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
            [wapMode getWapKSWithSipInfo:sipinfo traceId:traceId successBlock:successBlock failBlock:failBlock];
        }
            break;
        case 2:
        {
            IDMPDataSMSMode *dataSMS=[[IDMPDataSMSMode alloc]init];
            [dataSMS getDataSmsKSWithSipInfo:sipinfo traceId:traceId successBlock:successBlock failBlock:failBlock];
        }
            break;
        default:
            break;
    }
}


#pragma mark - accountManager

- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    int authType = [self getAuthType];
    if (authType < 0) {
        failBlock(@{@"resultCode":@"102101"});
        return;
    }
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo, @"phoneNo", password, @"password", validCode, @"validCode", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"registerUser" requestParm:requestParam authType:authType traceId:traceId];
    [self requestAccountWithPhoneNo:phoneNo passWord:password validCodeOrNewPwd:validCode option:IDMPRegister traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    int authType = [self getAuthType];
    if (authType < 0) {
        failBlock(@{@"resultCode":@"102101"});
        return;
    }
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo, @"phoneNo", password, @"password", newpassword, @"newpassword", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"changePassword" requestParm:requestParam authType:authType traceId:traceId];
    [self requestAccountWithPhoneNo:phoneNo passWord:password validCodeOrNewPwd:newpassword option:IDMPChangePwd traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    int authType = [self getAuthType];
    if (authType < 0) {
        failBlock(@{@"resultCode":@"102101"});
        return;
    }
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo, @"phoneNo", password, @"password", validCode, @"validCode", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"resetPassword" requestParm:requestParam authType:authType traceId:traceId];
    [self requestAccountWithPhoneNo:phoneNo passWord:password validCodeOrNewPwd:validCode option:IDMPResetPwd traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}

- (void)requestAccountWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password validCodeOrNewPwd:(NSString *)validCodeOrNewPwd option:(NSUInteger)option traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    if (phoneNo.length == 0 || password.length == 0 || validCodeOrNewPwd.length == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock) {
            failBlock(dic);
        }
        return;
    }
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
//        if ([self getAuthType] < 0) {
//            if (failBlock) {
//                NSDictionary *result = @{@"resultCode":@"102101"};
//                failBlock(result);
//            }
//            return;
//        }
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
            @autoreleasepool {
                [self manageAccount:accountManager phoneNo:phoneNo passWord:password validCodeOrNewPwd:validCodeOrNewPwd option:option traceId:traceId finishBlock:successBlock failBlock:failBlock];
            }
        } failBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
        }];

    });
}

- (void)manageAccount:(IDMPAccountManagerMode *)accountManager phoneNo:(NSString *)phoneNo passWord:(NSString *)password validCodeOrNewPwd:(NSString *)validCodeOrNewPwd option:(NSUInteger)option traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    switch (option) {
        case IDMPRegister:
        {
            [accountManager registerUserWithPhoneNo:phoneNo passWord:password andValidCode:validCodeOrNewPwd traceId:traceId finishBlock:successBlock failBlock:failBlock];
        }
            break;
        case IDMPChangePwd:
        {
            [accountManager changePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:validCodeOrNewPwd traceId:traceId finishBlock:successBlock failBlock:failBlock];
        }
            break;
        case IDMPResetPwd:
        {
            [accountManager resetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCodeOrNewPwd traceId:traceId finishBlock:successBlock failBlock:failBlock];
        }
            break;
        default:
            break;
    }
}


#pragma mark - checkLocalNum
-(void)checkIsLocalNumberWith:(NSString *)userName finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    int authType = [self getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"checkLocalNum" requestParm:requestParam authType:authType traceId:traceId];
    [self requestCheckIsLocalNumberWith:userName traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
    
}
-(void)requestCheckIsLocalNumberWith:(NSString *)userName traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    NSLog(@"check localnumber");
    
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        int currentAuthType = [self getAuthType];
        if (currentAuthType > 1 || currentAuthType < 0) {
            NSLog(@"check localnumber yes");
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,@"resultCode", nil];
            failBlock(result);
            return ;
        }
        __block IDMPHttpRequest *request=[[IDMPHttpRequest alloc]init];
        [request getWapAsynWithHeads:nil  url:localUrl timeOut:10 successBlock:^{
             NSDictionary *responseHeaders=request.responseHeaders;
             NSString *localNumber = [responseHeaders objectForKey:@"mobile"];
             if ([IDMPFormatTransform checkNSStringisNULL:localNumber]) {
                 NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,@"resultCode", nil];
                 failBlock(result);
             } else {
                 NSLog(@"localNumber :%@",localNumber);
                 NSString *newNumber=secRSA_Decrypt(localNumber);
                 newNumber=[newNumber substringWithRange:NSMakeRange(2,11)];
                 NSLog(@"newNumber :%@",newNumber);
                 if (![newNumber isEqual: userName]&&![IDMPFormatTransform checkNSStringisNULL:newNumber]) {
                     NSLog(@"is not same");
                     NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberNO,@"resultCode", nil];
                     successBlock(result);
                 } else {
                     NSLog(@"check localnumber yes");
                     NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,@"resultCode", nil];
                     failBlock(result);
                 }
             }
         } failBlock:^{
             NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,@"resultCode", nil];
             failBlock(result);
         }];
    });
    
}

#pragma mark - reAuth
- (void)reAuthenticationWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    int authType = [self getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"reAuth" requestParm:requestParam authType:authType traceId:traceId];
    [self requestReAuthenticationWithUserName:userName successBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        successBlock(paraments);
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
        failBlock(paraments);
    }];
}
- (void)requestReAuthenticationWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    if ([IDMPFormatTransform checkNSStringisNULL:userName]) {
        return failBlock(@{@"resultCode":@"102303"});
    }
    [self getAccessTokenWithUserName:userName andLoginType:0 isUserDefaultUI:NO finishBlock:^(NSDictionary *results) {
        __block IDMPReAuthViewController *reAuthVC = [[IDMPReAuthViewController alloc] initWithUserName:userName];
        [reAuthVC requestReAuthStatusWithUsername:userName successBlock:^(NSDictionary *paraments) {
            NSInteger queryResult = [paraments[@"Query-Result"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (queryResult) {
                    case 0:
                        reAuthVC.authType = IDMPReAuthSetCode;
                        break;
                    case 1:
                        reAuthVC.authType = IDMPReAuthValidateCode;
                        break;
                    default:
                        break;
                }
                reAuthVC.forgetPwdDesc = paraments[@"desc"];
            });
            
            [[IDMPPopTool sharedInstance] showWithPresentViewController:reAuthVC completion:^(NSDictionary *parameters) {
                if ([parameters[@"resultCode"] isEqualToString:@"103000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successBlock(results);
                    });
                }
            }  animated:YES];
        } failBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
        }];
    } failBlock:failBlock];
}

#pragma mark - getAuthType
- (int)getAuthType {
    NSString *currntNet = [IDMPDevice GetCurrntNet];
    BOOL isChinaMobile = [IDMPDevice checkChinaMobile];
    BOOL isCellularOpened = [IDMPDevice checkCellular];
    //    BOOL cellularAuthority = [IDMPDevice hasCellularAuthority];
    
    if ([currntNet isEqual:@"4g"] && isChinaMobile ) {
        return 1;
    } else if (isCellularOpened && isChinaMobile ) {
        return 0;
    } else if( [IDMPDevice simExist] && currntNet!=nil) {
        NSString *allowNonCMCCLogin = [(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPNON_CMCC_LOGIN_FLAG];
        if ([allowNonCMCCLogin isEqualToString:@"0"]) {
            if (isChinaMobile) {
                return 2;
            } else {
                return 3;
            }
        } else {
            return 2;
        }
    } else if(currntNet != nil) {
        return 3;
    } else {
        return -1;
    }
}

#pragma mark - cleansso
- (BOOL)cleanSSO {
    int authType = [self getAuthType];
//    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"cleanSSO" requestParm:nil authType:authType traceId:traceId];
    [self requestCleanSSOWithSuccessBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
    }];
    return YES;
}

- (void)requestCleanSSOWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        pthread_mutex_lock(&queueLock);
        NSMutableArray *userKs=[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
        NSLog(@"original userlist is %@",userKs);
        NSMutableArray *users=[[NSMutableArray alloc]init];
        [userInfoStorage setInfo:users withKey:userList];
        NSLog(@"clear cache success and userlist: %@",userKs);
        if (userKs.count) {
            for (int i=0; i<userKs.count; i++) {
                if ([userKs[i]isKindOfClass:[NSDictionary class]]) {
                    NSString *name = [userKs[i] objectForKey:@"userName"];
                    NSDictionary *currentUser= (NSDictionary *)[userInfoStorage getInfoWithKey:name];
                    if ([userInfoStorage removeInfoWithKey:name]) {
                        [IDMPQueryModel cleanSsoSuccessNotificationWithBtid:[currentUser objectForKey:ksBTID] andSqn:[currentUser objectForKey:ksSQN] successBlock:successBlock failBlock:failBlock];
                    }
                }
            }
        }
        pthread_mutex_unlock(&queueLock);
    });
}

- (BOOL)cleanSSOWithUserName:(NSString *)userName {
    int authType = [self getAuthType];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"userName", nil];
    NSString *traceId = [[IDMPNonce getClientNonce] uppercaseString];
    IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"cleanSSOWithUserName" requestParm:requestParam authType:authType traceId:traceId];
    [self requestCleanSSOWithUserName:userName successBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
    } failBlock:^(NSDictionary *paraments) {
        [logReportMode reportLogWithRepsonseParam:paraments];
    }];
    return YES;
}

- (void)requestCleanSSOWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        pthread_mutex_lock(&queueLock);
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey: userList]];
        if (accounts) {
            for (int i=0; i<accounts.count; i++) {
                if ([[accounts[i] objectForKey:@"userName"]isEqualToString:userName]) {
                    [accounts removeObjectAtIndex:i];
                    break;
                }
            }
            [userInfoStorage setInfo:accounts withKey:userList];
        }
        NSDictionary *currentUser= (NSDictionary *)[userInfoStorage getInfoWithKey:userName];
        if ([userInfoStorage removeInfoWithKey:userName]) {
            [IDMPQueryModel cleanSsoSuccessNotificationWithBtid:[currentUser objectForKey:ksBTID] andSqn:[currentUser objectForKey:ksSQN] successBlock:successBlock failBlock:failBlock];
        }
        pthread_mutex_unlock(&queueLock);
    });
}

#pragma mark - currentEdition
- (void)currentEdition {
    NSLog(@"版本:andidmp-iosv3.1.0  时间:2017.07.25");
}

//-(void)requestAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
//{
//
//    if (loginType > 2)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102205"};
//            failBlock(result);
//        }
//        return;
//    }
//
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//        pthread_mutex_lock(&queueLock);
//        @autoreleasepool {
//            if ([self getAuthType] < 0)
//            {
//                if (failBlock)
//                {
//                    NSDictionary *result = @{@"resultCode":@"102101"};
//                    failBlock(result);
//                }
//                pthread_mutex_unlock(&queueLock);
//                return;
//            }
//
//            if(![IDMPQueryModel appidIsChecked])
//            {
//
//                [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString
//                                   finishBlock:^(NSDictionary *paraments)
//                 {
//
//                     @autoreleasepool {
//                         [self checkCacheBeforeLoginUseWithUserName:userName sipInfo:noSip LoginType:loginType isUserDefaultUI:NO
//                                                        finishBlock:^(NSDictionary *paraments)
//                          {
//                              if (successBlock)
//                              {
//                                  successBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }
//                                                          failBlock:^(NSDictionary *paraments)
//                          {
//                              if (failBlock)
//                              {
//                                  failBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }];
//                     }
//                 }
//                                     failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//
//                 }];
//
//            }
//            else
//            {
//                [self checkCacheBeforeLoginUseWithUserName:userName sipInfo:noSip LoginType:loginType isUserDefaultUI:NO
//                                               finishBlock:^(NSDictionary *paraments)
//                 {
//                     if (successBlock)
//                     {
//                         successBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }
//                                                 failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }];
//            }
//        }
//
//    });
//}
//
//
//
//-(void)requestAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
//{
//
//    if (loginType > 2)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102205"};
//            failBlock(result);
//        }
//        return;
//    }
//
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//
//        pthread_mutex_lock(&queueLock);
//        @autoreleasepool {
//
//            if ([self getAuthType] < 0)
//            {
//                if (failBlock)
//                {
//                    NSDictionary *result = @{@"resultCode":@"102101"};
//                    failBlock(result);
//                }
//                pthread_mutex_unlock(&queueLock);
//                return;
//            }
//
//            if(![IDMPQueryModel appidIsChecked])
//            {
//
//                [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
//                 {
//                     @autoreleasepool {
//                         [self checkCacheBeforeLoginUseWithUserName:userName sipInfo:isSip LoginType:loginType isUserDefaultUI:YES
//                                                        finishBlock:^(NSDictionary *paraments)
//                          {
//                              if (successBlock)
//                              {
//                                  successBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }
//                                                          failBlock:^(NSDictionary *paraments)
//                          {
//                              if (failBlock)
//                              {
//                                  failBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }];
//                     }
//
//                 }
//                                     failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//
//                 }];
//
//
//            }
//            else
//            {
//                [self checkCacheBeforeLoginUseWithUserName:userName sipInfo:isSip LoginType:loginType isUserDefaultUI:YES
//                                               finishBlock:^(NSDictionary *paraments)
//                 {
//                     if (successBlock)
//                     {
//                         successBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }
//                                                 failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }];
//            }
//        }
//    });
//
//}

//-(void)requestAppPasswordByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock
//{
//
//    if (userName.length == 0)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102303"};
//            failBlock(result);
//        }
//        return;
//    }
//
//    if (content.length == 0)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102304"};
//            failBlock(result);
//        }
//        return;
//    }
//    if (loginType > 2)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102205"};
//            failBlock(result);
//        }
//        return;
//    }
//
//
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//        pthread_mutex_lock(&queueLock);
//        @autoreleasepool
//        {
//            if ([self getAuthType] < 0)
//            {
//                if (failBlock)
//                {
//                    NSDictionary *result = @{@"resultCode":@"102101"};
//                    failBlock(result);
//                }
//                pthread_mutex_unlock(&queueLock);
//                return;
//            }
//
//            if(![IDMPQueryModel appidIsChecked])
//            {
//                [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString
//                                   finishBlock:^(NSDictionary *paraments)
//                 {
//                     @autoreleasepool
//                     {
//
//                         [self noCacheLoginByConditionWithUserName:userName andPassWd:content sipInfo:isSip LoginType:loginType
//                                                      successBlock:^(NSDictionary *paraments)
//                          {
//                              if (successBlock)
//                              {
//                                  successBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }
//                                                         failBlock:^(NSDictionary *paraments)
//                          {
//                              if (failBlock)
//                              {
//                                  failBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }];
//                     }
//
//                 }
//                                     failBlock:^(NSDictionary *paraments)
//                 {
//
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//
//                 }];
//
//            }
//            else
//            {
//                [self noCacheLoginByConditionWithUserName:userName andPassWd:content sipInfo:isSip LoginType:loginType
//                                             successBlock:^(NSDictionary *paraments)
//                 {
//                     if (successBlock)
//                     {
//                         successBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }
//                                                failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }];
//            }
//        }
//
//    });
//}

//-(void)requestAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
//{
//
//    if (userName.length == 0)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102303"};
//            failBlock(result);
//        }
//        return;
//    }
//
//    if (content.length == 0)
//    {
//        if (failBlock)
//        {
//            NSDictionary *result = @{@"resultCode":@"102304"};
//            failBlock(result);
//        }
//        return;
//    }
//    if (loginType > 2)
//    {
//        if (failBlock)
//        {
//            NSLog(@"logintype error");
//            NSDictionary *result = @{@"resultCode":@"102205"};
//            failBlock(result);
//        }
//        return;
//    }
//
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//
//        pthread_mutex_lock(&queueLock);
//        @autoreleasepool {
//
//            if ([self getAuthType] < 0)
//            {
//                if (failBlock)
//                {
//                    NSDictionary *result = @{@"resultCode":@"102101"};
//                    failBlock(result);
//                }
//                pthread_mutex_unlock(&queueLock);
//                return;
//            }
//
//            if(![IDMPQueryModel appidIsChecked])
//            {
//
//                [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString
//                                   finishBlock:^(NSDictionary *paraments)
//                 {
//
//                     @autoreleasepool
//                     {
//                         [self noCacheLoginByConditionWithUserName:userName andPassWd:content sipInfo:noSip LoginType:loginType
//                                                      successBlock:^(NSDictionary *paraments)
//                          {
//                              if (successBlock)
//                              {
//                                  successBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }
//                                                         failBlock:^(NSDictionary *paraments)
//                          {
//                              if (failBlock)
//                              {
//                                  failBlock(paraments);
//                              }
//                              pthread_mutex_unlock(&queueLock);
//                          }];
//
//                     }
//
//
//                 }
//                                     failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//
//
//                 }];
//            }
//            else
//            {
//                [self noCacheLoginByConditionWithUserName:userName andPassWd:content sipInfo:noSip LoginType:loginType
//                                             successBlock:^(NSDictionary *paraments)
//                 {
//                     if (successBlock)
//                     {
//                         successBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }
//                                                failBlock:^(NSDictionary *paraments)
//                 {
//                     if (failBlock)
//                     {
//                         failBlock(paraments);
//                     }
//                     pthread_mutex_unlock(&queueLock);
//                 }];
//            }
//
//        }
//
//    });
//
//
//}

//- (void)requestRegisterUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
//{
//    if (phoneNo.length == 0 || password.length == 0)
//    {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
//        if (failBlock) {
//            failBlock(dic);
//        }
//        return;
//    }
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//        if ([self getAuthType] < 0)
//        {
//            if (failBlock)
//            {
//                NSDictionary *result = @{@"resultCode":@"102101"};
//                failBlock(result);
//            }
//            return;
//        }
//
//
//
//        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
//        if(![IDMPQueryModel appidIsChecked])
//        {
//
//            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString  finishBlock:^(NSDictionary *paraments) {
//                @autoreleasepool {
//
//                    [accountManager registerUserWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
//                }
//
//
//            }
//                                 failBlock:^(NSDictionary *paraments)
//             {
//
//
//                 failBlock(paraments);
//
//             } ];
//
//        }
//        else
//        {
//
//
//            [accountManager registerUserWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
//        }
//
//
//    });
//}
//
//
//- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
//{
//
//    if (phoneNo.length == 0 || password.length == 0)
//    {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
//        if (failBlock)
//        {
//            failBlock(dic);
//        }
//        return;
//    }
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//        if ([self getAuthType] < 0)
//        {
//            if (failBlock)
//            {
//                NSDictionary *result = @{@"resultCode":@"102101"};
//                failBlock(result);
//            }
//            return;
//        }
//
//
//        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
//        if(![IDMPQueryModel appidIsChecked])
//        {
//
//            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
//             {
//                 @autoreleasepool {
//                     [accountManager resetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
//                 }
//
//             }
//                                 failBlock:^(NSDictionary *paraments)
//             {
//
//
//                 failBlock(paraments);
//
//             }];
//        }
//        else
//        {
//
//            [accountManager resetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
//        }
//
//    });
//}
//
//- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
//{
//
//    if (phoneNo.length == 0 || password.length == 0)
//    {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
//        if (failBlock)
//        {
//            failBlock(dic);
//        }
//        return;
//    }
//    if (!tokenQueue)
//    {
//        tokenQueue= dispatch_queue_create("token", NULL);
//    }
//    dispatch_async(tokenQueue, ^{
//        if ([self getAuthType] < 0)
//        {
//            if (failBlock)
//            {
//                NSDictionary *result = @{@"resultCode":@"102101"};
//                failBlock(result);
//            }
//            return;
//        }
//
//
//        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
//
//        if(![IDMPQueryModel appidIsChecked])
//        {
//
//            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
//             {
//                 @autoreleasepool {
//                     [accountManager changePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
//                 }
//
//             }
//                                 failBlock:^(NSDictionary *paraments)
//             {
//
//
//                 failBlock(paraments);
//
//             }];
//
//        }
//        else
//        {
//
//            [accountManager changePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
//
//        }
//
//    });
//}



@end
