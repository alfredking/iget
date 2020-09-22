//
//  IDMPCoreEngine.m
//  IDMPCMCC
//
//  Created by wj on 2017/12/28.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPCoreEngine.h"
#import "IDMPParseParament.h"
#import "IDMPQueryModel.h"
#import <pthread.h>
#import "IDMPUPMode.h"
#import "IDMPTempSmsMode.h"
#import "IDMPAuthModel.h"
#import "IDMPDate.h"
#import "IDMPHttpRequest.h"
#import "IDMPCheckKS.h"
#import "IDMPToken.h"
#import "IDMPWapMode.h"
#import "IDMPDataSMSMode.h"
#import "IDMPDevice.h"
#import "IDMPAccountManagerMode.h"
#import "IDMPFormatTransform.h"
#import "IDMPReAuthViewController.h"
#import "IDMPPopTool.h"
#import "NSString+IDMPAdd.h"
#import "IDMPKeychain.h"
#import "IDMPUtility.h"
#import "userInfoStorage.h"

@implementation IDMPCoreEngine

static pthread_mutex_t queueLock = PTHREAD_MUTEX_INITIALIZER;

- (void)requestValidateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime traceId:(NSString *)traceId finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock {
    NSLog(@"init with appid start");
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
    
    if (appid.length == 0 || appkey.length == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",IDMPResCode,@"输入参数错误",IDMPResStr, nil];
        if (failBlock) {
            failBlock(dic);
        }
        return;
    }
    
    if (![appidString isEqualToString:appid]) {
        NSLog(@"has no cache appid and save new setting");
        [userInfoStorage setInfo:appid withKey:IDMP_APPIDsk];
        [userInfoStorage setInfo:appkey withKey:IDMP_APPKEYsk];
//            [userInfoStorage setInfo:@(aTime) withKey:secDataSmsHttpTimesk];
        [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
        [userInfoStorage setInfo:yesFlag withKey:currentIsNorth];
        [userInfoStorage setInfo:noFlag withKey:isChecked];
        
    }
    
    [IDMPQueryModel getConfigsWithCompletionBlock:^(NSDictionary *paraments) {
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:successBlcok failBlock:failBlock];
    }];

}

- (BOOL)cleanKeychainSSO {
    pthread_mutex_lock(&queueLock);
    NSMutableArray *userKs=[NSMutableArray arrayWithArray:(NSArray *)[IDMPKeychain getDataForAccount:userList]];
    NSMutableArray *users=[[NSMutableArray alloc]init];
    NSLog(@"userlist: %@",users);
    [IDMPKeychain setData:users account:userList];
    [IDMPKeychain setData:noFlag account:isChecked];
    NSLog(@"清除缓存成功");
    
    NSLog(@"userlist: %@",userKs);
    if (userKs.count) {
        for (int i=0; i<userKs.count; i++) {
            if ([userKs[i]isKindOfClass:[NSDictionary class]]) {
                NSString *name = [userKs[i] objectForKey:IDMPUserName];
                [userInfoStorage removeInfoWithKey:name];
            }
        }
    }
    [userInfoStorage removeInfoWithKey:IDMPLastGetConfigDate];
    [userInfoStorage removeInfoWithKey:IDMPCONFIGS];
    [userInfoStorage removeInfoWithKey:IDMP_APPIDsk];
    [userInfoStorage removeInfoWithKey:IDMP_APPKEYsk];
    [userInfoStorage removeInfoWithKey:secDataSmsHttpTimesk];
    [userInfoStorage removeInfoWithKey:currentIsDomain];
    [userInfoStorage removeInfoWithKey:currentIsNorth];
#ifdef STATESECRET
    [userInfoStorage removeInfoWithKey:NCANameKey];
    [userInfoStorage removeInfoWithKey:MskNameKey];
#endif

    
    pthread_mutex_unlock(&queueLock);
    return YES;
}

#pragma mark - requestAccessToken
-(void)requestTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType sip:(NSString *)sip traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"start getaccesstoken with username:%@",userName);
    if (loginType > 2) {
        if (failBlock) {
            NSDictionary *result = @{IDMPResCode:@"102205",IDMPResStr:@"当前环境不支持指定的登录方式"};
            failBlock(result);
        }
        return;
    }

    pthread_mutex_lock(&queueLock);
    @autoreleasepool {
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
            [self checkCacheBeforeLoginUseWithUserName:userName sipInfo:sip LoginType:loginType isUserDefaultUI:YES traceId:traceId finishBlock:^(NSDictionary *paraments) {
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
        } failBlock:^(NSDictionary *paraments) {
            if (failBlock) {
                failBlock(paraments);
            }
            pthread_mutex_unlock(&queueLock);
        }];
        
    }
    
}

- (void)checkCacheBeforeLoginUseWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo LoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    if (userName) {
        NSMutableArray *users = [NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
        BOOL cacheEffective=NO;
        for (int i=0; i<users.count; i++) {
            if ([users[i]isKindOfClass:[NSDictionary class]]) {
                NSString *nameList = [users[i] objectForKey:IDMPUserName];
                if([nameList isEqualToString:userName]) {
                    cacheEffective=YES;
                }
            }
        }
        if (cacheEffective) {
            NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:userName];
            NSLog(@"cache test user %@",user);
            if([user objectForKey:IDMPBTID]&&[user objectForKey:IDMPKS]&&[user objectForKey:IDMPSQN]) {
                [self cacheUseWithUserName:userName sipInfo: sipinfo traceId:traceId finishBlock:successBlock failBlock:failBlock];
            } else {
                NSDictionary *result = @{IDMPResCode:@"102314",IDMPResStr:@"指定用户缓存不存在"};
                failBlock(result);
            }
        } else {
            NSDictionary *result = @{IDMPResCode:@"102314",IDMPResStr:@"指定用户缓存不存在"};
            failBlock(result);
        }
    } else {
        NSString *localUserName = [self getLocalUserName];
        if (localUserName == nil) {
            [self noCacheLoginWithUserName:localUserName sipInfo: sipinfo LoginType:loginType  isUserDefaultUI:isUserDefaultUI traceId:traceId isTmpCache:NO successBlock:successBlock failBlock:failBlock];
        } else {
            NSDictionary *user= (NSDictionary *)[userInfoStorage getInfoWithKey:localUserName];
            
            if([user objectForKey:IDMPBTID]&&[user objectForKey:IDMPKS]&&[user objectForKey:IDMPSQN]) {
                [self cacheUseWithUserName:localUserName sipInfo: sipinfo traceId:traceId finishBlock:successBlock failBlock:failBlock];
            } else {
                NSLog(@"user error is %@",user);
                NSDictionary *result = @{IDMPResCode:@"102314",IDMPResStr:@"指定用户缓存不存在"};
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
                NSDictionary *result = @{IDMPResCode:@"102298",IDMPResStr:@"应用合法性校验失败"};
                failBlock(result);
            }
            return;
        }
        NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
        NSString *passid=[user objectForKey:IDMPPassID];
        NSString *token;
        if([user objectForKey:IDMPBTID]&&[user objectForKey:IDMPKS]&&[user objectForKey:IDMPSQN]) {
            token=[IDMPToken getTokenWithUserName:userName andSourceId:sourceID isTmpCache:NO];
            if (token == nil && failBlock) {
                NSDictionary *result = @{IDMPResCode:@"102317",IDMPResStr:@"token生成失败"};
                failBlock(result);
                return;
            }
        } else {
            if (failBlock) {
                NSDictionary *result = @{IDMPResCode:@"102314",IDMPResStr:@"指定用户缓存不存在"};
                failBlock(result);
            }
            return;
        }
        NSString *isSipFromServer = (NSString *)[userInfoStorage getInfoWithKey:isSipApp];
        if ([sipinfo isEqualToString:isSip] && [isSipFromServer isEqualToString:isSip]) {
            [IDMPQueryModel queryAppPasswdWithUserName:userName finishBlock:^(NSDictionary *paraments){
                NSString *passwd=[paraments objectForKey:sipPassword];
                NSString *openid = [paraments objectForKey:IDMPOPENID];
                resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",userName,ksUserName,passid,IDMPPassID,@"102000",IDMPResCode,@"success",IDMPResStr,passwd,sipPassword, openid, IDMPOPENID, nil];
                successBlock(resultInfo);
            } failBlock:^(NSDictionary *paraments) {
                NSString *passwd=[paraments objectForKey:sipPassword];
                NSString *resultcode=[paraments objectForKey:IDMPResCode];
                resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",userName,ksUserName,passid,IDMPPassID,resultcode,IDMPResCode,@"success",IDMPResStr,passwd,sipPassword, nil];
                failBlock(resultInfo);
            }];
        } else {
            NSString *fakeUserName = nil;
            if ([userName idmp_isPhoneNum]) {
                fakeUserName = [userName idmp_hideMiddleFourFromEnd];
            }
            resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:token,@"token",passid,IDMPPassID ,@"102000",IDMPResCode,@"success",IDMPResStr,fakeUserName,IDMPMsisdn, nil];
            successBlock(resultInfo);
        }
        
    } failBlock:^(NSDictionary *paraments) {
        failBlock(paraments);
    }];
}

