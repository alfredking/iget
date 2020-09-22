//
//  WeiboImageBrowser.m
//  Fenvo
//
//  Created by Caesar on 15/4/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WebImageBrowser.h"
#import "UIImageView+WebCache.h"
#import "KVNProgress.h"

#define IPHONE_SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define IPHONE_SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface WebImageBrowser ()<UIScrollViewDelegate>
{
    UIWindow *window;
    UIImageView *imageView;
    UIScrollView *scrollView;
    UIScrollView *mainScrollView;
    UIPageControl *pageControl;
    NSArray *bmiddle_pic_urls;
    NSArray *original_pic_urls;
    //
    UIButton *downloadBtn;
    UIButton *saveBtn;
    //
    UIActivityIndicatorView *waiting;
}
@end

@implementation WebImageBrowser:NSObject
static CGRect oldImageViewFrame;
+(WebImageBrowser *)sharedWebImageBrowser{
    static WebImageBrowser *webImageBrowser;
    @synchronized(self){
        if (!webImageBrowser) {
            webImageBrowser = [[self alloc]init];
        }
    }
    return webImageBrowser;
}

-(void)showBmiddlePic:(WebImageView *)webImageView andTag:(NSInteger)tag{
    NSString *url = webImageView.bmiddle_pic_url;
    bmiddle_pic_urls = webImageView.bmiddle_pic_urls;
    original_pic_urls = webImageView.original_pic_urls;
    //初始化控件
    [self initComponent:webImageView andTag:tag];
    
    
    [imageView addSubview:waiting];
    [waiting startAnimating];
    
    //使用SDWebImage异步下载并缓存图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:nil
                          options:SDWebImageProgressiveDownload
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        //图片下载成功
        if (image) {
            [waiting stopAnimating];
            imageView.image = image;
            CGSize imageSize = image.size;
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
        }
        else{
            [waiting stopAnimating];
        }
        
    }];
    
    
    
    UITapGestureRecognizer *tap_closeScrollView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBmiddlePic:)];
    [mainScrollView addGestureRecognizer:tap_closeScrollView];
    //放大图片浏览器
    [UIScrollView animateWithDuration:0.3 animations:^{
        mainScrollView.alpha = 1;
    }completion:^(BOOL finished){
        
    }];
}

- (void)initComponent:(WebImageView *)webImageView andTag:(NSInteger)tag{
    window = [UIApplication sharedApplication].keyWindow;
    mainScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    mainScrollView.backgroundColor = RGBACOLOR(20, 20, 20, 0.55);
    mainScrollView.scrollEnabled = YES;
    mainScrollView.contentSize = CGSizeMake(webImageView.bmiddle_pic_urls.count * IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH/2 - 15, IPHONE_SCREEN_HEIGHT - 20, 30, 10)];
    pageControl.currentPageIndicatorTintColor = RGBACOLOR(20, 200, 40, 0.5);
    pageControl.pageIndicatorTintColor = RGBACOLOR(200, 200, 200, 0.8);
    pageControl.numberOfPages = bmiddle_pic_urls.count;
    [pageControl setCurrentPage:tag];
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake(10, IPHONE_SCREEN_HEIGHT-40, 50, 25);
    [downloadBtn setTitle:@"Original" forState:UIControlStateNormal];
    [downloadBtn setFont:[UIFont systemFontOfSize:12]];
    downloadBtn.layer.cornerRadius = 5.0;
    downloadBtn.layer.masksToBounds = YES;
    downloadBtn.backgroundColor = RGBACOLOR(20, 200, 40, 0.5);
    [downloadBtn addTarget:self action:@selector(downloadOriginalPic) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(70, IPHONE_SCREEN_HEIGHT-40, 50, 25);
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setFont:[UIFont systemFontOfSize:12]];
    saveBtn.layer.cornerRadius = 5.0;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.backgroundColor = RGBACOLOR(20, 200, 40, 0.5);
    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(pageControl.currentPage*IPHONE_SCREEN_WIDTH, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
    
    
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(pageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    scrollView.frame = rect;
    [mainScrollView scrollRectToVisible:rect animated:YES];
    
    oldImageViewFrame = [webImageView convertRect:webImageView.bounds toView:window];
    
    CAGradientLayer* _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = scrollView.bounds;
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = scrollView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],nil];
    _gradientLayer.startPoint = CGPointMake(0.5, 0);
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
    
    //设置tag值因为点击时需要按照tag获取点击的控件
    imageView.tag = 901;
    [scrollView addSubview:imageView];
    [mainScrollView addSubview:scrollView];
    
    [window addSubview:mainScrollView];
    [window addSubview:pageControl];
    [window addSubview:downloadBtn];
    [window addSubview:saveBtn];
    
    waiting = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    waiting.center = CGPointMake(window.center.x, window.center.y);
    [imageView addSubview:waiting];
    
}

