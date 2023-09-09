
//
//  YellowView.m
//  TouchEventLib-master
//
//  Created by 卢旭峰 on 2017/8/23.
//  Copyright © 2017年 StockAccount. All rights reserved.
//

#import "YellowView.h"

@implementation YellowView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [super touchesCancelled:touches withEvent:event];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"yellow view hitTest called");
    return  [super hitTest:point withEvent:event];
}
@end
