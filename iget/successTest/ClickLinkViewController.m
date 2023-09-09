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

@property(nonatomic,strong) UILabel *label1;
@property(nonatomic,strong) UILabel *label2;
@property(nonatomic,strong) UILabel *label3;
@property(nonatomic,strong) UILabel *label4;
@property(nonatomic,strong) UILabel *label5;
@property(nonatomic,strong) UILabel *label6;
@property(nonatomic,strong) NSString *testString;

@end

@implementation ClickLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
//    NSString *webString = @"这不是网址\"http://www.baidu.com\"这是我大百度帝国";
//    NSString *webString = @"这不是网址\"http://m.weibo.cn/2014433131/4629845684786036\"这是我大百度帝国";
//
//    [self needHightText:webString];
    
    
    self.testString = @"jkf测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本";
//    self.testString = @"juxtaposedjuxtaposedjuxtaposedjuxtaposedjuxtaposedjuxtaposedjuxtaposedjuxtaposed";
    

         [self.view addSubview:self.label1];
         [self.view addSubview:self.label2];
        [self.view addSubview:self.label3];
        [self.view addSubview:self.label4];
        [self.view addSubview:self.label5];
        [self.view addSubview:self.label6];
    
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

-(UILabel *)label1
{
    if (!_label1) {
        _label1 = [[UILabel alloc]init];

        _label1.backgroundColor = [UIColor greenColor];

        _label1.textColor = [UIColor blackColor];

        _label1.numberOfLines = 0;

        _label1.text = self.testString;

//        _label1.lineBreakMode = NSLineBreakByWordWrapping;
//        _label1.lineBreakMode = NSLineBreakByTruncatingTail;

        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};

        CGRect rect = [_label1.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];

        NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

        _label1.frame = (CGRect){{100, 100}, rect.size};
        if (rect.size.height > 61) {

            _label1.numberOfLines = 3;

            _label1.frame = (CGRect){{100, 100}, {rect.size.width, 60.862}};

        }
//        [_label1 sizeToFit];
    }
    return _label1;
}

-(UILabel *)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc]init];

        _label2.backgroundColor = [UIColor greenColor];

        _label2.textColor = [UIColor blackColor];

        _label2.numberOfLines = 0;

        _label2.text = self.testString;

//        _label2.lineBreakMode = NSLineBreakByCharWrapping;
//        _label2.lineBreakMode = NSLineBreakByTruncatingTail;

        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};

        CGRect rect = [_label2.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];

        NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

        _label2.frame = (CGRect){{100, 180}, rect.size};
        if (rect.size.height > 61) {

            _label2.numberOfLines = 3;

            _label2.frame = (CGRect){{100, 180}, {rect.size.width, 60.862}};

        }
//        [_label2 sizeToFit];
    }
    return _label2;
}

-(UILabel *)label3
{
    if (!_label3) {
        _label3 = [[UILabel alloc]init];

        _label3.backgroundColor = [UIColor greenColor];

        _label3.textColor = [UIColor blackColor];

        _label3.numberOfLines = 0;

        _label3.text = self.testString;

//        _label3.lineBreakMode = NSLineBreakByClipping;
        _label3.lineBreakMode = NSLineBreakByTruncatingTail;

        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};

        CGRect rect = [_label3.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];

        NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

        _label3.frame = (CGRect){{100, 260}, rect.size};
        if (rect.size.height > 61) {

            _label3.numberOfLines = 3;

            _label3.frame = (CGRect){{100, 260}, {rect.size.width, 60.862}};

        }
//        [_label3 sizeToFit];
    }
    return _label3;
}

-(UILabel *)label4
{
    if (!_label4) {
        _label4 = [[UILabel alloc]init];

        _label4.backgroundColor = [UIColor greenColor];

        _label4.textColor = [UIColor blackColor];

        _label4.numberOfLines = 0;

        _label4.text = self.testString;

//        _label4.lineBreakMode = NSLineBreakByTruncatingHead;
        _label4.lineBreakMode = NSLineBreakByTruncatingTail;

        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};

        CGRect rect = [_label4.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];

        NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

        _label4.frame = (CGRect){{100, 340}, rect.size};
        if (rect.size.height > 61) {

            _label4.numberOfLines = 3;

            _label4.frame = (CGRect){{100, 340}, {rect.size.width, 60.862}};

        }
//        [_label4 sizeToFit];
    }
    return _label4;
}

-(UILabel *)label5
{
    if (!_label5) {
        _label5 = [[UILabel alloc]init];

        _label5.backgroundColor = [UIColor greenColor];

        _label5.textColor = [UIColor blackColor];

        _label5.numberOfLines = 0;

        _label5.text = self.testString;

        _label5.lineBreakMode = NSLineBreakByTruncatingTail;
    

        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};

        CGRect rect = [_label5.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];

        NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

        _label5.frame = (CGRect){{100, 420}, rect.size};
        if (rect.size.height > 61) {

            _label5.numberOfLines = 3;

            _label5.frame = (CGRect){{100, 420}, {rect.size.width, 60.862}};

        }
//        [_label5 sizeToFit];
    }
    return _label5;
}

-(UILabel *)label6
{
    if (!_label6) {
        _label6 = [[UILabel alloc]init];

        _label6.backgroundColor = [UIColor greenColor];

        _label6.textColor = [UIColor blackColor];

        _label6.numberOfLines = 0;

        _label6.text = self.testString;

//        _label6.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _label6.lineBreakMode = NSLineBreakByTruncatingTail;

        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};

        CGRect rect = [_label6.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT)  options:nil attributes:attributes context:nil];

        NSLog(@"%f-----%f", rect.size.width,  rect.size.height);

        _label6.frame = (CGRect){{100, 500}, rect.size};
        if (rect.size.height > 61) {

            _label6.numberOfLines = 3;

            _label6.frame = (CGRect){{100, 500}, {rect.size.width, 60.862}};

        }
//        [_label6 sizeToFit];
    }
    return _label6;
}
@end
