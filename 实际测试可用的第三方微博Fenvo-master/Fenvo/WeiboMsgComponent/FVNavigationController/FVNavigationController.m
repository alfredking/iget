//
//  FVNavigationController.m
//  Fenvo
//
//  Created by Caesar on 15/6/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FVNavigationController.h"
#import "UIBarButtonItem+Extension.h"

@interface FVNavigationController ()

@end

@implementation FVNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //normal state
    NSMutableDictionary *textAttrsNormal = [NSMutableDictionary dictionary];
    textAttrsNormal[NSForegroundColorAttributeName] = RGBACOLOR(30, 40, 50, 1);
    textAttrsNormal[NSFontAttributeName] = SystemFont;
    [item setTitleTextAttributes:textAttrsNormal forState:UIControlStateNormal];
    
    //disable state
    NSMutableDictionary *textAttrsDisabled = [NSMutableDictionary dictionary];
    textAttrsDisabled[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    textAttrsDisabled[NSForegroundColorAttributeName] = RGBACOLOR(100, 100, 100, 1);
    [item setTitleTextAttributes:textAttrsDisabled forState:UIControlStateDisabled];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //set the left button.
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(back)];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highLightedImage:@"navigationbar_more_hl"];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)more {
    [self popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
