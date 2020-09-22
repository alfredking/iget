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
#import "IDMPTokenCheckHelper.h"
#import "IDMPAutoLoginViewController.h"
#import "IDMPAlterHelper.h"


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
//    IDMPAutoLoginViewController *idmp = [[IDMPAutoLoginViewController alloc] init];
//    [idmp idmp_sm4Decrypt];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queryFreeStatus:(UIButton *)sender {
//    [[IDMPAutoLoginViewController new] freeDataAuthWithSuccessBlock:^(NSDictionary *paraments) {
//        NSLog(@"%@",paraments);
//    } failBlock:^(NSDictionary *paraments) {
//        NSLog(@"%@",paraments);
//    }];
}
- (IBAction)noCacheAutoLogin:(UIButton *)sender {
    IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else if(authType == 3) {
            NSLog(@"检测到移动sim卡不存在，但可能检测异常。苹果api不稳定");
        } else {
            [autoLogin getAccessTokenNoCacheWithLoginType:2 finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];
            }];
        }
    });

}
- (IBAction)autoLogin:(id)sender
{
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int authType = [autoLogin getAuthType];
        if (authType == -1) {
            NSLog(@"网络异常");
        } else if(authType == 3) {
            NSLog(@"检测到移动sim卡不存在，但可能检测异常。苹果api不稳定");
        } else {
            //1.getAccessTokenWithUserName中userName可以传nil，如果有缓存，会用上一次使用的登录账号签发token。
            //如果缓存的用户不是本机号码，而想用本机号码登录，则可以checkIsLocalNumber来检查，如果发现不是本机号码，可以cleanSSO清除缓存再登录。
            //如果没有缓存，会重新协商ks进行token签发。
            //2.userName也可以传指定手机号，如果这个手机号有缓存，则直接签发token；如果没有，则返回102314，缓存不存在。
            [autoLogin getAccessTokenWithUserName:nil andLoginType:authType isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
                NSLog(@"get token success------%@",paraments);
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];

                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];
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
                NSLog(@"get token success------%@",paraments);
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];
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
                NSLog(@"get token success------%@",paraments);
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];

                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];
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
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
                }];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];

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
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app册自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------");
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];
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
                NSLog(@"get token success------%@",paraments);
                IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app自己完成
                NSString *token = [paraments objectForKey:@"token"];
                [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid success------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                    
                } failBlock:^(NSDictionary *dic) {
                    NSLog(@"token valid fail------%@",dic);
                    [IDMPAlterHelper alertWithMessage:dic superVC:self];
                }];
                
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"get token fail------%@",paraments);
                [IDMPAlterHelper alertWithMessage:paraments superVC:self];
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
    [IDMPAlterHelper alertWithMessage:@"清除成功" superVC:self];
}

- (IBAction)getNetStatus:(id)sender {
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    int authType = [idmp getAuthType];
    [IDMPAlterHelper alertWithMessage:[NSString stringWithFormat:@"%d", authType] superVC:self];
}

- (IBAction)secondAuth:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultLabel.text = nil;
    });
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    [idmp reAuthenticationWithUserName:self.userName successBlock:^(NSDictionary *paraments) {
        [IDMPAlterHelper alertWithMessage:paraments superVC:self];
    } failBlock:^(NSDictionary *paraments) {
        [IDMPAlterHelper alertWithMessage:paraments superVC:self];
    }];
}
- (IBAction)checkIsLocalNum:(id)sender {
    IDMPAutoLoginViewController *idmp =  [IDMPAutoLoginViewController new];
    [idmp checkIsLocalNumberWith:self.username.text finishBlock:^(NSDictionary *paraments) {
        NSLog(@"check result is ------%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"check result is ------%@",paraments);
    }];
}

- (IBAction)currentEdition:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    NSString *currentEdition = [autoLogin currentEdition];
    [IDMPAlterHelper alertWithMessage:currentEdition superVC:self];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}




@end
