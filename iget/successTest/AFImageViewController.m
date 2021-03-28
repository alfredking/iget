//
//  AFImageViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/8.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "AFImageViewController.h"
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "UIImage+CircleImage.h"
@interface AFImageViewController ()

@end

@implementation AFImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AFImageViewController called");
    self.view.backgroundColor = [UIColor yellowColor];
    //占满全屏幕
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,30, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    //正方形
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-100,self.view.bounds.size.height/2, 200, 200)];
    UIImage *muscleimage = [UIImage imageNamed:@"WechatIMG7996.jpeg"];
//    imageView.image = muscleimage;
  

    //如果是block方法，block有值就不会为image赋值
//    [imageView setImageWithURL:[NSURL URLWithString:@"https://wx2.sinaimg.cn/mw690/744bc337ly1gnfwt733zog206o06o4au.gif"]];
//    [imageView setImageWithURL:[NSURL URLWithString:@"https://wx3.sinaimg.cn/mw690/744bc337ly1gmh99a3n57j20u015wqcz.jpg"]];
//
//    imageView.layer.cornerRadius=imageView.frame.size.width/2;
//    imageView.layer.masksToBounds=YES;
//
//    //光栅化可以缓存离屏渲染结果，变化少的场景可以使用
//    imageView.layer.shouldRasterize = YES;
    
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [[UIImage imageNamed:@"WechatIMG7996.jpeg"] drawCircleImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = img;
            [self.view addSubview:imageView];
        });
    });
    
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
