//
//  IDMPTestViewController.m
//  testlib
//
//  Created by zwk on 14/11/28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//


#import "IDMPTestViewController.h"
#import "IDMPCustomUI.h"
#import "IDMPTempSmsMode.h"
#import "IDMPRegisterViewController.h"
#import "Test2ViewController.h"
#import "IDMPAutoLoginViewController.h"
#import "IDMPMatch.h"
#import "IDMPToken.h"

@interface IDMPTestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTf;
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
    NSLog(@"--%@",NSHomeDirectory());
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]);
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tokenUI:(id)sender {      
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAccessTokenWithUserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSString *tokenStr = [paraments objectForKey:@"token"];
        [IDMPToken checkToken:tokenStr andAppid:@"100000"];
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)tokenCondition:(id)sender {
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAccessTokenByConditionWithUserName:@"18867101277" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)tokenUserUI:(id)sender {
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAccessTokenWithUserName:nil andLoginType:3 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)passwordUI:(id)sender {
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAppPasswordWithUserName:nil andLoginType:2 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
        NSString *tokenStr = [paraments objectForKey:@"token"];
        [IDMPToken checkToken:tokenStr andAppid:@"100000"];
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)passwordCondition:(id)sender {
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAppPasswordByConditionWithUserName:@"18867101277" Content:@"hong123" andLoginType:1 finishBlock:^(NSDictionary *paraments)
     {
         NSLog(@"test %@",paraments);
     }
                                   failBlock:^(NSDictionary *paraments)
     {
         NSLog(@"%@",paraments);
         
     }];

}
- (IBAction)passwordUserUI:(id)sender {
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAppPasswordWithUserName:nil andLoginType:3 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)clearCache:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin cleanSSO];
}
- (IBAction)accountManager:(id)sender {
    IDMPRegisterViewController *accountController = [[IDMPRegisterViewController alloc]init];
    [self presentViewController:accountController animated:YES completion:nil];
}
- (IBAction)changeAccountList:(id)sender {
    NSLog(@"切换账户");
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin changeAccountWithUserName:@"15201183091" andFinishBlick:^(NSDictionary *paraments) {
        NSLog(@"success:%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail:%@",paraments);
    }];
}
- (IBAction)accountList:(id)sender {
      IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAccountListWithFinishBlock:nil failBlock:nil];
}
- (IBAction)presentTest2:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin currentEdition];
}
- (IBAction)checkLocalNumber:(UIButton *)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    BOOL isPhoneNumber = [IDMPMatch validateMobile:self.phoneNumberTf.text];
    NSLog(@"输入的手机号：%@",self.phoneNumberTf.text);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (isPhoneNumber) {
                BOOL isLoacalNumber = [autoLogin checkIsLocalNumberWith:self.phoneNumberTf.text];
                NSLog(@"isLoacalNumber=%d",isLoacalNumber);
                if (isLoacalNumber) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.phoneNumberTf.text = @"是";
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.phoneNumberTf.text = @"否";
                    });
                }
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确手机号" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil] show];
                });
            }
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
