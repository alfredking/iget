//
//  IDMPSetOrResetPwdViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by HGQ on 15/8/5.
//  Copyright (c) 2015年 alfredking－cmcc. All rights reserved.
//

#import "IDMPSetOrResetPwdViewController.h"
#import "IDMPAccountManagerMode.h"
#define APPID @"10000033"
#define APPKEY @"88A01AB6F83BF946"
#import "IDMPConst.h"

@interface IDMPSetOrResetPwdViewController ()
@property (strong, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)confirmBtnClick:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation IDMPSetOrResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    

}


- (IBAction)confirmBtnClick:(id)sender {
    
    if (![self.pwd.text isEqualToString:@""]) {
        
        NSLog(@"----%@---%@----%@----%@",self.phoneNo,self.cert,self.busiType,self.pwd.text);
        
        IDMPAccountManagerMode *manager = [[IDMPAccountManagerMode alloc] init];
        
        [manager setPasswordWithAppId:APPID AppKey:APPKEY phoneNo:self.phoneNo cert:self.cert password:self.pwd.text busiType:self.busiType successBlock:^(NSDictionary *paraments) {
            
            NSLog(@"setPasswordWithAppId------------success-------------%@",paraments);
            
        } failBlock:^(NSDictionary *paraments) {
            
            NSLog(@"setPasswordWithAppId------------fail-------------%@",paraments);
            
        }];
    }
    
}

- (IBAction)back:(id)sender {
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
