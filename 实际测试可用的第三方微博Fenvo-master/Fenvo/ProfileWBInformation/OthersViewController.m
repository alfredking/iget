//
//  OthersViewController.m
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "OthersViewController.h"

@interface OthersViewController ()

@end

@implementation OthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"refreshUserInfo" object:nil];
    [center addObserver:self selector:@selector(refreshUserProfileWithUser:) name:@"refreshUserInfo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshUserProfileWithUser:(NSNotification *)notice {
    self.userProfile = (WeiboUserInfo *)notice.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = self.userProfile.screen_name;
        [self.profileAvatar sd_setImageWithURL:[NSURL URLWithString:self.userProfile.profile_image_url]];
        /*[_basicInfoView sd_setImageWithURL:
         [NSURL URLWithString:userProfile.avatar_hd]
         placeholderImage:nil
         options:SDWebImageProgressiveDownload
         completed:^(UIImage *image,
         NSError *error,
         SDImageCacheType cacheType,
         NSURL *imageURL){
         if (image) {
         //_basicInfoView.image = [[WeiboGetBlurImage shareWeiboGetBlurImage]getBlurImage:image];
         }
         }];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_weiboLabel];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_followingLabel];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_followerLabel];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_gender];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_address];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_weiboNumber.titleLabel];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_followerNumber.titleLabel];
         [self setTextColorWithBackgroundImage:_basicInfoView.image andComponent:_followingNumber.titleLabel];
         */
        
        self.gender.text = self.userProfile.gender;
        self.address.text = self.userProfile.location;
        self.descriptions.text = self.userProfile.descriptions;
        [self.weiboNumber setTitle:[NSString stringWithFormat:@"%lld",self.userProfile.statuses_count.longLongValue] forState:UIControlStateNormal];
        [self.followingNumber setTitle:[NSString stringWithFormat:@"%lld",self.userProfile.followers_count.longLongValue] forState:UIControlStateNormal];
        [self.followerNumber setTitle:[NSString stringWithFormat:@"%lld",self.userProfile.friends_count.longLongValue] forState:UIControlStateNormal];
    });
    self.userInfoView.userInfo = self.userProfile;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
