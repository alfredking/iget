//
//  MainTabBar.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MainTabBar.h"

@implementation MainTabBar

//既然不需要改变size，就不需要重写了
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGSize osize = [super sizeThatFits:size];
//
//    NSLog(@"osize is %@",NSStringFromCGSize(osize));
////    osize.height = 40;
//    //测试改变tabbar高度，然后就没有图标和字体重叠的问题了
////    osize.height = 80;
//    //测试发现，直接使用系统给的size就可以，不需要再自己设置高度
//
//    return osize;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUserInteractionEnabled:YES];
    [self setTintColor:RGBACOLOR(250, 143, 5, 1) ];
    [self setBackgroundColor:[UIColor blackColor]];
    self.barStyle = UIBarStyleBlackOpaque;
    [self setAlpha:1];
}

@end
