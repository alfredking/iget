//
//  testUIStackViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/7/29.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testUIStackViewController.h"

@interface testUIStackViewController ()
@property (nonatomic, strong) UIStackView *verticalStackView;
@end

@implementation testUIStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        [self.view addSubview:self.verticalStackView];
        self.verticalStackView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    for (int i =0; i<3; i++) {
        UIButton *btn = [self textBtn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"第%d个选项",i] forState:UIControlStateNormal];
        [self.verticalStackView addArrangedSubview:btn];
    }
    
    [self.verticalStackView layoutIfNeeded];

}



- (UIButton *)textBtn{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor= [[UIColor redColor] colorWithAlphaComponent:0.1];
    return btn;
}

- (UIStackView *)verticalStackView {
    if (!_verticalStackView) {
        _verticalStackView = [[UIStackView alloc] init];
        _verticalStackView.axis = UILayoutConstraintAxisVertical;
        _verticalStackView.distribution = UIStackViewDistributionFillEqually;
        _verticalStackView.spacing = 10;
        _verticalStackView.alignment = UIStackViewAlignmentFill;
        _verticalStackView.backgroundColor = [UIColor yellowColor];
    }
    return _verticalStackView;
}

-(void)btnClicked:(UIButton*)sender
{
    NSLog(@"sender tag is %ld",(long)sender.tag);
}

@end
