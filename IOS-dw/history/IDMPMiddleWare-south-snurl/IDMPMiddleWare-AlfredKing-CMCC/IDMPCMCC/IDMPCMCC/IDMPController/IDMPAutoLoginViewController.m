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
#import "IDMPUPViewController.h"
#import "IDMPHttpRequest.h"
#import "IDMPLoadingView.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPParseParament.h"
#import "IDMPUPMode.h"
#import "IDMPTempSmsMode.h"
#import "IDMPAccountManagerMode.h"
#import "IDMPAES128.h"
#import "IDMPListUserView.h"
#import "OpenUDID.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPDevice.h"


NSMutableDictionary *NotNormalDictionary = nil;
NSMutableDictionary *CollectDeviceDataDictionary = nil;

@implementation IDMPAutoLoginViewController

- (NSString *)queryAppPasswdWithUserName:(NSString *)userName
{
    NSLog(@"query apppassword start ");
    NSLog(@"query password network status  %d",[self getAuthType]);
    NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", requestAppPsd,@"100000",ksUserName,userName,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
    NSString *Signature = RSA_EVP_Sign(Query);
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:qapUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request1.allHTTPHeaderFields = heads;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"PASSWORD QUERY error:%@",[error localizedDescription]);
    NSDictionary *response=urlResponse.allHeaderFields;
    NSLog(@"PASSWORD QUERY %@",response);
    NSString *query = [response objectForKey:@"Query-Result"];
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
    NSString *apppassword= [parament objectForKey:@"appPassword"];
    return apppassword;
}

- (void)checkWithAppId:(NSString *)Appid andAppkey:(NSString *)Appkey finishBlock:(accessBlock)successBlock failBlock:(accessBlock )failBlock
{
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:isChecked];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"query appid start ");
    NSLog(@"query appid network status  %d",[self getAuthType]);
    NSString *checked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if (![checked isEqualToString:@"1"])
    {
        NSString *Query=[NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"",requestAppid,Appid,ksClientversion,[IDMPDevice getAppVersion],sdkversion,sdkversionValue,ksIOS_ID,[IDMPDevice getDeviceID]];
        NSString *Signature = RSA_EVP_Sign(Query);
        NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:Query,sourceidKey, Signature,ksSignature, nil];
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
        NSLog(@"heads:%@",heads);
        [request getWithHeads:heads url:appCheckUrl successBlock:^{
            NSDictionary *response=request.responseHeaders;
            NSLog(@"查询appid 结果 %@",response);
            NSInteger resultCode = [[response objectForKey:ksResultCode] integerValue];
            if(resultCode==IDMPResultCodeSuccess)
            {
                NSString *query = [response objectForKey:@"Query-Result"];
                NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
                NSString *serverEncAppid = [parament objectForKey:eAppid];
                NSLog(@"server appid %@",serverEncAppid);
                
                NSData *temp=[IDMPAES128 AESEncryptWithKey:Appkey andData:Appid];
                NSString *localEncAppid= [IDMPAES128 base64EncodingWithData:temp];
                NSLog(@"local appid %@",localEncAppid);
                if ([localEncAppid isEqualToString:serverEncAppid])
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:isChecked];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self resultCodeSuccessWithResponse:response];
                    
                    if (successBlock)
                    {
                        NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:[response objectForKey:ksResultCode],ksResultCode, nil];
                        successBlock(resultCode);
                    }
                }
                else
                {
                    NSLog(@"appkey/appid 错误");
                }
            }
            else
            {
                NSLog(@"resultcode fail");
            }
        } failBlock:^{
            NSLog(@"查询appid 结果 %@",request.responseHeaders);
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"103119",@"resultCode", nil];
            failBlock(resultCode);
        }];
    }
}

