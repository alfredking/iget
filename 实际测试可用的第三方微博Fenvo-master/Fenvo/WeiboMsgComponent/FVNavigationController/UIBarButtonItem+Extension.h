//
//  UIBarButtonItem+Extension.h
//  Fenvo
//
//  Created by Caesar on 15/6/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem(Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highLightedImage:(NSString *)hLightImage;
@end
