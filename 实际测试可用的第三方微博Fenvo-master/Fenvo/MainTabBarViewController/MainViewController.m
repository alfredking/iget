//
//  MainViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/18.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MainViewController.h"
#import "FollowingWBViewController.h"
#import "ProfileViewController.h"
#import "WeiboRemindVC.h"
#import "NewWeiboVC.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "MainTabBar.h"
#import "HomeNavigationController.h"
#import "MessageNavigationController.h"
#import "ProfileNavigationViewController.h"

@interface MainViewController ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    FollowingWBViewController *_followingWeiboVC;
    HomeNavigationController *_followingWeiboNC;
    
    ProfileViewController *_profileVC;
    ProfileNavigationViewController *_profileNC;
    
    WeiboRemindVC *_remindVC;
    MessageNavigationController *_remindNC;
    

    UIBarButtonItem *_settingBtn;
}
@end

@implementation MainViewController
NSString *access_token;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubView];
    self.selectedIndex = 0;

    [self tabBar:self.tabBar didSelectItem:_followingWeiboVC.tabBarItem];
    // Do any additional setup after loading the view.
    
}
- (void)initSubView{
    //自定义tabbar实现透明效果，替换时要使用[self setValue:  forKey:];因为其自带tabbar是只读，不能使用赋值形式。
    UITabBar * rootTabBar = [[MainTabBar alloc] init];
    
    [self.view addSubview:rootTabBar];
    [self setValue:rootTabBar forKey:@"tabBar"];

    _followingWeiboVC = [[FollowingWBViewController alloc]init];
    _followingWeiboNC = [[HomeNavigationController alloc]initWithRootViewController:_followingWeiboVC];
    _followingWeiboNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"HOME" image:[UIImage imageWithIcon:@"fa-home" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] andSize:CGSizeMake(20.0f, 20.0f)] selectedImage:[UIImage imageWithIcon:@"fa-home" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0f, 20.0f)]];
    _followingWeiboNC.tabBarItem.tag = 0;

    [self selectedTapTabBarItems:_followingWeiboNC.tabBarItem];
    [self unselectedTapTabBarItems:_followingWeiboNC.tabBarItem];
    
    
    _remindVC = [[WeiboRemindVC alloc]initWithStyle:UITableViewStyleGrouped];
    _remindNC = [[MessageNavigationController alloc]initWithRootViewController:_remindVC];
    _remindNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"MESSAGE" image:[UIImage imageWithIcon:@"fa-envelope" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] andSize:CGSizeMake(20.0f, 20.0f)] selectedImage:[UIImage imageWithIcon:@"fa-envelope" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0f, 20.0f)]];
    _remindNC.tabBarItem.tag = 1;
    [self selectedTapTabBarItems:_remindNC.tabBarItem];
    [self unselectedTapTabBarItems:_remindNC.tabBarItem];
    
    _profileVC = [[ProfileViewController alloc]init];
    _profileNC = [[ProfileNavigationViewController alloc]initWithRootViewController:_profileVC];
    _profileNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"ME" image:[UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:[UIColor lightGrayColor] andSize:CGSizeMake(20.0f, 20.0f)] selectedImage:[UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20.0f, 20.0f)]];

    _profileNC.tabBarItem.tag = 3;
    [self selectedTapTabBarItems:_profileNC.tabBarItem];
    [self unselectedTapTabBarItems:_profileNC.tabBarItem];
    
    
    
    self.viewControllers = @[_followingWeiboNC,_remindNC,_profileNC];
//    for (UIViewController *controller in self.viewControllers) {
//        UIViewController *view= controller.view;
//    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

}

- (void)selectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],UITextAttributeFont,RGBACOLOR(250, 143, 5, 1),UITextAttributeTextColor,nil] forState:UIControlStateSelected];
}
- (void)unselectedTapTabBarItems: (UITabBarItem *)tabBarItem{
    [tabBarItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0],UITextAttributeFont,[UIColor lightGrayColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
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
