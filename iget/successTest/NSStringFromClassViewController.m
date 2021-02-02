//
//  NSStringFromClassViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/29.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "NSStringFromClassViewController.h"
#import "Son.h"

@interface NSStringFromClassViewController ()

@end

@implementation NSStringFromClassViewController

- (void)viewDidLoad {
    NSLog(@"test super performSelector");
    
    BOOL res = [super respondsToSelector:@selector(viewDidLoad)];
    NSLog(@"res is %d",res);
//    [super performSelector:@selector(viewDidLoad)];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    [[Son alloc]init];
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