//下载大图
- (void)downloadOriginalPic{
    [waiting startAnimating];
    NSLog(@"Original image download finished%@",original_pic_urls[pageControl.currentPage]);
    [imageView sd_setImageWithURL:[NSURL URLWithString:original_pic_urls[pageControl.currentPage]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (image) {
            [waiting stopAnimating];
            imageView.image = image;
            CGSize imageSize = image.size;
            float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
            if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
                imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
            }
            else{
                imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
            }
        }
    }];

}

//保存图片到相册
- (void)saveImage{
    UIImageWriteToSavedPhotosAlbum([imageView image], nil, nil, nil);
    [KVNProgress showSuccess];
}

//
-(void)pageTurn:(UIPageControl *)aPageControl{
    [waiting stopAnimating];
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(aPageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    scrollView.frame = rect;
    [mainScrollView scrollRectToVisible:rect animated:YES];
    [waiting startAnimating];
    [imageView sd_setImageWithURL:[NSURL URLWithString:bmiddle_pic_urls[pageControl.currentPage]]
                 placeholderImage:nil
                          options:SDWebImageProgressiveDownload
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (image) {
            [waiting stopAnimating];
            [waiting removeFromSuperview];
            imageView.image = image;
            CGSize imageSize = image.size;
            float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
            if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
                imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
            }
            else{
                imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
            }
            
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            NSLog(@"scrollview image download finished%@%@",imageURL,image);
        }
        
    }];
}

-(void)closeBmiddlePic:(UITapGestureRecognizer *)tap{
    UIScrollView *backgroundView = tap.view;
    UIImageView *aimageView = (UIImageView *)[tap.view viewWithTag:901];
    [UIScrollView animateWithDuration:0.3 animations:^{
        aimageView.frame = oldImageViewFrame;
        backgroundView.alpha = 0;
        pageControl.alpha = 0;
        downloadBtn.alpha = 0;
        saveBtn.alpha = 0;
    }completion:^(BOOL finished){
        [backgroundView removeFromSuperview];
        [pageControl removeFromSuperview];
        [downloadBtn removeFromSuperview];
        [saveBtn removeFromSuperview];
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
        [waiting stopAnimating];
        CGPoint offset = myScrollView.contentOffset;
        pageControl.currentPage = offset.x/(mainScrollView.bounds.size.width);
        CGSize viewSize = scrollView.frame.size;
        CGRect rect = CGRectMake(pageControl.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
        scrollView.frame = rect;
        [mainScrollView scrollRectToVisible:rect animated:YES];
        [waiting startAnimating];
        [imageView sd_setImageWithURL:[NSURL URLWithString:bmiddle_pic_urls[pageControl.currentPage]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            if (image) {
                [waiting stopAnimating];
                imageView.image = image;
                CGSize imageSize = image.size;
                float b = imageSize.width/(IPHONE_SCREEN_WIDTH);
                if (imageSize.height/b >= IPHONE_SCREEN_HEIGHT) {
                    imageView.frame = CGRectMake(0, 20, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                    scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height + 40);
                }
                else{
                    imageView.frame = CGRectMake(0, (IPHONE_SCREEN_HEIGHT - imageSize.height/b)/2, IPHONE_SCREEN_WIDTH, imageSize.height/b);
                }
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
        }];

    }
}

@end
