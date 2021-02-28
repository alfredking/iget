//
//  DynamicMethodVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "DynamicMethodVC.h"
#import <objc/message.h>


//#if (DEBUG == 1 || TARGET_OS_SIMULATOR)
//#else
//#ifdef FILELOG_SUPPORT
//[self redirectNSlogToDocumentFolder];
//#endif
//#endif//```

#define FILELOG_SUPPORT(str) [self redirectNSlogToDocumentFolder:str]

typedef struct ParameterStruct{
    int a;
    int b;
}MyStruct;

@interface DynamicMethodVC ()

@end

@implementation DynamicMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    类中获取它的属性
    id LenderClass = objc_getClass("HLWebViewController");
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(LenderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "name~~~%s------属性~~~%s\n", property_getName(property), property_getAttributes(property));
    }

    
    NSDictionary *dicemp = @{@"first":@"partridge",@"second": @"turtledoves",@"fifth": @"golden rings"};
    
    NSLog(@"%@",dicemp[@"112222"]);
    
    //    [self invocationInstance];
    
    for (NSInteger i = 0; i <2; i ++) {
        //        [self performSelector:NSSelectorFromString(@[@"doSomething",@"doAnotherThing"][i])];
        //代替switch
        [self performSelector:NSSelectorFromString(@[@"doSomething:",@"doAnotherThing:"][i]) withObject:@(i)];
    }
    
    NSString *str = @"字符串objc_msgSend";
    NSNumber *num = @20;
    NSArray *arr = @[@"数组值1", @"数组值2"];
    SEL sel = NSSelectorFromString(@"ObjcMsgSendWithString:withNum:withArray:");
    ((void (*) (id, SEL, NSString *, NSNumber *, NSArray *))objc_msgSend)(self, sel, str, num, arr);
    
    
    MyStruct mystruct = {10,20};
    NSValue *value = [NSValue valueWithBytes:&mystruct objCType:@encode(MyStruct)];
    
    MyStruct struceBack;
    [value getValue:&struceBack];
    NSLog(@"%d~~~~~~~~~",struceBack.a);
    
    NSProxy *prox = [NSProxy alloc];
}

//三个参数的方法
-(void)take:(NSString *)name andAge:(NSString *)age andBlue:(NSString *)color{
    NSLog(@"%@-%@-%@",name,age,color);
    //    return 7;
}
-(void)invocationInstance{
    //    1.通过方法调用者创建方法签名；此方法是NSObject 的方法
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(take:andAge:andBlue:)];
    //    2.通过方法签名 生成NSInvocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    //    3.对invocation设置 方法调用者
    invocation.target = self;
    //    4.对invocation设置 方法选择器
    invocation.selector = @selector(take:andAge:andBlue:);
    //    5.对invocation设置 参数
    NSString *name = @"张三";
    NSString *age = @"20";
    NSString *color = @"red";
    //注意：设置的参数必须从2开始；因为0和1 已经被self ,_cmd 给占用了
    [invocation setArgument:&name atIndex:2];
    [invocation setArgument:&age atIndex:3];
    [invocation setArgument:&color atIndex:4];
    //    6.执行invocation
    [invocation invoke];
    //    7.判断 方法签名 判断是否有返回值
    const char *sigretun =  sig.methodReturnType; //方法签名的返回值
    NSUInteger siglength = sig.methodReturnLength; //方法签名返回值长度； 如果是字符串返回8，数字返回4，没有返回值返回0；
    if (siglength !=0) { //有返回值
        if (strcmp(sigretun, "@") == 0) {
            NSString *returnStr;
            [invocation getReturnValue:&returnStr];
            NSLog(@"字符串返回值：%@",returnStr);
        }else if (strcmp(sigretun, "i")){
            int a = 0;
            [invocation setReturnValue:&a];
            NSLog(@"数字返回值：%d",a);
        }
    }else{ //没有返回值
        NSLog(@"没有返回值");
    }
    
    //    8.常用方法
    NSUInteger argumentNum = sig.numberOfArguments;
    NSLog(@"%zd",argumentNum); //参数的个数
    
    const char *type = [sig getArgumentTypeAtIndex:3];
    NSLog(@"方法签名中下标为3的的参数类型:%s",type);
}
// 扩展
//-(id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects{
//    //生成方法签名
//    NSMethodSignature *sig = [NSMethodSignature methodSignatureForSelector:aSelector];
//    if (sig == nil) { //如果方法签名不存在抛出异常
//        [NSException raise:@"exceptionName" format:@"%@not found method",NSStringFromSelector(aSelector)];
//    }
//    //生成invocation
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
//    invocation.target = self;// 设置调用对象
//    invocation.selector = aSelector;//设置方法选择器
//
//    NSInteger num = sig.numberOfArguments -2; //传递进来的参数个数
//    NSInteger min = MAX(num, objects.count); //取得参数的数量；
//    for (int i = 0; i< min; i++) {
//        id obj = objects[i];
//        if ([obj isKindOfClass:[NSNull class]]) continue;
//            //设置参数
//        [invocation setArgument:&obj atIndex:i+2];
//
//    }
//    //调用方法
//    [invocation invoke];
//
//    //获得返回值
//    id retrunvalue = nil;
//    if (sig.methodReturnLength !=0) { //如果有返回值的话，获取返回值
//        [invocation getReturnValue:&retrunvalue];
//    }
//    return retrunvalue;
//
//
//}

- (void)doSomething:(id)index{
    NSLog(@"%@~~~~~~%@~~~",NSStringFromSelector(_cmd),index);
}

- (void)doAnotherThing:(id)index{
    NSLog(@"%@~~~~~~%@~~~",NSStringFromSelector(_cmd),index);
}

- (void)ObjcMsgSendWithString:(NSString *)string withNum:(NSNumber *)number withArray:(NSArray *)array {
    NSLog(@"%@, %@, %@", string, number, array[0]);
}


#pragma mark 通过宏调用自定义方法 --- 无参数无返回值的宏，带参数的宏，带返回值的宏，
- (void)defineFunction{
    FILELOG_SUPPORT(@"2222");
    NSString *str = FILELOG_SUPPORT(@"2222");
    NSLog(@"%@",str);
}

- (NSString *)redirectNSlogToDocumentFolder:(NSString *)str{
    NSLog(@"通过宏定义调用自定义的方法~~~~%@",str);
    NSString *strReturn = @"我是返回值";
    return strReturn;
}

@end
