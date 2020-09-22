//
//  ViewController.m
//  上下滚动
//
//  Created by chinajes on 2017/7/10.
//  Copyright © 2017年 chinajes. All rights reserved.
//p162 各种dispatch

#import "WeiboViewController.h"

@interface WeiboViewController ()

@property(nonatomic, weak)UILabel *label1;

@property(nonatomic, weak)UILabel *label2;

@property(nonatomic, strong)UILabel *label3;

@property(nonatomic, strong)NSArray *array;

@property(nonatomic, assign)NSInteger count;

@property(nonatomic, strong)NSTimer *timer;
@end

@implementation WeiboViewController

- (NSArray *)array{
    
    if (_array == nil) {
        _array = @[@"我就想说:还有谁?",@"我可以一直杀",@"国服第一JS",@"我一贱,你就笑"];
    }
    return _array;
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 repeats:1 block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer is running");
        [UIView animateWithDuration:1 animations:^{
            
            self.label1.frame = CGRectMake(0, -15, 100, 15);
            
            self.label2.frame = CGRectMake(0, 0, 100, 15);
            
        } completion:^(BOOL finished) {
            
            self.label1.frame = CGRectMake(0, 15, 100, 15);
            
            if (self.count < self.array.count - 1) {
                self.count ++;
                
                self.label1.text = self.array[self.count];
                
            }else{
                self.count = 0;
                self.label1.text = self.array[self.count];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:1 animations:^{
                    
                    self.label2.frame = CGRectMake(0, -15, 100, 15);
                    self.label1.frame = CGRectMake(0, 0, 100, 15);
                    
                } completion:^(BOOL finished) {
                    
                    self.label2.frame = CGRectMake(0, 15, 100, 15);
                    
                    if (self.count < self.array.count - 1) {
                        self.count ++;
                        
                        self.label2.text = self.array[self.count];
                        
                    }else{
                        self.count = 0;
                        self.label2.text = self.array[self.count];
                    }
                }];
                
            });
            
            
        }];
    }];
    
    
    self.timer = timer;
    
    // 开启定时器
    
    [timer setFireDate:[NSDate distantPast]];
    
    
    
    
    //[[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    //注释了也可以运行，底层加入tableview滑动timer就停止了
    
    //解决方法一：timer加入到NSRunLoopCommonModes
    //解决方法二：timer放到另外一个线程中，开启另外一个线程的runloop
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:4 repeats:1 block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timer is running");}];
        [[NSRunLoop currentRunLoop]run];
    });
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    
    // 关闭定时器
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 按钮
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 30, 30)];
//    button.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:button];
//    
//    [button addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    // bgView
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 150, 15)];

    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor yellowColor];

    [self.tableView addSubview:bgView];
    
    self.label3 = [[UILabel alloc]initWithFrame:CGRectMake(200 , 200, 50, 50)];
    self.label3.backgroundColor = [UIColor greenColor];
    self.label3.text = @"开始"  ;
    
    //2秒之后把开始变成结束
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        self.label3.text = @"结束"  ;
    });
    
    
    //p162
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"开始做任务1！");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"开始做任务2！");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@" 任务1和任务2都完成了！");
    });
    
    
    
    
    
    [self.tableView addSubview:_label3];

    // 11111
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    self.label1 = label1;
    self.label1.font = [UIFont systemFontOfSize:12];


    label1.text = self.array[0];;

    label1.backgroundColor = [UIColor redColor];

    [bgView addSubview:label1];


    // 22222
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 100, 15)];
    self.label2 = label2;
    self.label2.font = [UIFont systemFontOfSize:12];
    label2.backgroundColor = [UIColor blueColor];

    label2.text = self.array[1];

    [bgView addSubview:label2];

    self.count = 1;
    
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//
    

   
    
}

//- (void)didClickBtn{
//    
//    [UIView animateWithDuration:1 animations:^{
//        
//        self.label1.frame = CGRectMake(0, -15, 100, 15);
//        
//        self.label2.frame = CGRectMake(0, 0, 100, 15);
//        
//    } completion:^(BOOL finished) {
//        
//        self.label1.frame = CGRectMake(0, 15, 100, 15);
//        
//        [UIView animateWithDuration:1 animations:^{
//            self.label2.frame = CGRectMake(0, -15, 100, 15);
//            self.label1.frame = CGRectMake(0, 0, 100, 15);
//        } completion:^(BOOL finished) {
//            self.label2.frame = CGRectMake(0, 15, 100, 15);
//        }];
//        
//    }];
//    
//}

//- (NSInteger)numberOfRowsInSection:(NSInteger)section
//{
//    return 50;
//}
//两个有什么区别
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineTableViewCell"];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
