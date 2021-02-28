//
//  LicensePlateVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "LicensePlateVC.h"
#import "LicensePlateView.h"

@interface LicensePlateVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UITextField * plateTextField;

@end

@implementation LicensePlateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self plateNumber];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tapGesture.numberOfTouchesRequired=1;
    tapGesture.numberOfTapsRequired=1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark 车牌号输入
- (void)plateNumber{
    _plateTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, kScreenWidth-60, 50)];
    _plateTextField.delegate = self;
    _plateTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _plateTextField.layer.borderWidth = 1;
    _plateTextField.keyboardType = UIKeyboardTypeNumberPad;//设置数字键盘防止复制粘贴板自动加空格
    
    LicensePlateView *carView = [LicensePlateView initFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (([UIScreen mainScreen].bounds.size.height) / 568) *180) OriginalString:_plateTextField.text block:^(NSString *str) {
        NSLog(@"str = %@",str);
        self.plateTextField.text = str;
        if (str.length == 8) {
            [self.plateTextField resignFirstResponder];
        }
    }];
    carView.backgroundColor = [UIColor whiteColor];
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (([UIScreen mainScreen].bounds.size.height) / 568) *180)];
    inputView.backgroundColor = [UIColor greenColor];
    [inputView addSubview:carView];
    self.plateTextField.inputView = inputView;
    [self.view addSubview:_plateTextField];
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [tap.view endEditing:YES];
}

@end
