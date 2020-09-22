//
//  IDMPPerformaceViewController.m
//  IDMPCMCCDemo
//
//  Created by wj on 2018/5/11.
//  Copyright © 2018年 alfredking－cmcc. All rights reserved.
//

#import "IDMPPerformaceViewController.h"
#import "IDMPTokenCheckHelper.h"
#import "IDMPAutoLoginViewController.h"

@interface IDMPPerformaceViewController ()

@end

@implementation IDMPPerformaceViewController
- (IBAction)testAutoLogin:(id)sender {
    for (int i=0; i<5; i++) {
        IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
        [autoLogin cleanSSO];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            int authType = [autoLogin getAuthType];
//            if (authType == -1) {
//                NSLog(@"网络异常");
//            } else if(authType == 3) {
//                NSLog(@"检测到移动sim卡不存在，但可能检测异常。苹果api不稳定");
//            } else {
                //1.getAccessTokenWithUserName中userName可以传nil，如果有缓存，会用上一次使用的登录账号签发token。
                //如果缓存的用户不是本机号码，而想用本机号码登录，则可以checkIsLocalNumber来检查，如果发现不是本机号码，可以cleanSSO清除缓存再登录。
                //如果没有缓存，会重新协商ks进行token签发。
                //2.userName也可以传指定手机号，如果这个手机号有缓存，则直接签发token；如果没有，则返回102314，缓存不存在。
                [autoLogin getAccessTokenWithUserName:nil andLoginType:2 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
                    NSLog(@"get token success------");
                    IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app自己完成
                    NSString *token = [paraments objectForKey:@"token"];
                    [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                        NSLog(@"token valid success------");
                        
                    } failBlock:^(NSDictionary *dic) {
                        NSLog(@"token valid fail------%@",dic);
                        //某些情况下需要调用cleanSSO清除缓存，否则会一直登录失败。
                    }];
                } failBlock:^(NSDictionary *paraments) {
                    NSLog(@"get token fail------%@",paraments);
                }];
//            }
        });
    }
}
- (IBAction)testNocacheLogin:(UIButton *)sender {
    for (int i=0; i<5; i++) {
        IDMPAutoLoginViewController *autoLogin = [[IDMPAutoLoginViewController alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int authType = [autoLogin getAuthType];
            if (authType == -1) {
                NSLog(@"网络异常");
            } else if(authType == 3) {
                NSLog(@"检测到移动sim卡不存在，但可能检测异常。苹果api不稳定");
            } else {
                [autoLogin getAccessTokenNoCacheWithLoginType:authType finishBlock:^(NSDictionary *paraments) {
                    NSLog(@"get token success------");
                    IDMPTokenCheckHelper *tokencheck = [[IDMPTokenCheckHelper alloc]init];    //用于token校验类，app自己完成
                    NSString *token = [paraments objectForKey:@"token"];
                    [tokencheck checkToken:token successBlock:^(NSDictionary *dic) {
                        NSLog(@"token valid success------");
                        
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
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)testReportlog:(UIButton *)sender {
    IDMPAutoLoginViewController *idmp = [IDMPAutoLoginViewController new];
    for (int i = 0 ; i< 100; i++) {
        
        [idmp getAccessTokenWithUserName:nil andLoginType:0 isUserDefaultUI:NO finishBlock:^(NSDictionary *paraments) {
            
        } failBlock:^(NSDictionary *paraments) {
            
        }];
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
