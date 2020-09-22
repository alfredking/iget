//
//  IDMPRegisterViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPRegisterViewController.h"
#import "IDMPAccountManagerMode.h"
#import "IDMPTempSmsMode.h"
#import "IDMPConst.h"


@interface IDMPRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrOld;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrNew;
@property (weak, nonatomic) IBOutlet UITextField *valid;

@end

@implementation IDMPRegisterViewController
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getRegisterValid:(id)sender {
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text busiType:@"1" successBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms fail");
    }];
}
- (IBAction)getResetPasswordValid:(id)sender {
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text busiType:@"2" successBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"get sms fail");
    }];
}
- (IBAction)registerAccount:(id)sender {
    
    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    [registerModel registerUserWithPhoneNo:self.phoneNumber.text passWord:self.passwordOrOld.text andValidCode:self.valid.text finishBlock:^(NSDictionary *paraments) {
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
    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    [registerModel resetPasswordWithPhoneNo:self.phoneNumber.text passWord:self.passwordOrNew.text andValidCode:self.valid.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
    }];

}
- (IBAction)changePassword:(id)sender {
    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    [registerModel changePasswordWithPhoneNo:self.phoneNumber.text passWord:self.passwordOrOld.text andNewPSW:self.passwordOrNew.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"change success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"change fail");
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
}


@end
