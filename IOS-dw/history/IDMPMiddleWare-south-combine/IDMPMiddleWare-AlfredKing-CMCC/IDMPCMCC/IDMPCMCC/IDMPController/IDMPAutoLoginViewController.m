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
#import  "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPNonce.h"


NSMutableDictionary *CollectDeviceDataDictionary = nil;

@implementation IDMPAutoLoginViewController

dispatch_queue_t tokenQueue ;



- (void)noCacheLoginByConditionWithUserName:(NSString *)userName andPassWd:(NSString *)content LoginType:(NSInteger)loginType  successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    
    switch (loginType)
    {
        case 1:
        {
            IDMPUPMode *upMode=[[IDMPUPMode alloc]init];
            [upMode getUPKSByUserName:userName andPassWd:content successBlock:successBlock failBlock:failBlock];
        }
            
            break;
        case 2:
        {
            IDMPTempSmsMode *tsMode=[[IDMPTempSmsMode alloc]init];
            [tsMode getTMKSWithUserName:userName messageCode:content successBlock:successBlock failBlock:failBlock];
        }
            break;
        default:
            break;
    }
}


- (void)noCacheLoginWithUserName:(NSString *)userName LoginType:(NSInteger)loginType  isUserDefaultUI:(BOOL)isUserDefaultUI successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    
    if ([self getAuthType] > loginType)
    {
        NSLog(@"支持类型:%d  传入类型:%d",[self getAuthType] ,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }
    
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    switch (loginType)
    {
        case 1:
        {
            [wapMode getWapKSWithSuccessBlock: successBlock
                                    failBlock:failBlock];
        }
            break;
        case 2:
        {
            IDMPDataSMSMode *dataSMS=[[IDMPDataSMSMode alloc]init];
            [dataSMS getDataSmsKSWithSuccessBlock:successBlock
                                        failBlock:failBlock ];
        }
            break;
        default:
            break;
    }
}

- (void)cacheUseWithUserName:(NSString *)userName hasPassword:(BOOL)hasPW finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock

{
    NSMutableDictionary  *__block resultInfo = nil;
    NSLog(@"使用缓存");
    [self updateKSEverdayWithUserName:userName finishBlock:^
     {
         
         NSLog(@"update success");
         NSString *sourceID=[userInfoStorage getInfoWithKey:sourceIdsk];
         NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName]];
         NSLog(@"cacheUseWithUserName user is %@",user);
         NSString *passId=[user objectForKey:@"passid"];
         NSString *Token;
         Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceID];
         
         if (hasPW)
         {
             [IDMPQueryModel queryAppPasswdWithUserName:userName
                                            finishBlock:^(NSDictionary *paraments)
              {
                  
                  NSString *passwd=[paraments objectForKey:sipPassword];
                  resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid",@"102000",@"resultCode",passwd,sipPassword, nil];
                  successBlock(resultInfo);
                  
                  
              }
                                              failBlock:^(NSDictionary *paraments)
              {
                  NSString *passwd=[paraments objectForKey:sipPassword];
                  NSString *resultcode=[paraments objectForKey:@"resultCode"];
                  resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid",resultcode,@"resultCode",passwd,sipPassword, nil];
                  failBlock(resultInfo);
                  
                  
              }];
             
             
         }
         else
         {
             resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",passId,@"passid" ,@"102000",@"resultCode", nil];
             successBlock(resultInfo);
             
             
         }
         
     }
                            failBlock:^(NSDictionary *paraments)
     {
         
         failBlock(paraments);
         
     }];
    
    
}

- (NSString *)getLocalUserName
{
    NSMutableArray *users=[NSMutableArray arrayWithArray:[userInfoStorage getInfoWithKey:userList]];
    
    NSLog(@"userList is %@",users);
    for (NSDictionary *user in users)
    {
        if ([[user objectForKey:@"isLocalNum"] boolValue])
        {
            return [user objectForKey:@"userName"];
        };
    }
    return nil;
}



- (BOOL)cleanSSO
{
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    
    dispatch_async(tokenQueue, ^{
        NSMutableArray *users=[NSMutableArray arrayWithArray:[userInfoStorage getInfoWithKey:userList]];
        
        NSLog(@"userlist: %@",users);
        if (users.count)
        {
            for (int i=0; i<users.count; i++)
            {
                if ([users[i]isKindOfClass:[NSDictionary class]])
                {
                    NSString *name = [users[i] objectForKey:@"userName"];
                    
                    [userInfoStorage removeInfoWithKey:name];
                }
            }
        }
        [users removeAllObjects];
        [userInfoStorage removeInfoWithKey:nowLoginUser];
        [userInfoStorage setInfo:users withKey:userList];
        NSLog(@"清除缓存成功");
    });
    return YES;
}

