//
//  IDMPTempSmsViewController.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-1.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    getMessageCode = 0,
    login= 1
}buttonType;
@interface IDMPTempSmsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UILabel *passWdLabel;
@property (strong, nonatomic) IBOutlet UITextField *passWdField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end
