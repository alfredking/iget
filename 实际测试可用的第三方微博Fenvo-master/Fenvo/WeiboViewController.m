//
//  ViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"


@interface WeiboViewController ()<WBHttpRequestDelegate>{
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation WeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [ssoButton setTitle:NSLocalizedString(@"请求微博认证（SSO授权）", nil) forState:UIControlStateNormal];
//    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    ssoButton.frame = CGRectMake(20, 90, 280, 40);
//    [self.view addSubview:ssoButton];
    

    
    [self initInterface];
    NSString *OAuthURL = @"https://api.weibo.com/oauth2/authorize?client_id=3151711642&response_type=code&redirect_uri=https://api.weibo.com/oauth2/default.html";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:OAuthURL]];
    [self.loginView setDelegate:self];
    [self.loginView loadRequest:request];
}

- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"ViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)initInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.loginView = [[UIWebView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.scalesPageToFit = YES;
    self.loginView.opaque = YES;
    self.loginView.userInteractionEnabled = YES;
    [self.view addSubview:self.loginView];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
     activityIndicatorView.center=CGPointMake(self.view.center.x,240);
    [self.navigationController.view addSubview:activityIndicatorView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView stopAnimating];
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"%@",url);
    //NSRange rang = NSMakeRange(40, 32);
    if ([url hasPrefix:@"https://api.weibo.com/oauth2/default.html?"]) {
        
        
    //获得code
    NSString *code = [url substringFromIndex:47];
        NSLog(@"%@",code);
        
    NSString *urlTmp = @"https://api.weibo.com/oauth2/access_token?client_id=3151711642&client_secret=a9145449b749ca064e7acbcae7589818&grant_type=authorization_code&redirect_uri=https://api.weibo.com/oauth2/default.html&code=";
        NSString *getTokenUrlString = [urlTmp stringByAppendingString:code];
        NSLog(@"%@",getTokenUrlString);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSDictionary *dict = @{@"format": @"json"};
        
        /////////////////////////////////////////////////////////////////
        ////*********此处请求方式应该设为POST而不应该为GET！！！***********////
        /////////////////////////////////////////////////////////////////
        [manager POST:getTokenUrlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSDictionary *dict;
            NSLog(@"%@",responseObject);
            dict = responseObject;
            self.access_token = dict[@"access_token"];
            NSString *expires_in = dict[@"expires_in"];
            NSString *uid = dict[@"uid"];
            
            NSLog(@"%@\nexpires_in :%@",self.access_token,expires_in);
            NSDictionary *token = [[NSDictionary alloc]init];
            token = @{@"token":self.access_token,@"expires_in":expires_in,@"uid":uid};
            NSLog(@"%@",token);
            //[NSDictionary dictionaryWithObject:self.access_token forKey:@"token"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:@YES userInfo:token];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             NSLog(@"server error.%@",error);
        }];

    }
}
-(void) webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    
}

#pragma WBHttpRequestDelegate

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}


@end
