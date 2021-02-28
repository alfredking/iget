//
//  runTimeVC.m
//  testbutton
//
//  Created by lmcqc on 2020/11/17.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "runTimeVC.h"
#import <objc/runtime.h>

#import "TestModel.h"

@interface runTimeVC ()
- (void)resolveThisMethodDynamically;
@end

@implementation runTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"点击事件" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)btnAction{
    
    TestModel * model = [[TestModel alloc]init];
    [model testMethod];
    
    //动态方法解析
    [self resolveThisMethodDynamically];
}
 


#pragma --动态方法解析(添加)
void dynamicMethodIMP(id self, SEL _cmd) {
    // implementation ....
    NSLog(@"我他么是备胎");
}
+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
//    resolveThisMethodDynamically btnAction
    if (aSEL == @selector(resolveThisMethodDynamically)) {
          class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
          return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}

@end
