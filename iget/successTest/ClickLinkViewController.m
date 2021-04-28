//
//  ClickLinkViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/4/24.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "ClickLinkViewController.h"
#import <YYText/YYText.h>
#import <WebKit/WebKit.h>
@interface ClickLinkViewController ()

@end

@implementation ClickLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
//    NSString *webString = @"这不是网址\"http://www.baidu.com\"这是我大百度帝国";
    NSString *webString = @"这不是网址\"http://m.weibo.cn/2014433131/4629845684786036\"这是我大百度帝国";

    [self needHightText:webString];
}

- (void)needHightText:(NSString *)wholeText {

//    点击事件用的YYLabel框架，
    YYLabel *mainLabel = [[YYLabel alloc]initWithFrame:CGRectMake(0, 100, 400, 100)];
    [self.view addSubview:mainLabel];
    
    mainLabel.numberOfLines = 0;
    mainLabel.textColor = [UIColor purpleColor];//紫色的。
//    mainLabel.textColor = [UIColor greenColor];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:wholeText];
    text.yy_font = [UIFont systemFontOfSize:17];
    NSError *error;
    NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arrayOfAllMatches=[dataDetector matchesInString:wholeText options:NSMatchingReportProgress range:NSMakeRange(0, wholeText.length)];
    //NSMatchingOptions匹配方式也有好多种，我选择NSMatchingReportProgress，一直匹配
    
    //我们得到一个数组，这个数组中NSTextCheckingResult元素中包含我们要找的URL的range，当然可能找到多个URL，找到相应的URL的位置，用YYlabel的高亮点击事件处理跳转网页
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSLog(@"%@",NSStringFromRange(match.range));
        NSLog(@"match is %@",match);
        [text yy_setTextHighlightRange:match.range//设置点击的位置
                                 color:[UIColor orangeColor]
                       backgroundColor:[UIColor whiteColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 NSLog(@"这里是点击事件");
                                  //跳转用的WKWebView
                                 WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
                                 [self.view addSubview:webView];
                                 [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[wholeText substringWithRange:match.range]]]];
                                 
                             }];
    }
    mainLabel.attributedText = text;
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
