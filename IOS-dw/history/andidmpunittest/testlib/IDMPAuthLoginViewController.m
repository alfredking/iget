//
//  TestViewController.m
//  HttpTest
//
//  Created by zwk on 14/12/18.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import "IDMPAuthLoginViewController.h"
//#import "IDMPUPLoginViewController.h"

@interface IDMPAuthLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation IDMPAuthLoginViewController
- (IBAction)onBtnLogin:(id)sender {
    NSLog(@"登陆");
    NSString *nowUser = [self getNowLoginUser];
    NSString *userName = nil;
    if ([nowUser isEqualToString:self.loginUser.text]) {
        userName = self.loginUser.text;
    }
    if ([[self isSip]isEqualToString:@"2"]) {
        [self getAppPasswordWithUserName:userName andLoginType:3 isUserDefaultUI:YES
                          finishBlock:^(NSDictionary *paraments)
         {
             NSLog(@"finish : %@",paraments);
             NSString *token=[paraments objectForKey:@"token"];
             NSString *url=[NSString stringWithFormat:@"%@://?token=%@" ,[self callBackUrl], token];
             
             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                 
             {
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
             dispatch_async(dispatch_get_main_queue(), ^{
//                 IDMPUPLoginViewController *upLoginVC = [[IDMPUPLoginViewController alloc]init];
//                 upLoginVC.callBackUrl = self.callBackUrl;
//                 [self presentViewController:upLoginVC animated:YES completion:nil];
             });

         }];

    }else{
        [self getAccessTokenWithUserName:userName andLoginType:3 isUserDefaultUI:YES
                          finishBlock:^(NSDictionary *paraments)
         {
             NSLog(@"finish : %@",paraments);
             NSString *token=[paraments objectForKey:@"token"];
             NSString *url=[NSString stringWithFormat:@"%@://?token=%@" ,[self callBackUrl], token];
             
             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                 
             {
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
             dispatch_async(dispatch_get_main_queue(), ^{
//                 IDMPUPLoginViewController *upLoginVC = [[IDMPUPLoginViewController alloc]init];
//                 upLoginVC.callBackUrl = self.callBackUrl;
//                 [self presentViewController:upLoginVC animated:YES completion:nil];
             });
         }];
    }
//    IDMPUPLoginViewController *upLoginVC = [[IDMPUPLoginViewController alloc]init];
//    upLoginVC.callBackUrl = self.callBackUrl;
//    [self presentViewController:upLoginVC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self getNowLoginUser]) {
        self.loginUser.text = [self getNowLoginUser];
    }else{
        self.loginUser.text = @"授权登陆";
    }
}

- (IBAction)changeAccount:(id)sender {
    [self changeAccountWithUserName:@"18867101271" andFinishBlick:^(NSDictionary *paraments) {
        NSLog(@"success:%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail:%@",paraments);
    }];
}
- (IBAction)onBackClick:(id)sender {
    
    NSString *url=[NSString stringWithFormat:@"%@://?token=%@" ,[self callBackUrl],@"nologin"];
    NSLog(@"back %@",url);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        
    {
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

- (void)viewDidLoad {
   // [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bigView.layer.cornerRadius = 5.0;
    self.bigView.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3.0;
    self.loginBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
  //  [super didReceiveMemoryWarning];
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