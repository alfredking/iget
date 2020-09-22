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
    BOOL needOffset;
    UIViewController *_VC;
}
@end

@implementation IDMPTempSmsViewController

- (void)showInView:(UIViewController *)superVC callBackBlock:(callbackBlock)successBlock callFailBlock:(callbackBlock)failBlock
{
    self.callBlock = successBlock;
    self.callFailBlock = failBlock;
    needOffset = YES;
    [superVC.view addSubview:self];
    _VC = superVC;
}

- (void)dismissView
{
    
    [_VC dismissViewControllerAnimated:YES completion:nil];
}



- (void)onAutoGetClick
{
    IDMPTempSmsMode *tempSms=[[IDMPTempSmsMode alloc] init];
    [_userName resignFirstResponder];
    [_msgCheck resignFirstResponder];
    NSString *userName = _userName.text;
    BOOL userRet = [IDMPMatch validateMobile:userName];
    if(userRet)
    {
        /**********************************获取验证码倒计时****************************************/
        UIButton *button = (UIButton *)[self viewWithTag:999];
        __block int timeout = 60;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if (timeout <= 0)
            {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setTitle:@"获取短信" forState:UIControlStateNormal];
                    button.enabled = YES;
                    [button setTitleColor:[UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
                });
            }
            else
            {
                int seconds = timeout;
                NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    button.enabled = NO;
                    [button setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateDisabled];
                    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                });
                timeout --;
            }
        });
        dispatch_resume(_timer);
        /**********************************获取验证码倒计时****************************************/
        
        [tempSms getSmsCodeWithUserName:userName busiType:@"3" successBlock:^(NSDictionary *paraments) {
            NSLog(@"获取验证码成功");
            NSLog(@"%@",paraments);
        } failBlock:^(NSDictionary *paraments) {
            NSLog(@"获取验证码失败");
            NSLog(@"%@",paraments);
            self.callFailBlock(paraments);
            
        }];
    }
    else
    {
        NSLog(@"fail!");
        if (userName.length == 0)
        {
            NSDictionary *result = @{@"resultCode":@"102303"};
            if (self.callFailBlock)
            {
                self.callFailBlock(result);
            }
        }
        else
        {
            NSDictionary *result = @{@"resultCode":@"102307"};
            if (self.callFailBlock)
            {
                self.callFailBlock(result);
            }
        }
    }
    
}



- (instancetype)init
{
    if (self = [super init])
    {
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
        _userName.layer.borderWidth = 1.0;
        _userName.layer.cornerRadius = 5.0;
        _userName.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
        _userName.delegate = self;
        [self addSubview:_userName];
        
        _msgCheck = [[UITextField alloc]initWithFrame:CGRectMake(10, _userName.frame.size.height+_userName.frame.origin.y+padding, 150, 40)];
        _msgCheck.font = [UIFont systemFontOfSize:17];
        _msgCheck.placeholder = @"请输入短信验证码";
        _msgCheck.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        loseBtn.frame = CGRectMake(170, _userName.frame.size.height+_userName.frame.origin.y+padding, 100, 40);
        loseBtn.tag = 999;
        [loseBtn setTitle:@"获取短信" forState:UIControlStateNormal];
        [loseBtn setTitleColor:[UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
        loseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loseBtn addTarget:self action:@selector(onAutoGetClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loseBtn];
        self.bounds = CGRectMake(0, 0, bounds.size.width-40, cancelBtn.frame.origin.y+padding+cancelBtn.frame.size.height);
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (needOffset)
    {
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
    if (!needOffset)
    {
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
    if (!userRet&&pwdRet)
    {
        if (userName.length == 0)
        {
            NSDictionary *result = @{@"resultCode":@"102303"};
            if (self.callFailBlock)
            {
                self.callFailBlock(result);
            }
            return;
        }
        NSDictionary *result = @{@"resultCode":@"102307"};
        if (self.callFailBlock)
        {
            self.callFailBlock(result);
        }
        return;
    }
    else if (userRet&&!pwdRet)
    {
        if (passWd.length==0)
        {
            NSDictionary *result = @{@"resultCode":@"102308"};
            if (self.callFailBlock)
            {
                self.callFailBlock(result);
            }
            return;
        }
        NSDictionary *result = @{@"resultCode":@"102309"};
        if (self.callFailBlock)
        {
            self.callFailBlock(result);
        }
        return;
    }
    else if (!userRet&&!pwdRet)
    {
        NSDictionary *result = @{@"resultCode":@"102310"};
        self.callFailBlock(result);
        return;
    }
    IDMPLoadingView *loadingV = [[IDMPLoadingView alloc]init];
    [loadingV showInView:self.superview];
    IDMPTempSmsMode *tempSms=[[IDMPTempSmsMode alloc] init];
    [tempSms getTMKSWithUserName:userName messageCode:passWd
                    successBlock:
     ^(NSDictionary *response){
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadingV dismissView];
             
             [self dismissView];
             
         });
         if (self.callBlock)
         {
             self.callBlock(response);
         }
     }
                       failBlock:
     ^(NSDictionary *getTMFail){
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadingV dismissView];
         });
         if (self.callFailBlock)
         {
             self.callFailBlock(getTMFail);
         }
     }];
    
}

- (void)onCancelClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissView];
    });
}



@end
