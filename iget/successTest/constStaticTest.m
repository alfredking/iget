//
//  constStaticTest.m
//  iget
//
//  Created by alfredking－cmcc on 2021/2/4.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "constStaticTest.h"

@interface constStaticTest ()

@end

@implementation constStaticTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
//    int  age =24;
    int const  age =24;
    int *p =&age;
    *p =30;
    NSLog(@"age is %d",age);
    for (int i =0; i<5; i++) {
        [self testStatic];
    }
    
    
    
}

-(void)testStatic
{
    static int a =0;
//    int a =0;
    a++;
    NSLog(@"a is %d",a);
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
