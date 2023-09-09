//
//  TestMonitorViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/2/14.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestMonitorViewController.h"

@interface TestMonitorViewController ()

@end

@implementation TestMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self testMethod];
}

-(void)testMethod
{
    sleep(5);
//    for(int i =0;i<30000;i++)
//    {
//        NSLog(@"current is %d",i);
//    }
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
