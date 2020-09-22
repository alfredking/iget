//
//  IDMPAutoLoginViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-15.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAutoLoginViewController.h"
#import "IDMPLogReportMode.h"
#import "IDMPCoreEngine.h"
#import "NSString+IDMPAdd.h"
#import "IDMPDevice.h"

#ifdef CELLULARFREE
#import "FreeDataAuthMode.h"
#endif

@implementation IDMPAutoLoginViewController
static dispatch_queue_t tokenQueue;
static dispatch_semaphore_t semaphore;


- (id)init {
    static dispatch_once_t autoLoginOnceToken;
    self = [super init];
    if (self) {
        dispatch_once(&autoLoginOnceToken, ^{
            tokenQueue= dispatch_queue_create("token", NULL);
            semaphore = dispatch_semaphore_create(1);

        });
    }
    return self;
}

#pragma mark - validateAppid

- (void)validateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:appid, kAPPID, [NSString stringWithFormat:@"%f",aTime], @"aTime", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"init" requestParm:requestParam appid:appid appkey:appkey authType:authType traceId:traceId];
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestValidateWithAppid:appid appkey:appkey timeoutInterval:aTime traceId:(NSString *)traceId finishBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlcok param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
}


#pragma mark - authType

- (int)getAuthType {
    IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
    return [coreEngine getAuthType];
}

- (int)getOperatorType {
    return [[IDMPCoreEngine new] getOperatorType];
}

#pragma mark - getAccessTokenByConditon & getAppPasswordByConditon

-(void)getAppPasswordByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, IDMPUserName, [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAppPasswordByConditon" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestAccessTokenByConditionWithUserName:userName Content:content andLoginType:loginType sip:isSip traceId:traceId finishBlock:^(NSDictionary *paraments) {
            dispatch_source_cancel(timer);
            [self finishTokenSuccessBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
}

-(void)getAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, IDMPUserName, [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAccessTokenByConditon" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestAccessTokenByConditionWithUserName:userName Content:content andLoginType:loginType sip:noSip traceId:traceId finishBlock:^(NSDictionary *paraments) {
            dispatch_source_cancel(timer);
            [self finishTokenSuccessBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
            
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
}

#pragma mark - getAccessToken & getAppPassword
-(void)getAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"--------一键登录 is called with username:%@-------",userName);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:((fakeUserName==nil) ? @"" : fakeUserName), IDMPUserName, [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAccessToken" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        dispatch_source_t timer;
        __block BOOL isBlocked = NO;
        if (loginType != 2) {
            timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
                failBlock(paraments);
                isBlocked = YES;
            }];
        }
        [coreEngine requestTokenWithUserName:userName andLoginType:loginType sip:noSip traceId:traceId finishBlock:^(NSDictionary *paraments) {
            if (loginType != 2) {
                dispatch_source_cancel(timer);
            }
            [self finishTokenSuccessBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
            
            
        } failBlock:^(NSDictionary *paraments) {
            if (loginType != 2) {
                [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
            } else {
                [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
            }
        }];
    });
}


-(void)getAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:((fakeUserName==nil) ? @"" : fakeUserName), IDMPUserName, [NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAppPassword" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        dispatch_source_t timer;
        __block BOOL isBlocked = NO;
        if (loginType != 2) {
            timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
                failBlock(paraments);
                isBlocked = YES;
            }];
        }
        [coreEngine requestTokenWithUserName:userName andLoginType:loginType sip:isSip traceId:traceId  finishBlock:^(NSDictionary *paraments) {
            if (loginType != 2) {
                dispatch_source_cancel(timer);
            }
            [self finishTokenSuccessBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
        } failBlock:^(NSDictionary *paraments) {
            if (loginType != 2) {
                [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
            } else {
                [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
            }
        }];
    });
}


#pragma mark - accountManager
- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [phoneNo idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, @"phoneNo", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"registerUser" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestRegisterUserWithPhoneNo:phoneNo passWord:password andValidCode:validCode traceId:traceId finishBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
}

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [phoneNo idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, @"phoneNo", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"changePassword" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestChangePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:newpassword traceId:traceId finishBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
}

- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        NSString *fakeUserName = [phoneNo idmp_hideMiddleFourFromStart];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, @"phoneNo", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"resetPassword" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestResetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCode traceId:traceId finishBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];
    });
}




#pragma mark - checkLocalNum
-(void)checkIsLocalNumberWith:(NSString *)userName finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, IDMPUserName, nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"checkLocalNum" requestParm:requestParam authType:authType traceId:traceId];
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestCheckIsLocalNumberWith:userName traceId:traceId finishBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
    
}


#pragma mark - reAuth
- (void)reAuthenticationWithUserName:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock{
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, IDMPUserName, nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"reAuth" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [coreEngine requestReAuthenticationWithUserName:userName traceId:traceId successBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
}




#pragma mark - cleansso
- (BOOL)cleanSSO {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"cleanSSO" requestParm:nil authType:authType traceId:traceId];
        [coreEngine requestCleanSSOWithSuccessBlock:^(NSDictionary *paraments) {
            [logReportMode reportLogWithRepsonseParam:paraments];
        } failBlock:^(NSDictionary *paraments) {
            [logReportMode reportLogWithRepsonseParam:paraments];
        }];
        dispatch_semaphore_signal(semaphore);

    });
    return YES;
}


