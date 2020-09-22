//
//  IDMPDataSMSMode.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-10-16.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface IDMPDataSMSMode : UIViewController<MFMessageComposeViewControllerDelegate>

typedef void (^IDMPBlock)(void);

-(void)getDataSmsKS;

@end
