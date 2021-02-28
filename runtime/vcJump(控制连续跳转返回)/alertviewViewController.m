//
//  alertviewViewController.m
//  testbutton
//
//  Created by 大碗豆 on 17/4/13.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "alertviewViewController.h"
#import "towViewController.h"


@interface alertviewViewController ()

@end

@implementation alertviewViewController


- (UIView *)viewimage{
    if (!_viewimage) {
        _viewimage = [UIView new];
        
        _viewimage.backgroundColor = [UIColor redColor];
        
        _viewimage.frame = CGRectMake(0, STATUS_NAV_HEIGHT, 100, 100);
    }
    
    return _viewimage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.viewimage];
    
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 100, 200, 50);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.text = @"123";
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(actionBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

- (void)actionBtn{
    
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"结果反馈" message:@"成功" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    
//    [alertController addAction:cancle];
//
    towViewController *vc = [towViewController new];
    
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//限制输入小数点后一位数
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // _textFiledM1  项目中的tf控件
//    if (textField == textField) {
        
        // 1 不能直接输入小数点
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )  return NO;
        
        
        // 2 输入框第一个字符为“0”时候，第二个字符如果不是“.”,那么文本框内的显示内容就是新输入的字符[textField.text length] == 1  防止例如0.5会变成5
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && [textField.text length] == 1 && ![string isEqualToString:@"."]){
            textField.text = string;
            return NO;
        }
        
        // 3 保留两位小数
        NSUInteger remain = 1;
        NSRange pointRange = [textField.text rangeOfString:@"."];
        
        // 拼接输入的最后一个字符
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        
        // 输入框内存在小数点， 不让再次输入“.” 或者 总长度-包括小数点之前的长度>remain 就不能再输入任何字符
        if(pointRange.length > 0 &&([string isEqualToString:@"."] || strlen - (pointRange.location + 1) > remain))
            return NO;
        
        // 4 小数点已经存在情况下可以输入的字符集  and 小数点还不存在情况下可以输入的字符集
        NSCharacterSet *numbers = (pointRange.length > 0)?[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] : [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        
        NSScanner *scanner = [NSScanner scannerWithString:string];
        NSString *buffer;
        // 判断string在不在numbers的字符集合内
        BOOL scan = [scanner scanCharactersFromSet:numbers intoString:&buffer];
        
        if ( !scan && ([string length] != 0) )  // 包括输入空格scan为NO， 点击删除键[string length]为0
        {
            return NO;
        }
//    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
