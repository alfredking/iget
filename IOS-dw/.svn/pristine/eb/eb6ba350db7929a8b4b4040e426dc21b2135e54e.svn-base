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
#import "IDMPKsModel.h"
#import "IDMPTool.h"


//联调环境
//#define APPID @"01000205"
//#define APPKEY @"8188CCDA967ECC06"


//线上环境
#define APPID @"01000201"
#define APPKEY @"E20C43DAFDDA8E4E"

@interface IDMPTestViewController (){
    
    __weak IBOutlet UITextField *autoPhoneNumberTF;
    __weak IBOutlet UITextField *phoneNumberTF;
    __weak IBOutlet UITextField *sdkCertIDTF;
    __weak IBOutlet UILabel *resultLabel;
}

@end

@implementation IDMPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [IDMPAutoLoginViewController setIsPrintLocalLog:YES];
    [IDMPAutoLoginViewController setEnvironment:OnlineEnvironment];
}




- (IBAction)wapClick:(id)sender {
    NSLog(@"APPID:%@,APPKEY:%@",APPID,APPKEY);
    [IDMPAutoLoginViewController getAccessTokenWithAppid:APPID appkey:APPKEY userName:autoPhoneNumberTF.text loginType:1 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"wap getAccessToken:%@",paraments);
        NSString *resultCodeStr = [paraments objectForKey:@"resultcode"];
        NSString *nonce = [paraments objectForKey:@"nonce"];
        NSString *cnonce = [paraments objectForKey:@"cnonce"];
        if ([resultCodeStr integerValue] == 000)
        {
            [IDMPTool mobileDecodeWithCnonce:cnonce nonce:nonce callBack:^(id result1) {
                NSLog(@"mobileDecode result:%@",result1);
                NSString *resultCode2 = [result1 objectForKey:@"resultCode"];
                NSString *mobileNumber = [result1 objectForKey:@"mobileNumber"];
                NSString *sdkCertID = [result1 objectForKey:@"sdkCertID"];
                NSLog(@"----mobileNumber:%@,sdkCertID:%@",mobileNumber,sdkCertID);
                if ([resultCode2 integerValue] == 000 && mobileNumber && sdkCertID)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        phoneNumberTF.text = mobileNumber;
                        sdkCertIDTF.text = sdkCertID;
                    });
                    
                    [IDMPKsModel renewKsWithAppid:APPID appkey:APPKEY certID:sdkCertID mobile:mobileNumber callBack:^(id result2) {
                        NSLog(@"renewKs result:%@",result2);
                        NSString *resultCode3 = [result2 objectForKey:@"resultCode"];
                        NSString *tokenStr = [result2 objectForKey:@"token"];
                        if ([resultCode3 integerValue] == 102000 && tokenStr)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                resultLabel.text = [autoPhoneNumberTF.text isEqualToString:mobileNumber] ? @"是本机号码" : @"非本机号码";
                            });
                            [IDMPTool tokenValidateWithAppid:APPID token:tokenStr callBack:^(id result3) {
                                NSLog(@"tokenValidate result:%@",result3);
                            }];
                        }
                    }];
                }
            }];
        }
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail:%@",paraments);
    }];
}


- (IBAction)datasmsClick:(id)sender {
    [IDMPAutoLoginViewController getAccessTokenWithAppid:APPID appkey:APPKEY userName:autoPhoneNumberTF.text loginType:2 finishBlock:^(NSDictionary *paraments){
        NSLog(@"datasms getAccessToken:%@",paraments);
        NSString *resultCodeStr = [paraments objectForKey:@"resultcode"];
        NSString *nonce = [paraments objectForKey:@"nonce"];
        NSString *cnonce = [paraments objectForKey:@"cnonce"];
        if ([resultCodeStr integerValue] == 000 && nonce)
        {
            [IDMPTool mobileDecodeWithCnonce:cnonce nonce:nonce callBack:^(id result1) {
                NSLog(@"mobileDecode result:%@",result1);
                NSString *resultCode2 = [result1 objectForKey:@"resultCode"];
                NSString *mobileNumber = [result1 objectForKey:@"mobileNumber"];
                NSString *sdkCertID = [result1 objectForKey:@"sdkCertID"];
                NSLog(@"----mobileNumber:%@,sdkCertID:%@",mobileNumber,sdkCertID);
                if ([resultCode2 integerValue] == 000 && mobileNumber && sdkCertID)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        phoneNumberTF.text = mobileNumber;
                        sdkCertIDTF.text = sdkCertID;
                    });
                
                    [IDMPKsModel renewKsWithAppid:APPID appkey:APPKEY certID:sdkCertID mobile:mobileNumber callBack:^(id result2) {
                        NSLog(@"renewKs result:%@",result2);
                        NSString *resultCode3 = [result2 objectForKey:@"resultCode"];
                        NSString *tokenStr = [result2 objectForKey:@"token"];
                        if ([resultCode3 integerValue] == 102000 && tokenStr)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                resultLabel.text = [autoPhoneNumberTF.text isEqualToString:mobileNumber] ? @"是本机号码" : @"非本机号码";
                            });
                            [IDMPTool tokenValidateWithAppid:APPID token:tokenStr callBack:^(id result3) {
                                NSLog(@"tokenValidate result:%@",result3);
                            }];
                        }
                    }];
                }
            }];
        }
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail:%@",paraments);
    }];
}


