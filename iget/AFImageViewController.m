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
@interface AFImageViewController ()

@end

@implementation AFImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AFImageViewController called");
    self.view.backgroundColor = [UIColor yellowColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,30, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage *muscleimage = [UIImage imageNamed:@"WechatIMG7996.jpeg"];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:muscleimage];
    imageView.image = muscleimage;
    [self.view addSubview:imageView];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dfzximg02.dftoutiao.com/news/20210108/20210108092827_d6b2db7a6a3830b3d185dc464006935f_0_mwpm_03201609.jpeg"]];
//    [imageView setImageWithURLRequest: request  placeholderImage:nil
//    success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
//    {
//         NSLog(@"success image is %@",image);
//
//    }
//    failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
//    {
//         NSLog(@"fail");
//    }];
//
//    [self.view layoutIfNeeded];
    
    
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