- (BOOL)cleanSSOWithUserName:(NSString *)userName {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSString *fakeUserName = [userName idmp_hideMiddleFourFromStart];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:fakeUserName, IDMPUserName, nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"cleanSSOWithUserName" requestParm:requestParam authType:authType traceId:traceId];
        [coreEngine requestCleanSSOWithUserName:userName successBlock:^(NSDictionary *paraments) {
            [logReportMode reportLogWithRepsonseParam:paraments];
        } failBlock:^(NSDictionary *paraments) {
            [logReportMode reportLogWithRepsonseParam:paraments];
        }];
        dispatch_semaphore_signal(semaphore);

    });
    return YES;
}



#pragma mark - currentEdition
- (NSString *)currentEdition {
    NSString *info = [NSString stringWithFormat:@"版本:%@ 时间:2018.2.11",sdkversionValue];
    NSLog(@"%@", info);
    return info;
}


- (void)freeDataAuthWithSuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
#ifdef CELLULARFREE

    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        int authType = [self getAuthType];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"freeDataAuth" requestParm:nil authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        __block BOOL isBlocked = NO;
        dispatch_source_t timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
            failBlock(paraments);
            isBlocked = YES;
        }];
        [FreeDataAuthMode freeDataAuthWithTraceId:traceId successBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        } failBlock:^(NSDictionary *paraments) {
            [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
        }];

    });
#else
    return;
#endif

}


#pragma mark - 无缓存一键登录
- (void)getAccessTokenNoCacheWithLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }

    dispatch_async(tokenQueue, ^{
        long waitRes = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"start no cache 一键登录 with %d",waitRes);
        int authType = [self getAuthType];
        IDMPCoreEngine *coreEngine = [IDMPCoreEngine new];
        NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",(unsigned long)loginType], @"loginType", nil];
        NSString *traceId = [[NSString idmp_getClientNonce] uppercaseString];
        IDMPLogReportMode *logReportMode = [[IDMPLogReportMode alloc] initLogWithrequestType:@"getAccessTokenNoCache" requestParm:requestParam authType:authType traceId:traceId];
        if (authType < 0) {
            [self authFailWithLogReportMode:logReportMode finishBlock:failBlock];
            return;
        }
        dispatch_source_t timer;
        __block BOOL isBlocked = NO;
        if (loginType != 2) {
            timer = [self addTimer:logReportMode finishBlock:^(NSDictionary *paraments) {
                failBlock(paraments);
                isBlocked = YES;
            }];
        }

        [coreEngine noCacheLoginWithLoginType:loginType traceId:traceId successBlock:^(NSDictionary *paraments) {
            if (loginType != 2) {
                dispatch_source_cancel(timer);
            }
            [self finishTokenSuccessBlock:successBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
        } failBlock:^(NSDictionary *paraments) {
            if (loginType != 2) {
                [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode cancelTimer:timer];
            } else {
                [self finishWithBlock:failBlock param:paraments isBlocked:isBlocked logReportMode:logReportMode];
            }
        }];


    });
}

#pragma mark - private method
//增加网络异常回调
- (void)authFailWithLogReportMode:(IDMPLogReportMode *)logReportMode finishBlock:(accessBlock)finishBlock {
    NSDictionary *res = @{IDMPResCode:@"102101",IDMPResStr:@"手机无网络"};
    finishBlock(res);
    dispatch_semaphore_signal(semaphore);
    [logReportMode reportLogWithRepsonseParam:res];
}



//增加计时器超时回调
- (dispatch_source_t )addTimer:(IDMPLogReportMode *)logReportMode finishBlock:(accessBlock)finishBlock {
    return [self doIDMPTimeOut:^(NSDictionary *paraments) {
        finishBlock(paraments);
        dispatch_semaphore_signal(semaphore);
        [logReportMode reportLogWithRepsonseParam:paraments];
        return;
    }];
}

- (dispatch_source_t)doIDMPTimeOut:(accessBlock)failBlock {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"TIME OUT");
        failBlock(@{IDMPResCode:@"102400",IDMPResStr:@"统一认证响应超时"});
        dispatch_source_cancel(timer);
    });
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel timer");
    });
    dispatch_resume(timer);
    return timer;

}

//回调token获取结果
- (void)finishTokenSuccessBlock:(accessBlock)block param:(NSDictionary *)param isBlocked:(BOOL)isBLocked logReportMode:(IDMPLogReportMode *)logReportMode  {
    if(isBLocked) {
        return;
    }
    block(param);
    NSDictionary *reportDic = [NSDictionary dictionaryWithObjectsAndKeys:param[IDMPResCode],IDMPResCode,param[IDMPPassID],IDMPPassID,param[IDMPResStr],IDMPResStr, nil];
    dispatch_semaphore_signal(semaphore);
    [logReportMode reportLogWithRepsonseParam:reportDic];
    return;
}

//回调结果
- (void)finishWithBlock:(accessBlock)block param:(NSDictionary *)param isBlocked:(BOOL)isBLocked logReportMode:(IDMPLogReportMode *)logReportMode {
    if (isBLocked) {
        return ;
    }
    block(param);
    dispatch_semaphore_signal(semaphore);
    [logReportMode reportLogWithRepsonseParam:param];
    return;
}

//回调结果并结束计时器
- (void)finishWithBlock:(accessBlock)block param:(NSDictionary *)param isBlocked:(BOOL)isBLocked logReportMode:(IDMPLogReportMode *)logReportMode cancelTimer:(dispatch_source_t)timer {
    dispatch_source_cancel(timer);
    if (isBLocked) {
        return;
    }
    block(param);
    dispatch_semaphore_signal(semaphore);
    [logReportMode reportLogWithRepsonseParam:param];
    return;
}




@end
