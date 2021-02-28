//
//  HLWebViewController.m
//  HYZBLive
//
//  Created by 徐培帅 on 2017/7/17.
//  Copyright © 2017年  . All rights reserved.
//

#import "HLWebViewController.h"
#import <WebKit/WebKit.h>

@interface HLWebViewController ()<WKNavigationDelegate,NSURLSessionDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

@property(nonatomic, strong) NSDate * startDate;

@end

@implementation HLWebViewController

- (instancetype)initWithUrl:(NSString *)url {
    
    self = [super init];
    
    if (self) {
        
        self.url = url;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self showFSNavigationBar];
//    [self.navigationBar setTitle:_titleStr];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,user-scalable = no'); document.getElementsByTagName('head')[0].appendChild(meta);document.documentElement.style.webkitUserSelect='none';document.documentElement.style.webkitTouchCallout='none';";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 65, 400, 500) configuration:wkWebConfig];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.center = self.view.center;
    self.indicatorView.color = [UIColor orangeColor];
    [self.view addSubview:self.indicatorView];
    
    
    if (_type == 1) {
        //添加活动用的js事件
//        self.navigationBar.hidden = YES;
        self.view.backgroundColor = [UIColor clearColor];
        self.webView.backgroundColor = [UIColor clearColor];
        [self.webView setOpaque:NO];
        self.browserHeadDisplay = NO;
    }
}


-(void)setUrl:(NSString *)url {
    
    _url = url;
    if (_url) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
        
    }
}

- (void)setHtml:(NSString *)html {
    _html = html;
    
    NSString *header = @"<!DOCTYPE html><html><head><meta charset=\"utf-8\" /><title></title></head>";
    NSString *js = @"</html>";
    NSString *newStr = [header stringByAppendingString:html];
    newStr = [newStr stringByAppendingString:js];
    
    [self.webView loadHTMLString:newStr baseURL:nil];
}

- (void)setTitleStr:(NSString *)titleStr {
    
    _titleStr = titleStr;
    
    if (titleStr && self.navigationController) {
        
//        [self.navigationBar setTitle:_titleStr];
    }
}


- (void)setBrowserHeadDisplay:(BOOL)browserHeadDisplay {
    
    _browserHeadDisplay = browserHeadDisplay;
    
    if (browserHeadDisplay) {
        
        _webView.frame = CGRectMake(0, 65, 400, 500);
    }
    else {
        
        _webView.frame = CGRectMake(0, 65, 400, 500);
    }
}

#pragma mark - Button event
//返回
-(void)backEvent {
    
    if (_webView.canGoBack) {
        [_webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//关闭
- (void)closeEvent {
    
    if (_type == 1) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - webView delegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView Url === %@",webView.URL.description);
    if (_type < 3) {
        [self.indicatorView startAnimating];
    }
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self.indicatorView stopAnimating];
    
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        
        if (!weakSelf.titleStr) {
            weakSelf.titleStr = title;
        }
    }];
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [self.indicatorView stopAnimating];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"----------------------weiview----dealloc--");
    [_webView setNavigationDelegate:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webView setNavigationDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


@end
