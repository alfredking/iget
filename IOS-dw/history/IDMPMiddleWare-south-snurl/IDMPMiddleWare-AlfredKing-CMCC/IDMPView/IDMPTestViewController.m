//
//  IDMPTestViewController.m
//  testlib
//
//  Created by zwk on 14/11/28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTestViewController.h"
/**
 *	现网
 */
#define APPID @"00100218"
#define APPKEY @"72ECDCA973BA51C7"


/**
 *	联调
 */
//#define APPID @"10000020"
//#define APPKEY @"ED07CA9256280692"


/**
 *	开发
 */
//#define APPID @"10000055"
//#define APPKEY @"33B4E0ABC08FB652"


#import "IDMPCustomUI.h"
#import "IDMPTempSmsMode.h"
#import "IDMPRegisterViewController.h"



@interface IDMPTestViewController ()

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

- (IBAction)tokenUI:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    [autoLogin getAccessTokenWithUserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)tokenCondition:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc] init];
    [autoLogin getAccessTokenByConditionWithUserName:@"18867101271" Content:@"120647ak" andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)tokenUserUI:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAccessTokenWithUserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)passwordUI:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAppPasswordWithUserName:nil andLoginType:1 isUserDefaultUI:YES finishBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"%@",paraments);
    }];
}
- (IBAction)passwordCondition:(id)sender {
    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin getAppPasswordByConditionWithUserName:@"18867101271" Content:@"120647ak"andLoginType:1 finishBlock:^(NSDictionary *paraments)
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


@end