- (void)cacheNoUseByConditionWithLoginType:(NSInteger)loginType UserName:(NSString *)userName andPassWd:(NSString *)content successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");

    IDMPUPMode *upMode=[[IDMPUPMode alloc]init];
    IDMPTempSmsMode *tsMode=[[IDMPTempSmsMode alloc]init];
    switch (loginType)
    {
        case 1:
        {
            [upMode getUPKSByUserName:userName andPassWd:content successBlock:successBlock failBlock:^(NSDictionary *wapFail){
                 failBlock(wapFail);
                 NSLog(@"up fail!");
             }];
        }
            
            break;
        case 2:
        {
            [tsMode getTMKSWithUserName:userName messageCode:content successBlock:successBlock failBlock:^(NSDictionary *wapFail){
                 NSLog(@"msg fail");
                 failBlock(wapFail);
             }];
        }
            break;
        default:
            break;
    }
    
}

- (void)cacheNoUseWithLoginType:(NSInteger)loginType UserName:(NSString *)userName isUserDefaultUI:(BOOL)isUserDefaultUI successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    if ([self getAuthType] > loginType)
    {
        NSLog(@"比较%d  %d",[self getAuthType] ,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    __weak int LoginType=loginType;
    if (!LoginType)
    {
        LoginType=[self getAuthType];
        NSLog(@"loginType is:%d",LoginType);
    }
    switch (LoginType)
    {
        case 1:
        {
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 IDMPDataSMSMode *dataSMS=[[IDMPDataSMSMode alloc]init];
                 [dataSMS getDataSmsKSWithSuccessBlock:successBlock
                                             failBlock:
                  ^(NSDictionary *smsFail){
                      NSLog(@"1 datasms fail!");
                      NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                      NSLog(@"resultCode:%@",resultCode);
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (isUserDefaultUI)
                          {
                              IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                              [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                          }
                          else
                          {
                              NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                              failBlock(notUserDefaultUI);
                          }
                          
                      });
                  }];
             }];
        }
            break;
        case 2:
        {
            IDMPDataSMSMode *dataSMS=[[IDMPDataSMSMode alloc]init];
            [dataSMS getDataSmsKSWithSuccessBlock:(accessBlock)successBlock
                                        failBlock:
             ^(NSDictionary *smsFail){
                 NSLog(@"2 datasms fail!");
                 NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                 NSLog(@"resultCode:%@",resultCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (isUserDefaultUI)
                     {
                         IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                         [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                     }
                     else
                     {
                         NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                         failBlock(notUserDefaultUI);
                     }
                 });
             }];
        }
            break;
        case 3:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isUserDefaultUI)
                {
                    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                    [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                }
                else
                {
                    NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                    failBlock(notUserDefaultUI);
                }
            });
        }
            break;
        default:
            break;
    }
    
}

- (void)autoGoAndCacheNoUseWithLoginType:(NSInteger)loginType UserName:(NSString *)userName isUserDefaultUI:(BOOL)isUserDefaultUI successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"不使用缓存");
    if ([self getAuthType] > loginType)
    {
        NSLog(@"比较%d  %d",[self getAuthType] ,loginType);
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:@"102205",@"resultCode", nil];
        failBlock(result);
        return;
    }
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    __weak int LoginType=loginType;
    switch (LoginType)
    {
        case 1:
        {
            [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
             {
                 successBlock(paraments);
             }
                                    failBlock:
             ^(NSDictionary *wapFail){
                 NSLog(@"wap fail!");
                 NSString *resultCode = [wapFail objectForKey:@"resultCode"];
                 NSLog(@"wap resultCode:%@",resultCode);
                 failBlock(wapFail);
             }];
        }
            break;
        case 2:
        {
            IDMPDataSMSMode *dataSMS=[[IDMPDataSMSMode alloc]init];
            [dataSMS getDataSmsKSWithSuccessBlock:(accessBlock)successBlock
                                        failBlock:
             ^(NSDictionary *smsFail){
                 NSLog(@"datasms fail!");
                 NSString *resultCode = [smsFail objectForKey:@"resultCode"];
                 NSLog(@"datasms resultCode:%@",resultCode);
                 failBlock(smsFail);
             }];
        }
            break;
        case 3:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isUserDefaultUI)
                {
                    IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                    [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                }
                else
                {
                    NSDictionary *notUserDefaultUI = [NSDictionary dictionaryWithObjectsAndKeys:@"please user your custom UI",@"UIFaill", nil];
                    failBlock(notUserDefaultUI);
                }
            });
        }
            break;
        default:
            break;
    }
    
}

