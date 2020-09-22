//
//  ImageScaleDown.h
//  Fenvo
//
//  Created by Caesar on 15/5/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageScaleDown : NSObject
+ (ImageScaleDown *)shareImageScaleDown;
- (UIImageView *)compressImage:(float)viewWidth andImage: (UIImage *)image;
@end
