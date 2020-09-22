//
//  ProfileViewController.h
//  Fenvo
//
//  Created by Caesar on 15/5/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboUserInfo.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MostColor.h"
#import "MJRefresh.h"
#import "WeiboGetBlurImage.h"
#import "WeiboTableView.h"
#import "AlbumView.h"
#import "FollowingListTableViewController.h"
#import "FollowerListTableViewController.h"
#import "UserInfoView.h"
#import "WeiboTableView.h"

@interface ProfileViewController : UIViewController<UITabBarDelegate>
@property(copy, nonatomic)NSString *access_token;
@property(copy, nonatomic)NSString *uid;

@property(nonatomic, strong)UIScrollView *refreshView;
@property(nonatomic, strong)UIImageView *basicInfoView;
@property(nonatomic, strong)UILabel *gender;
@property(nonatomic, strong)UILabel *address;
@property(nonatomic, strong)UIImageView *profileAvatar;
@property(nonatomic, strong)UILabel *descriptions;

@property(nonatomic, strong)UIButton *weiboNumber;
@property(nonatomic, strong)UILabel *weiboLabel;
@property(nonatomic, strong)UIButton *followingNumber;
@property(nonatomic, strong)UILabel *followingLabel;
@property(nonatomic, strong)UIButton *followerNumber;
@property(nonatomic, strong)UILabel *followerLabel;

@property(nonatomic, strong)UISegmentedControl *segmentControl;

//
@property(nonatomic, strong)WeiboUserInfo *userProfile;

//
@property(nonatomic, strong)WeiboTableView *weiboTableView;
@property(nonatomic, strong)AlbumView *albumView;
@property(nonatomic, strong)UserInfoView *userInfoView;
//
@property(nonatomic, strong)UIViewController *currentVC;

- (void)initWithComponent;

//get others user profile
//using the uid. Forbidden Now.
- (void)downloadUserProfileWithUid:(long long)uid;


- (id)init;
@end
