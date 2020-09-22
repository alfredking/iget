//
//  IDMPTempSmsViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking on 14/11/6.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPTempSmsViewController.h"
#import "IDMPTempSmsMode.h"
#import "IDMPLoadingView.h"
#import "IDMPMatch.h"
#import "IDMPConst.h"

typedef void (^callbackBlock)(NSDictionary *paraments);

@interface IDMPTempSmsViewController () <UITextFieldDelegate>
{
    UITextField *_userName;
    UITextField *_msgCheck;
//    UIView *_backView;
    BOOL needOffset;
    UIViewController *_VC;
}
@end

@implementation IDMPTempSmsViewController

- (void)showInView:(UIViewController *)superVC callBackBlock:(callbackBlock)successBlock callFailBlock:(callbackBlock)failBlock
{
//    _backView.frame = superV.frame;
    self.callBlock = successBlock;
    self.callFailBlock = failBlock;
//    _backView.backgroundColor = [UIColor lightGrayColor];
    needOffset = YES;
//    [_backView addSubview:self];
//    [superV addSubview:_backView];
    [superVC.view addSubview:self];
    _VC = superVC;
}

- (void)dismissView
{
    [_VC dismissViewControllerAnimated:YES completion:nil];
}


//overwrite login func
- (void)onAutoGetClick
{
    IDMPTempSmsMode *tempSms=[[IDMPTempSmsMode alloc] init];
    [_userName resignFirstResponder];
    [_msgCheck resignFirstResponder];
    NSString *userName = _userName.text;
    BOOL userRet = [IDMPMatch validateMobile:userName];
    if(userRet)
        {
            [tempSms getSmsCodeWithUserName:userName appId:nil appKey:nil busiType:@"3" successBlock:^(NSDictionary *paraments) {
                NSLog(@"获取验证码成功");
                NSLog(@"%@",paraments);
                self.callBlock(paraments);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取验证码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alert show];
//                });

            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"获取验证码失败");
                NSLog(@"%@",paraments);
                self.callFailBlock(paraments);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取验证码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alert show];
//                });
            }];
        }
    else
    {
        NSLog(@"fail!");
        if (userName.length == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"手机号不能为空"
//                                                           delegate:self cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
            NSDictionary *result = @{@"resultCode":@"102303"};
            self.callFailBlock(result);
        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"请输入正确的手机号"
//                                                           delegate:self cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
            NSDictionary *result = @{@"resultCode":@"102307"};
            self.callFailBlock(result);
        }
    }
    
}



