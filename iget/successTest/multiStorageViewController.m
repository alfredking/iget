//
//  multiStorageViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/2/7.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "multiStorageViewController.h"
#import <AFNetworking.h>

@interface multiStorageViewController ()

@end

@implementation multiStorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_queue_t seQueue = dispatch_queue_create("alfredking", 0);
    NSString *finalkey =@"finaltest";
//    NSMutableArray *originArray = [NSMutableArray new];
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:finalkey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    for (int i =0; i<1; i++) {
        dispatch_async(seQueue, ^{
            NSLog(@"current thread is %@",[NSThread currentThread]);
            
//            [AFHTTPSessionManager manager]
            
            NSInteger current =[[NSUserDefaults standardUserDefaults]integerForKey:finalkey];
            current =current+1;
            [[NSUserDefaults standardUserDefaults]setInteger:current forKey:finalkey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSLog(@"final int is %ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:finalkey]);
            
//            sleep(2);
            
            [[AFHTTPSessionManager manager]GET:@"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e" parameters:nil headers: nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
//                NSLog(@"af progress is %lld",downloadProgress.completedUnitCount);
                NSLog(@"progress thread %@",[NSThread currentThread]);

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"af success object is %@",responseObject);
                NSLog(@"success thread %@",[NSThread currentThread]);
                
                NSLog(@"success block final int is %ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:finalkey]);
                NSInteger current =[[NSUserDefaults standardUserDefaults]integerForKey:finalkey];
                current =current+1;
                [[NSUserDefaults standardUserDefaults]setInteger:current forKey:finalkey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSLog(@"after success block final int is %ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:finalkey]);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"af failure error is %@",error);
                NSLog(@"failure thread %@",[NSThread currentThread]);
            }];
        });
    }
//    sleep(4);
    
    NSLog(@"outside thread is %@",[NSThread currentThread]);
    NSLog(@"finally final int is %ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:finalkey]);
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
