//
//  IDMPUPViewController.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-30.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDMPUPViewController : UIViewController

@property  BOOL __block didLoginIn;
@property (strong, nonatomic) IBOutlet UITextField *UPUserName;
@property (strong, nonatomic) IBOutlet UITextField *UPPassWd;

@end
