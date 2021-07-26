//
//  testSetViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/7/6.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testSetViewController.h"

@interface testSetViewController ()

@end

@implementation testSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSArray *array1 = @[@"1",@"2",@"3"];
    NSArray *array2 = @[@"1",@"5",@"6"];
    NSMutableSet *set1 = [NSMutableSet setWithArray:array1];
    NSMutableSet *set2 = [NSMutableSet setWithArray:array2];
     
//    [set1 unionSet:set2];       //取并集后 set1中为1，2，3，5，6
//    [set1 intersectSet:set2];  //取交集后 set1中为1
    [set1 minusSet:set2];      //取差集后 set1中为2，3，5，6
    
    NSLog(@"set is %@",set1);
    
    
//    @"0550-2756147,0571-05368751,0559-7788102,027-1234,028-12345"
    
    NSArray *receivedImsi = @[@"0550-2756147",@"0571-05368751",@"0559-7788102",@"027-1234",@"028-12345"];
    NSArray *currentList = @[@"0550-2756147",@"0571-05368751",@"0559-7788102"];
    NSMutableSet *receivedImsiSet = [NSMutableSet setWithArray:receivedImsi];
    NSMutableSet *currentListSet = [NSMutableSet setWithArray:currentList];
    [receivedImsiSet minusSet:currentListSet];      //取差集后 set1中为2，3，5，6
    
    NSLog(@"receivedImsiSet is %@",receivedImsiSet);
    
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
