//
//  HomeNavigationController.m
//  Fenvo
//
//  Created by Caesar on 15/7/26.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "HomeNavigationController.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "NewWeiboVC.h"

@interface HomeNavigationController ()
{
        
}
@end

@implementation HomeNavigationController

- (void)loadView
{
    [super loadView];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {

    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
