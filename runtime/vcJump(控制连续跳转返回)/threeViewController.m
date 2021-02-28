//
//  threeViewController.m
//  testbutton
//
//  Created by 大豌豆 on 18/12/20.
//  Copyright © 2018年 大碗豆. All rights reserved.
//

#import "threeViewController.h"

@interface threeViewController ()<UIWebViewDelegate>
@property(nonatomic,copy)UIWebView *webView;

@end

@implementation threeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self addWebView];
}

- (void)addWebView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 600)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.scrollEnabled = YES;
    _webView = webView;
    webView.delegate = self;
    
    NSString *headerStr = @"<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><style type='text/css'>img{max-width: 100%; width:720px!important; height: auto;}table{height: auto!important;width: 100%!important;max-width: 720px!important;margin: 0 auto!important; font-size: 14px!important;color:#151515!important;}tr td{height:28px!important;width:auto!important;margin:0 auto!important;}span{font-size:17px!important;}</style></head>";
    
    NSString *cententStr = @"<p><img src=\"http://47.98.50.57/image-server/advert_photo/DC/61/5617E6A35651BB6C1123BB42632EDC61.jpg\"><br></p>";
    
    NSString *strURL = [NSString stringWithFormat:@"<html>%@<body>%@</body></html>",headerStr,cententStr];
    
    [_webView loadHTMLString:strURL baseURL:nil];
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
