//
//  ViewController.m
//  test
//
//  Created by alfredking－cmcc on 2021/2/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"test result is %d",bracketTest(@"[]()"));
}
//struct testStruct{
//    int b;
//    int a[0];
//};

bool bracketTest(NSString *input)
{
//    struct testStruct tt;
//    tt.b=2;
//    tt.a=3;
    
    NSMutableArray *stackArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<input.length; i++) {
        NSString *current = [input substringWithRange:NSMakeRange(i,1)];
        NSLog(@"curren is %@",current);
        if ([current isEqualToString:@"{"]||[current isEqualToString:@"["]||[current isEqualToString:@"("]) {
            [stackArray addObject:current];
        }
        else if ([current isEqualToString:@"}"])
        {
            if ([stackArray.lastObject isEqualToString:@"{"]) {
                [stackArray removeLastObject];
            }
            else
                [stackArray addObject:current];
        }
        else if ([current isEqualToString:@"]"])
        {
            if ([stackArray.lastObject isEqualToString:@"["]) {
                [stackArray removeLastObject];
            }
            else
                [stackArray addObject:current];
        }
        else if ([current isEqualToString:@")"])
        {
            if ([stackArray.lastObject isEqualToString:@"("]) {
                [stackArray removeLastObject];
            }
            else
                [stackArray addObject:current];
        }
        
        
       
    }
    
    if (stackArray.count>0)
        return  false;
    else
        return true;
}

@end
