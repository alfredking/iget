//
//  TestMultiThreadViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/1/9.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestMultiThreadViewController.h"
#import <pthread.h>
@interface TestMultiThreadViewController ()

@end

@implementation TestMultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self pthreadDemo];
    
//    [self nsthreadDemo];
    
    
//    [self gcddemo];
    
//    [self gcddemo2];
//      [self gcddemo3];
//    [self nsoperationdemo];
    [self nsoperationdemo2];
}

// 创建线程，并且在线程中执行 demo 函数
- (void)pthreadDemo {
    /**
     参数：
     1> 指向线程标识符的指针，C 语言中类型的结尾通常 _t/Ref，而且不需要使用 *
     2> 用来设置线程属性
     3> 线程运行函数的起始地址
     4> 运行函数的参数

     返回值：
     - 若线程创建成功，则返回0
     - 若线程创建失败，则返回出错编号
     */
    pthread_t threadId = NULL;
    NSString *str = @"Hello Pthread";
    // 这边的demo函数名作为第三个参数写在这里可以在其前面加一个&，也可以不加，因为函数名就代表了函数的地址。
    int result = pthread_create(&threadId, NULL, demo, (__bridge void *)(str));

    if (result == 0) {
        NSLog(@"创建线程 OK");
    } else {
        NSLog(@"创建线程失败 %d", result);
    }
    // pthread_detach:设置子线程的状态设置为detached,则该线程运行结束后会自动释放所有资源。
    pthread_detach(threadId);
}

// 后台线程调用函数
void *demo(void *params) {
    NSString *str = (__bridge NSString *)(params);

    NSLog(@"%@ - %@", [NSThread currentThread], str);

    return NULL;
}

-(void)nsthreadDemo
{
    // 创建
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(download) object:nil];
    // 设置线程的名字
    thread.name = @"下载线程01";
    // 设置线程的优先级(取值 0.0 - 1.0)
    thread.threadPriority = 0.5;
    // 启动
    [thread start];
    
}

#pragma mark 异步串行队列
-(void)gcddemo
{
// 1.创建一个串行队列,意味着说队列里的任务是一个接着一个执行(类似于排队跑步)
    dispatch_queue_t q = dispatch_queue_create("gz.itcast.cn", DISPATCH_QUEUE_SERIAL);
// 2.往 ‘队列中’ 添加 ‘任务’,这个任务是异步的,// 异步意味着任务的执行会开启新线程来执行,我们称为子线程
    for (int i = 0; i < 10; i++) {dispatch_async(q, ^{
    NSLog(@"%@ 任务%d",[NSThread currentThread],i);});
    }
    
}

#pragma mark 异步并行队列
-(void)gcddemo2
{
// 1.创建一个并行队列,意味着说队列里的任务是抢着执行(类似于并排跑步比赛)
    dispatch_queue_t q = dispatch_queue_create("gz.itcast.cn", DISPATCH_QUEUE_CONCURRENT);
// 2.往 ‘队列中’ 添加 ‘任务’,这个任务是异步的,异步意味着任务的执行是在子线程// 在异步任务中,并行队列里的任务会抢占式执行// 线程的开销由系统调试,任务的执行顺序是不同的
    for (int i = 0; i < 10; i++)
    {
        dispatch_async(q, ^{
        NSLog(@"%@ 任务%d",[NSThread currentThread],i);});
    }

}

#pragma mark 全局队列
-(void)gcddemo3
{
// 1.获取全局队列,全局队列供所有APP使用
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
// 2.往 ‘全局队列’ 添加 ‘任务’
    
    // 2.1异步里添加同步
    dispatch_async(q, ^{
    NSLog(@"异步任务 %@ ",[NSThread currentThread]);
    for (int i = 0; i < 10; i++)
    {
        //在同步任务中,全局队列里的任务会顺序执行
        dispatch_sync(q, ^{
          NSLog(@"%@ 同步任务%d",[NSThread currentThread],i);
        });
    }
        
    });
    
    //2.2同步里添加异步
    dispatch_sync(q, ^{
    NSLog(@"同步任务 %@ ",[NSThread currentThread]);
        for (int i = 0; i < 10; i++) {
            //在异步任务中,全局队列里的任务会抢战执行
            dispatch_async(q, ^{
              NSLog(@"%@ 异步任务%d",[NSThread currentThread],i);
            });
        }
        
    });
}

-(void)nsoperationdemo
{
    
         NSOperationQueue *myQueue=[[NSOperationQueue alloc]init];
         NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
           //延时2秒
            sleep(2);
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"success");
            });
        }];
        [myQueue addOperation:operation];
}

-(void)nsoperationdemo2
{
    
    //自建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task0---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"task1---%@", [NSThread currentThread]);

    }];
    [op addExecutionBlock:^{
        NSLog(@"task2---%@", [NSThread currentThread]);

    }];
    [op addExecutionBlock:^{
        NSLog(@"task3---%@", [NSThread currentThread]);

    }];
    [queue addOperation:op];
    NSLog(@"操作结束");

}

-(void)download
{
 [self performSelectorOnMainThread:@selector(back:) withObject:@"back" waitUntilDone:NO];
}
-(void)back:(id)obj
{
    NSLog(@"%@",obj);
  NSLog(@"%@",[NSThread currentThread]);
}

//提供了一些GCD不好实现的，”最大并发数“
//
//暂停/继续 --- 挂起
//
//取消所有的任务
//
//依赖关系
//
//有KVO，可以监测operation是否正在执行（isExecuted）、是否结- 束（isFinished），是否取消（isCanceld）。
//
//NSOperationQueue可以 方便的管理并发、NSOperation之间的优先级。
//
//两者对比：就我在开发中的使用情况来看，不需要用到依赖和最大并发数就用GCD来进行多线程操作，因为苹果对其进行过性能上的优化，效率更高。


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
