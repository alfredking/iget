//
//  UIView+CLExtension.h
//  
//
//  Created by CHEN on 15/11/6.
//  Copyright © 2015年 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CLExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

/**
 获取当前view所在的控制器
 
 @return UIViewController
 */
- (UIViewController *)getCurrentViewController;
@end
