//
//  testProducerConsumerViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/4/3.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testProducerConsumerViewController.h"

@interface testProducerConsumerViewController ()

@property(nonatomic ,strong)NSCondition* cond;
@property(nonatomic ,assign)NSUInteger productNum;

//@property(nonatomic ,strong)NSMutableArray *products;
//@property(nonatomic ,strong)NSCondition *condition ;

@end

@implementation testProducerConsumerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(10, 310, 100, 50)];
    [button1 setTitle:@"生产者" forState:UIControlStateNormal];
    button1.backgroundColor=[UIColor grayColor];
    [button1 addTarget:self action:@selector(producerHandle) forControlEvents:UIControlEventTouchUpInside];
//    [button1 addTarget:self action:@selector(createProducter) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(150, 310, 100, 50)];
    [button2 setTitle:@"消费者" forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor greenColor];
    [button2 addTarget:self action:@selector(customerHandle)  forControlEvents:UIControlEventTouchUpInside];
//    [button2 addTarget:self action:@selector(createConsumenr)  forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    
    NSLog(@"begin condition works!");
//    products = [[NSMutableArray alloc] init];
//    condition = [[NSCondition alloc] init];
     
//    [NSThread detachNewThreadSelector:@selector(createProducter) toTarget:self withObject:nil];
//    [NSThread detachNewThreadSelector:@selector(createConsumenr) toTarget:self withObject:nil];
}



// 生产者生产数据
-(void)producerHandle {
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSString *currentThreadName = [NSThread currentThread].name;
                NSLog(@"%@" ,currentThreadName);
        
        //生产者限制生产数
        [self.cond lock];
        if (self.productNum > 10) {
            NSLog(@"!!!!生产太多，限制");
            NSLog(@"限制之后个数 - %lu" ,self.productNum);
            [self.cond unlock];
            sleep(1);
        
        }else {
            
            NSLog(@"============================");
            NSLog(@"%@...Begin - %lu" ,currentThreadName ,self.productNum);
            self.productNum++;
            [self.cond signal];
            NSLog(@"%@...end - %lu" ,currentThreadName ,self.productNum);
            NSLog(@"============================");
            [self.cond unlock];
        }
        
    });
        
        
       
    
}

// 消费者消费资源
-(void)customerHandle {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSString *currentThreadName = [NSThread currentThread].name;
        //        NSLog(@"%@" ,currentThreadName);
        [self.cond lock];
        NSLog(@"============================");
        NSLog(@"%@...消费者Begin - %lu" ,currentThreadName ,self.productNum);
        while (self.productNum <= 0) {
            [self.cond wait];
        }
       
        self.productNum--;
        NSLog(@"%@...消费者end - %lu" ,currentThreadName ,self.productNum);
        NSLog(@"============================");
        [self.cond unlock];
        
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
