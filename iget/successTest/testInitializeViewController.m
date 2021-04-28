//
//  testInitializeViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/4/21.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testInitializeViewController.h"
#import "Person.h"
#import "Student.h"
@interface testInitializeViewController ()

@end

@implementation testInitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
//    Person *p1 = [[Person alloc]init];
//    Person *p2 = [[Person alloc]init];
    Student *s = [[Student alloc]init];
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
