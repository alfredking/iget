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
#import "NSString+IDMPAdd.h"
#import "userInfoStorage.h"
#import "IDMPAuthModel.h"
#import "IDMPCheckKS.h"
#import "IDMPRusultHandler.h"

//@interface IDMPDataSms()
//
//@property(nonatomic, assign)BOOL needSaved;
//
//@end

@implementation IDMPDataSms
{
    NSDictionary *_options;
    accessBlock  finishblock;
    accessBlock  errorblock;
    NSString *sip;
    NSString *clientNonce;
//    NSDictionary *heads;
//    float timeout;
    NSString *traceId;
    BOOL _isTmpCache;
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

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients option:(NSDictionary *)options isTmpCache:(BOOL)isTmpCache SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    NSLog(@"start init MFMessageComposeViewController");
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
        _isTmpCache = isTmpCache;
        self.windowLevel=UIWindowLevelNormal;
        self.hidden=NO;
        self.rootViewController=controller;
        NSLog(@"prepare window visible");
        [self makeKeyAndVisible];
    } else {
        NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102313",IDMPResCode,@"短信登录失败",IDMPResStr, nil];
        failBlock(resultCode);
        
    }
}

- (void)dealloc {
    NSLog(@"It is being dealloced");
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
//            NSString *timeOut = (NSString *)[userInfoStorage getInfoWithKey:secDataSmsHttpTimesk];
//            if([timeOut idmp_isOverAllNULL])
//            {
//                timeout=20;
//            }
//            else
//            {
//                timeout=[timeOut floatValue];
//            }

            [self requestKSWithCount:1 isTmpCache:_isTmpCache];
        }
            break;
        case MessageComposeResultCancelled:
            //取消发短信功能
        {
            NSLog(@"Result: canceled");
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102301",IDMPResCode,@"用户取消认证",IDMPResStr, nil];
            errorblock(resultCode);
        }
            break;
        default:
        {
            NSDictionary *resultCode = [NSDictionary dictionaryWithObjectsAndKeys:@"102313",IDMPResCode,@"短信登录失败",IDMPResStr, nil];
            
            errorblock(resultCode);
        }
            break;
    }
}

- (void)requestKSWithCount:(NSInteger)hscount isTmpCache:(BOOL)isTmpCache{
    // 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 设置延时，单位秒
    double delay = hscount == 1 ? 3 : 2;
    __block NSDictionary *heads = [[IDMPAuthModel alloc] initHSWithcount:[NSString stringWithFormat:@"%tu",hscount] sipInfo:sip clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache].heads;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
        // 3秒后需要执行的任务
        IDMPHttpRequest *request = [[IDMPHttpRequest alloc]init];
        [request getAsynWithHeads:heads url:requestHSUrl timeOut:20
                     successBlock:^(NSDictionary *parameters){
             @autoreleasepool {
                 NSDictionary *wwwauthenticate = [IDMPCheckKS checkDataSmsKSIsValid:parameters clientNonce:self->clientNonce isTmpCache:isTmpCache];
                 [IDMPRusultHandler getRusultByHandlerWWWAuthenticate:wwwauthenticate userName:nil authType:IDMPHS sipinfo:self->sip traceId:self->traceId isTmpCache:isTmpCache successBlock:self->finishblock failBlock:self->errorblock];
             }
         } failBlock:^(NSDictionary *parameters){
             NSString *resultCode = [parameters objectForKey:IDMPResCode];
             if ([resultCode isEqualToString:@"103204"]) {
                 if (hscount < 2) {
                     NSLog(@"第%ld次出现103204",(long)hscount);
                     NSInteger count = hscount+1;
                     
                     heads = [[IDMPAuthModel alloc] initHSWithcount:[NSString stringWithFormat:@"%d",(int)count] sipInfo:self->sip clientNonce:self->clientNonce traceId:self->traceId isTmpCache:isTmpCache].heads;
                     [self requestKSWithCount:count isTmpCache:isTmpCache];
                 } else {
                     NSLog(@"轮询失败结束");
                     self->errorblock(parameters);
                 }
             } else {
                 self->errorblock(parameters);
             }
             
         }];
    });
}




@end