- (BOOL)cleanSSOWithUserName:(NSString *)userName
{
    if (!tokenQueue) {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[userInfoStorage getInfoWithKey: userList]];
        
        if (accounts)
        {
            for (int i=0; i<accounts.count; i++)
            {
                if ([[accounts[i] objectForKey:@"userName"]isEqualToString:userName])
                {
                    [accounts removeObjectAtIndex:i];
                    
                    [userInfoStorage removeInfoWithKey:userName];
                    break;
                }
            }
            [userInfoStorage setInfo:accounts withKey:userList];
            NSString *nowUser=[userInfoStorage getInfoWithKey:nowLoginUser];
            
            if ([nowUser isEqualToString:userName])
            {
                [userInfoStorage removeInfoWithKey:nowLoginUser];
            }
        }
    });
    return YES;
}




- (int)getAuthType
{
    if ([[IDMPDevice GetCurrntNet] isEqual:@"4g"] && [IDMPDevice checkChinaMobile])
    {
        return 1;
    }
    else if([IDMPDevice simExist] &&[IDMPDevice GetCurrntNet]!=nil&& [IDMPDevice checkChinaMobile])
    {
        return 2;
    }
    else if([IDMPDevice GetCurrntNet]!=nil)
    {
        return 3;
    }
    else
    {
        return -1;
    }
}


-(void)getAppPasswordByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock
{
    
    if (userName.length == 0)
    {
        NSDictionary *result = @{@"resultCode":@"102303"};
        failBlock(result);
        return;
    }
    
    if (content.length == 0)
    {
        NSDictionary *result = @{@"resultCode":@"102304"};
        failBlock(result);
        return;
    }
    
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        [userInfoStorage setInfo:isSip withKey:sipFlag];
        
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked];
        if(![ischecked isEqualToString:yesFlag])
        {
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString            finishBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 
                 
             }
                                 failBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
                 
             }];
            
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
            
        }
        [self noCacheLoginByConditionWithUserName:userName andPassWd:content LoginType:loginType  successBlock:successBlock failBlock:failBlock];
    });
}

-(void)getAccessTokenByConditionWithUserName:(NSString *)userName Content:(NSString *)content andLoginType:(NSUInteger)loginType finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    if (userName.length == 0)
    {
        NSDictionary *result = @{@"resultCode":@"102303"};
        failBlock(result);
        return;
    }
    
    if (content.length == 0)
    {
        NSDictionary *result = @{@"resultCode":@"102304"};
        failBlock(result);
        return;
    }
    
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        [userInfoStorage setInfo:noSip withKey:sipFlag];
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked];
        
        if(![ischecked isEqualToString:yesFlag])
        {
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments){ dispatch_semaphore_signal(disp);
            } failBlock:
             ^(NSDictionary *paraments)
             {
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
             } ];
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        }
        
        
        
        
        [self noCacheLoginByConditionWithUserName:userName andPassWd:content LoginType:loginType  successBlock:successBlock failBlock:failBlock];
    });
}

-(void)getAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        
        [userInfoStorage setInfo:noSip withKey:sipFlag ];
        
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked ];
        
        
        if(![ischecked isEqualToString:yesFlag])
        {
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString   finishBlock:^(NSDictionary *paraments) {
                dispatch_semaphore_signal(disp);
                
                
            }
                                 failBlock:^(NSDictionary *paraments)
             {
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
                 
                 
             }];
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
            
        }
        
        if (userName)
        {
            NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName ]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                [self cacheUseWithUserName:userName hasPassword:NO
                               finishBlock:successBlock failBlock:failBlock];
                
                
            }
            else
            {
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
                
            }
        }
        
        else
        {
            NSString *localUserName = [self getLocalUserName];
            if (localUserName == nil)
            {
                
                [self noCacheLoginWithUserName:localUserName LoginType:loginType  isUserDefaultUI:isUserDefaultUI successBlock:  successBlock failBlock:failBlock];
                
            }
            else
            {
                
                [self cacheUseWithUserName:localUserName hasPassword:NO finishBlock:successBlock failBlock:failBlock];
            }
        }
        
        
    });
}



