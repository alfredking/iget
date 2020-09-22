//
//  IDMPTestViewController.m
//  testlib
//
//  Created by zwk on 14/11/28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTestViewController.h"
#import "IDMPAutoLoginViewController.h"
//#define APPID @"10000015"
//#define APPKEY @"BF59CBD2E672FB15"
#import "IDMPCustomUI.h"
#import "IDMPTempSmsMode.h"
#import "IDMPRegisterViewController.h"
#import "IDMPToken.h"
#import "IDMPConst.h"
@interface IDMPTestViewController (){
    NSString *APPID,*APPKEY;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *environmentSegment;

@property (strong, nonatomic) IBOutlet UITextField *usernameTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTf;

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;


@end
static IDMPTestViewController *g_testVC = nil;

@implementation IDMPTestViewController

+ (instancetype)defaultTestVC
{
    if (g_testVC == nil) {
        g_testVC = [[IDMPTestViewController alloc]init];
    }
    return g_testVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_environmentSegment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    _environmentSegment.selectedSegmentIndex = 0;
    
    [[NSUserDefaults standardUserDefaults] setValue:hyURL forKey:@"URL"];
    [[NSUserDefaults standardUserDefaults] setValue:hyport forKey:@"port"];
    [[NSUserDefaults standardUserDefaults] setObject:hyUpSmsNum forKey:@"UpSmsNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    APPID = @"10000015";
    APPKEY = @"BF59CBD2E672FB15";
}

- (void)segmentSelected:(UISegmentedControl *)segmentController
{
    [[IDMPAutoLoginViewController alloc] cleanSSO];
    self.resultLabel.text = @"";
    switch (segmentController.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"selectedSegmentIndex = 0");
            [[NSUserDefaults standardUserDefaults] setValue:hyURL forKey:@"URL"];
            [[NSUserDefaults standardUserDefaults] setValue:hyport forKey:@"port"];
            [[NSUserDefaults standardUserDefaults] setObject:hyUpSmsNum forKey:@"UpSmsNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            APPID = @"10000015";
            APPKEY = @"BF59CBD2E672FB15";
        }
            break;
        case 1:
        {
            NSLog(@"selectedSegmentIndex = 1");
            [[NSUserDefaults standardUserDefaults] setValue:miguURL forKey:@"URL"];
            [[NSUserDefaults standardUserDefaults] setValue:miguport forKey:@"port"];
            [[NSUserDefaults standardUserDefaults] setObject:miguUpSmsNum forKey:@"UpSmsNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            APPID = @"10000027";
            APPKEY = @"873837F2D0E2BD98";
        }
            break;
        case 2:
        {
            NSLog(@"selectedSegmentIndex = 2");
            [[NSUserDefaults standardUserDefaults] setValue:southURL forKey:@"URL"];
            [[NSUserDefaults standardUserDefaults] setValue:southport forKey:@"port"];
            [[NSUserDefaults standardUserDefaults] setObject:southUpSmsNum forKey:@"UpSmsNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            APPID = @"10000059";
            APPKEY = @"F154152DE1292321";
        }
            break;
        default:
            break;
    }
}



- (IBAction)wapLoginBtnClick:(UIButton *)sender {
    //一键登录
    
    [[IDMPAutoLoginViewController alloc] getAccessTokenWithAppid:APPID Appkey:APPKEY UserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            [IDMPToken checkToken:tokenStr andAppid:APPID successBlock:^(NSDictionary *dic){
                NSString *userName = [dic objectForKey:@"msisdn"]?[dic objectForKey:@"msisdn"]:[dic objectForKey:@"email"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultLabel.text = [NSString stringWithFormat:@"登录方式:%@\n用户名:%@",[[[NSUserDefaults standardUserDefaults] objectForKey:userName] objectForKey:@"getKSWay"],userName];
                });
            } failBlock:^(NSDictionary *dic) {
                NSLog(@"fail");
            }];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"应答码：%@",[paraments objectForKey:@"resultCode"]);
            self.resultLabel.text = [NSString stringWithFormat:@"应答码:%@",[paraments objectForKey:@"resultCode"]];
        });
    }];
}



