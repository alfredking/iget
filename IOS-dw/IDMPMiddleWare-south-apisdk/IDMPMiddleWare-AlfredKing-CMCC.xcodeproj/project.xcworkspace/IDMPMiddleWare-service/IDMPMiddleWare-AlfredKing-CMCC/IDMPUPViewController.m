//
//  IDMPUPViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-30.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPUPViewController.h"
#import "IDMPUPMode.h"

@implementation IDMPUPViewController

@synthesize didLoginIn;


- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
}

- (IBAction)UPAction:(UIButton *)sender
{
    didLoginIn=NO;
    NSString *userName=_UPUserName.text;
    NSString *passWd=_UPPassWd.text;
    IDMPUPMode *UP=[[IDMPUPMode alloc] init];
    
    
    [UP getUPKSByUserName:userName andPassWd:passWd
    successBlock:
    ^{
        didLoginIn=YES;
        NSLog(@"success");
        NSString *callbackURL =[NSString stringWithFormat:@"IDMPSDK://?userName=%@",userName];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callbackURL]];
    }
    failBlock:
    ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"up方式登录失败"]
                                                       delegate:self cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];

        NSLog(@"fail");
    }];
    
    
}
- (IBAction)forgetPassWordAction:(UIButton *)sender
{

        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tmView"] animated:YES completion:nil];
        
}

-(void)tapAction:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    
}


@end
