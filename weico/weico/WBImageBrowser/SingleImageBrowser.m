//
//  SingleWebImageBrowser.m
//  WebImageBrowserDemo
//
//  Created by Caesar on 15/4/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "SingleImageBrowser.h"

#define IPHONE_SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define IPHONE_SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface SingleImageBrowser()<UIScrollViewDelegate>
{
    UIWindow *window;
    UIImageView *imageView;
    UIScrollView *scrollView;
    //
    UIButton *deleteBtn;
}
@end

@implementation SingleImageBrowser:NSObject
static CGRect oldImageViewFrame;
+(SingleImageBrowser *)sharedSingleWebImageBrowser{
    static SingleImageBrowser *webImageBrowser;
    @synchronized(self){
        if (!webImageBrowser) {
            webImageBrowser = [[self alloc]init];
        }
    }
    return webImageBrowser;
}

-(void)show:(SingleImageView *)webImageView{
    //初始化控件
    [self initComponent:webImageView];
    
    imageView.image = webImageView.image;
    CGSize imageSize = webImageView.image.size;
    float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
                                
    //依据下载图片尺寸调整显示
    //如果按比例缩小图片后图片长仍然比屏幕长，则按照长度设置scrollview的垂直方向上的可拖动范围
    if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
        imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
        scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
    }
    else{
        imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
    }
    
    UITapGestureRecognizer *tap_closeScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    [scrollView addGestureRecognizer:tap_closeScrollView];
    //放大图片浏览器
    [UIScrollView animateWithDuration:0.3 animations:^{
        scrollView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}

- (void)initComponent:(UIImageView *)webImageView{
    window = [UIApplication sharedApplication].keyWindow;
    
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(10, IPHONE_SCREEN_HEIGHT-40, 50, 25);
    [deleteBtn setTitle:@"Original" forState:UIControlStateNormal];
    [deleteBtn setFont:[UIFont systemFontOfSize:12]];
    deleteBtn.layer.cornerRadius = 5.0;
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.backgroundColor = RGBACOLOR(20, 200, 40, 0.5);
    [deleteBtn addTarget:self action:@selector(downloadOriginalPic) forControlEvents:UIControlEventTouchUpInside];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    
    oldImageViewFrame = [webImageView convertRect:webImageView.bounds toView:window];
    scrollView.backgroundColor = RGBACOLOR(150, 150, 150, 0.6);
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 0.5;
    
    imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    
    //设置tag值因为点击时需要按照tag获取点击的控件
    imageView.tag = 901;
    [scrollView addSubview:imageView];
    
    [window addSubview:scrollView];
    [window addSubview:deleteBtn];
}

-(void)close:(UITapGestureRecognizer *)tap{
    UIScrollView *backgroundView = tap.view;
    UIImageView *aimageView = (UIImageView *)[tap.view viewWithTag:901];
    [UIScrollView animateWithDuration:0.3 animations:^{
        aimageView.frame = oldImageViewFrame;
        backgroundView.alpha = 0;
        deleteBtn.alpha = 0;
    }completion:^(BOOL finished){
        [backgroundView removeFromSuperview];
        [deleteBtn removeFromSuperview];
    }];
}

//双指扩张放大图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView{
    if (aScrollView == scrollView) {
        return imageView;
    }
    return nil;
}
//放大缩小调整图片位置使其不发生偏移
- (void)scrollViewDidZoom:(UIScrollView *)ascrollView{
    if (ascrollView == scrollView) {
        CGFloat offsetX = (ascrollView.bounds.size.width > ascrollView.contentSize.width)?
        (ascrollView.bounds.size.width - ascrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (ascrollView.bounds.size.height > ascrollView.contentSize.height)?
        (ascrollView.bounds.size.height - ascrollView.contentSize.height) * 0.5 : 0.0;
        imageView.center = CGPointMake(ascrollView.contentSize.width * 0.5 + offsetX,
                                       ascrollView.contentSize.height * 0.5 + offsetY);
    }
    
}
@end
