//
//  ImageScaleDown.m
//  Fenvo
//
//  Created by Caesar on 15/5/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "ImageScaleDown.h"

@implementation ImageScaleDown

+ (ImageScaleDown *)shareImageScaleDown {
    static ImageScaleDown *imageScaleDown = nil;
    @synchronized(self) {
        if (!imageScaleDown) {
            imageScaleDown = [[self alloc]init];
        }
    }
    return imageScaleDown;
}

- (UIImageView *)compressImage:(float)viewWidth andImage: (UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    
    float orgi_width = image.size.width;
    float orgi_height = image.size.height;
    
    //根据视图宽度以及图片长宽比按比例压缩
    float new_width = viewWidth - 5;
    float new_height = (viewWidth * orgi_height)/orgi_width;
    
    //重置ImageView尺寸
    [imageView setFrame:CGRectMake(0, 0, new_width, new_height)];
    
    return imageView;
}

@end
