//
//  TestCrashViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2023/8/23.
//  Copyright © 2023 alfredking. All rights reserved.
//

#import "TestCrashViewController.h"
#import "MyObject.h"
@interface TestCrashViewController ()

@property (nonatomic, unsafe_unretained)MyObject *object;

@end

typedef struct {
    NSString *name;
} MyStruct;

@implementation TestCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    MyObject *object = [[MyObject alloc] init];
//    self.object = object;
//    self.object.name = @"HelloWorld";
//    void *p = (__bridge void *)(self.object);
//    NSLog(@"%p,%@",self.object,self.object.name);
//    NSLog(@"%p,%@",p, [(__bridge MyObject *)p name]);
    
    MyStruct *p;
    p = malloc(sizeof(MyStruct));
    // 此时内存中的数据不可控 可能是之前未擦除的
    printf("testp %x\n", *((int *)p));
    // 使用可能会出现野指针问题
    NSLog(@"%@", p->name);
    // 进行内存数据的初始化
    p->name = @"HelloWorld";
    // 回收内存
    free(p);
    // 此时内存中的数据不可控
    NSLog(@"%@", p->name);
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%p",self->_object);
    NSLog(@"%@",self.object.name);
}

@end
