//
//  ViewController.m
//  IDMPSDK-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-19.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
//@property (strong, nonatomic) IBOutlet UILabel *loginStatus;
@end

@implementation ViewController
static ViewController *g_vc = nil;
+ (instancetype)share
{
    if (g_vc == nil) {
        g_vc = [[ViewController alloc]init];
    }
    return g_vc;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    [webBtn setTitle:@"web" forState:UIControlStateNormal];
    webBtn.center = CGPointMake(w/2, h/6);
    webBtn.bounds = CGRectMake(0, 0, 200, 40);
    [webBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:webBtn];
    UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [middleBtn setTitle:@"中间件登陆" forState:UIControlStateNormal];
    middleBtn.center = CGPointMake(w/2, h/3);
    middleBtn.bounds = CGRectMake(0, 0, 200, 40);
    [middleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(onMiddleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middleBtn];
    self.loginStatus = [[UILabel alloc]init];
    self.loginStatus.center = CGPointMake(w/2, h/2);
    self.loginStatus.bounds = CGRectMake(0, 0, 200, 40);
    self.loginStatus.numberOfLines = 0;
    self.loginStatus.text = @"未登录";
    [self.view addSubview:self.loginStatus];
}

- (void)changeLoginStatus
{
    _loginStatus.text = self.labName;
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    CGSize size = CGSizeMake(200,2000);
    _loginStatus.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize labelsize = [_loginStatus.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    _loginStatus.frame = CGRectMake(_loginStatus.frame.origin.x, _loginStatus.frame.origin.y, labelsize.width, labelsize.height);
}


- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLoginStatus) name:@"ChangeLoginStatus" object:nil];
    NSLog(@"appear");
    _loginStatus.text = self.labName;
    NSLog(@"%@",NSStringFromCGRect(self.loginStatus.frame));
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    CGSize size = CGSizeMake(200,2000);
    _loginStatus.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize labelsize = [_loginStatus.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    _loginStatus.frame = CGRectMake(_loginStatus.frame.origin.x, _loginStatus.frame.origin.y, labelsize.width, labelsize.height);
    NSLog(@"%@",NSStringFromCGRect(self.loginStatus.frame));

}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"disappear");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ChangeLoginStatus" object:nil];
}


//- (IBAction)middlewareLogin:(UIButton *)sender
- (void)onMiddleBtnClick
{
    NSString *customURL =[self searchURLForLoginService];
    if (customURL)
    {
        NSString *url=[NSString stringWithFormat:@"%@%@" ,customURL,@"?scheme=IDMPSDK,isSip=1"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        NSString *labelText = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//        _loginStatus.text=labelText;

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法找到安装中间件应用"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
 
    }
    
    

}

-(NSString*)searchURLForLoginService
{
    
    UIPasteboard *urlschemePasteBoard = [UIPasteboard pasteboardWithName:@"com.cmcc.idmp.urlschemeList" create:NO];
    NSLog(@"URLInPasteBoard: %@",[urlschemePasteBoard URLs]);
    for(int i=0;i<[urlschemePasteBoard.strings count];i++)
    {
        NSString *urlscheme=[[urlschemePasteBoard strings] objectAtIndex:i];
        if (urlscheme)
        {
            return urlscheme;
        }
        else
        {
            NSMutableArray *mutableURL=[urlschemePasteBoard.strings mutableCopy];
            [mutableURL removeObjectAtIndex:i];
            urlschemePasteBoard.strings=mutableURL;
            
        }
    }
    return [NSString stringWithFormat:@"NULL"];
}


@end
