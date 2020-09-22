//
//  HomeNavigationController.h
//  Fenvo
//
//  Created by Caesar on 15/7/26.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNavigationController : UINavigationController

@property (nonatomic, strong) UIButton *titleButton;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
@end
