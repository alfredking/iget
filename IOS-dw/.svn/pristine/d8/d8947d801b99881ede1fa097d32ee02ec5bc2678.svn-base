//
//  IDMPUPViewController.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking on 14/11/6.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPUPViewController.h"
#import "IDMPTempSmsViewController.h"
#import "IDMPUPMode.h"
#import "IDMPLoadingView.h"
#import "IDMPMatch.h"
#import "IDMPConst.h"

@interface IDMPUPViewController () <UITextFieldDelegate>
{
    UITextField *_userName;
    UITextField *_userPWD;
//    UIView *_backView;
    BOOL needOffset;
}
@end

@implementation IDMPUPViewController

/*- (instancetype)init
{
    if (self = [super init]) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        self.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
//        self.bounds = CGRectMake(0, 0, bounds.size.width-40, bounds.size.height-240);
         CGFloat  padding = 20.0;
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
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
        _userName.placeholder = @"请输入手机号/邮箱/用户ID";
        _userName.text=@"18867101271";
        _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userName.layer.borderWidth = 1.0;
        _userName.layer.cornerRadius = 5.0;
        _userName.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
        _userName.delegate = self;
        [self addSubview:_userName];
        
        
        _userPWD = [[UITextField alloc]initWithFrame:CGRectMake(10, _userName.frame.size.height+_userName.frame.origin.y+padding, 260, 40)];
        _userPWD.font = [UIFont systemFontOfSize:17];
        _userPWD.placeholder = @"请输入密码";
        _userPWD.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userPWD.text=@"120647ak";
        _userPWD.secureTextEntry=YES;
        _userPWD.layer.borderWidth = 1.0;
        _userPWD.layer.cornerRadius = 5.0;
        _userPWD.delegate = self;
        _userPWD.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
        [self addSubview:_userPWD];
        
        //login
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(10, _userPWD.frame.size.height+_userPWD.frame.origin.y+padding, 120, 40);
        [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        [loginBtn addTarget:self action:@selector(onLoginClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginBtn];
        
        //cancel
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(150, _userPWD.frame.size.height+_userPWD.frame.origin.y+padding, 120, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancelBtn addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *loseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loseBtn.frame = CGRectMake(170, cancelBtn.frame.size.height+cancelBtn.frame.origin.y+padding, 100, 40);
        [loseBtn setTitle:@"忘记密码>>" forState:UIControlStateNormal];
        [loseBtn setTitleColor:[UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
        loseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loseBtn addTarget:self action:@selector(onLoseClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loseBtn];
        self.bounds = CGRectMake(0, 0, bounds.size.width-40, loseBtn.frame.origin.y+padding+loseBtn.frame.size.height);
        _backView = [[UIView alloc]init];
    }
    return self;
}
*/
- (void)showInView:(UIViewController *)superVC placedUserName:(NSString *)userName callBackBlock:(callbackBlock)successBlock callFailBlock:(callbackBlock)failBlock
{
//    _backView.frame = superV.frame;
    self.callBlock = successBlock;
    self.callFailBlock = failBlock;
    _userName.text = userName;
    needOffset = YES;
    _userPWD.text = nil;
    [self.view addSubview:self.customV];
    [superVC presentViewController:self animated:YES completion:nil];
//    _backView.backgroundColor = [UIColor lightGrayColor];
//    [_backView addSubview:self];
//    [superV addSubview:_backView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.customV = [[UIView alloc]init];
    self.customV.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    CGFloat  padding = 20.0;
    self.customV.layer.cornerRadius = 5.0;
    self.customV.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, padding, 200, 40)];
    titleLabel.textColor = [UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    titleLabel.text = @"中国移动账号";
    [self.customV addSubview:titleLabel];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, titleLabel.frame.origin.y+titleLabel.frame.size.height, 270, 3)];
    lineLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0];
    [self.customV addSubview:lineLabel];
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(10, lineLabel.frame.size.height+lineLabel.frame.origin.y+padding, 260, 40)];
    _userName.font = [UIFont systemFontOfSize:17];
    _userName.placeholder = @"请输入手机号/邮箱/用户ID";
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userName.layer.borderWidth = 1.0;
    _userName.layer.cornerRadius = 5.0;
    _userName.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
    _userName.delegate = self;
    [self.customV addSubview:_userName];
    
    
    _userPWD = [[UITextField alloc]initWithFrame:CGRectMake(10, _userName.frame.size.height+_userName.frame.origin.y+padding, 260, 40)];
    _userPWD.font = [UIFont systemFontOfSize:17];
    _userPWD.placeholder = @"请输入密码";
    _userPWD.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userPWD.secureTextEntry=YES;
    _userPWD.layer.borderWidth = 1.0;
    _userPWD.layer.cornerRadius = 5.0;
    _userPWD.delegate = self;
    _userPWD.layer.borderColor=[[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0] CGColor];
    [self.customV addSubview:_userPWD];
    
    //login
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, _userPWD.frame.size.height+_userPWD.frame.origin.y+padding, 120, 40);
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [loginBtn addTarget:self action:@selector(onLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customV addSubview:loginBtn];
    
    //cancel
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(150, _userPWD.frame.size.height+_userPWD.frame.origin.y+padding, 120, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customV addSubview:cancelBtn];
    
    UIButton *loseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loseBtn.frame = CGRectMake(170, cancelBtn.frame.size.height+cancelBtn.frame.origin.y+padding, 100, 40);
    [loseBtn setTitle:@"忘记密码>>" forState:UIControlStateNormal];
    [loseBtn setTitleColor:[UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
    loseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [loseBtn addTarget:self action:@selector(onLoseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customV addSubview:loseBtn];
    self.customV.bounds = CGRectMake(0, 0, bounds.size.width-40, loseBtn.frame.origin.y+padding+loseBtn.frame.size.height);
}

- (void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (needOffset) {
        self.customV.frame = CGRectMake(self.customV.frame.origin.x, self.customV.frame.origin.y-100, self.customV.frame.size.width, self.customV.frame.size.height);
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
        self.customV.frame = CGRectMake(self.customV.frame.origin.x, self.customV.frame.origin.y+100, self.customV.frame.size.width, self.customV.frame.size.height);
        needOffset = YES;
    }
    [_userName resignFirstResponder];
    [_userPWD resignFirstResponder];
}

- (void)onCancelClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissView];
    });
}

