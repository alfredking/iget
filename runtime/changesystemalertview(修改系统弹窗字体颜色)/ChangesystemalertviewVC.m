//
//  ChangesystemalertviewVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "ChangesystemalertviewVC.h"

@interface ChangesystemalertviewVC ()

@end

@implementation ChangesystemalertviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"弹窗" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(changesystemalertview) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
#pragma mark UIAlertAction颜色修改
- (void)changesystemalertview{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认离开支付？" message:@"你的订单在30分钟内未支付将被取消,请尽快支付" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleDestructive handler:nil];
    
    UIAlertAction *quiteAction = [UIAlertAction actionWithTitle:@"确定离开" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    /*title*/
    NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [alertTitleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, alertTitleStr.length)];
    [alertTitleStr addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(0, alertTitleStr.length)];
    [alertController setValue:alertTitleStr forKey:@"attributedTitle"];
    
    /*msg*/
    NSMutableAttributedString *alertMsgStr = [[NSMutableAttributedString alloc] initWithString:@"修改内容"];
    [alertMsgStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, alertMsgStr.length)];
    [alertMsgStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, alertMsgStr.length)];
    [alertController setValue:alertMsgStr forKey:@"attributedMessage"];
    [quiteAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
    [cancleAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    [alertController addAction:cancleAction];
    [alertController addAction:quiteAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