- (NSDictionary *)cacheUseWithUserName:(NSString *)userName hasPassword:(BOOL)hasPW
{
    NSLog(@"使用缓存");
    
    NSString *sourceID=[[NSUserDefaults standardUserDefaults] objectForKey:source];
    
    
    NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userName]];
    NSString *passId=[user objectForKey:@"passid"];
    NSString *Token;
    
    Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceID];
    NSMutableDictionary *resultInfo = nil;
    if (hasPW)
    {
        NSString *passwd=[self queryAppPasswdWithUserName:userName];
        if (passwd == nil)
        {
            resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid",@"102102",@"resultCode",passwd,@"password", nil];
            
        }
        else
        {
            resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid",@"102000",@"resultCode",passwd,@"password", nil];
        }
    }
    else
    {
        resultInfo=[NSMutableDictionary dictionaryWithObjectsAndKeys:Token,@"token",userName,ksUserName,passId,@"passid" ,@"102000",@"resultCode", nil];
    }
    return resultInfo;
}

- (NSString *)getLocalUserNameWithisLocalNumber:(BOOL)isLocalNumber
{
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    
    NSLog(@"user is %@",users);
    for (NSDictionary *user in users)
    {
        if ([[user objectForKey:@"isLocalNum"]boolValue])
        {
            return [user objectForKey:@"userName"];
        };
    }
    return nil;
}

- (NSDictionary *)getAutoLoginInfo
{
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    __block NSDictionary *resultCode;
    [wapMode getWapKSWithSuccessBlock:^(NSDictionary *paraments)
     {
         resultCode = paraments;
     }
                            failBlock:
     ^(NSDictionary *wapFail){
         resultCode = wapFail;
     }];
    NSLog(@"result:%@",resultCode);
    return resultCode;
}

- (NSString *)getNowLoginUser
{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser];
}

-(BOOL)cleanSSO
{
    
    NSMutableArray *users=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
    
    NSLog(@"userlist: %@",users);
    if (users.count)
    {
        for (int i=0; i<users.count; i++)
        {
            if ([users[i]isKindOfClass:[NSDictionary class]])
            {
                NSString *name = [users[i]objectForKey:@"userName"];
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:name];
            }
        }
    }
    [users removeAllObjects];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:users forKey:userList];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:nowLoginUser];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"清除缓存成功");
    return YES;
}

-(BOOL) cleanSSOWithUserName:(NSString *)userName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *accounts =[NSMutableArray arrayWithArray:[user objectForKey:userList]];
    
    if (accounts)
    {
        for (int i=0; i<accounts.count; i++)
        {
            if ([[accounts[i] objectForKey:@"userName"]isEqualToString:userName])
            {
                [accounts removeObjectAtIndex:i];
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:userName];
            }
        }
        [user setObject:accounts forKey:userList];
        
        if ([[user objectForKey:nowLoginUser]isEqualToString:userName])
        {
            [user setObject:nil forKey:nowLoginUser];
        }
    }
    [user synchronize];
    return YES;
}

-(int )getAuthType
{
    if ([[IDMPDevice GetCurrntNet] isEqual:@"4g"] && [IDMPDevice checkChinaMobile])
    {
        return 1;
    }
    else if([IDMPDevice simExist] && [IDMPDevice connectedToNetwork] && [IDMPDevice checkChinaMobile])
    {
        return 2;
    }
    else if([IDMPDevice connectedToNetwork])
    {
        return 3;
    }
    else
    {
        return -1;
    }
}

