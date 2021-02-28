//
//  testInstanceViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/2/8.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testInstanceViewController.h"
#import "testToken.h"

@interface testInstanceViewController ()

@end

@implementation testInstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    getToken();
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
