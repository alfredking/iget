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
#import "IDMPFormatTransform.h"
#import "IDMPConst.h"
#import "userInfoStorage.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"

@implementation IDMPDataSms
{
    NSDictionary *_options;
    accessBlock  finishblock;
    accessBlock  errorblock;
    NSString *sip;
    NSString *clientNonce;
//    NSDictionary *heads;
    float timeout;
    NSString *traceId;
}

+ (IDMPDataSms *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
    
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients option:(NSDictionary *)options SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        finishblock=successBlock;
        errorblock=failBlock;
        clientNonce=[options objectForKey:@"cNonce"];
        sip=[options objectForKey:sipFlag];
        traceId = [options objectForKey:IDMPTraceId];
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
            NSString *timeOut = (NSString *)[userInfoStorage getInfoWithKey:secDataSmsHttpTimesk];
            if([IDMPFormatTransform checkNSStringisNULL:timeOut])
            {
                timeout=20;
            }
            else
            {
                timeout=[timeOut floatValue];
            }

            [self requestKSWithCount:1];
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
        default:
        {
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102313",@"resultCode", nil];
            
            errorblock(resultCode);
        }
            break;
    }
}

- (void)requestKSWithCount:(NSInteger)hscount {
    // 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 设置延时，单位秒
    double delay = hscount == 1 ? 3 : 2;
    __block NSDictionary *heads = [[IDMPAuthModel alloc] initHSWithcount:[NSString stringWithFormat:@"%tu",hscount] sipInfo:sip clientNonce:clientNonce traceId:traceId].heads;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
        // 3秒后需要执行的任务
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
        [request getAsynWithHeads:heads url:requestHSUrl timeOut:timeout
                     successBlock:^(NSDictionary *parameters){
             @autoreleasepool {
                 NSDictionary *wwwauthenticate = [IDMPCheckKS checkDataSmsKSIsValid:parameters clientNonce:clientNonce];
                 [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:nil authType:IDMPHS sipinfo:sip traceId:traceId successBlock:finishblock failBlock:errorblock];
//                     NSString *userName = [wwwauthenticate objectForKey:ksUserName];
//                     NSString *passWd=[wwwauthenticate objectForKey:@"spassword"];
//                     NSString *decPassWd=nil;
//                     if(![IDMPFormatTransform checkNSStringisNULL:passWd]) {
//                         decPassWd=secRSA_Decrypt(passWd);
//                         NSLog(@"decpasswd is %@",decPassWd);
//                     }
//
//
//                     NSString *passid=[wwwauthenticate objectForKey:@"passid"];
//                     NSDictionary *result=nil;
//                     NSString *sourceid = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
//                     if(!sourceid) {
//                         if (errorblock) {
//                             NSDictionary *result = @{@"resultCode":@"102298"};
//                             errorblock(result);
//                         }
//                         return;
//                     }
//                     NSString *token=[IDMPToken getTokenWithUserName:userName andSourceId:sourceid andTraceId:traceId];
//                     if (token == nil && errorblock) {
//                         NSDictionary *result = @{@"resultCode":@"102317"};
//                         if (errorblock) {
//                             errorblock(result);
//                         }
//                         return;
//                     }
//                     if ([sip isEqualToString:isSip]) {
//                         if (!decPassWd) {
//                             result = [NSDictionary dictionaryWithObjectsAndKeys:@"102209",@"resultCode", nil];
//                             errorblock(result);
//                             return ;
//                         }
//
//                         NSString *openid = [wwwauthenticate objectForKey:@"openid"];
//                         if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                             NSLog(@"openid is nil from server");
//                             NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[userInfoStorage getInfoWithKey:userName]];
//                             openid = [user objectForKey:@"openid"];
//                             if ([IDMPFormatTransform checkNSStringisNULL:openid]) {
//                                 NSLog(@"openid is nil from cache");
//                                 openid = passid;
//                             }
//                         }
//                         result=[NSDictionary dictionaryWithObjectsAndKeys:userName,ksUserName,decPassWd,sipPassword,passid,@"passid",@"102000",@"resultCode",token,@"token",openid,@"openid",nil];
//                     } else {
//                         result=[NSDictionary dictionaryWithObjectsAndKeys:token,@"token",@"102000",@"resultCode",passid,@"passid",nil];
//                     }
//                     finishblock(result);
//                 } else {
//                     NSLog(@"mac不一致");
////                     request.responseHeaders = [NSDictionary dictionaryWithObjectsAndKeys:@"102208",@"resultCode", nil];
//                     errorblock(@{@"resultCode":@"102208"});
//                 }
             }
         } failBlock:^(NSDictionary *parameters){
             NSString *resultCode = [parameters objectForKey:@"resultCode"];
             if ([resultCode isEqualToString:@"103204"]) {
                 if (hscount < 2) {
                     NSLog(@"第%ld次出现103204",hscount);
                     NSInteger count = hscount+1;
                     
                     heads = [[IDMPAuthModel alloc] initHSWithcount:[NSString stringWithFormat:@"%d",(int)count] sipInfo:sip clientNonce:clientNonce traceId:traceId].heads;
                     [self requestKSWithCount:count];
                 } else {
                     NSLog(@"轮询失败结束");
                     errorblock(parameters);
                 }
             } else {
                 errorblock(parameters);
             }
             
         }];
    });
}

