//
//  IDMPShadeView.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPShadeView.h"

@implementation IDMPShadeView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.55] set];
    CGContextFillRect(context, self.bounds);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.closeBlcok();
}

@end