-(void)getAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        [userInfoStorage setInfo:isSip withKey:sipFlag ];
        NSMutableDictionary *user;
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked];
        if(![ischecked isEqualToString:yesFlag])
        {
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 
             }
             failBlock:^(NSDictionary *paraments)
             {
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
                 
             }];
            
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        }
        if (userName)
        {
            user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                [self cacheUseWithUserName:userName hasPassword:YES finishBlock:
                 successBlock failBlock:failBlock];
                
                
            }
            else
            {
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
                
            }
        }
        else
        {
            
            NSString *localUserName = [self getLocalUserName];
            if (localUserName == nil)
            {
                [self noCacheLoginWithUserName:localUserName LoginType:loginType isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
                
            }
            else
            {
                [self cacheUseWithUserName:localUserName hasPassword:YES finishBlock:                            successBlock failBlock:failBlock];
                
            }
            
            
        }
    });
}



- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    if (phoneNo.length == 0 || password.length == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock) {
            failBlock(dic);
        }
        return;
    }
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        
        
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked ];
        dispatch_semaphore_t disp = dispatch_semaphore_create(0);
        
        
        if(![ischecked isEqualToString:yesFlag])
        {
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString  finishBlock:^(NSDictionary *paraments) {
                
                dispatch_semaphore_signal(disp);
                
                
            }
                                 failBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
                 
             } ];
            
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
            
        }
        
        ischecked=[userInfoStorage getInfoWithKey:isChecked ];
        
        if([ischecked isEqualToString:yesFlag]){
            IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
            [accountManager registerUserWithAppId:appidString AppKey:appkeyString phoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
            
        }
        else
        {
            
            NSLog(@"应用合法性校验失败");
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102298"};
                failBlock(result);
                return;
            }
        }
    });
}


- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    
    if (phoneNo.length == 0 || password.length == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock)
        {
            failBlock(dic);
        }
        return;
    }
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked ];
        
        
        if(![ischecked isEqualToString:yesFlag])
        {
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 
             }
                                 failBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
                 
             }];
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        }
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager resetPasswordWithAppId:appidString AppKey:appkeyString phoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
        
    });
}

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    
    if (phoneNo.length == 0 || password.length == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock)
        {
            failBlock(dic);
        }
        return;
    }
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked];;
        
        
        if(![ischecked isEqualToString:yesFlag])
        {
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 
             }
                                 failBlock:^(NSDictionary *paraments)
             {
                 
                 dispatch_semaphore_signal(disp);
                 failBlock(paraments);
                 return ;
                 
             }];
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        }
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager changePasswordWithAppId:appidString AppKey:appkeyString phoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
        
    });
}


- (void)currentEdition
{
    
    
    NSLog(@"版本:andidmp-iosv1.9.8  时间:2016.08.04");
    [self updateKSEverdayWithUserName:@"15868178826" finishBlock:^{
        NSLog(@"success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail %@",paraments);
    }];
    NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"test",@"info", nil];
    NSData *result = [NSKeyedArchiver archivedDataWithRootObject:userInfo] ;
    [result writeToFile:NSHomeDirectory() atomically:NO];
    [[NSKeyedArchiver alloc] finishEncoding];
//    NSData *userData = [NSData dataWithContentsOfFile:NSHomeDirectory() ];
    
    
//    NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    
}



//请在子线程中调用
-(BOOL)checkIsLocalNumberWith:(NSString *)userName
{
    NSLog(@"check localnumber");
    if ([self getAuthType] != 1)
    {
        NSLog(@"check localnumber yes");
        return YES;
        NSLog(@"check localnumber yes");
    }
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:localUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request1.allHTTPHeaderFields = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *response= [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"PASSWORD QUERY error:%@",[error localizedDescription]);
    int statusCode = (int)[urlResponse statusCode];
    NSLog(@"statusCode is %d",statusCode);
    if (statusCode != 200) {
        NSLog(@"check localnumber yes");
        return YES;
        NSLog(@"check localnumber yes");
    }
    NSDictionary *queryResult = [NSJSONSerialization JSONObjectWithData:response options: NSJSONReadingMutableLeaves error: &error];
    NSLog(@"queryresult :%@",queryResult);
    NSString *localNumber = [queryResult objectForKey:@"mobile"];
    NSString *resultCode = [queryResult objectForKey:@"resultCode"];
    if ([IDMPFormatTransform checkNSStringisNULL:localNumber]) {
        return YES;
    }
    NSLog(@"localNumber :%@",localNumber);
    NSLog(@"resultCode :%@",resultCode);
    NSString *newNumber=RSA_decrypt(localNumber);
    newNumber=[newNumber substringWithRange:NSMakeRange(2,11)];
    NSLog(@"newNumber :%@",newNumber);
    if ([resultCode isEqual: @"103000"] && ![newNumber isEqual: userName])
    {
        NSLog(@"is not same");
        NSLog(@"check localnumber no");
        return NO;
    }
    else
    {
        NSLog(@"check localnumber yes");
        return YES;
    }
}


