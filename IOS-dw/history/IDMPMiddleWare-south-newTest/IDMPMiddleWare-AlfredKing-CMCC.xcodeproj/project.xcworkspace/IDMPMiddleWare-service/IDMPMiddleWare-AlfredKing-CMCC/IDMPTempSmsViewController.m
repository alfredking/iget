//
//  IDMPTempSmsViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-1.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTempSmsViewController.h"
#import "IDMPTempSmsMode.h"

@interface IDMPTempSmsViewController ()
{
   buttonType _buttonType;
}
@end

@implementation IDMPTempSmsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _passWdLabel.hidden=YES;
    _passWdField.hidden=YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];

    
}
- (IBAction)loginAction:(UIButton *)sender
{
    IDMPTempSmsMode *tempSms=[[IDMPTempSmsMode alloc] init];
    [self.passWdField resignFirstResponder];
    switch (_buttonType) {
        case getMessageCode:
        {
            NSString *userName = _userNameField.text;
            if(![userName isEqual:@""])
            {
                [tempSms getTMMessageCodeWithUserName:(NSString *)userName successBlock:
                 ^{
                    _passWdLabel.hidden = NO;
                    _passWdField.hidden = NO;
                    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
                    _buttonType = login;
                    NSLog(@"获取验证码成功");
                 }
                failBlock:
                ^{
                    NSLog(@"获取验证码失败");
                }];
            }
            else
            {
                NSLog(@"fail!");
            }
            break;
        }
        case login:
        {
            NSString *userName = _userNameField.text;
            NSString *passWd = _passWdField.text;
            if(![userName isEqual:@""]&&![passWd isEqual:@""])
            {
                [tempSms getTMKSWithUserName:userName messageCode:passWd
                successBlock:
                ^{
                    
                    NSString *callbackURL =[NSString stringWithFormat:@"IDMPSDK://?userName=%@",userName];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callbackURL]];
                }
               failBlock:
               ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"临时短信方式登录失败"]
                                                                   delegate:self cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
               }];
                
            }
            else
            {
                NSLog(@"invalid username or password");
            }
            break;
        }
        default:
            break;
    }
    
}

-(void)tapAction:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    
}


@end
