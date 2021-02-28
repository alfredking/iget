//
//  EGmyAlertView.m
//  EntranceGuard
//
//  Created by 大碗豆 on 16/12/5.
//  Copyright © 2016年 大碗豆. All rights reserved.
//

#import "EGmyAlertView.h"
//#import "BlueToothViewController.h"
//#import "EGTabBarViewController.h"

@interface EGmyAlertView ()
//背景图
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation EGmyAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (void)loadDefaultSetting{
//    self.backgroundColor = [UIColor whiteColor];
    //改变父视图的透明度而不改变子视图的透明度
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundView];
}




- (void)setContentView:(UIViewController *)contentView{
    _contentView = contentView;
    
    _contentView.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _contentView.view.center = self.center;
    
//    BlueToothViewController *BleVC = [BlueToothViewController new];
//    [BleVC setBlkArrCount:^(NSUInteger count) {
//    
//        _contentViewHeight = count;
//    
////        限制alertView的高度
////                if (_contentViewHeight >4) {
////                    _contentViewHeight = 4;
////                }
////        
////        决定alertview的大小
//        _contentView.view.frame = CGRectMake(0, 0, ANYScreenWidth, (_contentViewHeight+3)*CellHeight);
//        _contentView.view.center = self.center;
//        _contentViewHeight = 0;
//    }];
//    
    [_backgroundView addSubview:_contentView.view];
    
    NSLog(@"%f",_contentViewHeight);
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window makeKeyAndVisible];
    window.backgroundColor = [UIColor redColor];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [subView addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}

- (void)hide {
    _contentView.view.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

- (void)showBackground
{
    _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
//    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
     _backgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.6];
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.view.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self hide];
}

@end
