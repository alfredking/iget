//
//  TestCrashViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2023/8/23.
//  Copyright © 2023 alfredking. All rights reserved.
//

#import "TestCrashViewController.h"
#import "MyObject.h"
#import <DDZombieMonitor/DDZombieMonitor.h>
#import <DDZombieMonitor/DDBinaryImages.h>
#include <sys/sysctl.h>
#import <Bugly/Bugly.h>


@interface ZombieTest: NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *text;

- (void)test;

@end

@implementation ZombieTest

- (instancetype)init {
    if (self = [super init]) {
        _name = @"name";
        _text = @"text";
    }
    return self;
}

- (void)test {
    NSLog(@"%@ %@", self.name, self.text);
}

@end



@interface TestCrashViewController ()

@property (nonatomic, unsafe_unretained)MyObject *object;

//@property (nonatomic, assign)MyObject *object;

@property (nonatomic, assign)ZombieTest *zombieObj;

@end

typedef struct {
    NSString *name;
} MyStruct;

@implementation TestCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //setup DDZombieMonitor
    void (^zombieHandle)(NSString *className, void *obj, NSString *selectorName, NSString *deallocStack, NSString *zombieStack) = ^(NSString *className, void *obj, NSString *selectorName, NSString *deallocStack, NSString *zombieStack) {
        NSString *zombieInfo = [NSString stringWithFormat:@"ZombieInfo = \"detect zombie class:%@ obj:%p sel:%@\ndealloc stack:%@\nzombie stack:%@\"", className, obj, selectorName, deallocStack, zombieStack];
        NSLog(@"%@", zombieInfo);
        
        NSString *binaryImages = [NSString stringWithFormat:@"BinaryImages = \"%@\"", [self binaryImages]];
        NSLog(@"%@", binaryImages);
        NSString *reason = [NSString stringWithFormat:@"zombie (%@) call (%@)", className, selectorName];
//        [EHLog reportZombieCrashInfoWithName:@"zombie crash" reason:reason?:@"crash" dict:@{@"zombieInfo":zombieInfo?:@"", @"binaryImages":binaryImages?:@""}];
        //extraInfo有长度限制
        [Bugly reportExceptionWithCategory:3 name:@"zombie crash MyObject" reason:reason?:@"unknow reason" callStack:[NSThread callStackSymbols] extraInfo:@{@"zombieInfo":zombieInfo?:@"", @"binaryImages":@""} terminateApp:NO];
        
//            [Bugly reportExceptionWithCategory:3 name:@"zombie crash MyObject" reason:@"unknow reason" callStack:[NSThread callStackSymbols] extraInfo:@{@"zombieInfo":@"", @"binaryImages":@""} terminateApp:NO];
//
//    [Bugly reportExceptionWithCategory:3 name:@"zombie crash single" reason:@"unknow reason" callStack:[NSThread callStackSymbols] extraInfo:@{@"zombieInfo":@"", @"binaryImages":@""} terminateApp:NO];
        
    };
    [DDZombieMonitor sharedInstance].handle = zombieHandle;
    [[DDZombieMonitor sharedInstance] startMonitor];
    
    MyObject *object = [[MyObject alloc] init];
    self.object = object;
    self.object.name = @"HelloWorld";
    void *p = (__bridge void *)(self.object);
    NSLog(@"%p,%@",self.object,self.object.name);
    NSLog(@"%p,%@",p, [(__bridge MyObject *)p name]);
    
    ZombieTest *zombieObj = [ZombieTest new];
    self.zombieObj = zombieObj;
    
//    MyStruct *p;
//    p = malloc(sizeof(MyStruct));
//    // 此时内存中的数据不可控 可能是之前未擦除的
//    printf("testp %x\n", *((int *)p));
//    // 使用可能会出现野指针问题
//    NSLog(@"%@", p->name);
//    // 进行内存数据的初始化
//    p->name = @"HelloWorld";
//    // 回收内存
//    free(p);
//    // 此时内存中的数据不可控
//    NSLog(@"%@", p->name);
//    NSArray *array = @[@(1), @(2), @(3)];
//    NSLog(@"array[3] = %@", array[3]);
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%p",self->_object);
//    NSLog(@"%@",self.object.name);
    [self.zombieObj test];
//    [Bugly reportExceptionWithCategory:3 name:@"zombie crash single" reason:@"unknow reason" callStack:[NSThread callStackSymbols] extraInfo:@{@"zombieInfo":@"", @"binaryImages":@""} terminateApp:NO];
}



- (NSString*)binaryImages {
    NSArray *binaryImages = [DDBinaryImages binaryImages];
    NSMutableString *binaryImagesStr = [NSMutableString new];
    
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    NSString *ctlKey = @"kern.osversion";
    NSString *buildValue;
    size_t size = 0;
    if (sysctlbyname([ctlKey UTF8String], NULL, &size, NULL, 0) != -1){
        char *machine = calloc( 1, size );
        sysctlbyname([ctlKey UTF8String], machine, &size, NULL, 0);
        buildValue = [NSString stringWithCString:machine encoding:[NSString defaultCStringEncoding]];
        free(machine);
    }
    
    [binaryImagesStr appendFormat:@"{\nOS Version:%@ (%@)\n", osVersion, buildValue];
    for (NSString *image in binaryImages) {
        [binaryImagesStr appendString:image];
        [binaryImagesStr appendString:@"\n"];
    }
    [binaryImagesStr appendString:@"}"];
    return [binaryImagesStr copy];
}
@end
