//
//  IDMPReAuthViewController.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/19.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPReAuthViewController.h"
#import "UIColor+Hex.h"
#import "IDMPDevice.h"
#import "IDMPConst.h"
#import "userInfoStorage.h"
#import "IDMPRSA_Sign_Verify.h"
#import "IDMPHttpRequest.h"
#import "IDMPAES128.h"
#import "IDMPValidateCodeView.h"
#import "IDMPAlertView.h"
#import "IDMPValidateCodeNaviView.h"
#import "IDMPScreen.h"

@interface IDMPReAuthViewController ()

@property (nonatomic, strong) UILabel *loginUserLbl;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) NSString *userName;       //用于验证
@property (nonatomic, strong) NSString *fakeUserName;   //用于显示
@property (nonatomic, strong) IDMPValidateCodeView *validateCodeView;
@property (nonatomic, strong) IDMPValidateCodeNaviView *naviView;
@property (nonatomic, strong) IDMPAlertView *alertView;
@property (nonatomic, strong) UILabel *tintLbl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *clientVersion;
@property (nonatomic, strong) NSString *authorization;


@end

@implementation IDMPReAuthViewController

#pragma mark - setAuthType
- (void)setAuthType:(IDMPReAuthType)authType {
    _authType = authType;
    switch (authType) {
        case IDMPReAuthSetCode:
        {
            self.url = secCodeManageUrl;
            self.clientVersion = SSCclientversion;
            self.authorization = ksSecCodeManage;
            [self.naviView setNaviTitle:@"请设置统一认证安全码"];
            self.tintLbl.hidden = NO;
            self.forgetBtn.hidden = YES;
        }
            break;
        case IDMPReAuthValidateCode:
        {
            self.url = reAuthReqUrl;
            self.clientVersion = SCclientversion;
            self.authorization = ksReAuthorization;
            [self.naviView setNaviTitle:@"请输入统一认证安全码"];
            self.tintLbl.hidden = YES;
            self.forgetBtn.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setForgetPwdDesc:(NSString *)forgetPwdDesc {
    _forgetPwdDesc = forgetPwdDesc;
}

#pragma mark - life cycle
- (instancetype)initWithUserName:(NSString *)userName{
    if (self = [super init]) {
        if (![userName containsString:@"@"]) {
            NSUInteger length = userName.length;
            self.fakeUserName = [userName stringByReplacingCharactersInRange:NSMakeRange(length - 8, 4) withString:@"****"];
        } else {
            self.fakeUserName = userName;
        }
        self.userName = userName;
        NSLog(@"%@ reauthvc init",self);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc idmpreauthvc", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - reAuth

//查询二次鉴权密码状态
- (void)requestReAuthStatusWithUsername:(NSString *)userName successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    if (!userName) {
        failBlock(@{@"resultCode":@"102303"});
        return;
    }
    NSString *version = [IDMPDevice getAppVersion];
    NSString *sourceID = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
    if(!sourceID) {
        if (failBlock) {
            NSDictionary *result = @{@"resultCode":@"102298"};
            failBlock(result);
        }
        return;
    }
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", QSCclientversion,version,sdkversion,sdkversionValue,@"appid",appidString,sourceIdsk,sourceID,@"apptype",@"5",ksIOS_ID,[IDMPDevice getDeviceID],@"username",userName];
    NSString *signature = secRSA_EVP_Sign(authorization);
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,ksReAuthStatus,signature,ksSignature,RC_data,kRC_data, nil];
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:reAuthStatusReqUrl timeOut:20 successBlock:^(NSDictionary *parameters){
        successBlock(parameters);
    } failBlock:^(NSDictionary *parameters){
        failBlock(parameters);
    }];
    
}

//二次鉴权密码
- (void)reAuthWithUserName:(NSString *)userName code:(NSString *)code successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock {
    NSString *version = [IDMPDevice getAppVersion];
    NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:self.userName];
//    NSLog(@"user is %@",user);
    NSString *btid = [user objectForKey:ksBTID];
    NSString *ks = [user objectForKey:@"KS"];
    ks = [ks substringToIndex:16];
    NSData *encryCodeData = [IDMPAES128 AESEncryptWithKey:ks andString:code];
    NSString *encryCode = [IDMPAES128 base64EncodingWithData:encryCodeData];
//    NSString *sourceID = (NSString *)[userInfoStorage getInfoWithKey:sourceIdsk];
    NSString *authorization = [NSString stringWithFormat:@"%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\",%@=\"%@\"", self.clientVersion,version, @"btid",btid,@"seccode",encryCode,sdkversion,sdkversionValue,@"appid",appidString,@"apptype",@"5",ksIOS_ID,[IDMPDevice getDeviceID],@"username",userName];
    NSString *signature = secRSA_EVP_Sign(authorization);
    NSString *RC_data = [IDMPDevice getLocalUserDeviceData];
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:authorization,self.authorization,signature,ksSignature,RC_data,kRC_data, nil];
    IDMPHttpRequest *__block request = [[IDMPHttpRequest alloc]init];
    [request getAsynWithHeads:heads url:self.url timeOut:20 successBlock:^(NSDictionary *parameters){
        successBlock(parameters);
    } failBlock:^(NSDictionary *parameters){
        failBlock(parameters);
    }];
}

