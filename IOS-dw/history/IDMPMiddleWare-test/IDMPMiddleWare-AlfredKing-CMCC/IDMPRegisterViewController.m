//
//  IDMPRegisterViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPRegisterViewController.h"
#import "IDMPTempSmsMode.h"
#define APPID @"10000033"
#define APPKEY @"88A01AB6F83BF946"
#import "IDMPConst.h"
#import "IDMPAccountManagerMode.h"
#import "IDMPSetOrResetPwdViewController.h"


@interface IDMPRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrOld;
@property (weak, nonatomic) IBOutlet UITextField *passwordOrNew;
@property (weak, nonatomic) IBOutlet UITextField *valid;

@property (strong, nonatomic) IBOutlet UITextField *validCode;

@property (nonatomic,copy) NSString *busiType;

- (IBAction)validateBtnClick:(id)sender;


@end

@implementation IDMPRegisterViewController
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getRegisterValid:(id)sender {
    
    self.busiType = @"1";
    
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text appId:APPID appKey:APPKEY busiType:self.busiType successBlock:^(NSDictionary *paraments) {
        
        NSLog(@"getRegisterValid------get sms success----%@",paraments);
        
    } failBlock:^(NSDictionary *paraments) {

        NSLog(@"getRegisterValid----get sms fail---%@",paraments);
        
    }];
}
- (IBAction)getResetPasswordValid:(id)sender {
    
    self.busiType = @"2";
    
    IDMPTempSmsMode *smsModel = [[IDMPTempSmsMode alloc]init];
    [smsModel getSmsCodeWithUserName:self.phoneNumber.text appId:APPID appKey:APPKEY busiType:self.busiType successBlock:^(NSDictionary *paraments) {
        
        NSLog(@"getResetPasswordValid-----get sms success---%@",paraments);
        
    } failBlock:^(NSDictionary *paraments) {

        NSLog(@"getResetPasswordValid----get sms fail----%@",paraments);
        
    }];
}
- (IBAction)registerAccount:(id)sender {
    
//    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    [self registerUserWithAppId:APPID AppKey:APPKEY phoneNo:self.phoneNumber.text passWord:self.passwordOrOld.text andValidCode:self.valid.text finishBlock:^(NSDictionary *paraments) {
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
//    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    [self resetPasswordWithAppId:APPID AppKey:APPKEY phoneNo:self.phoneNumber.text passWord:self.passwordOrNew.text andValidCode:self.valid.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail");
    }];

}
- (IBAction)changePassword:(id)sender {
//    IDMPAccountManagerMode *registerModel = [[IDMPAccountManagerMode alloc]init];
    [self changePasswordWithAppId:APPID AppKey:APPKEY phoneNo:self.phoneNumber.text passWord:self.passwordOrOld.text andNewPSW:self.passwordOrNew.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"change success");
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"change fail");
    }];
}

/*
 *
 */
- (IBAction)validateBtnClick:(id)sender {

    
    IDMPAccountManagerMode *manager = [[IDMPAccountManagerMode alloc] init];
    
    [manager submitValidateWithAppId:APPID appKey:APPKEY phoneNo:self.phoneNumber.text validCode:self.validCode.text busiType:self.busiType succeedBlock:^(NSDictionary *paraments) {
        
        NSLog(@"validateBtnClick----success----%@",paraments);
    
        
        IDMPSetOrResetPwdViewController *setPwdVC = [[IDMPSetOrResetPwdViewController alloc] init];
        setPwdVC.cert = [paraments objectForKey:@"cert"];
        setPwdVC.phoneNo = self.phoneNumber.text;
        setPwdVC.busiType = self.busiType;
    
        [self presentViewController:setPwdVC animated:YES completion:nil];
        
        
        
        NSLog(@"\n================================\n");
        
        
//        NSString *cert = [paraments objectForKey:@"cert"];
//        NSString *pwd = @"Mnbvcxz1234_";
//        
//        
//        NSLog(@"----%@---%@----%@----%@",self.phoneNumber.text,cert,self.busiType,pwd);
//        
//        IDMPAccountManagerMode *manager = [[IDMPAccountManagerMode alloc] init];
//        
//        [manager setPasswordWithAppId:APPID AppKey:APPKEY phoneNo:self.phoneNumber.text cert:cert password:pwd busiType:self.busiType successBlock:^(NSDictionary *paraments) {
//            
//            NSLog(@"success-------------%@",paraments);
//            
//        } failBlock:^(NSDictionary *paraments) {
//            
//            NSLog(@"fail-------------%@",paraments);
//            
//        }];
        
        
        
    } failedBlock:^(NSDictionary *paraments) {
        
        
        NSLog(@"validateBtnClick----fail-----%@",paraments);
        
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
