//
//  ProfileViewController.m
//  Fenvo
//
//  Created by Caesar on 15/5/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "ProfileViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "AppDelegate.h"



@interface ProfileViewController ()<UIScrollViewDelegate>
{

}
@end

@implementation ProfileViewController

#pragma mark - Initialize Or Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initWithComponent];
    }
    return self;
}

- (void)dealloc
{
}

- (void)initWithComponent
{
    self.view.backgroundColor   = [UIColor whiteColor];
    
    UIView *vi                  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:vi];
    
    _refreshView                                = [[UIScrollView alloc]init];
    _refreshView.autoresizesSubviews            = NO;
    _refreshView.showsHorizontalScrollIndicator = NO;
    _refreshView.showsVerticalScrollIndicator   = NO;
    _refreshView.frame       = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    _refreshView.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH,IPHONE_SCREEN_HEIGHT);
    [_refreshView setBackgroundColor:RGBACOLOR(30, 30, 30, 0.75)];

    //_refreshView.contentInset  =  UIEdgeInsetsMake(-64,0, -49, 0);
    [_refreshView addLegendHeaderWithRefreshingTarget:self
                                     refreshingAction:@selector(downloadUserProfile)];
    [self.view addSubview:_refreshView];
    
    /*
     _basicInfoView = [[UIImageView alloc]init];
     _basicInfoView.contentMode = UIViewContentModeScaleToFill;
     _basicInfoView.backgroundColor = RGBACOLOR(30, 40, 50, 1);
     [_refreshView addSubview:_basicInfoView];
     */
    CGFloat navigationY     = IPHONE_NAVIGATIONHEIGHT + 30;
    
    CGFloat centerX         = self.view.center.x;
    
    _gender                 = [[UILabel alloc]initWithFrame:CGRectMake(centerX-40, navigationY, 20, 15)];
    _gender.textAlignment   = NSTextAlignmentCenter;
    _gender.font            = [UIFont fontWithName:@ "STHeitiJ-Light" size:13.0];
    _gender.textColor       = [UIColor whiteColor];
    [_refreshView addSubview:_gender];
    
    _address                = [[UILabel alloc]initWithFrame:CGRectMake(centerX, navigationY, 80, 15)];
    _address.textAlignment  = NSTextAlignmentCenter;
    _address.textColor      = [UIColor whiteColor];
    _address.font           = [UIFont fontWithName:@ "STHeitiJ-Light" size:13.0];
    [_refreshView addSubview:_address];
    
    _profileAvatar                      = [[UIImageView alloc]initWithFrame:
                      CGRectMake(centerX-40, CGRectGetMaxY(_gender.frame)+10, 80, 80)];
    _profileAvatar.layer.cornerRadius   = _profileAvatar.frame.size.width/2;
    _profileAvatar.layer.masksToBounds  = YES;
    _profileAvatar.contentMode          = UIViewContentModeScaleAspectFill;
    [_refreshView addSubview:_profileAvatar];
    
    _descriptions               = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_profileAvatar.frame)+5, IPHONE_SCREEN_WIDTH - 20, 15)];
    _descriptions.font          = [UIFont fontWithName:@ "STHeitiJ-Light" size:13.0];
    _descriptions.textColor     = [UIColor whiteColor];
    _descriptions.textAlignment = NSTextAlignmentCenter;
    [_refreshView addSubview:_descriptions];
    
    CGFloat btnWidth                    = (IPHONE_SCREEN_WIDTH - 20)/3;
    
    
    _weiboNumber                        = [[UIButton alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(_descriptions.frame)+5, btnWidth, 25)];
    _weiboNumber.backgroundColor        = [UIColor clearColor];
    _weiboNumber.titleLabel.font        = [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:20.0];
    
    
    _followingNumber                    = [UIButton buttonWithType:UIButtonTypeCustom];
    _followingNumber.frame              = CGRectMake(btnWidth + 10 , CGRectGetMaxY(_descriptions.frame)+ 5, btnWidth, 25);
    _followingNumber.titleLabel.font    = [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:20.0];
    _followerNumber                     = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth *2 + 15, CGRectGetMaxY(_descriptions.frame) + 5, btnWidth, 25)];
    _followerNumber.titleLabel.font     = [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:20.0];
    _followerNumber.titleLabel.text     = @"0";
    
    
    _weiboLabel                         = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_weiboNumber.frame)+2, btnWidth,15)];
    _weiboLabel.font                    = [UIFont fontWithName:@ "STHeitiJ-Light" size:13.0];
    _weiboLabel.text                    = @"Weibo";
    _weiboLabel.textColor               = [UIColor whiteColor];
    _weiboLabel.textAlignment           = NSTextAlignmentCenter;
    
    
    _followingLabel                     = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth + 10, CGRectGetMaxY(_weiboNumber.frame)+2, btnWidth, 15)];
    _followingLabel.font                = [UIFont fontWithName:@ "STHeitiJ-Light" size:13.0];
    _followingLabel.text                = @"Following";
    _followingLabel.textColor           = [UIColor whiteColor];
    _followingLabel.textAlignment       = NSTextAlignmentCenter;
    
    
    _followerLabel                      = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*2 + 15, CGRectGetMaxY(_weiboNumber.frame)+2, btnWidth,15)];
    _followerLabel.font                 = [UIFont fontWithName:@ "STHeitiJ-Light" size:13.0];
    _followerLabel.text                 = @"Follower";
    _followerLabel.textColor            = [UIColor whiteColor];
    _followerLabel.textAlignment        = NSTextAlignmentCenter;
    
    
    [_refreshView addSubview:_weiboNumber];
    [_refreshView addSubview:_followingNumber];
    [_refreshView addSubview:_followerNumber];
    [_refreshView addSubview:_weiboLabel];
    [_refreshView addSubview:_followingLabel];
    [_refreshView addSubview:_followerLabel];
    
    //_basicInfoView.frame = CGRectMake(0, -55, IPHONE_SCREEN_WIDTH, CGRectGetMaxY(_followerLabel.frame)+10);
    
    NSArray *segmentArray               = @[@"UserInfo",@"Album",@"Favourite"];
    
    _segmentControl                     = [[UISegmentedControl alloc]initWithItems:segmentArray];
    _segmentControl.frame               = CGRectMake(0, CGRectGetMaxY(_followingLabel.frame) + 10, IPHONE_SCREEN_WIDTH, 25);
    _segmentControl.backgroundColor     = [UIColor clearColor];
    _segmentControl.tintColor           = [UIColor whiteColor];
    [_refreshView addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(changeTableView) forControlEvents:UIControlEventValueChanged];
    
    
    //set the contentSize of refreshView,
    //let the height of childController equal to Screen Height.
    _userInfoView               = [[UserInfoView alloc]initWithNibName:@"UserInfoView" bundle:[NSBundle mainBundle]];
    _userInfoView.view.frame    = CGRectMake(0, CGRectGetMaxY(_segmentControl.frame), IPHONE_SCREEN_WIDTH, _userInfoView.view.frame.size.height);
    
    
    _albumView                  = [[AlbumView alloc]init];
    _albumView.view.frame       = CGRectMake(0, CGRectGetMaxY(_segmentControl.frame), IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    
    
    [_refreshView addSubview:_userInfoView.view];
    
    //add childViewController
    [self addChildViewController:_userInfoView];
    [self addChildViewController:_albumView];
    _currentVC = _userInfoView;
    
    
    [_followingNumber addTarget:self action:@selector(openFollowingList) forControlEvents:UIControlEventTouchUpInside];
    [_followerNumber addTarget:self action:@selector(openFollowerList) forControlEvents:UIControlEventTouchUpInside];
    [_weiboNumber addTarget:self action:@selector(openMyWeiboList) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.title = @"ME";
    
    //let the view will not move down when it pushed into navigation
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //let the view which in front of the root view become opaque
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.view.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    [center addObserver:self selector:@selector(downloadUserProfile:) name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    
}

#pragma mark - Get Data 

- (void)downloadUserProfile:(NSNotification *)notification
{
    _access_token = [notification.userInfo objectForKey:@"token"];
    _uid = [notification.userInfo objectForKey:@"uid"];
    NSLog(@"。。。。。access is%@",_access_token);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getUserProfile = WBAPIURL_USERPROFILE;
        NSLog(@"%@",getUserProfile);
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        dict0 = @{@"access_token":_access_token,@"uid":_uid};
        
        NSLog(@"access_token is %@ uid is %@",_access_token,_uid);
        [manager GET:getUserProfile
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonData = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonString = [[NSString alloc]
                                          initWithData:jsonData
                                          encoding:NSUTF8StringEncoding];
                 NSLog(@"%@",jsonString);
                 
                 NSDictionary *userProfileDictionary = [jsonString objectFromJSONString];
                 _userProfile = [WeiboUserInfo createdByDictionary:userProfileDictionary];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self refreshUserProfile];
                     _userInfoView.userInfo = _userProfile;
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"userProfile get failure downloadUserProfile");
             }];
        
        
    });
    [_albumView setAccessToken];
}

