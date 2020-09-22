//
//  IDMPVUPViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by wj on 2017/11/2.
//  Copyright © 2017年 alfredking－cmcc. All rights reserved.
//

#import "IDMPVUPViewController.h"
#import "IDMPTempSmsMode.h"

@interface IDMPVUPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation IDMPVUPViewController
- (IBAction)getVoiceCode:(UIButton *)sender {
    NSString *voiceVersion = [self getVoiceVersionFromButton:sender];
    IDMPTempSmsMode *tmpSms = [IDMPTempSmsMode new];
    [tmpSms getVOCWithUserName:self.usernameTF.text busiType:@"3" voiceVersion:voiceVersion successBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码成功:%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (sender.tag == 1 || sender.tag == 2) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取验证码成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                if (paraments[@"smsCode"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请说出以下语音验证码" message:paraments[@"smsCode"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    }
                }
            });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码失败:%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取验证码失败" message:paraments[@"resultCode"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

- (IBAction)authVoiceCode:(UIButton *)sender {
    NSString *voiceVersion = [self getVoiceVersionFromButton:sender];
    IDMPTempSmsMode *tmpSms = [IDMPTempSmsMode new];
    NSString *message = [voiceVersion isEqualToString:@"1.0"] ? self.passwordTF.text : nil;
    [tmpSms getVOCKSWithSipInfo:@"1" userName:self.usernameTF.text messageCode:message voiceVersion:voiceVersion traceId:nil successBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你本次的token" message:paraments[@"token"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    } failBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证失败" message:paraments[@"resultCode"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

- (NSString *)getVoiceVersionFromButton:(UIButton *)btn {
    NSString *title = btn.titleLabel.text;
    if ([title containsString:@"1.0"]) {
        return @"1.0";
    } else if ([title containsString:@"1.5"]) {
        return @"1.5";
    } else {
        return @"2.0";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
