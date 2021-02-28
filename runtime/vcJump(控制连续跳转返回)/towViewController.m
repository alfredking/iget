//
//  towViewController.m
//  testbutton
//
//  Created by 大碗豆 on 17/11/21.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "towViewController.h"
#import "threeViewController.h"

@interface towViewController ()

@end

@implementation towViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"返回" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(actionBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn1.frame = CGRectMake(CGRectGetMaxX(btn.frame) + 10, STATUS_NAV_HEIGHT, 220, 50);
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"跳转" forState:(UIControlStateNormal)];
    [btn1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn1 addTarget:self action:@selector(actionBtn1) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn1];
}


#pragma mark-button
- (void)actionBtn{
    ///连续两次present返回到第一个控制器
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    ///先push然后再present，返回到第一个控制器(presentedViewController当前控制器，presentingViewController上一个控制器)
//    UINavigationController * vc = self.presentationController.presentingViewController ;
//    NSLog(@"class = %@",NSStringFromClass(vc.class));
//    //有dismiss动画（和dismissViewControllerAnimated后面的bool值有关），放在外面有动画不会出现中间页面
//     [vc popViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:YES completion:^{
//        ///没有dismiss动画，放在里面有动画会出现中间页面
////       [vc popViewControllerAnimated:NO];
//    }];
    
    ///连续两次push返回到第一个控制器
    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
}
- (void)actionBtn1{
    threeViewController *VC = [[threeViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
