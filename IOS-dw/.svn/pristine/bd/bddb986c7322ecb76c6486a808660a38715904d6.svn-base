//
//  IDMPLoginViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/12/11.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPLoginViewController.h"
#import "IDMPTestViewController.h"
#import "IDMPConst.h"

@interface IDMPLoginViewController ()

@end

@implementation IDMPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(40, 80, 80, 40);
    [button setTitle:@"授权登陆" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onLoginClick
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    autoLogin.isSip= [[NSUserDefaults standardUserDefaults] objectForKey:getType];
    NSLog(@"登陆");
    if ([[IDMPAutoLoginViewController isSip] isEqualToString:@"2"]) {
        [autoLogin getAppPasswordWithAppid:@"01000107" Appkey:@"2396E39A4054A522" UserName:nil andLoginType:4 isUserDefaultUI:YES
                          finishBlock:^(NSDictionary *paraments)
         {
             NSLog(@"finish : %@",paraments);
             //             [self dismissViewControllerAnimated:YES completion:nil];
             NSString *token=[paraments objectForKey:@"token"];
             NSString *url=[NSString stringWithFormat:@"%@://?token=%@" ,[self callBackUrl], token];
             
             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                 
             {
                 //                 [self.view removeFromSuperview];
                 //                 [self removeFromParentViewController];
                 NSLog(@"can open");
                 NSLog(@"url is %@",url);
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法打开"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
             
         }
                            failBlock:^(NSDictionary *paraments)
         {
             NSLog(@"fail result code");
             NSLog(@"%@",paraments);
             //             [self dismissViewControllerAnimated:YES completion:nil];
             
         }];
        
    }else{
        [autoLogin getAccessTokenWithAppid:@"01000107" Appkey:@"2396E39A4054A522" UserName:nil andLoginType:4 isUserDefaultUI:YES
                          finishBlock:^(NSDictionary *paraments)
         {
             NSLog(@"finish : %@",paraments);
             //             [self dismissViewControllerAnimated:YES completion:nil];
             NSString *token=[paraments objectForKey:@"token"];
             NSString *url=[NSString stringWithFormat:@"%@://?token=%@" ,[self callBackUrl], token];
             
             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                 
             {
                 //                 [self.view removeFromSuperview];
                 //                 [self removeFromParentViewController];
                 NSLog(@"can open");
                 NSLog(@"url is %@",url);
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                 
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法打开"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
             
         }
                            failBlock:^(NSDictionary *paraments)
         {
             NSLog(@"fail result code");
             NSLog(@"%@",paraments);
             //             [self dismissViewControllerAnimated:YES completion:nil];
             
         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
