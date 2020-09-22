//
//  WeiboImageView.m
//  Fenvo
//
//  Created by Caesar on 15/3/31.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MutiImageView.h"
#import "MutiImageBrowser.h"
@interface MutiImageView()
{
    NSArray* _imageArray;
}
@end
@implementation MutiImageView

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
- (MutiImageView *)initWithImageArray:(NSArray *)imageArray AndTag:(NSInteger)tag{
    
    self = [super init];
    if (self) {
        _imageArray = imageArray;
        self.tag = tag;
        self.hidden = NO;
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        //self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage)];
        [self addGestureRecognizer:tap];
        
    }
    return  self;
}
-(void)setImageArray:(NSArray *)imageArray andTag:(NSInteger)tag{
    _imageArray = imageArray;
    self.tag = tag;

}


//调用打开图片浏览器显示中图
-(void)showImage{
    [[MutiImageBrowser sharedMutiImageBrowser] show:_imageArray withTag:self.tag andImageView:self];
}

@end