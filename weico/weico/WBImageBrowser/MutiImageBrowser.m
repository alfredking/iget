//
//  WeiboImageBrowser.m
//  Fenvo
//
//  Created by Caesar on 15/4/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "MutiImageBrowser.h"
#import "MutiImageView.h"

#define IPHONE_SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define IPHONE_SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface MutiImageBrowser ()<UIScrollViewDelegate>
{
    UIWindow *window;
    UIImageView *imageView;
    UIScrollView *scrollView;
    UIScrollView *mainScrollView;
    UIPageControl *pageControl;
    //
    UIButton *_deleteBtn;
    
    //
    NSMutableArray *_imageArray;
}
@end

@implementation MutiImageBrowser:NSObject
+(MutiImageBrowser *)sharedMutiImageBrowser{
    static MutiImageBrowser *webImageBrowser;
    @synchronized(self){
        if (!webImageBrowser) {
            webImageBrowser = [[self alloc]init];
        }
    }
    return webImageBrowser;
}

-(void)show:(NSArray *)imageArray withTag:(NSInteger)tag andImageView:(MutiImageView *)img{
    //初始化控件
    _imageArray = [[NSMutableArray alloc]initWithArray:imageArray];
    NSLog(@"------The imageArray count is :%ld",_imageArray.count);
    [self initComponentWithTag:tag];

    imageView.image = img.image;
    
    CGSize imageSize = imageView.image.size;
    float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
            
    //图片尺寸调整显示
    //如果按比例缩小图片后图片长仍然比屏幕长，则按照长度设置scrollview的垂直方向上的可拖动范围
    if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
        imageView.frame = CGRectMake(8, 20, IPHONE_SCREEN_WIDTH - 16, imageSize.height/b);
        scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
    }
    else{
        imageView.frame = CGRectMake(8, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH - 16, imageSize.height/b);
    }
    CGFloat img_left = CGRectGetMaxX(imageView.frame);
    CGFloat img_top = imageView.frame.origin.y;
    _deleteBtn.frame = CGRectMake(img_left - 15, img_top - 15, 30, 30);
    
    UITapGestureRecognizer *tap_closeScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close:)];
    [mainScrollView addGestureRecognizer:tap_closeScrollView];
    //放大图片浏览器
    [UIScrollView animateWithDuration:0.3 animations:^{
        mainScrollView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}

- (void)initComponentWithTag:(NSInteger)tag{
    window = [UIApplication sharedApplication].keyWindow;
    mainScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    mainScrollView.backgroundColor = RGBACOLOR(20, 20, 20, 0.55);
    mainScrollView.scrollEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(_imageArray.count * IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2 - 15, IPHONE_SCREEN_HEIGHT - 20, 30, 10)];
    pageControl.currentPageIndicatorTintColor = RGBACOLOR(20, 200, 40, 0.5);
    pageControl.pageIndicatorTintColor = RGBACOLOR(200, 200, 200, 0.8);
    pageControl.numberOfPages = _imageArray.count;
    [pageControl setCurrentPage:tag];
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(pageControl.currentPage*IPHONE_SCREEN_WIDTH, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    
    
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(pageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    scrollView.frame = rect;
    [mainScrollView scrollRectToVisible:rect animated:YES];
    
    //scrollView.backgroundColor = RGBACOLOR(220, 220, 220, 0.6);
    
    
    CAGradientLayer* _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = scrollView.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = scrollView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0);
    //_gradientLayer.startPoint
    //_gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    
    [scrollView.layer insertSublayer:_gradientLayer atIndex:0];
    
    
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 0.5;
    
    imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];

    
    //设置tag值因为点击时需要按照tag获取点击的控件
    imageView.tag = 901;
    [scrollView addSubview:imageView];
    [mainScrollView addSubview:scrollView];
    
    [window addSubview:mainScrollView];
    [window addSubview:pageControl];
    [imageView addSubview:_deleteBtn];
}

//
-(void)pageTurn:(UIPageControl *)aPageControl{
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(aPageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    scrollView.frame = rect;
    [mainScrollView scrollRectToVisible:rect animated:YES];
     ;
    
    MutiImageView *img;
    img = (MutiImageView *)_imageArray[pageControl.currentPage];
    imageView.image = img.image;
    
    CGSize imageSize = imageView.image.size;
    float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
    
    //图片尺寸调整显示
    //如果按比例缩小图片后图片长仍然比屏幕长，则按照长度设置scrollview的垂直方向上的可拖动范围
    if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
        imageView.frame = CGRectMake(8, 20, IPHONE_SCREEN_WIDTH - 16, imageSize.height/b);
        scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
    }
    else{
        imageView.frame = CGRectMake(8, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH - 16, imageSize.height/b);
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    CGFloat img_left = imageView.frame.origin.x + imageView.frame.size.width;
    CGFloat img_top = imageView.frame.origin.y;
    _deleteBtn.frame = CGRectMake(img_left - 15, img_top - 15, 30, 30);
}

-(void)close:(UITapGestureRecognizer *)tap{
    UIScrollView *backgroundView = tap.view;
    UIImageView *aimageView = (UIImageView *)[tap.view viewWithTag:901];
    [UIScrollView animateWithDuration:0.3 animations:^{
        backgroundView.alpha = 0;
        pageControl.alpha = 0;
        _deleteBtn.alpha = 0;
    }completion:^(BOOL finished){
        [backgroundView removeFromSuperview];
        [pageControl removeFromSuperview];
        [_deleteBtn removeFromSuperview];
    }];
}

- (void)deleteImage {
    NSDictionary *dict = [[NSDictionary alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteImage" object:[NSNumber numberWithLong:pageControl.currentPage]];
    [_imageArray removeObjectAtIndex:pageControl.currentPage];
    //remove the window
    [UIScrollView animateWithDuration:0.3 animations:^{
        mainScrollView.alpha = 0;
        pageControl.alpha = 0;
        _deleteBtn.alpha = 0;
    }completion:^(BOOL finished){
        [mainScrollView removeFromSuperview];
        [pageControl removeFromSuperview];
        [_deleteBtn removeFromSuperview];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)myScrollView{
    if (myScrollView == mainScrollView) {
        CGPoint offset = myScrollView.contentOffset;
        pageControl.currentPage = offset.x/(mainScrollView.bounds.size.width);
        CGSize viewSize = scrollView.frame.size;
        CGRect rect = CGRectMake(pageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
        scrollView.frame = rect;
        [mainScrollView scrollRectToVisible:rect animated:YES];

        MutiImageView *img;
        img = (MutiImageView *)_imageArray[pageControl.currentPage];
        imageView.image = img.image;
        CGSize imageSize = imageView.image.size;
        float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
        
        //图片尺寸调整显示
        //如果按比例缩小图片后图片长仍然比屏幕长，则按照长度设置scrollview的垂直方向上的可拖动范围
        if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
            imageView.frame = CGRectMake(8, 20, IPHONE_SCREEN_WIDTH - 16, imageSize.height/b);
            scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
        }
        else{
            imageView.frame = CGRectMake(8, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH - 16, imageSize.height/b);
        }
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        CGFloat img_left = imageView.frame.origin.x + imageView.frame.size.width;
        CGFloat img_top = imageView.frame.origin.y;
        _deleteBtn.frame = CGRectMake(img_left - 15, img_top - 15, 30, 30);

    }
}

@end