- (NSArray *)getUsersWithHasNowAccount:(BOOL)hasNowAccount
{
    NSMutableArray *usersDict = [[NSUserDefaults standardUserDefaults]objectForKey:userList];
    NSString *nowLoginAccount = [[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser];
    
    NSLog(@"nowlogin:%@",nowLoginAccount);
    NSMutableArray *users = [[NSMutableArray alloc]init];
    for (NSDictionary *user  in usersDict)
    {
        [users addObject:[user objectForKey:@"userName"]];
    }
    if (hasNowAccount)
    {
        return users;
    }
    else
    {
        [users removeObject:nowLoginAccount];
        return users;
    }
}

- (void)changeAccountWithUserName:(NSString *)userName andFinishBlick:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"now:%@",[[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser]);
    NSLog(@"users:%@",[[NSUserDefaults standardUserDefaults]objectForKey:userList]);
    NSArray *users = [[NSUserDefaults standardUserDefaults]objectForKey:userList];
    
    if ([users count]==0)
    {
        NSDictionary *result = @{@"resultCode": @"102302"};
        failBlock(result);
        return;
    }
    IDMPListUserView *listV = [IDMPListUserView sharedView];
    NSArray *usersName = [[NSArray alloc]initWithArray:[self getUsersWithHasNowAccount:NO]];
    if (usersName.count > 0)
    {
        listV.userInfoArr = [NSMutableArray arrayWithArray:usersName];
        NSLog(@"userInfo:%@",listV.userInfoArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [listV showInView:[UIApplication sharedApplication].keyWindow.rootViewController];
            [listV.tableV reloadData];
        });
        listV.callBack = ^(NSDictionary *parament){
            NSString *changeUserName = [parament objectForKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:changeUserName forKey:nowLoginUser];
            [[NSUserDefaults standardUserDefaults]synchronize];
        
            
            NSDictionary *result = [self cacheUseWithUserName:changeUserName hasPassword:NO];
            NSLog(@"result:%@",result);
            successBlock(result);
        };
    }
    else
    {
        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
        });
    }
}

- (void)getAccountListWithFinishBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    IDMPListUserView *listV = [IDMPListUserView sharedView];
    NSArray *users = [self getUsersWithHasNowAccount:YES];
    if (users.count > 0)
    {
        listV.userInfoArr = [NSMutableArray arrayWithArray:users];
        dispatch_async(dispatch_get_main_queue(), ^{
            [listV showInView:[UIApplication sharedApplication].keyWindow.rootViewController];
            [listV.tableV reloadData];
        });
    }
}

- (void)resultCodeSuccessWithResponse:(NSDictionary *)response
{
    NSString *query = [response objectForKey:@"Query-Result"];
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:query];
    NSString *sip = [parament objectForKey:SIP];
    NSString *sourceid = [parament objectForKey:source];
    NSLog(@"query sourceid result : %@",sourceid);
    [[NSUserDefaults standardUserDefaults] setValue:sip forKey:SIP];
    [[NSUserDefaults standardUserDefaults] setValue:sourceid forKey:source];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getAppPasswordByConditionWithUserName:(NSString *)userName Content: (NSString *)content andLoginType:(NSUInteger) loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
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
    
    
    if ([self getAuthType] < 0)
    {
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        if(![first_ischecked isEqualToString:@"1"])
        {
            [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
        }
        
        
        __weak NSString *mUserName=userName;
        
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        
        if([ischecked isEqualToString:@"1"])
        {
            [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:successBlock failBlock:failBlock];
        }
    });
}

-(void)getAccessTokenByConditionWithUserName:(NSString *)userName Content: (NSString *)content andLoginType:(NSUInteger) loginType finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
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
    if ([self getAuthType] < 0)
    {
        if (failBlock) {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        if(![first_ischecked isEqualToString:@"1"])
        {
            [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
        }
        
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        
        if([ischecked isEqualToString:@"1"])
        {
            [self cacheNoUseByConditionWithLoginType:loginType UserName:mUserName andPassWd:content successBlock:^(NSDictionary *paraments) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                [dic removeObjectForKey:ksUserName];
                if (successBlock)
                {
                    successBlock(dic);
                }
            } failBlock:failBlock];
        }
    });
}

