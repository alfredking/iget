//
//  testBoolViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/8/15.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testBoolViewController.h"

@interface testBoolViewController ()

@end

@implementation testBoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    bool t1 =1;//true or false
    BOOL t2 = 3;//YES or NO
    Boolean t3 =1; //unsigned char type
    boolean_t t4 = 1;//int type

    //可以用po打印来看具体的值
//    NSLog(@"t1 is %@",t1);
//    NSLog(@"t2 is %@",t2);
//    NSLog(@"t3 is %@",t3);
//    NSLog(@"t4 is %@",t4);
    
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
