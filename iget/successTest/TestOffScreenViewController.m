//
//  TestOffScreenViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/5/8.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestOffScreenViewController.h"

@interface TestOffScreenViewController ()

@end

@implementation TestOffScreenViewController

//layer设置图片
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
//    // 设置背景色
//    view1.backgroundColor = UIColor.redColor;
//    // 设置边框宽度和颜色
////    view1.layer.borderWidth = 2.0;
////    view1.layer.borderColor = UIColor.blackColor.CGColor;
//
//    //设置图片
//    view1.layer.contents = (__bridge id)[UIImage imageNamed:@"line.jpeg"].CGImage;
//
////    view1.layer.opacity = 0.5;
//    // 设置圆角
//    view1.layer.cornerRadius = 100.0;
//    // 设置裁剪
//    view1.clipsToBounds = YES;
//
//    view1.center = self.view.center;
//    [self.view addSubview:view1];
//}

//其实不光是图片，我们为视图添加一个有颜色、内容或边框等有图像信息的子视图也会触发离屏渲染。
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
//    // 设置背景色
//    view1.backgroundColor = UIColor.redColor;
//    // 设置边框宽度和颜色
//    view1.layer.borderWidth = 2.0;
//    view1.layer.borderColor = UIColor.blackColor.CGColor;
//    // 设置圆角
//    view1.layer.cornerRadius = 100.0;
//    // 设置裁剪
//    view1.clipsToBounds = YES;
//
//    // 子视图
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100.0, 100.0)];
//    // 下面3个任何一个属性
//    // 设置背景色
////    view2.backgroundColor = UIColor.blueColor;
////    // 设置内容
////    view2.layer.contents = (__bridge id)([UIImage imageNamed:@"line.jpeg"].CGImage);
////    // 设置边框
//    view2.layer.borderWidth = 2.0;
//    view2.layer.borderColor = UIColor.blackColor.CGColor;
//    [view1 addSubview:view2];
//    view2.center = view1.center;
//
//    view1.center = self.view.center;
//    [self.view addSubview:view1];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建一个button视图
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
    button.backgroundColor = UIColor.greenColor;
    button.center = self.view.center;
    [self.view addSubview:button];
    //设置图片
    [button setImage:[UIImage imageNamed:@"line.jpeg"] forState:UIControlStateNormal];
    // 设置圆角
    button.layer.cornerRadius = 100.0;
    // 设置裁剪
    button.clipsToBounds = YES;
    // 设置圆角
//    button.imageView.layer.cornerRadius = 100.0;
//    // 设置裁剪
//    button.imageView.clipsToBounds = YES;


}

@end