//download others user profile
//Forbidden Now. Because of the weibo API restriction
- (void)downloadUserProfileWithUid:(long long)uid{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    _access_token = delegate.wbtoken;
    NSLog(@"。。。。。access is%@",_access_token);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getUserProfile = WBAPIURL_USERPROFILE;
        NSLog(@"%@",getUserProfile);
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        _uid = [NSString stringWithFormat:@"%lld",uid];
        dict0 = @{@"access_token":_access_token,@"uid":_uid};
        [manager GET:getUserProfile
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonData = [responserObject
                                     JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                     error:&error];
                 NSString *jsonString = [[NSString alloc]
                                         initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
                 NSLog(@"%@",jsonString);
                 
                 NSDictionary *userProfileDictionary = [jsonString objectFromJSONString];
                 _userProfile = [WeiboUserInfo createdByDictionary:userProfileDictionary];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self refreshUserProfile];
                     _userInfoView.userInfo = _userProfile;
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"userProfile get failure WithUid");
             }];
        
        
    });
    [_albumView setAccessToken];
}

- (void)downloadUserProfile {
    if (!_uid) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getUserProfile = WBAPIURL_USERPROFILE;
        NSLog(@"%@",getUserProfile);
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        dict0 = @{@"access_token":_access_token,@"uid":_uid};
        [manager GET:getUserProfile
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonData = [responserObject
                                     JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                     error:&error];
                 NSString *jsonString = [[NSString alloc]
                                         initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
                 NSLog(@"%@",jsonString);
                 
                 NSDictionary *userProfileDictionary = [jsonString objectFromJSONString];
                 _userProfile = [WeiboUserInfo createdByDictionary:userProfileDictionary];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self refreshUserProfile];
                     [_refreshView.header endRefreshing];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"userProfile get failure");
             }];
    });
}

