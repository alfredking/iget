//
//  LoginViewController.m
//  Fenvo
//
//  Created by Neil on 15/8/30.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginButton.layer.cornerRadius     = 8.0;
    _loginButton.layer.masksToBounds    = YES;
    
    [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_loginButton addTarget:self action:@selector(requestWBSSOAuthorize) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestWBSSOAuthorize
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI         = kRedirectURI;
    request.scope               = @"all";
    request.userInfo            = @{@"SSO_From": @"AppDelegate",
                                    @"Info": @"Token is not exsit. Request Authorize."};
    [WeiboSDK sendRequest:request];
}

@end
