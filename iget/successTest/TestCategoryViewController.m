//
//  TestCategoryViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/2/13.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestCategoryViewController.h"
#import <objc/runtime.h>
#import "TestCategoryClass.h"

@interface TestCategoryViewController ()

@end

@implementation TestCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self testCategory];
}


-(void)testCategory
{
    typedef void (*fn)(id,SEL);
    Class currentClass = [TestCategoryClass class];
    TestCategoryClass *my = [[TestCategoryClass alloc] init];

    if (currentClass) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        IMP lastImp = NULL;
        SEL lastSel = NULL;
        for (NSInteger i = 0; i < methodCount; i++) {
            Method method = methodList[i];
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                            encoding:NSUTF8StringEncoding];
            NSLog(@"current i is %ld",(long)i);
            NSLog(@"methodName is %@",methodName);
            if ([@"testMethod4" isEqualToString:methodName]) {
               
                lastImp = method_getImplementation(method);
                lastSel = method_getName(method);
                if (lastImp != NULL) {
                    fn f = (fn)lastImp;
                    f(my,lastSel);
                }
            }
        }
        
        
        if (lastImp != NULL) {
            fn f = (fn)lastImp;
            f(my,lastSel);
        }
        free(methodList);
    }
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
