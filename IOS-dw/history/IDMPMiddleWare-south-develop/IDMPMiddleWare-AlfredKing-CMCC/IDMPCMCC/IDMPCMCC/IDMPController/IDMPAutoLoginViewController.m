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

NSMutableDictionary *CollectDeviceDataDictionary = nil;

@implementation IDMPAutoLoginViewController

static dispatch_queue_t tokenQueue ;


- (id)init
{
    static dispatch_once_t autoLoginOnceToken;
    self = [super init];
    if (self)
    {
          dispatch_once(&autoLoginOnceToken, ^{
          
              tokenQueue= dispatch_queue_create("token", NULL);
          
          });

        
    }
    return self;
}

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

- (void)checkCacheBeforeLoginUseWithUserName:(NSString *)userName hasPassword:(BOOL)hasPW LoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock)failBlock
{
    if (userName)
    {
        NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:userName ]];
        NSLog(@"user %@",user);
        if([user count]>0)
        {
            [self cacheUseWithUserName:userName hasPassword:hasPW
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
            NSMutableDictionary *user=[NSMutableDictionary dictionaryWithDictionary:[userInfoStorage getInfoWithKey:localUserName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                 [self cacheUseWithUserName:localUserName hasPassword:hasPW finishBlock:successBlock failBlock:failBlock];
            }
            else
            {
                NSDictionary *result = @{@"resultCode":@"102314"};
                failBlock(result);
                
            }
            
           
        }
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
        BOOL removeSucess=YES;
        if (users.count)
        {
            for (int i=0; i<users.count; i++)
            {
                if ([users[i]isKindOfClass:[NSDictionary class]])
                {
                    NSString *name = [users[i] objectForKey:@"userName"];
                    BOOL result= [userInfoStorage removeInfoWithKey:name];
                    if(!result)
                    {
                        removeSucess=NO;
                    }
                }
            }
        }
        if (removeSucess)
        {
            [users removeAllObjects];
            [userInfoStorage removeInfoWithKey:nowLoginUser];
            [userInfoStorage removeInfoWithKey:ksUpdateDate];
            [userInfoStorage setInfo:users withKey:userList];
            NSLog(@"清除缓存成功");
        }
    });
    return YES;

}

- (BOOL)cleanKeychainSSO
{
        NSMutableArray *users=[NSMutableArray arrayWithArray:[userInfoStorage getAppInfoWithKey:userList]];
        
        NSLog(@"userlist: %@",users);
        BOOL removeSucess=YES;
        if (users.count)
        {
            for (int i=0; i<users.count; i++)
            {
                if ([users[i]isKindOfClass:[NSDictionary class]])
                {
                    NSString *name = [users[i] objectForKey:@"userName"];
                    
                    BOOL result=[userInfoStorage removeAppInfoWithKey:name];
                    if(!result)
                    {
                        removeSucess=NO;
                    }

                }
            }
        }
        if (removeSucess)
        {
           [users removeAllObjects];
           [userInfoStorage removeAppInfoWithKey:nowLoginUser];
           [userInfoStorage removeAppInfoWithKey:ksUpdateDate];
           [userInfoStorage setAppInfo:users withKey:userList];
           NSLog(@"清除缓存成功");
        }
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
    NSString *currntNet=[IDMPDevice GetCurrntNet];
    BOOL isChinaMobile=[IDMPDevice checkChinaMobile];
    
    if ([currntNet isEqual:@"4g"] && isChinaMobile)
    {
        return 1;
    }
    else if( [IDMPDevice simExist]&&currntNet!=nil&& isChinaMobile)
    {
        return 2;
    }
    else if(currntNet!=nil)
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
    if (loginType!= 1&&loginType!= 2)
    {
        NSDictionary *result = @{@"resultCode":@"102205"};
        failBlock(result);
        return;
    }

    
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        
      @autoreleasepool {
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
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString
            finishBlock:^(NSDictionary *paraments)
            {
                @autoreleasepool {
                
                [self noCacheLoginByConditionWithUserName:userName andPassWd:content LoginType:loginType  successBlock:successBlock failBlock:failBlock];
                }
                

            }
            failBlock:^(NSDictionary *paraments)
            {
                
                
                failBlock(paraments);
                
            }];

        }
        else
        {
            [self noCacheLoginByConditionWithUserName:userName andPassWd:content LoginType:loginType  successBlock:successBlock failBlock:failBlock];
        }
      }
        
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
    if (loginType!= 1&&loginType!= 2)
    {
        NSLog(@"logintype error");
        NSDictionary *result = @{@"resultCode":@"102205"};
        failBlock(result);
        return;
    }

    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
    @autoreleasepool {
        
    [userInfoStorage setInfo:noSip withKey:sipFlag];
        
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
            
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString   finishBlock:^(NSDictionary *paraments) {
                
            @autoreleasepool {
            [self noCacheLoginByConditionWithUserName:userName andPassWd:content LoginType:loginType  successBlock:successBlock failBlock:failBlock];
                
            }
                
                
            }
            failBlock:^(NSDictionary *paraments)
             {
                 
                 failBlock(paraments);
                 
                 
             }];
            
        }
        else
        {
            [self noCacheLoginByConditionWithUserName:userName andPassWd:content LoginType:loginType  successBlock:successBlock failBlock:failBlock];
        }
        
    }
    
    });
   

}

