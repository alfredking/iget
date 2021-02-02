////
////  testOCForwarding.m
////  iget
////
////  Created by alfredking－cmcc on 2021/1/24.
////  Copyright © 2021 alfredking. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#include <stdio.h>
//int main(int argc, char * argv[]) {
//    __block NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
//    NSLog(@"before a指向的堆中地址：%p,a在栈中的指针地址：%p", a, &a);               //a在栈区
//    void (^foo)(void) =
//    ^{
//            NSLog(@"block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
////            a.string = @"Jerry";
//            NSLog(@"block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
//            [a appendFormat:@"jerry"];
//            NSLog(@"block内部：a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
//            NSLog(@"a is in block %@",a);
//            //a在栈区
////            a = [NSMutableString stringWithString:@"William"];
//    };
//    
//    NSLog(@"after a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
//    foo();
//    NSLog(@"a is %@",a);
////    [a appendFormat:@"alfredking"];
//    a = [NSMutableString stringWithString:@"William"];
//    foo();
//    
//    NSLog(@"a is %@",a);
//    NSLog(@"finally a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
//}
