//
//  ANPopoverVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "ANPopoverVC.h"
#import "EFButton.h"
#import "ANPopoverView.h"

@interface ANPopoverVC ()

@end

@implementation ANPopoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EFButton *btn = [EFButton new];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 600, 140, 60);
    btn.center = self.view.center;
    [btn setTitle:@"弹窗提示" forState:(UIControlStateNormal)];
//    [btn setImage:[UIImage imageNamed:@"qwas.png"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(popoverView:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)popoverView:(UIButton *)btn{
    ANPopoverView *popoverView = [ANPopoverView popoverView];
    [popoverView showToView:btn withActions:@"只有初恋般的热情和宗教般的意志，人才有可能成就某种事业。 尽管创造的过程无比艰辛而成功的结果无比荣耀；尽管一切艰辛都是为了成功，但是，人生最大的幸福也许在于创造的过程，而不在于那个结果。 读书如果不是一种消遣，那是相当熬人的，就像长时间不间断地游泳，使人精疲力竭，有一种随时溺没的感觉。"];
}

@end
