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
    Person *p1 = [[Person alloc]init];
    Person *p2 = [[Person alloc]init];
    Student *s = [[Student alloc]init];
}


@end
