//
//  EFButton.m
//  EnjoyFood
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "EFButton.h"

#define W self.frame.size.width
#define H self.frame.size.height


@implementation EFButton

+ (instancetype)markButton
{
    return [[self alloc] init];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = W * 0.2;
    CGFloat imageY = H * 0.1;
    CGFloat imageW = W * 0.6;
    CGFloat imageH = imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = W * 0.1;
    CGFloat titleY = H * 0.7;
    CGFloat titleW = W * 0.8;
    CGFloat titleH = H * 0.2;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
