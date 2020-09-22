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
@interface IDMPAutoLoginViewController ()

@end


@implementation IDMPAutoLoginViewController

-(int )getAuthType
{
    if ([[IDMPDevice GetCurrntNet] isEqual:@"4g"])
    {
        return 1;
    }
    else if(![CTSIMSupportGetSIMStatus() isEqualToString:kCTSIMSupportSIMStatusNotInserted]&[IDMPDevice connectedToNetwork])
    {
        return 3;
    }
    else if ([IDMPDevice connectedToNetwork])
    {
        return 3;
    }
    else
    {
        return -1;
    }
    
}

-(NSMutableDictionary *)getAccessTokenWithAppid:(NSString *)Appid Appkey: (NSString *)Appkey UserName:(NSString *)userName andLoginType:(NSUInteger) loginType,
{
    if(userName)
    {
        NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userName]];
    }
    else
    {
        
    }
    NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:Appid];
    NSMutableDictionary *resultInfo=[NSMutableDictionary dictionaryWithObject:Token forKey:@"token"];
    return resultInfo;
}

-(BOOL)removeAuthDataWithUserName:(NSString *)userName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:userName];
     NSMutableArray *accounts =[NSMutableArray arrayWithArray:[user objectForKey:userList]];
    if (accounts) {
        [accounts removeObject:userName];
        [user setObject:accounts forKey:userList];
    }
    [user synchronize];
    return YES;
}
- (IBAction)autoLogin:(UIButton *)sender
{
    IDMPWapMode *wapMode=[[IDMPWapMode alloc]init];
    int  loginType=[self getAuthType];
    switch (loginType)
    {
            case 1:
            {
                [wapMode getWapKSWithSuccessBlock:
                 ^{
                    NSLog(@"登录成功 wap!");
                }
                failBlock:
                ^{
                    NSLog(@"wap fail!");
                    [self getDataSmsKS];
                }];

            }
            
            break;
            case 2:
            {
                [self getDataSmsKS];
                
            }
            break;
            case 3:
            {
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"upView"] animated:YES completion:nil];

            }
                break;
            default:
                break;
        }
}

@end
