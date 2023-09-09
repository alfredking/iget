//
//  TestEdgeInsetsViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/11/16.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestEdgeInsetsViewController.h"

@interface TestEdgeInsetsViewController ()

@end

@implementation TestEdgeInsetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton1];
}

-(void)createButton1{
     UIFont *t_f =  [UIFont fontWithName:@"PingFangSC-Medium" size:13];
         NSString *t_t1 =  @"退出";
         UIButton *cancelBut = [[UIButton alloc] init];
    cancelBut.frame = CGRectMake(20, 100, 220, 40);
   cancelBut.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
   [cancelBut setTitle:t_t1 forState:UIControlStateNormal];
    cancelBut.titleLabel.font = t_f;
    cancelBut.titleLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:cancelBut];
    CGFloat conw =  cancelBut.titleLabel.intrinsicContentSize.width;
    CGFloat ml = cancelBut.frame.size.width - conw;
    [cancelBut setTitleEdgeInsets:UIEdgeInsetsMake(0, ml, 0, 0)];

//    [cancelBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
//    [cancelBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
//    [cancelBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];

    NSLog(@"EdgeInsets = %@",NSStringFromUIEdgeInsets(cancelBut.titleEdgeInsets));
    
    [cancelBut addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

/// 结果输出  EdgeInsets={0, 0, 0, 0}

-(void)changeScreen:(id)sender
{
    if (@available(iOS 13.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array[0];
        UIWindowSceneGeometryPreferencesIOS *geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:@(UIInterfaceOrientationMaskLandscapeLeft)];
        [ws requestGeometryUpdateWithPreferences:geometryPreferences
                                       errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"-----> 旋转错误:%@", error);
        }];
    } else {
        // Fallback on earlier versions
    }
    
}


- (void)dealloc{
    NSLog(@"dealloc");
}

@end
