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
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text busiType:@"1" successBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms success");
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms fail");
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)getResetPasswordValid:(id)sender {
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
            NSLog(@"%@",paraments);
        }else{
            NSLog(@"fail");
        }
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"register fail");
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)resetPassword:(id)sender {
//    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin resetPasswordWithPhoneNo:self.phoneNumber.text passWord:self.passwordOrNew.text andValidCode:self.valid.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"success");
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
        NSLog(@"%@",paraments);
    }];

}
- (IBAction)changePassword:(id)sender {
//    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin changePasswordWithPhoneNo:self.phoneNumber.text passWord:self.passwordOrOld.text andNewPSW:self.passwordOrNew.text finishBlock:^(NSDictionary *paraments) {
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
