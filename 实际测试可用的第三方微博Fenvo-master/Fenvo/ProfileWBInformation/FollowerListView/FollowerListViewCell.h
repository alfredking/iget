//
//  FollowingListViewCell.h
//  Fenvo
//
//  Created by Caesar on 15/6/7.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboAvatarView.h"
#import "WeiboUserInfo.h"

@interface FollowerListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userDescription;
@property (strong, nonatomic) IBOutlet WeiboAvatarView *avatar;
@property (strong, nonatomic) IBOutlet UIButton *relationBtn;


@property (strong, nonatomic) WeiboUserInfo *userInfo;
@end