//-(BOOL)checkDataSmsKSIsValid:(NSDictionary *)responseHeaders  clientNonce:(NSString *)clientNonceStr
//{
//    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
//    if(resultCode!=IDMPResultCodeSuccess)
//    {
//        return NO;
//    }
//    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
//    NSString *serverMac = [responseHeaders objectForKey:ksMac];
//    if(!wwwauthenticate||!serverMac)//服务返回错误，返回nil
//    {
//        return NO;
//    }
//    NSMutableDictionary *parament=[IDMPParseParament parseParamentFrom:wwwauthenticate];
//    NSString *serverNonce= [parament objectForKey:ksDS_nonce];
//    NSString *userName = [parament objectForKey:ksUserName];
//    unsigned char *ks=kdf_sms((unsigned char *)[clientNonceStr UTF8String],(char *)[ksDS_GBA UTF8String],(char *)[serverNonce UTF8String]);
//    NSLog(@"ks is");
////    print_hex((char *)ks);
//    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
//    NSLog(@"native mac %@",nativeMac);
//    if([nativeMac isEqualToString:serverMac])
//    {
//        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
//        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
//        NSString *rand =[md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonceStr]];
//        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
//        [user setObject:expireTimeString forKey:ksExpiretime];
//        [user setObject:[IDMPFormatTransform charToNSHex:ks length:16] forKey:@"KS"];
//        [user setObject:rand forKey:@"Rand"];
//        NSString *passid=[parament objectForKey:@"passid"];
//        [user setObject:passid forKey:@"passid"];
//        NSString *sqn=[parament objectForKey:ksSQN];
//        NSString *BTID=[parament objectForKey:ksBTID];
//        [user setObject: sqn forKey:@"sqn"];
//        [user setObject: BTID forKey:@"BTID"];
//        [user setObject:serverMac forKey:@"mac"];
//
//        NSString *openid = [parament objectForKey:@"openid"];
//        if (![IDMPFormatTransform checkNSStringisNULL:openid]) {
//            [user setObject:openid forKey:@"openid"];
//        }
//
//        NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTimeString,ksExpiretime,[NSNumber numberWithBool:YES],@"isLocalNum",userName,@"userName", nil];
//        if([accounts count]>0)
//        {
//            int count = 0;
//            for (NSDictionary *model in accounts)
//            {
//                if ([[model objectForKey:@"userName"]isEqualToString:userName])
//                {
//                    [accounts removeObject:model];
//                    [accounts addObject:userInfo];
//                    break;
//                }
//                count++;
//            }
//            if (count>=[accounts count])
//            {
//                [accounts addObject:userInfo];
//            }
//            [userInfoStorage setInfo:accounts withKey:userList];
//        }
//        else
//        {
//            NSMutableArray *accounts=[[NSMutableArray alloc]init];
//            [accounts addObject:userInfo];
//            [userInfoStorage setInfo:accounts withKey:userList];
//
//        }
//
//        [userInfoStorage setInfo:user withKey:userName];
//        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
//        free(ks);
//        ks=NULL;
//        NSLog(@"ks存储成功");
//        return YES;
//    }
//    else
//    {
//        free(ks);
//        ks=NULL;
//        return NO;
//        NSLog(@"ks验证不正确");
//    }
//}


@end