#pragma mark - Change Children Controller / Segment Controller Event

- (void)changeTableView
{
    
    if ((_currentVC == _userInfoView && _segmentControl.selectedSegmentIndex == 0)||
        (_currentVC == _albumView && _segmentControl.selectedSegmentIndex == 1)) {
        return;
    }
    else{
        switch (_segmentControl.selectedSegmentIndex) {
            case 0:
                [self replaceController:_currentVC newController:_userInfoView];
                _refreshView.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, _userInfoView.view.frame.size.height + CGRectGetMaxY(_segmentControl.frame));
                break;
            case 1:
                [self replaceController:_currentVC newController:_albumView];
                _refreshView.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, _albumView.view.frame.size.height + CGRectGetMaxY(_segmentControl.frame));
                break;
            
            default:
                [_weiboTableView.view removeFromSuperview];
                break;
    }
    }
}
- (void)replaceController: (UIViewController *)oldController newController:(UIViewController *)newController {
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController
                      toViewController:newController
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished){
       
        if(finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            _currentVC = newController;
        }
        else {
            _currentVC = oldController;
        }
    }];
}

#pragma mark - Refresh Interface

- (void)refreshUserProfile {
    [_profileAvatar sd_setImageWithURL:
     [NSURL URLWithString:_userProfile.profile_image_url]
                      placeholderImage:nil
                               options:SDWebImageProgressiveDownload
                             completed:^(UIImage *image,
                                         NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL){
        if (image) {
            _profileAvatar.image = image;
        }
    }];
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

    _gender.text = _userProfile.gender;
    _address.text = _userProfile.location;
    _descriptions.text = _userProfile.descriptions;
    [_weiboNumber setTitle:[NSString stringWithFormat:@"%lld",_userProfile.statuses_count.longLongValue] forState:UIControlStateNormal];
    [_followingNumber setTitle:[NSString stringWithFormat:@"%lld",_userProfile.followers_count.longLongValue] forState:UIControlStateNormal];
    [_followerNumber setTitle:[NSString stringWithFormat:@"%lld",_userProfile.friends_count.longLongValue] forState:UIControlStateNormal];
}

#pragma mark - Button Deal Event

- (void)openFollowingList {
    NSLog(@"you touch following");
    FollowingListTableViewController *following = [[FollowingListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [following setUid:_uid];
    following.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:following animated:YES];
}

- (void)openFollowerList {
    NSLog(@"you touch follower");
    FollowerListTableViewController *follower = [[FollowerListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    follower.hidesBottomBarWhenPushed = YES;
    [follower setUid:_uid];
    [self.navigationController pushViewController:follower animated:YES];
}

- (void)openMyWeiboList {
    NSLog(@"you touch myweibo");
    WeiboTableView *myWeibo = [[WeiboTableView alloc]initWithStyle:UITableViewStylePlain];
    myWeibo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWeibo animated:YES];
}

#pragma mark UITextColor Setting Methods
- (void)setTextColorWithBackgroundImage:(UIImage *)background andComponent:(UILabel *) uiLabel
{
    UIColor *color = nil;
    if(background != nil)
        color = [background mostColor];
    else
        color = _basicInfoView.backgroundColor;
    if([self isLightColor:color])
        [uiLabel setTextColor:[UIColor blackColor]];
    else
        [uiLabel setTextColor:[UIColor whiteColor]];
}

//判断颜色是不是亮色
-(BOOL) isLightColor:(UIColor*)clr
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:clr];
    NSLog(@"%f %f %f", components[0], components[1], components[2]);
    
    CGFloat num = components[0] + components[1] + components[2];
    if(num < 382)
        return NO;
    else
        return YES;
}

//获取RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScorllViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0.2) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
