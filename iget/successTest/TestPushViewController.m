//
//  TestPushViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2023/7/15.
//  Copyright © 2023 alfredking. All rights reserved.
//

#import "TestPushViewController.h"

@interface TestPushViewController ()

@end

@implementation TestPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor redColor];
    UIViewController *vc2 = [[UIViewController alloc]init];
    vc2.view.backgroundColor = [UIColor greenColor];
    UIViewController *vc3 = [[UIViewController alloc]init];
    vc3.view.backgroundColor = [UIColor blueColor];
    
    [self.navigationController pushViewController:vc1 animated:NO];
    [self.navigationController pushViewController:vc2 animated:YES];
    [self.navigationController pushViewController:vc3 animated:YES];
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
