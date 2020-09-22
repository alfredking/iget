//
//  StyleOfRemindSubviews.m
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "StyleOfRemindSubviews.h"

@implementation StyleOfRemindSubviews

+ (CGFloat)baseWeiboHeight {
    return 50;
}

+ (CGFloat)usernameHeight {
    return 18;
}

+ (CGFloat)detailHeight {
    return 30;
}

+ (CGFloat)componentSpacing {
    return 8.0;
}

+ (CGFloat)componentSpacing_small {
    return 4.0;
}

+ (CGFloat)componentSpacing_large {
    return 12.0;
}

+ (CGFloat)bottomHeight {
    return 44.0f;
}


+ (UIFont *)buttonFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:13.0];
}

+ (UIFont *)middleFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:13.0];
}

+ (UIFont *)smallFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:10.0];
}

+ (UIFont *)largeFont {
    return [UIFont fontWithName:@ "HYQiHei-BEJ" size:15.0];
}



+ (UIColor *)middleGreyColor {
    return RGBACOLOR(160, 160, 160, 1);
}

+ (UIColor *)greyColor {
    return RGBACOLOR(60, 60, 60, 1);
}

+ (UIColor *)lightGreyColor {
    return RGBACOLOR(220, 220, 220, 1);
}

+ (UIColor *)deepBlackColor {
    return RGBACOLOR(10, 20, 20, 1);
}

+ (UIColor *)orangeColor {
    return RGBACOLOR(250, 143, 5, 1);
}

+ (UIColor *)lightSkyColor {
    return RGBACOLOR(211, 227, 235, 1);
}

+ (UIColor *)whiteOpaqueColor {
    return RGBACOLOR(220, 220, 220, 0.3);
}

+ (UIColor *)blackOpaqueColor_light{
    return RGBACOLOR(60, 60, 60, 0.75);
}

@end
