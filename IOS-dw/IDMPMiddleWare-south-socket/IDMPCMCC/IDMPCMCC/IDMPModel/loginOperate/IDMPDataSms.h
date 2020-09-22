//
//  IDMPDataSms.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking on 15/4/7.
//  Copyright (c) 2015年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface IDMPDataSms : UIWindow<MFMessageComposeViewControllerDelegate>

typedef void (^accessBlock)(NSDictionary *paraments);

+ (IDMPDataSms *)sharedInstance;

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients option:(NSDictionary *)options isTmpCache:(BOOL)isTmpCache SuccessBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;;

@end