- (void)noCacheLoginWithLoginType:(NSInteger)loginType traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
        [self noCacheLoginWithUserName:nil sipInfo:noSip LoginType:loginType isUserDefaultUI:NO traceId:traceId isTmpCache:YES successBlock:successBlock failBlock:failBlock];
    }failBlock:^(NSDictionary *paraments) {
        failBlock(paraments);
    }];
}

- (void)noCacheLoginWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo LoginType:(NSInteger)loginType  isUserDefaultUI:(BOOL)isUserDefaultUI traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSLog(@"不使用缓存");
    int currentAuthType = [self getAuthType];
    int operatorType = [self getOperatorType];
    if ((loginType < 2 && (currentAuthType != 1 && currentAuthType != 0)) //wap登录，当前authtype必须为0或1
        || (loginType == 2 && operatorType == 0 && (currentAuthType > 2 || currentAuthType < 0))    //datasms登录，在移动卡情况下，当前authtype必须为0或1或2
        || (loginType == 2 && operatorType != 0)) { //datasms登录，在非移动卡情况下
        NSLog(@"支持类型:%d  传入类型:%ld",currentAuthType,(long)loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",IDMPResCode,@"当前环境不支持指定的登录方式",IDMPResStr, nil];
        failBlock(result);
        return;
    }
    NSLog(@"支持类型:%d  传入类型:%ld",currentAuthType,(long)loginType);
    switch (loginType) {
        case 0:
        {
            IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
            [wapMode getWapKSWithSipInfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
            break;
        }
        case 1:
        {
            IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
            [wapMode getWapKSWithSipInfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
        }
            break;
        case 2:
        {
            IDMPDataSMSMode *dataSMS=[[IDMPDataSMSMode alloc]init];
            [dataSMS getDataSmsKSWithSipInfo:sipinfo traceId:traceId isTmpCache:isTmpCache successBlock:successBlock failBlock:failBlock];
        }
            break;
        default:
        {
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",IDMPResCode,@"当前环境不支持指定的登录方式",IDMPResStr, nil];
            failBlock(result);
        }
            break;
    }
}

#pragma mark - requestAccessTokenByCondition
-(void)requestAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType sip:(NSString *)sip traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (userName.length == 0) {
        if (failBlock) {
            NSDictionary *result = @{IDMPResCode:@"102303",IDMPResStr:@"用户名为空"};
            failBlock(result);
        }
        return;
    }
    
    if (content.length == 0) {
        if (failBlock) {
            NSDictionary *result = @{IDMPResCode:@"102304",IDMPResStr:@"密码为空"};
            failBlock(result);
        }
        return;
    }
    if (loginType > 2) {
        if (failBlock) {
            NSDictionary *result = @{IDMPResCode:@"102205",IDMPResStr:@"当前环境不支持指定的登录方式"};
            failBlock(result);
        }
        return;
    }
    pthread_mutex_lock(&queueLock);
    @autoreleasepool {
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
            @autoreleasepool {
                [self noCacheLoginByConditionWithUserName:userName andPassWd:content sipInfo:sip LoginType:loginType traceId:traceId successBlock:^(NSDictionary *paraments) {
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
    BOOL isSameDay = [IDMPDate isSameDay:ksupdatedate date2:[NSDate date]];
    if (!ksupdatedate || !isSameDay) {
        NSLog(@"ksupdate exceeded for one day or date not exist");
        
        NSString *clientNonce = [NSString idmp_getClientNonce];
        NSDictionary *heads = [[IDMPAuthModel alloc] initUPDKSWithUserName:userName sipInfo:sipinfo clientNonce:clientNonce traceId:traceId].heads;
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
        [request getAsynWithHeads:heads url:updateUrl timeOut:20 successBlock:^(NSDictionary *parameters){
            NSLog(@"updateKSEverdayWithUserName %@",parameters);
            NSDictionary *wwwauthenticate = [IDMPCheckKS checkUpdateKSIsValid:parameters clientNonce:clientNonce userName:userName];
            if (wwwauthenticate) {
                [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
                successBlock();
            } else {
                failBlock(@{IDMPResCode:@"102298",IDMPResStr:@"应用合法性校验失败"});
            }
            
        } failBlock: ^(NSDictionary *parameters){
            NSInteger resultCode = [[parameters objectForKey:IDMPResCode] integerValue];
            if (resultCode==IDMPResultCodeRecentlyUpdated) {
                successBlock();
                [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
            } else if (resultCode==102102) {
                successBlock();
            } else {
                NSLog(@"cleansso by self");
                [self requestCleanSSOWithSuccessBlock:^(NSDictionary *parameters) {} failBlock:^(NSDictionary *parameters) {}];
                failBlock(parameters);
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
            return [user objectForKey:IDMPUserName];
        };
    }
    return nil;
}


#pragma mark -cleansso
- (void)requestCleanSSOWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    pthread_mutex_lock(&queueLock);
    NSMutableArray *userKs=[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
    NSLog(@"original userlist is %@",userKs);
    NSMutableArray *users=[[NSMutableArray alloc]init];
    [userInfoStorage setInfo:users withKey:userList];
    NSLog(@"clear cache success and userlist: %@",userKs);
    if (userKs.count) {
        for (int i=0; i<userKs.count; i++) {
            if ([userKs[i]isKindOfClass:[NSDictionary class]]) {
                NSString *name = [userKs[i] objectForKey:IDMPUserName];
                NSDictionary *currentUser= (NSDictionary *)[userInfoStorage getInfoWithKey:name];
                if ([userInfoStorage removeInfoWithKey:name]) {
                    [IDMPQueryModel cleanSsoSuccessNotificationWithBtid:[currentUser objectForKey:IDMPBTID] andSqn:[currentUser objectForKey:IDMPSQN] successBlock:successBlock failBlock:failBlock];
                } else {
                    successBlock(@{IDMPResCode:@"102000",IDMPResStr:@"success"});
                }
            } else {
                successBlock(@{IDMPResCode:@"102000",IDMPResStr:@"success"});
            }
        }
    } else {
        successBlock(@{IDMPResCode:@"102000",IDMPResStr:@"success"});
    }
    pthread_mutex_unlock(&queueLock);
}

- (void)requestCleanSSOWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    pthread_mutex_lock(&queueLock);
    NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey: userList]];
    if (accounts) {
        for (int i=0; i<accounts.count; i++) {
            if ([[accounts[i] objectForKey:IDMPUserName]isEqualToString:userName]) {
                [accounts removeObjectAtIndex:i];
                break;
            }
        }
        [userInfoStorage setInfo:accounts withKey:userList];
    }
    NSDictionary *currentUser= (NSDictionary *)[userInfoStorage getInfoWithKey:userName];
    if ([userInfoStorage removeInfoWithKey:userName]) {
        [IDMPQueryModel cleanSsoSuccessNotificationWithBtid:[currentUser objectForKey:IDMPBTID] andSqn:[currentUser objectForKey:IDMPSQN] successBlock:successBlock failBlock:failBlock];
    } else {
        successBlock(@{IDMPResCode:@"102000",IDMPResStr:@"success"});
    }
    pthread_mutex_unlock(&queueLock);
}

#pragma mark - account manage
- (void)requestRegisterUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
        @autoreleasepool {
            [[IDMPAccountManagerMode shareAccountManager] manageAccount:phoneNo passWord:password validCodeOrNewPwd:validCode option:IDMPRegister traceId:traceId finishBlock:successBlock failBlock:failBlock];
        }
    } failBlock:failBlock];

}

- (void)requestResetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
        @autoreleasepool {
            [[IDMPAccountManagerMode shareAccountManager] manageAccount:phoneNo passWord:password validCodeOrNewPwd:validCode option:IDMPResetPwd traceId:traceId finishBlock:successBlock failBlock:failBlock];
        }
    } failBlock:failBlock];
}

