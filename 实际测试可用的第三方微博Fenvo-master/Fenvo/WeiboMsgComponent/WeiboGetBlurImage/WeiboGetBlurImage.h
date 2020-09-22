//
//  WeiboGetBlurImage.h
//  Fenvo
//
//  Created by Caesar on 15/5/21.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboGetBlurImage : NSObject
+ (WeiboGetBlurImage *)shareWeiboGetBlurImage;
-(UIImage*)getBlurImage:(UIImage*)image;
@end
