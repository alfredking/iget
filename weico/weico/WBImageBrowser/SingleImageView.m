//
//  SingleWebImageView.m
//  WebImageBrowserDemo
//
//  Created by Caesar on 15/4/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "SingleImageView.h"
#import "SingleImageBrowser.h"

@implementation SingleImageView

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
- (SingleImageView *)initWithStyle{
    
    self = [super init];
    if (self) {
        //ImageView样式自行定制
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = RGBACOLOR(220, 220, 220, 0.5);
        //添加手势
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
        [self addGestureRecognizer:tap];
    }
    return  self;
}
//调用打开图片浏览器显示中图
-(void)showBmiddleImage{
    [[SingleImageBrowser sharedSingleWebImageBrowser]show:self];
}
@end
