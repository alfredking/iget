//
//  Father.m
//  iget
//
//  Created by alfredking－cmcc on 2019/8/3.
//  Copyright © 2019 alfredking. All rights reserved.
//

#import "Father.h"


@interface Father()
{
    //NSMutableString *testStringB;

}

@property (nonatomic,strong)NSMutableString *testStringA;
@property (nonatomic,strong)NSMutableString *testStringB;
//@property (nonatomic,strong)NSString *title;
//@property (nonatomic,weak)NSString *title;
@property (nonatomic,copy)NSString *title;

@end

@implementation Father

-(void)testcopy
{
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"name"];
    NSLog(@"原始string的地址:%p",string);
    _testStringA = string;
    NSLog(@"A对象string的地址:%p",_testStringA);
    _testStringB = string ;
    NSLog(@"B对象string的地址:%p",_testStringB);


    NSMutableString *copyString = [string copy];
    //发生了深拷贝，但是确是不可变的
    NSLog(@"拷贝string的地址:%p",copyString);

    //[copyString appendString:@"test"];


    
    NSString *stringb = [NSString stringWithFormat:@"test"];
    NSLog(@"原始string的地址:%p",stringb);
    
    NSString *copyStringb = [stringb copy];
    //发生了浅拷贝，是不可变的，字符串是@"name"的时候，与copyString是同一个对象
    NSLog(@"拷贝string的地址:%p",copyStringb);
    
    self.title = @"title"; //成员变量不能用.的方法
    NSLog(@"self.title is %@",self.title);
    NSMutableString *mutableTitleA = [@"mutableTitleA" mutableCopy];
    NSMutableString *mutableTitleB = [@"mutableTitleB" mutableCopy];
    
    NSMutableString *mutable =mutableTitleA;

    
    
    
    self.title = mutable;
    
    NSLog(@"self.title is %@",self.title);
    
    mutable = mutableTitleB; //如果self.title是weak属性的时候，@"title"指向的内存在mutableTitle不再指向的时候会被销毁，值为null
    //mutableTitle = [@"test" mutableCopy];
    //[mutableTitle appendString:@" wawawa"];
    
    //self.title只有在strong属性的时候会变化
    NSLog(@"self.title is %@",self.title);
    
    
}


//__block关键字实现https://www.jianshu.com/p/404ff9d3cd42  https://www.jianshu.com/p/e5b56b883d54
-(void) testblock
{
    
    //1.基本数据类型(不被__block修饰)
    int a = 100;                                //a在栈区
    NSLog(@"栈中a的地址%p",&a);
    
    void (^intBlock)(void) = ^(void){
        //a = 33;  //Block不允许修改外部变量的值
        NSLog(@"a = %d",a);                     //a在堆区
        NSLog(@"堆中a的地址%p",&a);
    };
    
    a = 33;                                    //a在栈区
    
    NSLog(@"修改后栈中a的地址%p",&a);

    intBlock();
    
    NSLog(@"执行block之后栈中a的地址%p",&a);
    
    //输出:
    //栈中a的地址0x7fff5d5035ac
    //a = 100
    //堆中a的地址0x60c000256bb0
    
    
    //2.oc对象(不被__block修饰)
    NSString *str = @"zw";
    NSLog(@"1--栈中str的地址%p,str指向堆中的地址%p",&str,str);
    
    void (^strBlock)(void) = ^(void){
        //str = @"once";  Block不允许修改外部变量的值
        NSLog(@"str = %@",str);
        NSLog(@"3--堆中str的地址%p,str指向堆中的地址%p",&str,str);
    };
    NSLog(@"2--栈中str的地址%p,str指向堆中的地址%p",&str,str);
    
    strBlock();
    
    //番外的知识
    str = @"once";
    NSLog(@"4--栈中str的地址%p,str指向堆中的地址%p",&str,str);
    
    
    /*输出：
     1--栈中str的地址0x7fff5b9fa570,str指向堆中的地址0x1042051f0
     2--栈中str的地址0x7fff5b9fa570,str指向堆中的地址0x1042051f0
     str = zw
     3--堆中str的地址0x60800024ad98,str指向堆中的地址0x1042051f0
     4--栈中str的地址0x7fff5b9fa570,str指向堆中的地址0x108814290
     */
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:@"zw"];
    
    void (^mutableStrBlock)(void) = ^(void){
        
    //Block不允许修改外部变量的值，这里所说的外部变量的值，指的是栈中指针的地址。要想在Block内修改“外部变量”的值，必须被__block修饰。
        mutableStr.string = @"once";
        NSLog(@"mutableStr = %@",mutableStr);
        //mutableStr = [NSMutableString stringWithString:@"once"];  //Block不允许修改外部变量的值
    };
    
    mutableStrBlock();
    
    //输出 mutableStr = once
    
    
    
    //基本数据类型/oc对象(被__block修饰)
    __block int b = 100;
    __block NSString *strI = @"zw";
    __block NSMutableString *strM = [NSMutableString stringWithString:@"zw"];
    
    NSLog(@"__block 1栈中b的地址%p",&b);
    NSLog(@"__block 1栈中strI的地址%p,strI指向堆中的地址%p",&strI,strI);
    NSLog(@"__block 1栈中strM的地址%p,strM指向堆中的地址%p",&strM,strM);
    
    b = 99;
    strI = @"ONCE";
    strM = [NSMutableString stringWithString:@"ONCE"];
    NSLog(@"b = %d,strI = %@,strM = %@",b,strI,strM);
    
    NSLog(@"__block 5栈中b的地址%p",&b);
    NSLog(@"__block 5栈中strI的地址%p,strI指向堆中的地址%p",&strI,strI);
    NSLog(@"__block 5栈中strM的地址%p,strM指向堆中的地址%p",&strM,strM);
    
    void (^block)(void) = ^(void){
        
        NSLog(@"__block 3堆中b的地址%p",&b);
        NSLog(@"__block 3堆中strI的地址%p,strI指向堆中的地址%p",&strI,strI);
        NSLog(@"__block 3堆中strM的地址%p,strM指向堆中的地址%p",&strM,strM);
        b = 66;
        strI = @"once";
        strM = [NSMutableString stringWithString:@"once"];
        NSLog(@"b = %d,strI = %@,strM = %@",b,strI,strM);
        
        NSLog(@"__block 4堆中b的地址%p",&b);
        NSLog(@"__block 4堆中strI的地址%p,strI指向堆中的地址%p",&strI,strI);
        NSLog(@"__block 4堆中strM的地址%p,strM指向堆中的地址%p",&strM,strM);
    };
    
    b = 99;
    strI = @"ONCE";
    strM = [NSMutableString stringWithString:@"ONCE"];
    NSLog(@"b = %d,strI = %@,strM = %@",b,strI,strM);
    
    NSLog(@"__block 2栈中b的地址%p",&b);
    NSLog(@"__block 2栈中strI的地址%p,strI指向堆中的地址%p",&strI,strI);
    NSLog(@"__block 2栈中strM的地址%p,strM指向堆中的地址%p",&strM,strM);
    
    block();
    
    //输出 b = 99,strI = ONCE,strM = ONCE,
    //输出 b == 66,strI = once,strM = once
    
    NSLog(@"__block 6栈中b的地址%p",&b);
    NSLog(@"__block 6栈中strI的地址%p,strI指向堆中的地址%p",&strI,strI);
    NSLog(@"__block 6栈中strM的地址%p,strM指向堆中的地址%p",&strM,strM);
    
    
}
@end
