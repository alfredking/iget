//
//  ViewManagerTool.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "ViewManagerTool.h"

@implementation ViewManagerTool

//get the controller of view
//得到此view 所在的viewController
+ (UIViewController *)viewController: (UIView *)view{
    for (UIView* next = [view superview]; next; next =
         next.superview) {
        
        NSLog(@"next is %@",next);
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isMemberOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