-(void)getAccessTokenWithUserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    
    if ([self getAuthType] < 0)
    {
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        if(![first_ischecked isEqualToString:@"1"])
        {
            [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
        }
        
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        NSMutableDictionary *user;
        if (mUserName)
        {
            user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                NSString *expireTimeString=[user objectForKey:ksExpiretime];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
                NSString *KS=[user objectForKey:@"KS"];
                if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
                    [dic removeObjectForKey:ksUserName];
                    if (successBlock)
                    {
                        successBlock(dic);
                    }
                }
                else
                {
                    [self  cleanSSOWithUserName:mUserName];
                    [self autoGoAndCacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:^(NSDictionary *paraments) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                        [dic removeObjectForKey:ksUserName];
                        if (successBlock)
                        {
                            successBlock(dic);
                        }
                    } failBlock:failBlock];
                }
            }
            else
            {
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:^(NSDictionary *paraments) {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                            [dic removeObjectForKey:ksUserName];
                            if (successBlock)
                            {
                                successBlock(dic);
                            }
                        } callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
        }
        else
        {
            if (loginType == 3)
            {
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:^(NSDictionary *paraments) {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                            [dic removeObjectForKey:ksUserName];
                            if (successBlock)
                            {
                                successBlock(dic);
                            }
                        } callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
            else
            {
                mUserName = [self getLocalUserNameWithisLocalNumber:isLocalNumber];
                if (mUserName == nil)
                {
                    if ([ischecked isEqualToString:@"1"])
                    {
                        [self autoGoAndCacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:^(NSDictionary *paraments) {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paraments];
                            [dic removeObjectForKey:ksUserName];
                            if (successBlock)
                            {
                                successBlock(dic);
                            }
                        } failBlock:failBlock];
                    }
                }
                else
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:NO];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultInfo];
                    [dic removeObjectForKey:ksUserName];
                    if (successBlock)
                    {
                        successBlock(dic);
                    }
                }
            }
        }
    });
}



-(void)getAppPasswordWithUserName:(NSString *)userName andLoginType:(NSUInteger) loginType isUserDefaultUI:(BOOL)isUserDefaultUI finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock;
{
    
    if ([self getAuthType] < 0)
    {
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isLocalNumber=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:getType];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
        NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        if(![first_ischecked isEqualToString:@"1"])
        {
            [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
        }
        
        __weak NSString *mUserName=userName;
        NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
        NSMutableDictionary *user;
        if (mUserName)
        {
            NSLog(@"%@",mUserName);
        
            user=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:mUserName]];
            NSLog(@"user %@",user);
            if([user count]>0)
            {
                NSString *expireTimeString=[user objectForKey:ksExpiretime];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
                NSString *KS=[user objectForKey:@"KS"];
                if([expireTimeString compare:[formatter stringFromDate:[NSDate date]]]>0&&KS!=nil)
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
                    successBlock(resultInfo);
                }
                else
                {
                    [self  cleanSSOWithUserName:mUserName];
                    [self autoGoAndCacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
                }
            }
            else
            {
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
        }
        else
        {
            if(loginType == 3)
            {
                if (isUserDefaultUI)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        IDMPUPViewController *upView = [[IDMPUPViewController alloc]init];
                        [upView showInView:[UIApplication sharedApplication].keyWindow.rootViewController placedUserName:userName callBackBlock:successBlock callFailBlock:failBlock];
                    });
                }
                else
                {
                    NSLog(@"Use your UI");
                    NSDictionary *failResult = [NSDictionary dictionary];
                    failBlock(failResult);
                }
            }
            else
            {
                mUserName = [self getLocalUserNameWithisLocalNumber:isLocalNumber];
                if (mUserName == nil)
                {
                    if ([ischecked isEqualToString:@"1"])
                    {
                        [self autoGoAndCacheNoUseWithLoginType:loginType UserName:mUserName isUserDefaultUI:isUserDefaultUI successBlock:successBlock failBlock:failBlock];
                    }
                }
                else
                {
                    NSDictionary *resultInfo = [self cacheUseWithUserName:mUserName hasPassword:YES];
                    successBlock(resultInfo);
                }
            }
        }
    });
}



