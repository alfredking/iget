//
//  ViewController.m
//  IDMPSDK-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-19.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *loginStatus;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _loginStatus.text=@"未登录";
}


- (IBAction)middlewareLogin:(UIButton *)sender
{
    
      NSString *customURL =[self searchURLForLoginService];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"无法打开"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    NSString *labelText = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    _loginStatus.text=labelText;
    
    

}

-(NSString*)searchURLForLoginService
{
    
    UIPasteboard *urlschemePasteBoard = [UIPasteboard pasteboardWithName:@"com.cmcc.idmp.urlschemeList" create:NO];
    NSLog(@"URLInPasteBoard: %@",[urlschemePasteBoard URLs]);
    for(int i=0;i<[urlschemePasteBoard.strings count];i++)
    {
        NSString *urlscheme=[[urlschemePasteBoard strings] objectAtIndex:i];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: urlscheme]])
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
