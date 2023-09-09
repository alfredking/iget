//
//  TestLayoutViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/11/28.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "TestLayoutViewController.h"
#import <objc/message.h>
@interface TestLayoutViewController ()

@end

@interface Cls : NSObject

@property (nonatomic,copy) NSString *name;

@end

@implementation Cls

-(void)speak
{
    NSLog(@"Cls test : %@",self.name);
}

@end
@implementation TestLayoutViewController

//-(void)loadView
//{
//    NSLog(@"loadView");
//}

+ (void)load {
    
    NSLog(@"TestLayoutViewController load called");
}

//+(void)initialize
//{
//    NSLog(@"TestLayoutViewController initialize called");
//}

- (instancetype)init
{
    NSLog(@"init called");
    return [super init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *str = @"11111";
    id cls = [Cls class];
    void *obj = &cls;
    [(__bridge id)obj speak];
    
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    NSLog(@"self view is %@",NSStringFromCGRect(self.view.bounds));
    NSLog(@"self view is %@",NSStringFromCGRect(self.view.frame));
    
//    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 100)];
//    testView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:testView];
    
//    UIViewController *guideVC = [[UIViewController alloc]init];
//    guideVC.view.backgroundColor = [UIColor yellowColor];
//    [self presentViewController:guideVC animated:NO completion:nil];
    
    NSLog(@"*********动态获取方法************");
    unsigned int count = 0;
    Method *mem = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(mem[i]);
        NSString *method = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        NSLog(@"\n%@",method);
    }
    NSLog(@"*********动态获取方法************");

    NSLog(@"*********动态获取属性************");
    unsigned int *varCount = malloc(sizeof(unsigned int));
    Ivar *memIvar = class_copyIvarList([NSObject class], varCount);
    for (int i = 0; i < *varCount; i++) {
        Ivar var = *(memIvar + i);
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        NSLog(@"%s:%s\n",name,type);
    }
    free(varCount);
    varCount = nil;
    NSLog(@"*********动态获取属性************");
    
    
    
}

-(void)viewWillLayoutSubviews
{
    NSLog(@"viewWillLayoutSubviews");
}

-(void)viewDidLayoutSubviews
{
    NSLog(@"viewDidLayoutSubviews");
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
}

//-(void)viewWillUnload
//{
//    NSLog(@"viewWillUnload");
//}
//
//-(void)viewDidUnload
//{
//    NSLog(@"viewDidAppear");
//}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
}

-(void)dealloc
{
    NSLog(@"dealloc");
}
@end
