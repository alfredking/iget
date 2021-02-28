//
//  CallNumberVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "CallNumberVC.h"

@interface CallNumberVC ()

@end

@implementation CallNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"打电话" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(callNumber) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
- (void)callNumber{
    
    //    方法一:不弹出提示直接拨打
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"113"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //    方法二:会弹出提示
    
    NSMutableString *str1=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"332"];
    
    UIWebView *callWebview = [[UIWebView alloc]init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str1]]];
    
    [self.view addSubview:callWebview];
    
    //    方法三:会弹出提示
    
    NSMutableString* str2=[[NSMutableString alloc]initWithFormat:@"telprompt://%@",@"111"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str2]];
    
//    方案四之终极拨号方式:
    
    NSMutableString *str3 = [[NSMutableString alloc]initWithFormat:@"tel:%@",@"1155"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"打电话" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str3]];
        
    }];
    // Add the actions.
    
    [alertController addAction:cancelAction];
    
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
