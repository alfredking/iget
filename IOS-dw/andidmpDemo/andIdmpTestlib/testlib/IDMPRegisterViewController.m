//
//  IDMPRegisterViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPRegisterViewController.h"
#import "IDMPTempSmsMode.h"


@interface IDMPRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrOld;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrNew;
@property (weak, nonatomic) IBOutlet UITextField *valid;

@end

@implementation IDMPRegisterViewController
- (IBAction)goBack:(id)sender {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getRegisterValid:(id)sender {
    //获取注册账户时用的验证码
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text busiType:@"1" successBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms success");
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms fail");
        NSLog(@"%@",paraments);
    }];
    
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin registerUserWithPhoneNo:@"your register username" passWord:@"your register password" andValidCode:@"your register temp sms code" finishBlock:^(NSDictionary *paraments) {
        NSLog(@"paraments:%@",paraments);
        
        if ([[paraments objectForKey:@"resultCode"] integerValue]==103000) {
            NSLog(@"register success");
        }else{
            NSLog(@"fail");
        }
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"register fail");
    }];
}
- (IBAction)getResetPasswordValid:(id)sender {
    
    //获取重置密码时用的验证码
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text busiType:@"2" successBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms success");
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms fail");
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)registerAccount:(id)sender {
    
//    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin registerUserWithPhoneNo:self.phoneNumber.text passWord:self.passwordOrOld.text andValidCode:self.valid.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"paraments:%@",paraments);
        
        if ([[paraments objectForKey:@"resultCode"] integerValue]==103000) {
            NSLog(@"register success");
        }else{
            NSLog(@"fail");
        }
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"register fail");
    }];
}
- (IBAction)resetPassword:(id)sender {
    
    //重置密码
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin resetPasswordWithPhoneNo:@"your reset username" passWord:@"your reset password" andValidCode:@"your reset temp sms code" finishBlock:^(NSDictionary *paraments) {
        NSLog(@"success");
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        NSLog(@"%@",paraments);
    }];

}
- (IBAction)changePassword:(id)sender {
    
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin changePasswordWithPhoneNo:@"your username" passWord:@"your old password" andNewPSW:@"your new password" finishBlock:^(NSDictionary *paraments) {
        NSLog(@"change success");
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"change fail");
        NSLog(@"%@",paraments);
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumber resignFirstResponder];
    [self.passwordOrNew resignFirstResponder];
    [self.passwordOrOld resignFirstResponder];
    [self.valid resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.phoneNumber.delegate = self;
    self.passwordOrOld.delegate = self;
    self.passwordOrNew.delegate = self;
    self.valid.delegate =self;
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
