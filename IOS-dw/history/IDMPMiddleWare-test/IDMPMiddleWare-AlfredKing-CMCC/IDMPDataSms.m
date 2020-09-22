//
//  IDMPDataSms.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking on 15/4/7.
//  Copyright (c) 2015年 alfredking－cmcc. All rights reserved.
//

#import "IDMPDataSms.h"
#import "IDMPDataSMSMode.h"
#import "IDMPHttpRequest.h"
#import "IDMPConst.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPMD5.h"
#import "IDMPToken.h"
#import "IDMPFormatTransform.h"

@interface IDMPDataSms ()

@property BOOL isUsingPresentMethod;   // is using presentViewController method to show MFMessageComposeViewController

@end

@implementation IDMPDataSms
{
    NSDictionary *_options;
    accessBlock  finishblock;
    accessBlock  errorblock;
    NSString *sip;
    NSString *clientNonce;
    NSDictionary *heads;
}
+(IDMPDataSms *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;

}
-(void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients option: (NSDictionary *) options SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        finishblock=successBlock;
        errorblock=failBlock;
        heads=[options objectForKey:@"head"];
        clientNonce=[options objectForKey:@"cNonce" ];
        sip=[options objectForKey:SIP];
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.editing=NO;
        controller.messageComposeDelegate =self;
        _options=options;
        
        
        // Use presentViewController method to show MFMessageComposeViewController if possible.
        
        UIViewController* lViewController = [self getViewControllerForPresenting];
        
        if(lViewController)
        {
            self.isUsingPresentMethod = YES;
            [lViewController presentViewController:controller animated:YES completion:NULL];
        }else
        {
            self.windowLevel=UIWindowLevelNormal;
            self.hidden=NO;
            self.rootViewController=controller;
            [self makeKeyAndVisible];
        }
    }
}

- (UIViewController*)getViewControllerForPresenting
{
    UIViewController* lViewController = [[self getKeyWindow]rootViewController];
    return [lViewController presentedViewController]? [lViewController presentedViewController] : lViewController;
}

/**
 * 取得真正的keywindow 或nil（如，UIAlertView在iOS8 上会显示在一个单独的UIWindow里，该window是Application的
 * keyWindow，但它自身的keyWindow属性是NO， 这种情况不将它作为keyWindow）。
 */
- (UIWindow*)getKeyWindow
{
    UIWindow* lKeyWindow = [[UIApplication sharedApplication]keyWindow];
    
    if (lKeyWindow.keyWindow)
    {
        return lKeyWindow;
    }
    
    for (UIWindow* lWin in [[UIApplication sharedApplication] windows])
    {
        if (lWin.keyWindow) {
            return lWin;
        }
    }
    
    return nil;
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if(self.isUsingPresentMethod)
    {
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }else
    {
        self.rootViewController=nil;
        [self resignKeyWindow];
        self.hidden=YES;
    }

    switch (result) {
        case MessageComposeResultSent:
            //发送短信
        {
            NSLog(@"Result: Sent");
            IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
            [request getHttpByHeads:heads url:requestUrl
                                     successBlock:
                   ^{
                       
                       NSDictionary *responseHeaders=request.responseHeaders;
                       NSLog(@"%@",responseHeaders);
                       if ([self checkDataSmsKSIsValid:responseHeaders clientNonce:clientNonce])
                       {
                           NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
                           NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
                           NSString *userName = [parament objectForKey:ksUserName];
                           NSString *passWd=[parament objectForKey:@"spassword"];
                           NSString *passid=[parament objectForKey:@"passid"];
                           NSDictionary *result=nil;
                           NSString *sourceid=[[NSUserDefaults standardUserDefaults] objectForKey:source];
                           NSString *Token=[IDMPToken getTokenWithUserName:userName andAppId:sourceid];
                           if ([sip isEqualToString:@"1"])
                           {
                               if (!passWd) {
                                   result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
                                   errorblock(result);
                                   return ;
                               }
                               result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,Token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
                           }
                           else
                           {
                               result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,passWd,@"password",passid,@"passid",@"102000",@"resultCode",Token,@"token",nil];
                           }
                           finishblock(result);

                       }else{
                           request.responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:@"102208",@"resultCode", nil];
                           errorblock(request.responseHeaders);
                       }

                   }
                                        failBlock:
                   ^{
                       if ([request.responseHeaders objectForKey:@"resultCode"]!=nil) {
                           NSLog(@"data sms %@",request.responseHeaders);
                           request.responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:@"102208",@"resultCode", nil];
                           errorblock(request.responseHeaders);
                       }else{
                           NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];

                           errorblock(resultCode);
                           NSLog(@"datasms fail");
                           NSLog(@"datasms %@",request.responseHeaders);
                       }
                   }];

        }
            break;
        case MessageComposeResultCancelled:
            //取消发短信功能
        {
            NSLog(@"Result: canceled");
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102301",@"resultCode", nil];

            errorblock(resultCode);
        }
            break;
        case MessageComposeResultFailed:
            //发送失败
        {
            NSLog(@"发送失败");
        }
        default:
        {
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102313",@"resultCode", nil];

            errorblock(resultCode);
        }
            break;
    }
}

