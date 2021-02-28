//
//  ImagebrowseVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "ImagebrowseVC.h"

#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"

static NSTimeInterval const kTransformPart1AnimationDuration = 0.3;

@interface ImagebrowseVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *srcStringArray;

@property (nonatomic, strong) UIImageView *image;
@end

@implementation ImagebrowseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"图片浏览" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(actionBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn1.frame = CGRectMake(CGRectGetMaxX(btn.frame) + 10, STATUS_NAV_HEIGHT, 220, 50);
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"图片动画" forState:(UIControlStateNormal)];
    [btn1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn1 addTarget:self action:@selector(actionBtn1) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
    
    
}

-(void)actionBtn{
    [self ImagesGroupView];
}

-(void)actionBtn1{
    [self.view addSubview:self.image];
    [self showPickView];
}

#pragma mark 图片动画
- (UIImageView *)image{
    if (!_image) {
        _image = [UIImageView new];
        _image.frame = CGRectMake(100, 100, 200, 250);
        _image.image = [UIImage imageNamed:@"rp"];
        _image.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
        tapGesture.numberOfTouchesRequired=1;
        tapGesture.numberOfTapsRequired=1;
        tapGesture.delegate = self;
        [_image addGestureRecognizer:tapGesture];
        
//        UIControl *dummyControl = [[UIControl alloc] initWithFrame:self.view.bounds];
//        dummyControl.backgroundColor = [UIColor clearColor];
//        [dummyControl addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
//        [_image insertSubview:dummyControl atIndex:0];
        
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(100, 100, 220, 50);
        btn.backgroundColor = [UIColor orangeColor];
        btn.titleLabel.text = @"123";
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
//        [_image addSubview:btn];
    }
    return _image;
}

-(void)dismissKeyBoard{
    NSLog(@"%@~~~~~~~~~",NSStringFromSelector(_cmd));
    [self hidePickView];
}

- (void)onTap:(UIControl *)sender{
    NSLog(@"%@~~~~~~~~~",NSStringFromSelector(_cmd));
}

- (void)showPickView{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.image.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    } completion:^(BOOL finished) {
//
//    }];
    
    self.image.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
//        containerView.alpha = 1;
        self.image.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
//            containerView.alpha = 1;
            self.image.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kTransformPart1AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                containerView.alpha = 1;
                self.image.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            } completion:^(BOOL finished2) {
//                self.image.layer.shouldRasterize = NO;
            }];
            
        }];
    }];
}


- (void)hidePickView{
    [self.image removeFromSuperview];
    self.image = nil;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.image.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    } completion:^(BOOL finished) {
////        [self.image removeFromSuperview];
//    }];
}

#pragma mark - 照片浏览器
- (void)ImagesGroupView{
    HZImagesGroupView *imagesGroupView = [[HZImagesGroupView alloc] initWithFrame:CGRectMake(0, STATUS_NAV_HEIGHT + 100, kScreenWidth, kScreenHeight - 80 - 30)];
    NSMutableArray *temp = [NSMutableArray array];
    [self.srcStringArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
        item.thumbnail_pic = src;
        [temp addObject:item];
    }];
    imagesGroupView.photoItemArray = [temp copy];
    imagesGroupView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imagesGroupView];
//    imagesGroupView.hidden = YES;
//    [imagesGroupView showGigPhotoBrowser];
}

#pragma mark - 照片浏览器
- (NSArray *)srcStringArray{
    if (!_srcStringArray) {
        _srcStringArray = @[
                            @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                            @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                            @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                            @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                            @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
                            @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
                            @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
                            ];
    }
    return _srcStringArray;
}

@end