- (instancetype)init
{
    if (self = [super init]) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        self.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        CGFloat padding = 20;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding, 200, 40)];
        titleLabel.textColor = [UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        titleLabel.text = @"中国移动账号";
        [self addSubview:titleLabel];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, titleLabel.frame.origin.y+titleLabel.frame.size.height, 270, 3)];
        lineLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0];
        [self addSubview:lineLabel];
        _userName = [[UITextField alloc]initWithFrame:CGRectMake(10, lineLabel.frame.size.height+lineLabel.frame.origin.y+padding, 260, 40)];
        _userName.font = [UIFont systemFontOfSize:17];
        _userName.placeholder = @"请输入手机号";
        _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _userName.text=@"18867101271";
        _userName.layer.borderWidth = 1.0;
        _userName.layer.cornerRadius = 5.0;
        _userName.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
        _userName.delegate = self;
        [self addSubview:_userName];
        
        _msgCheck = [[UITextField alloc]initWithFrame:CGRectMake(10, _userName.frame.size.height+_userName.frame.origin.y+padding, 150, 40)];
        _msgCheck.font = [UIFont systemFontOfSize:17];
        _msgCheck.placeholder = @"请输入短信验证码";
        _msgCheck.clearButtonMode = UITextFieldViewModeWhileEditing;
        //    _msgCheck.secureTextEntry=YES;
        _msgCheck.layer.borderWidth = 1.0;
        _msgCheck.layer.cornerRadius = 5.0;
        _msgCheck.delegate = self;
        _msgCheck.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
        [self addSubview:_msgCheck];
        
        //login
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(10, _msgCheck.frame.size.height+_msgCheck.frame.origin.y+padding, 120, 40);
        [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        [loginBtn addTarget:self action:@selector(onLoginClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginBtn];
        
        //cancel
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(150,  _msgCheck.frame.size.height+_msgCheck.frame.origin.y+padding, 120, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancelBtn addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *loseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loseBtn.frame = CGRectMake(180, _userName.frame.size.height+_userName.frame.origin.y+padding, 100, 40);
        [loseBtn setTitle:@"获取短信" forState:UIControlStateNormal];
        [loseBtn setTitleColor:[UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
        loseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loseBtn addTarget:self action:@selector(onAutoGetClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loseBtn];
        self.bounds = CGRectMake(0, 0, bounds.size.width-40, cancelBtn.frame.origin.y+padding+cancelBtn.frame.size.height);
//        _backView = [[UIView alloc]init];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (needOffset) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-100, self.frame.size.width, self.frame.size.height);
        needOffset = NO;
    }
    textField.layer.cornerRadius = 5.0;
    textField.layer.borderColor=[[UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0] CGColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!needOffset) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+100, self.frame.size.width, self.frame.size.height);
        needOffset = YES;
    }
    [_userName resignFirstResponder];
    [_msgCheck resignFirstResponder];
}

- (void)onLoginClick
{
    [_userName resignFirstResponder];
    [_msgCheck resignFirstResponder];
    NSString *userName = _userName.text;
    NSString *passWd = _msgCheck.text;
    BOOL userRet = [IDMPMatch validateMobile:userName];
    BOOL pwdRet = [IDMPMatch validateCheck:passWd];
    if (!userRet&&pwdRet) {
        if (userName.length == 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"手机号不能为空"
//                                                           delegate:self cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
            NSDictionary *result = @{@"resultCode":@"102303"};
            self.callFailBlock(result);
            return;
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"手机号输入错误"
//                                                       delegate:self cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        NSDictionary *result = @{@"resultCode":@"102307"};
        self.callFailBlock(result);
        return;
    }else if (userRet&&!pwdRet){
        if (passWd.length==0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"请输入验证码"
//                                                           delegate:self cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
            NSDictionary *result = @{@"resultCode":@"102308"};
            self.callFailBlock(result);
            return;
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"验证码输入格式错误"
//                                                       delegate:self cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        NSDictionary *result = @{@"resultCode":@"102309"};
        self.callFailBlock(result);
        return;
    }else if (!userRet&&!pwdRet){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"手机号和验证码错误"
//                                                       delegate:self cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        NSDictionary *result = @{@"resultCode":@"102310"};
        self.callFailBlock(result);
        return;
    }
        IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
        [loadingV showInView:self.superview];
        IDMPTempSmsMode *tempSms=[[IDMPTempSmsMode alloc] init];
        [tempSms getTMKSWithUserName:userName messageCode:passWd successBlock:
         ^(NSDictionary *response){

             dispatch_async(dispatch_get_main_queue(), ^{
                 [loadingV dismissView];
                 
                 [self dismissView];
                 
             });
             if (self.callBlock) {
                 self.callBlock(response);
             }
         }
        failBlock:
         ^(NSDictionary *getTMFail){
             if (self.callFailBlock) {
                 self.callFailBlock(getTMFail);
             }
             dispatch_async(dispatch_get_main_queue(), ^{
//                 [self dismissView];
                 [loadingV dismissView];
//                 if ([[getTMFail objectForKey:@"resultCode"] intValue] == 103108 ||[[getTMFail objectForKey:@"resultCode"] intValue] == 103203) {
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                     message:@"短信验证码错误"
//                                                                    delegate:self cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                     [alert show];
//                 }else if([[getTMFail objectForKey:@"resultCode"]integerValue] == 103106){
//                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                     message:@"用户名错误"
//                                                                    delegate:self cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                     [alert show];
//                 }
//                 else if ([[getTMFail objectForKey:@"resultCode"]integerValue] == 102102){
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                     message:[NSString stringWithFormat:@"临时短信方式登录失败"]
//                                                                    delegate:self cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                [alert show];
//                 }
             });
             
         }];
    
}

- (void)onCancelClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissView];
    });
}



@end
