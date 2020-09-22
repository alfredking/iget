//
//  IDMPUPLoginViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/12/25.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPUPLoginViewController.h"

@interface IDMPUPLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation IDMPUPLoginViewController
- (IBAction)onBtnLogin:(id)sender {
    [self getAccessTokenByConditionWithAppid:@"01000104" Appkey:@"D6683D3B5245D064" UserName:self.userText.text Content:self.passwordText.text andLoginType:1 finishBlock:^(NSDictionary *paraments) {
        NSString *token=[paraments objectForKey:@"token"];
        NSString *url=[NSString stringWithFormat:@"%@://?token=%@" ,[self callBackUrl], token];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
            
        {
            NSLog(@"can open");
            NSLog(@"url is %@",url);
            [self dismissViewControllerAnimated:NO completion:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法打开"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    }
                                   failBlock:^(NSDictionary *paraments)
     {
         NSLog(@"fail result code");
         NSLog(@"%@",paraments);
         
     }];
    [self.userText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.userText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