- (void)requestChangePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword traceId:(NSString *)traceId finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString traceId:traceId finishBlock:^(NSDictionary *paraments) {
        @autoreleasepool {
            [[IDMPAccountManagerMode shareAccountManager] manageAccount:phoneNo passWord:password validCodeOrNewPwd:newpassword option:IDMPChangePwd traceId:traceId finishBlock:successBlock failBlock:failBlock];
        }
    } failBlock:failBlock];
}

#pragma mark - check local number
-(void)requestCheckIsLocalNumberWith:(NSString *)userName traceId:(NSString *)traceId finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    NSLog(@"check localnumber");
    int currentAuthType = [self getAuthType];
    if (currentAuthType > 1 || currentAuthType < 0) {
        NSLog(@"check localnumber yes");
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,IDMPResCode,@"检测到是本机号码",IDMPResStr, nil];
        failBlock(result);
        return ;
    }
    __block IDMPHttpRequest *request=[[IDMPHttpRequest alloc]init];
    NSMutableDictionary *heads = [NSMutableDictionary dictionaryWithCapacity:0];
#ifdef STATESECRET
    NSString *NCAKeyName = (NSString *)[userInfoStorage getInfoWithKey:NCANameKey];
    [heads setValue:@"nca" forKey:@"encType"];
    [heads setValue:NCAKeyName forKey:@"keyName"];
