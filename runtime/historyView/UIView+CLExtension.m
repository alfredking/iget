//
//  UIView+CLExtension.m
//  
//
//  Created by CHEN on 15/11/6.
//  Copyright © 2015年 CHEN. All rights reserved.
//

#import "UIView+CLExtension.h"

@implementation UIView (CLExtension)

- (CGSize)size
{
    return self.frame.size;
}

- (void)setsize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setwidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setheight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setx:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)sety:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setcenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setcenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)right
{
//    return self.x + self.width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)bottom
{
//    return self.y + self.height;
    return CGRectGetMaxY(self.frame);
}

- (void)setright:(CGFloat)right
{
    self.x = right - self.width;
}

- (void)setbottom:(CGFloat)bottom
{
    self.y = bottom - self.height;
}

- (UIViewController *)getCurrentViewController {
    
    id nextResponder = [self nextResponder];
    while (nextResponder != nil) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
        nextResponder = [nextResponder nextResponder];
    }
    return nil;
}
@end
