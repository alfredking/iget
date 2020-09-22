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

-(void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients option: (NSArray *) options SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        finishblock=successBlock;
        errorblock=failBlock;
        heads=options[0];
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.editing=NO;
        controller.messageComposeDelegate =self;
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
               [request getHttpByHeads:heads url:authLoginUrl
                          successBlock:
                ^{
                    NSLog(@"%@",request.responseStr);
                    if (finishblock && request.responseStr)
                    {
                        finishblock(request.responseStr);
                    }
                }
                             failBlock:
                ^{
                    NSDictionary *result = request.responseStr;
                    NSLog(@"%@",result);
                    if ([result objectForKey:@"resultcode"])
                    {
                        NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:[result objectForKey:@"resultcode"],@"resultCode", nil];
                        errorblock(resultDic);
                    }
                    else
                    {
                        NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:@"102102",@"resultCode", nil];
                        
                        errorblock(resultDic);
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


@end
