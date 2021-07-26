//
//  testContactsViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/7/10.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testContactsViewController.h"
#import <Contacts/Contacts.h>
@interface testContactsViewController ()

@end

@implementation testContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
        if (error) {
            //无权限
            NSLog(@"无权限");
        } else {
            //有权限
            NSLog(@"有权限");
        }
    }];
    
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
