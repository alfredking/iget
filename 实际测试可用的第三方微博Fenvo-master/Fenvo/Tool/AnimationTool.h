//
//  AnimationTool.h
//  Fenvo
//
//  Created by Neil on 15/9/9.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationTool : NSObject

+ (void)bounceTargetView:(UIView *)target;
+ (void)translationTargetView:(UIView *)target;
+ (void)rotationTargetView:(UIView *)target;
+ (void)vibrateTargetView:(UIView *)target;
+ (void)curveEaseInOutTargetFromTop:(UIView *)target;
+ (void)curveEaseInOutTargetFromBottom:(UIView *)target;

@end
