//
//  blockTestViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/22.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "blockTestViewController.h"

@interface blockTestViewController ()

@end


int a = 1;
static int b = 2;

@implementation blockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    


//    firstTest();
//    blockTest();
    
//    testPointer();
    
   
    
//    nonBlockTest();
    forwardingTest();
    
//    blockArray();
    
    
    
}

void firstTest()
{
    //代码片段1
    __block int a = 0;
//    int a =0;
    __block NSString *ak=@"hello alfredking";

    //a因为是基本类型没有地址，所以就是a的值0
    NSLog(@"a before %p --%p,",&a,a);
    NSLog(@"ak before %p --%p,",&ak,ak);

    void (^test)(void) = ^{

        a=1;
        ak =@"good alfredking";
        
        


        //在block中已经变成堆地址
    NSLog(@"a middle --%p,a is %d",&a,a);
    NSLog(@"ak middle --%p,a is %@",&ak,ak);
        
        //定义临时变量就是在栈上
//         int test1 = 9;
//         NSString *test2=@"hello test";
        //定义block变量就是在堆上，错误，还是在栈上
        __block int test1 = 9;
        __block NSString *test2=@"hello test";
        NSLog(@"test middle --%p,a is %d",&test1,test1);
        NSLog(@"test middle --%p,a is %@",&test2,test2);

    };

  //block内部定义的外部无法访问
//    NSLog(@"a after --%p, a is %d",&test1,test1);
    a=2;
    ak=@"test alfredking";
    //因为在block后面所以也是堆地址
   NSLog(@"a after --%p, a is %d",&a,a);
   NSLog(@"ak after --%p,a is %@",&ak,ak);
    
    test();
    
    NSLog(@"a after block --%p, a is %d",&a,a);
    NSLog(@"ak after block --%p,a is %@",&ak,ak);
    
    
}
void blockTest() {

    int c = 3;
    static int d = 4;
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"hello"];
   
    __block NSMutableString *mystr = [[NSMutableString alloc]initWithString:@"alfredking"];
    NSLog(@"mystr p is %p",mystr);
    NSLog(@"mystr指针内存地址：%p",&mystr);
    void (^blk)(void) = ^{
        a++;
        b++;
        d++;
//        c++;
        [str appendString:@"world"];
        NSLog(@"1----------- a = %d,b = %d,c = %d,d = %d,str = %@,mystr = %@",a,b,c,d,str,mystr);
        NSLog(@"mystr p is %p",mystr);
        NSLog(@"mystr指针内存地址：%p",&mystr);
    };
    
    a++;
    b++;
    c++;
    d++;
    NSLog(@"mystr p is %p",mystr);
    NSLog(@"mystr指针内存地址：%p",&mystr);
    str = [[NSMutableString alloc]initWithString:@"haha"];
   
    mystr = [[NSMutableString alloc]initWithString:@"new"];
    NSLog(@"mystr p is %p",mystr);
    NSLog(@"mystr指针内存地址：%p",&mystr);
    NSLog(@"2----------- a = %d,b = %d,c = %d,d = %d,str = %@,mystr = %@",a,b,c,d,str,mystr);
    blk();
    
    NSLog(@"blk class %@",[blk class]);
    

}


//演示变量内存地址和所指向的地址
void testPointer()
{
    int a =10;
    NSLog(@"a p is %d,a address is %p",a,&a);
    a=20;
    NSLog(@"a p is %d,a address is %p",a,&a);
    
    NSString *test = @"test1";
    NSLog(@"test p is %p,test address is %p",test,&test);
    [test stringByAppendingFormat:@"appendstring"];
    NSLog(@"test is %@",test);
    NSLog(@"test p is %p,test address is %p",test,&test);
    test=@"test2";
    NSLog(@"test p is %p,test address is %p",test,&test);
    
    
    
}

void nonBlockTest()
{
//    __block NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
    NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
    
    NSLog(@"before a指向的堆中地址：%p,a在栈中的指针地址：%p", a, &a);               //a在栈区
    void (^foo)(void) =
    ^{
        
            NSString  *test =@"alfredking";
            NSLog(@"block内部：test指向的堆中地址：%p；test在栈中的指针地址：%p", test, &test);
            NSLog(@"block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
        //可以通过编译
            a.string = @"Jerry";
            NSLog(@"block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
            [a appendFormat:@"jerry"];
            NSLog(@"block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
            NSLog(@"a is in block %@",a);
            //a在栈区
           //无法通过编译
            //a = [NSMutableString stringWithString:@"William"];
    };
    
    NSLog(@"foo type is %@",foo);
    
    NSLog(@"after a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
    foo();
    NSLog(@"a is %@",a);
//    [a appendFormat:@"alfredking"];
    a = [NSMutableString stringWithString:@"William"];
    foo();
    
    NSLog(@"a is %@",a);
    NSLog(@"finally a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
    NSLog(@"foo class is %@",[foo class]);
}

void forwardingTest()
{
    __block int val = 0;

        printf("&val:%p, val:%d \n", &val, val);
        
        void (^blk)(void) = ^{
            printf("inBlock    &val:%p, val:%d \n", &val, val);
            ++val;
        };
        
        printf("&val:%p, val:%d \n", &val, val);
        blk();
        printf("&val:%p, val:%d \n", &val, val);
        ++val;
        printf("&val:%p, val:%d \n", &val, val);
}


//block作为函数参数，不会从栈拷贝到堆
void blockArray()
{
    int intVarInStack = 0;
        printf("&intVarInStack:%p, intVarInStack:%d \n", &intVarInStack, intVarInStack);

        __block int val = 0;
        
        printf("&b:%p, b:%d \n", &val, val);
        NSArray *blockArray = [[NSArray alloc] initWithObjects:^{
            printf("hello world!");},
            ^{
                printf("inBlock2    &val:%p, val:%d \n", &val, val);
                ++val;
            },
        nil];
        
        printf("&val:%p, val:%d \n", &val, val);
        ++val;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