-(void)getAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    if (loginType!= 1&&loginType!= 2)
    {
        NSDictionary *result = @{@"resultCode":@"102205"};
        failBlock(result);
        return;
    }

    
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
       
        @autoreleasepool {
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
            
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString
        finishBlock:^(NSDictionary *paraments) {
            
            @autoreleasepool {
         [self checkCacheBeforeLoginUseWithUserName:userName hasPassword:NO LoginType:loginType isUserDefaultUI:NO finishBlock:successBlock failBlock:failBlock];
            }
            

            }
            failBlock:^(NSDictionary *paraments)
            {
               
               failBlock(paraments);

            }];
           
        }
        else
        {
        
        [self checkCacheBeforeLoginUseWithUserName:userName hasPassword:NO LoginType:loginType isUserDefaultUI:NO finishBlock:successBlock failBlock:failBlock];
        }
     }
        
    });
}



-(void)getAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger)loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    if (loginType!= 1&&loginType!= 2)
    {
        NSDictionary *result = @{@"resultCode":@"102205"};
        failBlock(result);
        return;
    }

    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
    @autoreleasepool {
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
        NSMutableDictionary *user;
        NSString *ischecked=[userInfoStorage getInfoWithKey:isChecked];
        if(![ischecked isEqualToString:yesFlag])
        {
            
            [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
            {
               @autoreleasepool {
                [self checkCacheBeforeLoginUseWithUserName:userName hasPassword:YES LoginType:loginType isUserDefaultUI:YES finishBlock:successBlock failBlock:failBlock];
               }
               
            }
            failBlock:^(NSDictionary *paraments)
            {
                               failBlock(paraments);
                
            }];
            
            
        }
        else
        {
           [self checkCacheBeforeLoginUseWithUserName:userName hasPassword:YES LoginType:loginType isUserDefaultUI:YES finishBlock:successBlock failBlock:failBlock];
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
    IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
    if(![ischecked isEqualToString:yesFlag])
    {
        
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString  finishBlock:^(NSDictionary *paraments) {
            @autoreleasepool {
            
           [accountManager registerUserWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
            }
           

        }
        failBlock:^(NSDictionary *paraments)
        {
            
            
            failBlock(paraments);
            
        } ];
        
    }
    else
    {

    
    [accountManager registerUserWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
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
    
    IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
    if(![ischecked isEqualToString:yesFlag])
    {
        
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
        {
           @autoreleasepool {
           [accountManager resetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
           }
            
        }
        failBlock:^(NSDictionary *paraments)
        {
           
           
            failBlock(paraments);
           
        }];
    }
    else
    {
    
     [accountManager resetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
    }

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
   IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
       
    if(![ischecked isEqualToString:yesFlag])
    {
        
        [IDMPQueryModel checkWithAppId:appidString andAppkey:appkeyString finishBlock:^(NSDictionary *paraments)
        {
            @autoreleasepool {
            [accountManager changePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
            }
            
        }
        failBlock:^(NSDictionary *paraments)
        {
           
            
            failBlock(paraments);
            
        }];
        
    }
    else
    {
    
    [accountManager changePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
    }

    });
}


- (void)currentEdition
{
   
    NSLog(@"版本:andidmp-iosv1.12.2  时间:2016.11.29");
    
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
    NSString *newNumber=secRSA_Decrypt(localNumber);
    newNumber=[newNumber substringWithRange:NSMakeRange(2,11)];
    NSLog(@"newNumber :%@",newNumber);

    if ([resultCode isEqual: @"103000"] && ![newNumber isEqual: userName]&&![IDMPFormatTransform checkNSStringisNULL:newNumber] )
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


- (void)validateWithAppid:(NSString *)appid appkey:(NSString *)appkey timeoutInterval:(float)aTime finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock
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
    if (!tokenQueue)
    {
        tokenQueue= dispatch_queue_create("token", NULL);
    }
    dispatch_async(tokenQueue, ^{
        
        //全新安装需要清除keychain数据
        NSString *lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:@"secCmccLastVersion"];
         NSString *currentVersion=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!lastVersion)
        {
            [self cleanKeychainSSO];
            
        }
        //更新lastVersion
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"secCmccLastVersion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        

            
            // 如果有旧版本的缓存，先将缓存加密存储再使用
            NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
            NSLog(@"last version storage userlist: %@",users);
            if (users.count)
            {
                [IDMPParseParament changeDataStorage];
            }
            [userInfoStorage setInfo:appid withKey:IDMP_APPIDsk];
            [userInfoStorage setInfo:appkey withKey:IDMP_APPKEYsk];
            [userInfoStorage setInfo:@(aTime) withKey:secDataSmsHttpTimesk];
            [userInfoStorage setInfo:yesFlag withKey:currentIsDomain];
            [userInfoStorage setInfo:NorthForwardwapURL withKey:secwapURL];
            
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
        if ((int)([[NSDate date] timeIntervalSince1970] + timezoneFix) -
            (int)([ksupdatedate timeIntervalSince1970] + timezoneFix)
            > 86400)
       
        {
            NSLog(@"ksupdate exceeded for one day");
            
            NSLog(@"fetch new ks");
            NSString *version = [IDMPDevice getAppVersion];
            
            NSString *clientNonce = [IDMPNonce getClientNonce];
            
            NSString *encryptClientNonce= secRSA_Encrypt(clientNonce);
            
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
            [request getAsynWithHeads:heads url:updateUrl timeOut:20
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
                 if (resultCode==IDMPResultCodeRecentlyUpdated)
                 {
                     successBlock();
                     [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
                 }
                 else if (resultCode==nil)
                 {
                      successBlock();
                 }
                 else
                 {
                     [self cleanSSO];
                     NSDictionary *result = @{@"resultCode":[request.responseHeaders objectForKey:@"resultCode"]};
                     failBlock(result);
                 }
                 
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