- (IBAction)smsCodeClicked:(id)sender{
    [IDMPAutoLoginViewController getAccessTokenWithAppid:APPID appkey:APPKEY userName:nil loginType:3 finishBlock:^(NSDictionary *paraments) {
        NSLog(@"tempsms getAccessToken:%@",paraments);
        NSString *SdkCertID = [paraments objectForKey:@"sdkCertID"];
        NSString *mobileNumber = [paraments objectForKey:@"mobileNumber"];
        if (SdkCertID && mobileNumber) {
            dispatch_async(dispatch_get_main_queue(), ^{
                phoneNumberTF.text = mobileNumber;
                sdkCertIDTF.text = SdkCertID;
            });
            
            [IDMPKsModel renewKsWithAppid:APPID appkey:APPKEY certID:SdkCertID mobile:mobileNumber callBack:^(id result) {
                NSLog(@"renewKs result:%@",result);
                NSString *resultCode = [result objectForKey:@"resultCode"];
                NSString *tokenStr = [result objectForKey:@"token"];
                if ([resultCode integerValue] == 102000 && tokenStr)
                {
                    [IDMPTool tokenValidateWithAppid:APPID token:tokenStr callBack:^(id result2) {
                        NSLog(@"tokenValidate result:%@",result2);
                        if ([[result2 objectForKey:@"ResultCode"] integerValue] == 000) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                resultLabel.text = [NSString stringWithFormat:@"登录号码:%@",mobileNumber];
                            });
                        }
                    }];
                }
            }];
        }
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"fail:%@",paraments);
    }];
}


- (IBAction)renewalAuthTokenClicked:(id)sender {
    [IDMPAutoLoginViewController renewalAuthTokenWithAppid:APPID appkey:APPKEY certID:sdkCertIDTF.text mobile:phoneNumberTF.text callBack:^(id result) {
        NSLog(@"renewalAuthTokenClicked result:%@",result);
        NSString *tokenStr = [result objectForKey:@"token"];
        if (tokenStr) {
            [IDMPTool tokenValidateWithAppid:APPID token:tokenStr callBack:^(id result) {
                NSLog(@"tokenValidate result:%@",result);
            }];
        }
        NSString *expiretime = [result objectForKey:@"expiretime"];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultLabel.text = [NSString stringWithFormat:@"ks有效期:%@",expiretime];;
        });
    }];
}



- (IBAction)getTokenClick:(id)sender {
    NSDictionary *result = [IDMPAutoLoginViewController getToken:sdkCertIDTF.text mobile:phoneNumberTF.text];
   
    NSLog(@"getTokenClick result:%@",result);
    NSString *tokenStr = [result objectForKey:@"token"];
    if (tokenStr) {
        [IDMPTool tokenValidateWithAppid:APPID token:tokenStr callBack:^(id result) {
            NSLog(@"tokenValidate result:%@",result);
        }];
    }
    NSString *resultCode = [result objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"102206"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resultLabel.text = @"该手机号未登录";;
        });
        return;
    }
    if ([resultCode isEqualToString:@"102000"]) {
        NSString *mobileNumber = [result objectForKey:@"mobileNumber"];
        dispatch_async(dispatch_get_main_queue(), ^{
            resultLabel.text = [NSString stringWithFormat:@"登录号码:%@",mobileNumber];
        });
    }
}



- (IBAction)logoutClick:(id)sender {
    
    [IDMPAutoLoginViewController logout];
    resultLabel.text = @"ks已清除";
}



- (IBAction)accountList:(id)sender {
    [IDMPAutoLoginViewController getAccountListWithFinishBlock:nil failBlock:nil];
}



- (IBAction)presentTest2:(id)sender {
    [IDMPAutoLoginViewController currentEdition];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    resultLabel.text = @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
