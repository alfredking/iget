//
//  testThreadViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/18.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testThreadViewController.h"

@interface testThreadViewController ()

@end

@implementation testThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
//    NSLog(@"------------------1");
//       dispatch_queue_t queue = dispatch_get_main_queue();
//       dispatch_async(queue, ^{
//           NSLog(@"主队列异步   %@",[NSThread currentThread]);
//       });
//       NSLog(@"------------------2");
    
    
    // 主队列同步
//        NSLog(@"------------------1");
//        dispatch_queue_t queue = dispatch_get_main_queue();
//        dispatch_sync(queue, ^{
//            NSLog(@"主队列同步   %@",[NSThread currentThread]);
//        });
//        NSLog(@"------------------2");
    
//    dispatch_queue_t queue =dispatch_queue_create("jz",DISPATCH_QUEUE_SERIAL);
//        dispatch_sync(queue, ^{
//            for (int i =0; i <3; i ++) {
//                NSLog(@"task1------%@", [NSThread currentThread]);
//            }
//        });
//        dispatch_sync(queue, ^{
//            for (int i =0; i <3; i ++) {
//                NSLog(@"task2------%@", [NSThread currentThread]);
//            }
//        });
//        dispatch_sync(queue, ^{
//            for (int i =0; i <3; i ++) {
//                NSLog(@"task3------%@", [NSThread currentThread]);
//            }
//        });
    
//    dispatch_queue_t queue =dispatch_queue_create("serial",DISPATCH_QUEUE_SERIAL);
//       dispatch_async(queue, ^{
//           for (int i =0; i <3; i ++) {
//               NSLog(@"task1------%@", [NSThread currentThread]);
//           }
//       });
//       dispatch_async(queue, ^{
//           for (int i =0; i <3; i ++) {
//               NSLog(@"task2------%@", [NSThread currentThread]);
//           }
//       });
//       dispatch_async(queue, ^{
//           for (int i =0; i <3; i ++) {
//               NSLog(@"task3------%@", [NSThread currentThread]);
//           }
//       });
    
//    dispatch_queue_t queue =dispatch_queue_create("concurrent",DISPATCH_QUEUE_CONCURRENT);
//      dispatch_sync(queue, ^{
//          for (int i =0; i <3; i ++) {
//              NSLog(@"task1------%@", [NSThread currentThread]);
//          }
//      });
//      dispatch_sync(queue, ^{
//          for (int i =0; i <3; i ++) {
//              NSLog(@"task2------%@", [NSThread currentThread]);
//          }
//      });
//      dispatch_sync(queue, ^{
//          for (int i =0; i <3; i ++) {
//              NSLog(@"task3------%@", [NSThread currentThread]);
//          }
//      });

    dispatch_queue_t serialqueue =dispatch_queue_create("concurrent",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serialqueue2 =dispatch_queue_create("concurrent2",DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue =dispatch_queue_create("concurrent",DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(serialqueue, ^{
            
            
            
            for (int i =0; i <3; i ++) {
                NSLog(@"task1------%@", [NSThread currentThread]);
            }
            
            
            
            
            
        });
    
    dispatch_async(serialqueue2, ^{
        for (int i =0; i <3; i ++) {
            NSLog(@"task2------%@", [NSThread currentThread]);
        }
    });
        
        dispatch_async(serialqueue, ^{
            for (int i =0; i <3; i ++) {
                NSLog(@"task3------%@", [NSThread currentThread]);
            }

        });


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