-(BOOL)checkDataSmsKSIsValid:(NSDictionary *)responseHeaders  clientNonce:(NSString *)clientNonce
{
    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
    if(resultCode!=IDMPResultCodeSuccess)
    {
        return NO;
    }
    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
    NSString *serverMac = [responseHeaders objectForKey:ksMac];
    if(!wwwauthenticate||!serverMac)//服务返回错误，返回nil
    {
        return NO;
    }
    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
    NSString *serverNonce= [parament objectForKey:ksDS_nonce];
    NSString *userName = [parament objectForKey:ksUserName];
    unsigned char *ks=kdf_sms([clientNonce UTF8String],[ksDS_GBA UTF8String],[serverNonce UTF8String]);
    
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac])
    {
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
        NSString *rand =[md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce]];
        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
        [user setObject:expireTimeString forKey:ksExpiretime];
        [user setObject:[IDMPFormatTransform charToNSHex:ks length:16] forKey:@"KS"];
        [user setObject:rand forKey:@"Rand"];
        NSString *passid=[parament objectForKey:@"passid"];
        [user setObject:passid forKey:@"passid"];
        NSString *sqn=[parament objectForKey:ksSQN];
        NSString *BTID=[parament objectForKey:ksBTID];
        [user setObject: sqn forKey:@"sqn"];
        [user setObject: BTID forKey:@"BTID"];
        [user setObject:serverMac forKey:@"mac"];
        NSMutableArray *accounts =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:userList]];
        
        //        if(([accounts count]>0)&&(![accounts containsObject:userName]))
        //        {
        //
        //            [accounts addObject:userName];
        //            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
        //        }
        //        else
        //        {
        //            NSMutableArray *accounts=[[NSMutableArray alloc]init];
        //            [accounts addObject:userName];
        //            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
        //
        //        }
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
        if([accounts count]>0)
        {
            int count = 0;
            for (NSDictionary *model in accounts) {
                if ([[model objectForKey:@"userName"]isEqualToString:userName]) {
                    [accounts removeObject:model];
                    [accounts addObject:userInfo];
                    break;
                }
                count++;
            }
            if (count>=[accounts count]) {
                [accounts addObject:userInfo];
            }
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
            
            
        }
        else
        {
            NSMutableArray *accounts=[[NSMutableArray alloc]init];
            [accounts addObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setValue:accounts forKey:userList];
            
        }
        [user setObject:@"数据短信登录" forKey:@"getKSWay"];
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:userName];
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:nowLoginUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"ks存储成功");
        return YES;
    }
    else
    {
        return NO;
        NSLog(@"ks验证不正确");
    }
}

@end
