//
//  UserInfoView.h
//  Fenvo
//
//  Created by Caesar on 15/6/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboUserInfo.h"

@interface UserInfoView : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *user_description;
@property (strong, nonatomic) IBOutlet UILabel *hometown;
@property (strong, nonatomic) IBOutlet UILabel *register_time;
@property (strong, nonatomic) IBOutlet UILabel *habits;
@property (strong, nonatomic) IBOutlet UILabel *remark;
@property (strong, nonatomic) IBOutlet UILabel *blogUrl;

@property (strong, nonatomic) WeiboUserInfo *userInfo;

@end
