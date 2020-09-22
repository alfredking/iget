//
//  OthersViewController.h
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "ProfileViewController.h"

@interface OthersViewController : ProfileViewController

//using the userInfo that got from the weiboMsg
- (void)refreshUserProfileWithUser:(WeiboUserInfo *)userInfo;
@end
