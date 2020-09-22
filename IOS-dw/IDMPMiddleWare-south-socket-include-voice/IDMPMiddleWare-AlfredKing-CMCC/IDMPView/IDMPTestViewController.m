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
#import "secTokenCheck.h"
#import "userInfoStorage.h"


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
- (IBAction)autoLogin:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
//        } else if(authType == 3) {
//            NSLog(@"检测到sim卡不存在，但可能检测异常。苹果api不稳定");
        } else {
            //1.getAccessTokenWithUserName中userName可以传nil，如果有缓存，会用上一次使用的登录账号签发token。
            //如果缓存的用户不是本机号码，而想用本机号码登录，则可以checkIsLocalNumber来检查，如果发现不是本机号码，可以cleanSSO清除缓存再登录。
            //如果没有缓存，会重新协商ks进行token签发。
            //2.userName也可以传指定手机号，如果这个手机号有缓存，则直接签发token；如果没有，则返回102314，缓存不存在。
            [autoLogin getAccessTokenWithUserName:nil andLoginType:authType isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------");
                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login success";
                    });
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
            }];
        }
    });
}

- (IBAction)upLogin:(id)sender {
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    NSString *userName = self.username.text;
    NSString *password = self.password.text;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAccessTokenByConditionWithUserName:userName Content:password andLoginType:1 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------");
                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login success";
                        self.userName = dic[@"body"][@"msisdn"];
                        
                    });
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
            }];
        }
    });
}

- (IBAction)smsLogin:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAccessTokenByConditionWithUserName:username Content:password andLoginType:2 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------");
                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login success";
                    });
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
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
                NSLog(@"get token success------");
                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login success";
                    });
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
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
                NSLog(@"get token success------");
                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login success";
                    });

                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login fail";
                    });
                    
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultLabel.text = @"login fail";
                });
            }];
        }
    });
}

- (IBAction)smsLoginReturnPwd:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else {
            [autoLogin getAppPasswordByConditionWithUserName:username Content:password andLoginType:2 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------");
                secTokenCheck *tokencheck = [[secTokenCheck alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------%@",dic);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.resultLabel.text = @"login success";
                    });
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
            }];
        }
    });
}


- (IBAction)getSms:(id)sender
{
    IDMPTempSmsMode *tmpSms = [IDMPTempSmsMode new];
    [tmpSms getSmsCodeWithUserName:self.username.text busiType:@"3" successBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码成功:%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"获取验证码失败:%@",paraments);
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultLabel.text = nil;
    });
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    [idmp reAuthenticationWithUserName:self.userName successBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = [NSString stringWithFormat:@"%@",paraments[@"token"]];
        });
    } failBlock:^(NSDictionary *paraments) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = paraments[@"resultCode"];
        });
    }];
}

- (IBAction)currentEdition:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin currentEdition];
}
- (IBAction)testReportlog:(UIButton *)sender {
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    for (int i = 0 ; i< 1000; i++) {
        
        [idmp getAccessTokenWithUserName:nil andLoginType:0 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
            
        } failBlock:^(NSDictionary *paraments) {
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