- (void)registerUserWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    
    if ([self getAuthType] < 0)
    {
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if(![first_ischecked isEqualToString:@"1"])
    {
        [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
    }
    
    NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if([ischecked isEqualToString:@"1"])
    {
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager registerUserWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
    }
}


- (void)resetPasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andValidCode:(NSString *)validCode finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    
    if ([self getAuthType] < 0)
    {
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if(![first_ischecked isEqualToString:@"1"])
    {
        [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
    }
    
    NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if([ischecked isEqualToString:@"1"])
    {
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager resetPasswordWithPhoneNo:phoneNo passWord:password andValidCode:validCode finishBlock:successBlock failBlock:failBlock];
    }
}

- (void)changePasswordWithPhoneNo:(NSString *)phoneNo passWord:(NSString *)password andNewPSW:(NSString *)newpassword finishBlock:(accessBlock) successBlock failBlock:(accessBlock )failBlock
{
    NSString *first_ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if(![first_ischecked isEqualToString:@"1"])
    {
        [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:nil failBlock:failBlock];
    }
    
    NSString *ischecked=[[NSUserDefaults standardUserDefaults] objectForKey:isChecked];
    if([ischecked isEqualToString:@"1"])
    {
        IDMPAccountManagerMode *accountManager = [IDMPAccountManagerMode shareAccountManager];
        [accountManager changePasswordWithPhoneNo:phoneNo passWord:password andNewPSW:newpassword finishBlock:successBlock failBlock:failBlock];
    }
}



- (void)currentEdition
{
    NSLog(@"版本:andidmp-iosv1.9.0  时间:2015.11.26");
    NSLog(@"network :%d",[self getAuthType]);

}


//请在子线程中调用
-(BOOL)checkIsLocalNumberWith:(NSString *)userName
{
    NSLog(@"check localnumber");
    if ([self getAuthType] != 1)
    {
        return YES;
    }
    NSMutableURLRequest * request1 = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:localUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request1.allHTTPHeaderFields = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *response= [NSURLConnection sendSynchronousRequest:request1  returningResponse:&urlResponse error:&error];
    NSLog(@"PASSWORD QUERY error:%@",[error localizedDescription]);
    int statusCode = (int)[urlResponse statusCode];
    NSLog(@"statusCode is %d",statusCode);
    if (statusCode != 200)
    {
        return YES;
    }
    NSDictionary *queryResult = [NSJSONSerialization JSONObjectWithData:response options: NSJSONReadingMutableLeaves error: &error];
    NSLog(@"queryresult :%@",queryResult);
    NSString *localNumber = [queryResult objectForKey:@"mobile"];
    NSString *resultCode = [queryResult objectForKey:@"resultCode"];
    if (localNumber == nil || localNumber == NULL)
    {
        return YES;
    }
    if ([localNumber isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ( [localNumber isKindOfClass:[NSString class]] && [localNumber isEqualToString:@"<null>"])
    {
        return YES;
    }
    
    if ( [localNumber isKindOfClass:[NSString class]] && [localNumber isEqualToString:@"(null)"])
    {
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
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)initWithAppid:(NSString *)appid Appkey:(NSString *)appkey finishBlock:(accessBlock)successBlcok failBlock:(accessBlock)failBlock
{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:isChecked];
    [[NSUserDefaults standardUserDefaults] setObject:@"南方地址" forKey:@"south_url"];
    [[NSUserDefaults standardUserDefaults] setObject:@"北方地址" forKey:@"north_url"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"action_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    if (appid.length == 0 || appkey.length == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"102203",@"resultCode", nil];
        if (failBlock)
        {
            failBlock(dic);
        }
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:appid forKey:@"IDMP_APPID"];
    [[NSUserDefaults standardUserDefaults] setValue:appkey forKey:@"IDMP_APPKEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self getAuthType] < 0)
    {
        if (failBlock)
        {
            NSDictionary *result = @{@"resultCode":@"102101"};
            failBlock(result);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self checkWithAppId:appidString andAppkey:appkeyString finishBlock:successBlcok failBlock:failBlock];
    });
}


@end
