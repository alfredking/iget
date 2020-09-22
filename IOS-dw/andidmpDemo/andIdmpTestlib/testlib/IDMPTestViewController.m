//
//  IDMPTestViewController.m
//  testlib
//
//  Created by zwk on 14/11/28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTestViewController.h"
#import "IDMPTempSmsMode.h"
#import "IDMPRegisterViewController.h"
//#import "secTokenCheck.h"


@interface IDMPTestViewController ()
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString *userName;
@end


@implementation IDMPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queryFreeFlowStatus:(UIButton *)sender {
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    [idmp freeDataAuthWithSuccessBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)autoLogin:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else if(authType == 3) {
            NSLog(@"检测到sim卡不存在，但可能检测异常。苹果api不稳定");
        } else {
            //1.getAccessTokenWithUserName中userName可以传nil，如果有缓存，会用上一次使用的登录账号签发token。
            //如果缓存的用户不是本机号码，而想用本机号码登录，则可以checkIsLocalNumber来检查，如果发现不是本机号码，可以cleanSSO清除缓存再登录。
            //如果没有缓存，会重新协商ks进行token签发。
            //2.userName也可以传指定手机号，如果这个手机号有缓存，则直接签发token；如果没有，则返回102314，缓存不存在。
            [autoLogin getAccessTokenWithUserName:nil andLoginType:authType isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"succ" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
//                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
//                NSString *token = [paraments objectForKey:@"token"];
//                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid success------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *username = dic[@"body"][@"msisdn"];
//                        if (!username) {
//                            username = dic[@"body"][@"email"];
//                            if (!username) {
//                                username = dic[@"body"][@"passid"];
//                            }
//                        }
//                        self.userName = username;
//                        self.resultLabel.text = @"login success";
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                } failBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid fail------%@",dic);
//                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
//                    NSLog(@"token valid fail------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
            }];
        }
    });
}

- (IBAction)upLogin:(id)sender {
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAccessTokenByConditionWithUserName:self.username.text Content:self.password.text andLoginType:1 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"succ" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
//                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
//                NSString *token = [paraments objectForKey:@"token"];
//                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid success------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.resultLabel.text = @"login success";
//                        NSString *username = dic[@"body"][@"msisdn"];
//                        if (!username) {
//                            username = dic[@"body"][@"email"];
//                            if (!username) {
//                                username = dic[@"body"][@"passid"];
//                            }
//                        }
//                        self.userName = username;
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//
//                    });
//
//                } failBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid fail------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
            }];
        }
    });
}

- (IBAction)smsLogin:(id)sender {
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAccessTokenByConditionWithUserName:self.username.text Content:self.password.text andLoginType:2 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"succ" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
//                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
//                NSString *token = [paraments objectForKey:@"token"];
//                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid success------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *username = dic[@"body"][@"msisdn"];
//                        if (!username) {
//                            username = dic[@"body"][@"email"];
//                            if (!username) {
//                                username = dic[@"body"][@"passid"];
//                            }
//                        }
//                        self.userName = username;                        self.resultLabel.text = @"login success";
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//
//                } failBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid fail------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
            }];
        }
    });
}

- (IBAction)autoLoginReturnPwd:(id)sender {
    
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else if(authType == 3) {
            NSLog(@"检测到sim卡不存在，但可能检测异常。苹果api不稳定");
        } else {
            //1.getAccessTokenWithUserName中userName可以传nil，如果有缓存，会用上一次使用的登录账号签发token。
            //如果缓存的用户不是本机号码，而想用本机号码登录，则可以checkIsLocalNumber来检查，如果发现不是本机号码，可以cleanSSO清除缓存再登录。
            //如果没有缓存，会重新协商ks进行token签发。
            //2.userName也可以传指定手机号，如果这个手机号有缓存，则直接签发token；如果没有，则返回102314，缓存不存在。
            [autoLogin getAppPasswordWithUserName:nil andLoginType:authType isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"succ" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
//                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
//                NSString *token = [paraments objectForKey:@"token"];
//                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid success------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *username = dic[@"body"][@"msisdn"];
//                        if (!username) {
//                            username = dic[@"body"][@"email"];
//                            if (!username) {
//                                username = dic[@"body"][@"passid"];
//                            }
//                        }
//                        self.userName = username;                        self.resultLabel.text = @"login success";
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//
//                } failBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid fail------%@",dic);
//                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
            }];
        }
    });
}

- (IBAction)upLoginRetrunPwd:(id)sender {
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAppPasswordByConditionWithUserName:self.username.text Content:self.password.text andLoginType:1 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"succ" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
//                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
//                NSString *token = [paraments objectForKey:@"token"];
//                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid success------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *username = dic[@"body"][@"msisdn"];
//                        if (!username) {
//                            username = dic[@"body"][@"email"];
//                            if (!username) {
//                                username = dic[@"body"][@"passid"];
//                            }
//                        }
//                        self.userName = username;                        self.resultLabel.text = @"login success";
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//
//                } failBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid fail------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
            }];
        }
    });
}

- (IBAction)smsLoginReturnPwd:(id)sender {
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAppPasswordByConditionWithUserName:self.username.text Content:self.password.text andLoginType:2 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"succ" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
//                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
//                NSString *token = [paraments objectForKey:@"token"];
//                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid success------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *username = dic[@"body"][@"msisdn"];
//                        if (!username) {
//                            username = dic[@"body"][@"email"];
//                            if (!username) {
//                                username = dic[@"body"][@"passid"];
//                            }
//                        }
//                        self.userName = username;                        self.resultLabel.text = @"login success";
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                    
//                } failBlock:^(NSDictionary *dic) {
//                    NSLog(@"token valid fail------%@",dic);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSString *message = [NSString stringWithFormat:@"%@",dic];
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token valid fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    });
//                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@",paraments];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"token get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                });
            }];
        }
    });
}


- (IBAction)getSms:(id)sender
{
    IDMPTempSmsMode *tmpSms = [IDMPTempSmsMode new];
    [tmpSms getSmsCodeWithUserName:self.username.text busiType:@"3" successBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码成功:%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"%@",paraments];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"sms get success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码失败:%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"%@",paraments];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"sms get fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
    
}

- (IBAction)clearCache:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin cleanSSO];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultLabel.text = @"清除成功";
    });
}

- (IBAction)getNetStatus:(id)sender {
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    int authType = [idmp getAuthType];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultLabel.text = [NSString stringWithFormat:@"%d", authType];
    });
}

- (IBAction)secondAuth:(id)sender {
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    [idmp reAuthenticationWithUserName:self.userName successBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"%@",paraments];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"reauth success" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    } failBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"%@",paraments];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"reauth fail" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

- (IBAction)currentEdition:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin currentEdition];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end

