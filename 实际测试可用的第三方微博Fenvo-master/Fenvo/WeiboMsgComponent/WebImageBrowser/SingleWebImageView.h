//
//  SingleWebImageView.h
//  WebImageBrowserDemo
//
//  Created by Caesar on 15/4/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleWebImageView : UIImageView
@property(nonatomic, copy)NSString *original_pic_url;
@property(nonatomic, copy)NSString *bmiddle_pic_url;

-(SingleWebImageView *)initWithStyleAndBmiddlePicUrl:(NSString *)bmiddle_pic_url andOriginalPicUrl:(NSString *)original_pic_url;
@end
