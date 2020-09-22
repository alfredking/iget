//
//  WeiboImageView.m
//  Fenvo
//
//  Created by Caesar on 15/3/31.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WebImageView.h"
#import "WebImageBrowser.h"

@implementation WebImageView

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
- (WebImageView *)initWithStyleAndTag:(NSInteger)tag{
    
    self = [super init];
    if (self) {
        self.tag = tag;
        //self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.hidden = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundColor = RGBACOLOR(220, 220, 220, 0.5);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBmiddleImage:)];
        [self addGestureRecognizer:tap];
        
    }
    return  self;
}
- (void)setOriginal_pic_url{
    _original_pic_url = _original_pic_urls[self.tag];
}
- (void)setBmiddle_pic_url{
    _bmiddle_pic_url = _bmiddle_pic_urls[self.tag];
}
- (void)setBmiddle_pic_urls:(NSArray *)bmiddle_pic_urls{
    _bmiddle_pic_urls = bmiddle_pic_urls;
    [self setBmiddle_pic_url];
}
- (void)setOriginal_pic_urls:(NSArray *)original_pic_urls{
    _original_pic_urls = original_pic_urls;
    [self setOriginal_pic_url];
}

-(void)showOriginalImage:(NSString *)original_pic_url{
    
}
//调用打开图片浏览器显示中图
-(void)showBmiddleImage:(NSString *)bmiddle_pic_url{
    [[WebImageBrowser sharedWebImageBrowser] showBmiddlePic:self andTag:self.tag];
}

@end