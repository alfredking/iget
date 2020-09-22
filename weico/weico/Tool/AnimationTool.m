//
//  AnimationTool.m
//  Fenvo
//
//  Created by Neil on 15/9/9.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import "AnimationTool.h"

@implementation AnimationTool

+ (void)bounceTargetView:(UIView *)target
{
    [UIView animateWithDuration:0.1 animations:^{
        target.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            target.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                target.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

+ (void)translationTargetView:(UIView *)target
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         target.transform = CGAffineTransformMakeTranslation(40, 0);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              target.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

+ (void)rotationTargetView:(UIView *)target
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         target.transform = CGAffineTransformMakeRotation(M_PI);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3 animations:^{
                             target.transform = CGAffineTransformMakeRotation(M_PI);
                         } completion:^(BOOL finished) {
                             target.transform = CGAffineTransformIdentity;
                         }];
                     }];
}

//Vibrate View
+ (void)vibrateTargetView:(UIView *)target
{
    [UIView animateWithDuration:0.05 animations:^{
        target.transform = CGAffineTransformMakeTranslation(2, 5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            target.transform = CGAffineTransformMakeTranslation(-2, - 5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                target.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    target.transform = CGAffineTransformMakeTranslation(2, - 5);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.05 animations:^{
                        target.transform = CGAffineTransformMakeTranslation(-2, 5);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.05 animations:^{
                            target.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }];
    }];
}

//From top to move in
+ (void)curveEaseInOutTargetFromTop:(UIView *)target
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromBottom;
    [target.layer addAnimation:animation forKey:@"animation"];
}

//From top to move in
+ (void)curveEaseInOutTargetFromBottom:(UIView *)target
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    [target.layer addAnimation:animation forKey:@"animation"];
}

@end
