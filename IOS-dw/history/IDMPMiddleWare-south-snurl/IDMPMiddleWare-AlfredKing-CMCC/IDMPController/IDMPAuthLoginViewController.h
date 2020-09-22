//
//  TestViewController.h
//  HttpTest
//
//  Created by zwk on 14/12/18.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDMPAutoLoginViewController.h"

@interface IDMPAuthLoginViewController : UIViewController
@property (nonatomic, copy) NSString *callBackUrl;
@property (nonatomic, copy) NSString *isSip;

@property (weak, nonatomic) IBOutlet UILabel *loginUser;

@end
