//
//  ViewController.m
//  RSA原理
//
//  Created by 刘凡 on 14/9/16.
//  Copyright (c) 2014年 joyios. All rights reserved.
//

#import "WeiboViewController.h"
#import "RSA.h"
#import "testTableViewController.h"
#import "CTDisplayView.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController
//新版本iOS已有变化，旧版本iOS仅供参考https://www.jianshu.com/p/01914bf42a38
- (void)viewDidLoad {
    [super viewDidLoad];
    
    RSA *rsa = [[RSA alloc] init];
    NSString *encryStr = [rsa encryptString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789"];
    NSLog(@"加密结果 : %@", encryStr);
    
    NSString *decryStr = [rsa decryptString:encryStr];
    NSLog(@"解密结果 : %@", decryStr);
    
    
    //图层混合
    //https://www.jianshu.com/p/db6602413fa3
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, 200, 100)];
    testLabel.backgroundColor = [UIColor darkGrayColor];
    testLabel.text = @"简单-FlyElephant";
    
    testLabel.opaque = YES;
    testLabel.font = [UIFont systemFontOfSize:14];
    testLabel.textColor = [UIColor blackColor];
    
//    clipsToBounds(UIView)
//    是指视图上的子视图,如果超出父视图的部分就截取掉,
//    masksToBounds(CALayer)
//    却是指视图的图层上的子图层,如果超出父图层的部分就截取掉
     testLabel.layer.masksToBounds = YES;
    
    
    //圆角普通方法
    //testLabel.layer.cornerRadius = 10;
    
    //圆角高效方法
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:testLabel.bounds cornerRadius: 10.0].CGPath;
//    maskLayer.frame = testLabel.bounds;
//    testLabel.layer.mask = maskLayer;
    
    //阴影普通方法https://www.jianshu.com/p/b3c9f2719e62
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 150)];
    
    
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowOpacity = 0.8;
    
    //阴影高效方法
    [shadowView.layer setShadowPath: [[UIBezierPath bezierPathWithRect: shadowView.bounds] CGPath]];
    shadowView.layer.shadowRadius = 9.0;
    shadowView.layer.cornerRadius = 9.0;
    shadowView.layer.backgroundColor = [UIColor greenColor].CGColor;
    
    
    [self.view addSubview:shadowView];
    
    
    
    
    
    
    
    
    [self.view addSubview:testLabel];
    //图层混合
    
    UIButton *tableviewButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 500, 100, 50)];
    
    tableviewButton.titleLabel.text = @"跳转到tableview";
    tableviewButton.backgroundColor = [UIColor yellowColor];
    [tableviewButton addTarget:self action:@selector(gotoTableView) forControlEvents:UIControlEventTouchUpInside];
    
    
    //coretext测试
    
    UIButton *coretextButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 600, 100, 50)];
    
    coretextButton.titleLabel.text = @"coretext测试";
    coretextButton.backgroundColor = [UIColor yellowColor];
    [coretextButton addTarget:self action:@selector(gotoCoreText) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 700, 0, 0)];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    label.text = @"北京欢饮您！！！";
    
    //sizeToFit:直接改变了这个label的宽和高，使它根据上面字符串的大小做合适的改变
//    [label sizeToFit];
//
//    NSLog(@"width=%.1f  height=%.1f ", label.frame.size.width, label.frame.size.height);
   
    
    
    //sizeThatFits并没有改变原始label的大小
    CGSize sizeThatFits = [label sizeThatFits:CGSizeZero];
    NSLog(@"sizeThatFits: width=%.1f  height=%.1f", sizeThatFits.width, sizeThatFits.height);

    NSLog(@"width=%.1f  height=%.1f", label.frame.size.width, label.frame.size.height);
    
     [self.view addSubview:label];
    
    [self.view addSubview:tableviewButton];
    [self.view addSubview:coretextButton];
    
}

-(void)gotoTableView
{
    NSLog(@"touch inside");
    NSLog(@" system version %@",[[UIDevice currentDevice] systemVersion]);
    testTableViewController *testTV = [[testTableViewController alloc] init];
    //testTV.tableView.estimatedRowHeight = 0;    //push自带返回，prensent需要自己写https://www.jianshu.com/p/1ff88835c2b3
   //     使用navigationController比普通的viewcontroller多了上面一层导航条，可以更方便的控制界面的跳转https://www.jianshu.com/p/ef1cd11a4b53
    
    [self.navigationController pushViewController: testTV animated:YES];
    //[self presentViewController:testTV animated:YES completion:nil];
}


-(void)gotoCoreText
{
    NSLog(@"goto coretext");
    
    CTDisplayView *CTDV = [[CTDisplayView alloc] init];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:CTDV];

   // [self.navigationController pushViewController: CTDV animated:YES];
    
    
}
@end