#endif
    
    [request getWapMobileAsynWithHeads:heads url:[NSURL URLWithString:localUrl] timeOut:15 successBlock:^(NSDictionary *parameters) {
        NSString *localNumber = [parameters objectForKey:@"mobile"];
        if ([IDMPUtility checkNSStringisNULL:localNumber]) {
            NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,IDMPResCode,@"检测到是本机号码",IDMPResStr, nil];
            failBlock(result);
        } else {
            NSLog(@"localNumber :%@",localNumber);
            NSString *newNumber = [IDMPUtility rsaOrSM4DecryptWithEncData:localNumber];
            newNumber=[newNumber substringWithRange:NSMakeRange(2,11)];
            NSLog(@"newNumber :%@",newNumber);
            if (![newNumber isEqual:userName]&&![IDMPUtility checkNSStringisNULL:newNumber]) {
                NSLog(@"is not same");
                NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberNO,IDMPResCode,@"检测到是非本机号码",IDMPResStr, nil];
                successBlock(result);
            } else {
                NSLog(@"check localnumber yes");
                NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,IDMPResCode,@"检测到是本机号码",IDMPResStr, nil];
                failBlock(result);
            }
        }
    } failBlock:^(NSDictionary *parameters){
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:SECLocalNumberYES,IDMPResCode,@"检测到是本机号码",IDMPResStr, nil];
        failBlock(result);
    }];
    
}

#pragma mark -reAuth
- (void)requestReAuthenticationWithUserName:(NSString *)userName traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    if ([IDMPUtility checkNSStringisNULL:userName]) {
        return failBlock(@{IDMPResCode:@"102303",IDMPResStr:@"用户名为空"});
    }
    
    [self requestTokenWithUserName:userName andLoginType:0 sip:noSip traceId:traceId finishBlock:^(NSDictionary *results) {
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
                if ([parameters[IDMPResCode] isEqualToString:@"103000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successBlock(results);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failBlock(@{@"resulCode":@"102301",@"resultString":@"canceled"});
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
    NetworkStatus networkStatus = [IDMPDevice GetCurrntNet];
    BOOL isChinaMobile = [IDMPDevice checkChinaMobile];
    BOOL isCellularOpened = [IDMPDevice checkCellular];
    BOOL hasCelluarAuth = [IDMPDevice hasCellularAuthority];
    if (networkStatus == ReachableViaWWAN && hasCelluarAuth) {
        return 1;
    } else if (isCellularOpened && networkStatus != NotReachable && hasCelluarAuth) {
        return 0;
    } else if ([IDMPDevice simExist] && networkStatus != NotReachable) {
//        NSString *allowNonCMCCLogin = [(NSDictionary *)[userInfoStorage getInfoWithKey:IDMPCONFIGS] objectForKey:IDMPNON_CMCC_LOGIN_FLAG];
//        if ([allowNonCMCCLogin isEqualToString:@"1"]) {
//            return 2;
//        } else {
        //暂时不使用服务端下发的上行配置
            if (isChinaMobile) {
                return 2;
            } else {
                return 3;
            }
//        }
    } else if (networkStatus != NotReachable) {
        return 3;
    } else {
        return -1;
    }
}

- (int)getOperatorType {
    OperatorName operator = [IDMPDevice getChinaOperatorName];
    switch (operator) {
        case CMCC:
        return 0;
        break;
        case CUCC:
        return 1;
        break;
        case CTCC:
        return 2;
        break;
        case Unkown:
        return -1;
        break;
    }
}

@end