- (void)alertWithParam:(NSDictionary *)parameters {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger resultCode = [parameters[@"resultCode"] integerValue];
        switch (resultCode) {
            case 103000:
                if (self.authType == IDMPReAuthValidateCode) {
                    [self.alertView setMessage:@"验证成功" alertType: IDMPPopupAlertSuccess alertWidth:IDMPAlertWidthShort];
                } else {
                    [self.alertView setMessage:@"设置成功" alertType: IDMPPopupAlertSuccess alertWidth:IDMPAlertWidthShort];
                }
                break;
            case 103153:
                [self.alertView setMessage:@"安全码错误" alertType: IDMPPopupAlertError alertWidth:IDMPAlertWidthShort];
                break;
            case 103154:
                [self.alertView setMessage:@"操作频繁，请稍后再试" alertType: IDMPPopupAlertWarn alertWidth:IDMPAlertWidthLong];
                break;
            case 0:
                [self.alertView setMessage:@"请检查网络连接" alertType: IDMPPopupAlertWarn alertWidth:IDMPAlertWidthShort];
                break;
            default:
                [self.alertView setMessage:@"服务异常，请稍后再试" alertType: IDMPPopupAlertError alertWidth:IDMPAlertWidthLong];
                break;
        }
        
        if (resultCode != 103000) {
            [self.validateCodeView clearText];
        }
        self.alertView.alpha = 1.0;
        [UIView animateWithDuration:0.1 delay:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.alertView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (resultCode == 103000) {
                [self.view endEditing:YES];
                self.returnBlcok(parameters);
            }
        }];
    });
}

#pragma mark - forget pwd
- (void)forgetPwd {
//    self.returnBlcok(@{@"result":@"forgetPwd"});
    if(self.forgetPwdDesc) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.forgetPwdDesc]];
    }
}

#pragma mark - lazy load
- (IDMPValidateCodeNaviView *)naviView {
    if (!_naviView) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
            IDMPValidateCodeNaviView *naviView = [IDMPValidateCodeNaviView new];
            __weak __typeof__(self) weakSelf = self;
            naviView.closeBlcok = ^{
                __strong __typeof(self) strongSelf = weakSelf;
                strongSelf.returnBlcok(nil);
            };
            _naviView = naviView;
//        });
    }
    return _naviView;
}

- (UILabel *)loginUserLbl {
    if (!_loginUserLbl) {
        UILabel *loginUserLbl = [UILabel new];
        loginUserLbl.text = [NSString stringWithFormat:@"登录用户：%@",self.fakeUserName];
        loginUserLbl.font = [UIFont systemFontOfSize:15.0];
        loginUserLbl.textColor = [UIColor colorWithHex:0xa6a6a6];
        _loginUserLbl = loginUserLbl;
    }
    return _loginUserLbl;
}

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
            UIButton *forgetBtn =  [UIButton new];
            [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
            [forgetBtn setTitleColor:[UIColor colorWithHex:0x1979bc] forState:UIControlStateNormal];
            forgetBtn.hidden = YES;
            [forgetBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
            _forgetBtn = forgetBtn;
//        });
    }
    return _forgetBtn;
}

