//
//  testMapleTableViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/2/27.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testMapleTableViewController.h"
#import "Fathers.h"
#import "Son.h"
@interface testMapleTableViewController ()

@end

@implementation testMapleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
//    [self testDic];
    [self testMaple];
}

-(void)testDic
{
    //father遵守了NSCoping协议
    Fathers *father = [[Fathers alloc] init];
    NSMutableDictionary * dictest = [[NSMutableDictionary alloc] initWithCapacity:2];
    {
          Son * son = [[Son alloc] init];
          NSLog(@"son:%@",son);
          [dictest setObject:son forKey:father];
    }
     NSLog(@"dictest:%@\nfather:%@",dictest,father);
     

}

-(void)testMaple
{
    NSMapTable * table = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory capacity:2];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        Fathers * father = [[Fathers alloc] init];
        father.name = @"老师";
        father.old = @"31";
        
        Son * son1 = [[Son alloc] init];
        son1.name = @"学生1";
        son1.old = @"21";
        
        Son * son2 = [[Son alloc] init];
        son2.name = @"学生2";
        son2.old = @"22";
        
        Son * son3 = [[Son alloc] init];
        son3.name = @"学生3";
        son3.old = @"23";
        
        [dic setObject:@[son1,son2,son3] forKey:father];
        [dic setObject:@[son1,son2] forKey:father];
        [table setObject:@[son1,son2,son3] forKey:father];
        [table setObject:@[son1,son2] forKey:father];
        NSLog(@"\n Fathers:%@\ndic:%@\n table:%@",father,dic,table);
     
   
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
