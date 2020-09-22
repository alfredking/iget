//
//  IDMPCustomUI.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/27.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPCustomUI.h"

@implementation IDMPCustomUI
- (IBAction)onLoginClick:(id)sender {
    NSLog(@"up登陆");
    self.loginBlock();
    [self removeFromSuperview];
}
- (IBAction)getVaild:(id)sender {
    NSLog(@"获取验证码");
    self.getValidBlock();
}
- (IBAction)loginWithVaild:(id)sender {
    NSLog(@"数据短信登陆");
    self.loginWithValidBlock();
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
