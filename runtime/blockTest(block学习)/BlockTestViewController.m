//
//  BlockTestViewController.m
//  testbutton
//
//  Created by lmcqc on 2020/11/11.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "BlockTestViewController.h"



@interface CaculateMaker : NSObject

@property (nonatomic, assign) CGFloat result;

- (CaculateMaker *(^)(CGFloat num))add;

@end

@implementation CaculateMaker

//链式编程思想：核心思想为将block作为方法的返回值，且返回值的类型为调用者本身，并将该方法以setter的形式返回，这样就可以实现了连续调用，即为链式编程。
- (CaculateMaker *(^)(CGFloat num))add;{
    return ^CaculateMaker *(CGFloat num){
        self->_result += num;
        return self;
    };
}

@end


static NSInteger num3 = 300;
NSInteger num4 = 3000;

@interface BlockTestViewController ()

@end

@implementation BlockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"点击事件" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}
- (void)btnAction{
    NSLog(@"self ' class is %@", [self class]);
    NSLog(@"super' class is %@", [super class]);
    

    
//    1、局部变量截获 是值截获
    NSInteger num = 3;
    NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
        return n*num;
    };
    num = 1;
    NSLog(@"%zd",block(2));
    
    
//    2、局部对象变量截获 是值截获。
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    void(^block1)(void) = ^{
        NSLog(@"%@",arr);//局部变量
        [arr addObject:@"4"];
    };
    [arr addObject:@"3"];
    arr = nil;
    block1();
    
//    3、局部静态变量截获 是指针截获。
    static NSInteger num0 = 3;
    NSInteger(^block2)(NSInteger) = ^NSInteger(NSInteger n){
        return n*num0;
    };
    num0 = 1;
    NSLog(@"%zd",block2(2));
    
    
    NSInteger num1 = 30;
    static NSInteger num2 = 3;
    __block NSInteger num5 = 30000;
    void(^block3)(void) = ^{
        NSLog(@"%zd",num1);//局部变量
        NSLog(@"%zd",num2);//局部静态变量
        NSLog(@"%zd",num3);//全局静态变量
        NSLog(@"%zd",num4);//全局变量
        NSLog(@"%zd",num5);//__block修饰变量
    };
    num5 = 2800;
    block3();
    
    
    CaculateMaker *maker = [[CaculateMaker alloc] init];
    maker.add(20).add(30);
    NSLog(@"%f",maker.result);
}

@end
