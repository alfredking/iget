//
//  IDMPPopViewController.h
//  IDMPCMCC
//
//  Created by wj on 2017/7/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDMPShadeView.h"

@interface IDMPPopViewController : UIViewController

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) IDMPShadeView *shadeView;
@property (nonatomic, copy) void(^closeBlcok)(NSDictionary *parameters);

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