- (IDMPValidateCodeView *)validateCodeView {
    if (!_validateCodeView) {
        IDMPValidateCodeView *validateCodeView = [IDMPValidateCodeView new];
        __weak __typeof__(self) weakSelf = self;
        validateCodeView.endEditBlcok = ^(NSString *text) {
            [weakSelf reAuthWithUserName:weakSelf.userName code:text successBlock:^(NSDictionary *paraments) {
                [weakSelf alertWithParam:paraments];
            } failBlock:^(NSDictionary *paraments) {
                NSLog(@"reauth result is %@",paraments);
                [weakSelf alertWithParam:paraments];
                
           }];
                
        };
        _validateCodeView = validateCodeView;
    }
    return _validateCodeView;
}

- (IDMPAlertView *)alertView {
    if (!_alertView) {
        IDMPAlertView *alertView =  [[IDMPAlertView alloc] initWithMessage:@"安全码错误" alertType:IDMPPopupAlertError];
        alertView.alpha = 0;
        _alertView = alertView;
    }
    return _alertView;
}

- (UILabel *)tintLbl {
    if (!_tintLbl) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
            UILabel *lbl = [UILabel new];
            lbl.text = @"开启安全码二次鉴权，增强隐私数据安全性";
            lbl.textColor = [UIColor colorWithHex:0xa6a6a6];
            lbl.font = [UIFont systemFontOfSize:12.0];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.hidden = YES;
            _tintLbl = lbl;
//        });
    }
    return _tintLbl;
}

- (void)addSubview {
    [self.view addSubview:self.naviView];
    [self.naviView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *naviTop = [NSLayoutConstraint constraintWithItem:self.naviView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *naviLeft = [NSLayoutConstraint constraintWithItem:self.naviView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *naviRight = [NSLayoutConstraint constraintWithItem:self.naviView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *naviHeight = [NSLayoutConstraint constraintWithItem:self.naviView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:52];
    [self.naviView addConstraint:naviHeight];
    [self.view addConstraints:@[naviTop,naviLeft,naviRight]];
    
    
    [self.view addSubview:self.loginUserLbl];
    [self.loginUserLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *loginUserLblCenterX = [NSLayoutConstraint constraintWithItem:self.loginUserLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *loginUserLblTop = [NSLayoutConstraint constraintWithItem:self.loginUserLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.naviView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:16*IDMPWidthScale];
    
    [self.view addConstraints:@[loginUserLblCenterX,loginUserLblTop]];
    
    [self.view addSubview:self.validateCodeView];
    [self.validateCodeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *vcwCenterX = [NSLayoutConstraint constraintWithItem:self.validateCodeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *vcwTop = [NSLayoutConstraint constraintWithItem:self.validateCodeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.loginUserLbl attribute:NSLayoutAttributeBottom multiplier:1.0 constant:24*IDMPWidthScale];
    NSLayoutConstraint *vcwLeft = [NSLayoutConstraint constraintWithItem:self.validateCodeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *vcwHeight = [NSLayoutConstraint constraintWithItem:self.validateCodeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:46*IDMPWidthScale];
    [self.validateCodeView addConstraint:vcwHeight];
    [self.view addConstraints:@[vcwTop,vcwCenterX,vcwLeft]];
    
    [self.view addSubview:self.tintLbl];
    [self.tintLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *tintLblCenterX = [NSLayoutConstraint constraintWithItem:self.tintLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *tintLblTop = [NSLayoutConstraint constraintWithItem:self.tintLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.validateCodeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:22*IDMPWidthScale];
    [self.view addConstraints:@[tintLblCenterX,tintLblTop]];
    
    [self.view addSubview:self.forgetBtn];
    [self.forgetBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *fBtnTop = [NSLayoutConstraint constraintWithItem:self.forgetBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.validateCodeView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15*IDMPWidthScale];
    NSLayoutConstraint *fBtnRight = [NSLayoutConstraint constraintWithItem:self.forgetBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
    [self.view addConstraints:@[fBtnTop,fBtnRight]];
    
    [self.view addSubview:self.alertView];
    [self.alertView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *alertCenterX = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *alertTop = [NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:168.5*IDMPWidthScale];
    [self.view addConstraints:@[alertCenterX,alertTop]];
}


@end