//overwrite login func
- (void)onLoginClick
{
    [_userName resignFirstResponder];
    [_userPWD resignFirstResponder];
    NSString *userName = _userName.text;
    NSString *passWd = _userPWD.text;
    BOOL userRet = [IDMPMatch validateMobile:userName];
    BOOL emailRet = [IDMPMatch validateEmail:userName];
    BOOL pwdRet = [IDMPMatch validatePassword:passWd];
    BOOL passIdRet = [IDMPMatch validatePassID:userName];
    if ((!userRet&&!emailRet&&!passIdRet)&&pwdRet) {
        if ([userName isEqual:@""]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"用户名不能为空"
//                                                           delegate:self cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
            NSDictionary *result = @{@"resultCode":@"102303"};
            self.callFailBlock(result);
            return;
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"用户名错误"
//                                                       delegate:self cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        NSDictionary *result = @{@"resultCode":@"102307"};
        self.callFailBlock(result);
        return;
    }else if ((userRet||emailRet||passIdRet)&&!pwdRet){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"密码错误"
//                                                       delegate:self cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        NSDictionary *result = @{@"resultCode":@"102311"};
        self.callFailBlock(result);
        return;
    }else if ((!userRet&&!emailRet&&!passIdRet)&&!pwdRet){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"用户名和密码错误"
//                                                       delegate:self cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
        NSDictionary *result = @{@"resultCode":@"102312"};
        self.callFailBlock(result);
        return;
    }
    __block IDMPLoadingView *loadingV;
    dispatch_async(dispatch_get_main_queue(), ^{
        loadingV = [[IDMPLoadingView alloc]init];
        [loadingV showInView:self.view];
    });
    IDMPUPMode *UP=[[IDMPUPMode alloc] init];
    [UP getUPKSByUserName:userName andPassWd:passWd successBlock:
     ^(NSDictionary *response){
         //退回到第一个窗口
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadingV dismissView];
             [self dismissView];
         });
         if (self.callBlock) {
             self.callBlock(response);
         }
     }
    failBlock:
     ^(NSDictionary *UPFail){
         if (self.callFailBlock) {
             self.callFailBlock(UPFail);
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [loadingV dismissView];
//             if ([[UPFail objectForKey:@"resultCode"]integerValue] == 103105) {
//                 
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:@"密码错误"
//                                                                delegate:self cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//                 [alert show];
//             }else if([[UPFail objectForKey:@"resultCode"]integerValue] == 103106){
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:@"用户名错误"
//                                                                delegate:self cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//                 [alert show];
//             }else
//             if ([[UPFail objectForKey:@"resultCode"]integerValue] == 103212) {
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:@"用户名或密码错误"
//                                                                delegate:self cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//                 [alert show];
//
//             }else if ([[UPFail objectForKey:@"resultCode"]integerValue] == 103103 ||[[UPFail objectForKey:@"resultCode"]integerValue] == 103118){
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:@"用户不存在"
//                                                                delegate:self cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//                 [alert show];
//             }else if ([[UPFail objectForKey:@"resultCode"]integerValue] == 102102)
//             {
//
//                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:[NSString stringWithFormat:@"网络超时"]
//                                                                delegate:self cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//                 [alert show];
//             }
         });
         
         NSLog(@"fail");
     }];
}


//overwrite losepassword func
- (void)onLoseClick
{
    IDMPTempSmsViewController *autoController = [[IDMPTempSmsViewController alloc]init];
    [autoController showInView:self callBackBlock:self.callBlock callFailBlock:self.callFailBlock];
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"%@",NSStringFromCGRect(_backView.superview.frame));
//        [self dismissView];
        [self.customV removeFromSuperview];
    });
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
