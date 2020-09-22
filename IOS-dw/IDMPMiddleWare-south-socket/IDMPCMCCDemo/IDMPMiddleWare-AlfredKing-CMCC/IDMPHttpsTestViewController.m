//
//  IDMPHttpsTestViewController.m
//  IDMPCMCCDemo
//
//  Created by wj on 2018/9/5.
//  Copyright © 2018年 alfredking－cmcc. All rights reserved.
//

#import "IDMPHttpsTestViewController.h"
#import "IDMPTokenCheckHelper.h"
#import "IDMPAlterHelper.h"

#define HTTPSTESTURL @"https://www.quhao.cmpassport.com/ggsn?GW_TEST=1"
#define CERTURL @"https://www.quhao.cmpassport.com/ins/cert"

#define HTTPSTESTURL2 @"https://www.quhao.cmpassport.com/ggsn"

@interface IDMPHttpsTestViewController ()

@end

@implementation IDMPHttpsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getFixedNumber:(id)sender {
    IDMPTokenCheckHelper *test = [[IDMPTokenCheckHelper alloc] init];
    [test httpsTestWithUrlStr:HTTPSTESTURL heads:nil successBlock:^(NSDictionary *dic) {
        NSString *cert = dic[@"cert"];
        if (cert) {
            [test httpsTestWithUrlStr:CERTURL heads:@{@"cert":cert} successBlock:^(NSDictionary *dic) {
                [IDMPAlterHelper alertWithMessage:dic superVC:self];
            } failBlock:^(NSDictionary *dic) {
                [IDMPAlterHelper alertWithMessage:dic superVC:self];
            }];
        } else {
            [IDMPAlterHelper alertWithMessage:dic superVC:self];
        }
    } failBlock:^(NSDictionary *dic) {
        [IDMPAlterHelper alertWithMessage:dic superVC:self];
    }];
    
}
- (IBAction)getLocalNumber:(id)sender {
    IDMPTokenCheckHelper *test = [[IDMPTokenCheckHelper alloc] init];
    [test httpsTestWithUrlStr:HTTPSTESTURL2 heads:nil successBlock:^(NSDictionary *dic) {
        NSString *cert = dic[@"cert"];
        if (cert) {
            [test httpsTestWithUrlStr:CERTURL heads:@{@"cert":cert} successBlock:^(NSDictionary *dic) {
                [IDMPAlterHelper alertWithMessage:dic superVC:self];
            } failBlock:^(NSDictionary *dic) {
                [IDMPAlterHelper alertWithMessage:dic superVC:self];
            }];
        } else {
            [IDMPAlterHelper alertWithMessage:dic superVC:self];
        }

    } failBlock:^(NSDictionary *dic) {
        [IDMPAlterHelper alertWithMessage:dic superVC:self];
    }];
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
