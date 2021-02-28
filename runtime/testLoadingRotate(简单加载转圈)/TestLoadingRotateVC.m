//
//  TestLoadingRotateVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "TestLoadingRotateVC.h"

@interface TestLoadingRotateVC ()
@property(nonatomic,strong)UIImageView *imag;
@end

@implementation TestLoadingRotateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 80, 80)];
    imag.image = [UIImage imageNamed:@"rp"];
    //    imag.transform = CGAffineTransformMakeRotation(223);
    [self.view addSubview:imag];
    self.imag = imag;
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"转圈" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
-(void)click:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self testLoadingRotate:btn.selected];
}

#pragma 简单的加载转圈

- (void)testLoadingRotate:(BOOL)isRotating{
    if (isRotating) {
        [self startRotate:self.imag];
    }else{
        [self stopRotate:self.imag];
    }
}

/**
 开始转圈

 @param loadingImage UIImageView
 */
-(void)startRotate:(UIImageView *)loadingImage{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = HUGE_VALF;
    [loadingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/**
 停止转圈

 @param loadingImage UIImageView
 */
-(void)stopRotate:(UIImageView *)loadingImage{
    [loadingImage.layer removeAllAnimations];
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0*(M_PI/180.0f));
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        loadingImage.transform = endAngle;
    } completion:^(BOOL finished) {
    }];
    
    
}

@end
