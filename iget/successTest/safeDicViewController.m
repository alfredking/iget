//
//  safeDicViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/2/7.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "safeDicViewController.h"

@interface safeDicViewController ()

@end

@implementation safeDicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //一种方法是使用串行队列
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t conquene = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t tokenQueue= dispatch_queue_create("token", NULL);
    NSMutableDictionary *user = [NSDictionary dictionaryWithObjects:@[@"alfredking",@"123456"] forKeys:@[@"name",@"pass"]];
    NSLog(@"user is %@",user);
        NSMutableArray *originArray = [NSMutableArray new];
    NSString *finalkey =@"finaltest";
    [[NSUserDefaults standardUserDefaults]setObject:user forKey:finalkey];
    [[NSUserDefaults standardUserDefaults]synchronize];
        for (int i = 0 ; i < 10000; i++) {
            dispatch_async(conquene, ^{
                //一种方法是使用@synchronized加锁
//                @synchronized (originArray) {
                    NSLog(@"current thread is %@",[NSThread currentThread]);
//                    [originArray addObject:[NSString stringWithFormat:@"item%ld", i]];
                
                NSMutableDictionary *user =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[[NSUserDefaults standardUserDefaults]objectForKey:finalkey]];
                NSLog(@"in the middle user is %@",user);
                [user setValue:@"test" forKey:@"name"];
                [[NSUserDefaults standardUserDefaults]setObject:user forKey:finalkey];
                [[NSUserDefaults standardUserDefaults]synchronize];
//                }

            });
            
            NSLog(@"outside thread is %@",[NSThread currentThread]);
            NSLog(@"finally final int is %ld",(long)[[NSUserDefaults standardUserDefaults]objectForKey:finalkey]);
            
            //一种方法是使用dispatch_barrier_async来进行写操作
//            dispatch_barrier_async(conquene, ^{
//                NSLog(@"current thread is %@",[NSThread currentThread]);
//                [originArray addObject:[NSString stringWithFormat:@"item%ld", i]];
//                });
        }
    
//    NSLog(@"originArray count is %d",[originArray count]);
//    sleep(2);
//    NSLog(@"originArray count is %d",[originArray count]);
    
    self.view.backgroundColor =[UIColor whiteColor];
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
