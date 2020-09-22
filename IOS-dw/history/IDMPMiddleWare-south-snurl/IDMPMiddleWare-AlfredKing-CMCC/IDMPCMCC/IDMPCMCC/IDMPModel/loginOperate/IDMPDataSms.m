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

-(void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients option:(NSDictionary *)options SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
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
        self.windowLevel=UIWindowLevelNormal;
        self.hidden=NO;
        self.rootViewController=controller;
        [self makeKeyAndVisible];
    }
}



-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
        self.rootViewController=nil;
        [self resignKeyWindow];
        self.hidden=YES;
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
                               if (!passWd)
                               {
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

                       }
                       else
                       {
                           NSLog(@"mac不一致");
                           request.responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:@"102208",@"resultCode", nil];
                           errorblock(request.responseHeaders);
                       }

                   }
                    failBlock:
                   ^{
                       if ([request.responseHeaders objectForKey:@"resultCode"])
                       {
                           NSLog(@"data sms %@",request.responseHeaders);
                           NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:[request.responseHeaders objectForKey:@"resultCode"],@"resultCode", nil];
                           errorblock(resultCode);
                       }
                       else
                       {
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
//        case MessageComposeResultFailed:
//            //发送失败
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
    NSLog(@"ks is");
    print_hex(ks);
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    NSLog(@"native mac %@",nativeMac);
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
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
        if([accounts count]>0)
        {
            int count = 0;
            for (NSDictionary *model in accounts)
            {
                if ([[model objectForKey:@"userName"]isEqualToString:userName])
                {
                    [accounts removeObject:model];
                    [accounts addObject:userInfo];
                    break;
                }
                count++;
            }
            if (count>=[accounts count])
            {
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
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:userName];
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:nowLoginUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        free(ks);
        NSLog(@"ks存储成功");
        return YES;
    }
    else
    {
        free(ks);
        return NO;
        NSLog(@"ks验证不正确");
    }
}


@end
