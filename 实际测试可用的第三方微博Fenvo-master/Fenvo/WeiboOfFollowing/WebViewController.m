//
//  WebViewController.m
//  Fenvo
//
//  Created by Caesar on 15/5/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WebViewController.h"
#import "KVNProgress.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()
{
    WKWebView *_webView;
    NSString *_linkAdr;
    UIActivityIndicatorView *_activityIndicatorView;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    // Do any additional setup after loading the view.
}

- (void)initWithLink:(NSString *)linkAdr {
    self.view.backgroundColor = [UIColor greenColor];
    _webView = [[WKWebView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _webView.backgroundColor = [UIColor greenColor];
//    _webView.scalesPageToFit = YES;
    _webView.opaque = YES;
    _webView.userInteractionEnabled = YES;
//    _webView.delegate = self;
    [self.view addSubview:_webView];
//    [self.navigationController.view addSubview:_webView];
    
//    _activityIndicatorView = [[UIActivityIndicatorView alloc]
//                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    _activityIndicatorView.center = CGPointMake(self.view.center.x, self.view.center.y);
//    [self.navigationController.view addSubview:_activityIndicatorView];
//    [_activityIndicatorView startAnimating];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:linkAdr]];
    [_webView loadRequest:request];
    
    //Set KVNProgress
//    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
//    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30.0f];
//    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
//    configuration.circleSize = 110.0f;
//    configuration.lineWidth = 1.0f;
//    configuration.fullScreen = YES;
//    configuration.allowUserInteraction = YES;
//
//    [KVNProgress setConfiguration:configuration];
//
//    //show progress
//    [KVNProgress showWithStatus:@"Loading..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
