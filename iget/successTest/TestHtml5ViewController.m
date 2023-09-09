//
//  TestHtml5ViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/2/18.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestHtml5ViewController.h"
#import <WebKit/WebKit.h>

@interface TestHtml5ViewController ()

@end

@implementation TestHtml5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"H5测试";
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:[self agreementWebview]];
}

- (WKWebView *)agreementWebview
{
    WKWebView* webview = [[WKWebView alloc] initWithFrame:self.view.frame];
    webview.backgroundColor  = [UIColor greenColor];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webview loadHTMLString:htmlString baseURL:[NSURL URLWithString:nil]];

    
    return webview;
}

@end
