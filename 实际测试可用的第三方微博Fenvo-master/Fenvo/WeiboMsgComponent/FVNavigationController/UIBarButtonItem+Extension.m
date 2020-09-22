//
//  UIBarButtonItem+Extension.m
//  Fenvo
//
//  Created by Caesar on 15/6/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem(Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highLightedImage:(NSString *)hLightImage {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //set backgroundImage
    [backBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:hLightImage] forState:UIControlStateHighlighted];

    //set action of backBtn
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //set button frame
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    return itemBtn;
}
@end