- (IBAction)dataSmsBtnClick:(UIButton *)sender {
    //数据短信登录

    [[IDMPAutoLoginViewController alloc] getAccessTokenWithAppid:APPID Appkey:APPKEY UserName:nil andLoginType:2 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            [IDMPToken checkToken:tokenStr andAppid:APPID successBlock:^(NSDictionary *dic){
                NSString *userName = [dic objectForKey:@"msisdn"]?[dic objectForKey:@"msisdn"]:[dic objectForKey:@"email"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultLabel.text = [NSString stringWithFormat:@"登录方式:%@\n用户名:%@",[[[NSUserDefaults standardUserDefaults] objectForKey:userName] objectForKey:@"getKSWay"],userName];
                });
            } failBlock:^(NSDictionary *dic) {
                NSLog(@"fail");
            }];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"应答码：%@",[paraments objectForKey:@"resultCode"]);
            self.resultLabel.text = [NSString stringWithFormat:@"应答码:%@",[paraments objectForKey:@"resultCode"]];
        });
    }];
}




- (IBAction)upLoginBtnClick:(UIButton *)sender {
    //用户名密码登录
    
    if ([_usernameTf.text isEqualToString:@""] || [_passwordTf.text isEqualToString:@""]) {
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    
    [[IDMPAutoLoginViewController alloc] getAccessTokenByConditionWithAppid:APPID Appkey:APPKEY UserName:_usernameTf.text Content:_passwordTf.text andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tokenStr = [paraments objectForKey:@"token"];
            [IDMPToken checkToken:tokenStr andAppid:APPID successBlock:^(NSDictionary *dic){
                NSString *userName = [dic objectForKey:@"msisdn"]?[dic objectForKey:@"msisdn"]:[dic objectForKey:@"email"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.resultLabel.text = [NSString stringWithFormat:@"登录方式:%@\n用户名:%@",[[[NSUserDefaults standardUserDefaults] objectForKey:userName] objectForKey:@"getKSWay"],userName];
                });
            } failBlock:^(NSDictionary *dic) {
                NSLog(@"fail");
            }];
        });
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"应答码：%@",[paraments objectForKey:@"resultCode"]);
            self.resultLabel.text = [NSString stringWithFormat:@"应答码:%@",[paraments objectForKey:@"resultCode"]];
        });
    }];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tokenUI:(id)sender {
    //接口用于获取统一认证的身份标识；如果为sip应用需要返回应用密码则调用getAppPassword接口来完成
    [[IDMPAutoLoginViewController alloc] getAccessTokenWithAppid:APPID Appkey:APPKEY UserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)tokenCondition:(id)sender {
    //接口用于获取统一认证的身份标识
    [[IDMPAutoLoginViewController alloc] getAccessTokenByConditionWithAppid:APPID Appkey:APPKEY UserName:@"18867101277" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)tokenUserUI:(id)sender {
    //接口用于获取统一认证的身份标识；如果为sip应用需要返回应用密码则调用getAppPassword接口来完成
    [[IDMPAutoLoginViewController alloc] getAccessTokenWithAppid:APPID Appkey:APPKEY UserName:nil andLoginType:4 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            IDMPCustomUI *customV = [[[NSBundle mainBundle]loadNibNamed:@"IDMPCustomUI" owner:nil options:nil]firstObject];
            customV.center = self.view.center;
            customV.loginBlock = ^{
                //接口用于获取统一认证的身份标识
                [[IDMPAutoLoginViewController alloc] getAccessTokenByConditionWithAppid:APPID Appkey:APPKEY UserName:customV.userName.text Content:customV.passWord.text andLoginType:1 finishBlock:^(NSDictionary *paraments) {
                    NSLog(@"%@",paraments);
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"fail");
                }];
            };
            customV.loginWithValidBlock = ^{
                //接口用于获取统一认证的身份标识
                [[IDMPAutoLoginViewController alloc] getAccessTokenByConditionWithAppid:APPID Appkey:APPKEY UserName:customV.userName.text Content:customV.passWord.text andLoginType:2 finishBlock:^(NSDictionary *paraments) {
                    NSLog(@"%@",paraments);
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"fail");
                }];
            };
            customV.getValidBlock = ^{
                IDMPTempSmsMode *temp = [[IDMPTempSmsMode alloc]init];
                //接口用于第三方应用使用自定义登陆界面，通过临时密码登陆方式登陆时，获取临时登陆密码使用。
                [temp getSmsCodeWithUserName:customV.userName.text appId:nil appKey:nil busiType:@"3" successBlock:^(NSDictionary *paraments) {
                    NSLog(@"get valid success");
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"get valid fail");
                }];
                
            };
            [self.view addSubview:customV];
        });
    }];
}
- (IBAction)passwordUI:(id)sender {
    //这一接口用于sip应用获取token以及sip密码
    [[IDMPAutoLoginViewController alloc] getAppPasswordWithAppid:APPID Appkey:APPKEY UserName:nil andLoginType:7 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)passwordCondition:(id)sender {
    //接口用于获取统一认证的应用密码（同时返回Token身份标示）
    [[IDMPAutoLoginViewController alloc] getAppPasswordByConditionWithAppid:APPID Appkey:APPKEY UserName:@"18790255676" Content:@"cmcc571" andLoginType:1 finishBlock:^(NSDictionary *paraments)
     {
         NSLog(@"test %@",paraments);
     }
     failBlock:^(NSDictionary *paraments)
     {
         NSLog(@"%@",paraments);
         
     }];

}



- (IBAction)passwordUserUI:(id)sender {
    //接口用于获取统一认证的应用密码（同时返回Token身份标示）
    [[IDMPAutoLoginViewController alloc] getAppPasswordWithAppid:APPID Appkey:APPKEY UserName:nil andLoginType:4 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            IDMPCustomUI *customV = [[[NSBundle mainBundle]loadNibNamed:@"IDMPCustomUI" owner:nil options:nil]firstObject];
            customV.center = self.view.center;
            customV.loginBlock = ^{
                [[IDMPAutoLoginViewController alloc] getAccessTokenByConditionWithAppid:APPID Appkey:APPKEY UserName:customV.userName.text Content:customV.passWord.text andLoginType:1 finishBlock:^(NSDictionary *paraments) {
                    NSLog(@"%@",paraments);
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"fail");
                }];
            };
            customV.loginWithValidBlock = ^{
                [[IDMPAutoLoginViewController alloc] getAccessTokenByConditionWithAppid:APPID Appkey:APPKEY UserName:customV.userName.text Content:customV.passWord.text andLoginType:2 finishBlock:^(NSDictionary *paraments) {
                    NSLog(@"%@",paraments);
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"fail");
                }];
            };
            customV.getValidBlock = ^{
                IDMPTempSmsMode *temp = [[IDMPTempSmsMode alloc]init];
                [temp getSmsCodeWithUserName:customV.userName.text appId:nil appKey:nil busiType:@"3" successBlock:^(NSDictionary *paraments) {
                    NSLog(@"get valid success");
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"get valid fail");
                }];
                
            };
            [self.view addSubview:customV];
        });
    }];
}
- (IBAction)clearCache:(id)sender {
    self.resultLabel.text = @"";
    [[IDMPAutoLoginViewController alloc] cleanSSO];
}
- (IBAction)accountManager:(id)sender {
    IDMPRegisterViewController *accountController = [[IDMPRegisterViewController alloc]init];
    [self presentViewController:accountController animated:YES completion:nil];
}
- (IBAction)changeAccountList:(id)sender {
    NSLog(@"切换账户");
    [[IDMPAutoLoginViewController alloc] changeAccountWithUserName:@"15201183091" andFinishBlick:^(NSDictionary *paraments) {
        NSLog(@"success:%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail:%@",paraments);
    }];
}
- (IBAction)accountList:(id)sender {
    [[IDMPAutoLoginViewController alloc] getAccountListWithAppid:nil Appkey:nil finishBlock:nil failBlock:nil];
}
- (IBAction)presentTest2:(id)sender {
  [[IDMPAutoLoginViewController alloc] currentEdition];
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