- (void)initWithAppid:(NSString *)appid Appkey:(NSString *)appkey TimeoutInterval:(float)aTime finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock
{
    
    NSLog(@"init with appid start");
    
    if (appid.length == 0 || appkey.length == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock)
        {
            failBlock(dic);
        }
        return;
    }
    
    NSLog(@"appid :%@,appkey :%@",appid,appkey);
    [userInfoStorage setInfo:appid withKey:IDMP_APPIDsk];
    [userInfoStorage setInfo:appkey withKey:IDMP_APPKEYsk];
    [userInfoStorage setInfo:@(aTime) withKey:secDataSmsHttpTimesk];
    [userInfoStorage setInfo:domainURL withKey:secCurrentURL];
    [userInfoStorage setInfo:domainPort withKey:secCurrentPort];
    [userInfoStorage setInfo:NorthForwardwapURL withKey:secwapURL];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self getAuthType] < 0)
        {
            if (failBlock)
            {
                NSDictionary *result = @{@"resultCode":@"102101"};
                failBlock(result);
            }
            return;
        }
        
        [IDMPQueryModel checkWithAppId:appid andAppkey:appkey finishBlock:successBlcok failBlock:failBlock];
    });
}



-(void)updateKSEverdayWithUserName:(NSString *)userName finishBlock:(IDMPBlock) successBlock failBlock:(accessBlock)failBlock

{
    NSLog(@"update ks start ");
    NSDate *ksupdatedate=[userInfoStorage getInfoWithKey:ksUpdateDate];
    NSLog(@"ksupdate time is %@",ksupdatedate);
    if (ksupdatedate)
    {
        NSLog(@"ksupdate date  is not null");
        double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
        if ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(86400)) -
            (int)(([ksupdatedate timeIntervalSince1970] + timezoneFix)/(86400))
            > 0)
        {
            NSLog(@"ksupdate exceeded for one day");
            
            NSLog(@"fetch new ks");
            NSString *version = [IDMPDevice getAppVersion];
            
            NSString *clientNonce = [IDMPNonce getClientNonce];
            
            NSString *encryptClientNonce= RSA_encrypt(clientNonce);
            
            NSString *sip=[userInfoStorage getInfoWithKey:sipFlag];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
            NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
            
            NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName]];
            NSString *BTID;
            if([user count]>0)
            {
                BTID = [user objectForKey:ksBTID];
            }
            else
            {
                NSLog(@"缓存不存在");
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
                return;
            }
            
            NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", updateKSClientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sipEncFlag,@"1",ksBTID,BTID,sipFlag,sip,ksEnClientNonce,encryptClientNonce,ksIOS_ID,[IDMPDevice getDeviceID],systemTime,currentDateStr,httpsFlag,yesFlag];
            
            
            NSString *Signature = RSA_EVP_Sign(authorization);
            NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksAuthorization,Signature,ksSignature, nil];
            IDMPHttpRequest *request = [[IDMPHttpRequest alloc] init];
            NSLog(@"updateKSEverdayWithUserName heads:%@",heads);
            [request getAsynWithHeads:heads url:requestUrl timeOut:20
                         successBlock:
             ^{
                 NSDictionary *responseHeaders=request.responseHeaders;
                 NSLog(@"updateKSEverdayWithUserName %@",responseHeaders);
                 [IDMPUPMode checkUpdateKSIsValid:responseHeaders userName:userName clientNonce:clientNonce];
                 [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
                 successBlock();
                 
             }
                            failBlock:
             ^{
                 NSDictionary *responseHeaders=request.responseHeaders;
                 NSLog(@"updateks failBlock %@",responseHeaders);
                 NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
                 if (resultCode!=nil&resultCode!=IDMPResultCodeSuccess&resultCode!=IDMPResultCodeRecentlyUpdated)
                 {
                     [self cleanSSO];
                     NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                     failBlock(result);
                 }
                 NSLog(@"http fail");
             }];
            
            
            
        }
        else
        {
            
            successBlock();
        }
        
    }
    else
    {
        successBlock();
    }
    
    
    
}



@end
