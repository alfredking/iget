//
//  XQTableViewController.m
//  Demo
//
//  Created by 格式化油条 on 15/7/7.
//  Copyright (c) 2015年 格式化油条. All rights reserved.
//

#import "XQTableViewController.h"
#import "XQFeedModel.h"
#import "XQFeedCell.h"
#import "UITableView+FDTemplateLayoutCell.h"


//Masonry与UITableView+FDTemplateLayoutCell搭配使用
//https://www.cnblogs.com/geshihuayoutiao/p/4671246.html
//https://blog.csdn.net/wujakf/article/details/79995114
//https://www.jianshu.com/p/bcb4813e3367

@interface XQTableViewController ()

/**
 *  解析json数据后得到的数据
 */
@property (strong, nonatomic) NSArray *feedsDataFormJSON;

/**
 *  用于给数据源使用的数组
 */
@property (strong, nonatomic) NSMutableArray *feeds;
@end

@implementation XQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadJSONData:^{ // 加载完josn数据后要做的操作
        
        self.feeds = @[].mutableCopy;
        
        [self.feeds addObject:self.feedsDataFormJSON.mutableCopy];
        
        // 给一个标识符，告诉tableView要创建哪个类
        [self.tableView registerClass:[XQFeedCell class] forCellReuseIdentifier:@"feedCell"];
        //最开始执行tableview代理的时候没有数据会结束，reloaddata相当于加载数据之后重新触发tableview代理流程
        [self.tableView reloadData];
        
    }];
}

#pragma mark - 加载json数据
- (void) loadJSONData:(void(^)()) then {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataFilePath =[[NSBundle mainBundle] pathForResource:@"dataq" ofType:@"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error:nil];
        
        NSArray *feedArray = dataDictionary[@"feed"];
        
        NSMutableArray *feedArrayM = @[].mutableCopy;
        
        //遍历为类方法
        //https://www.jianshu.com/p/5d4a8be9baf7
        [feedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [feedArrayM addObject:[XQFeedModel feedWithDictionary:obj]];
        }];
        
        self.feedsDataFormJSON = feedArrayM;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            !then ? : then();
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.feeds count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"**************************");
    NSLog( @"section is %ld, count is %lu " ,(long)section,(unsigned long)[self.feeds[section] count]);
    return [self.feeds[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XQFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];
    
    [self setupModelOfCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void) setupModelOfCell:(XQFeedCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
//    cell.fd_enforceFrameLayout = NO;
    
    cell.feed = self.feeds[indexPath.section][indexPath.row];
}

//代理方法调用次数的说明https://www.jianshu.com/p/c67dfa3ecd11
//iOS7.1中先依次调一遍heightForRow方法再依次调一遍cellForRow方法，在调cellForRow方法的时候并不会再调一次对应的heightForRow方法。

//iOS8中先依次调heightForRow（如果行数超过屏幕依次调用两次，如果行数很少，没有超过屏幕，只依次调用一次），之后每调一次cellForRow的时候又调一次对应的heightForRow方法。
//
//------
//
//2017-03-27补充
//
//经测试，在iOS9和iOS10上，heightForRow方法会先调用三次，然后每调用一次cellForRow的时候再调用一次对应的heightForRow。


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSLog(@"heightForRowAtIndexPath called");
    return [self.tableView fd_heightForCellWithIdentifier:@"feedCell" cacheByIndexPath:indexPath configuration:^(XQFeedCell *cell) {
        
        // 在这个block中，重新cell配置数据源
        //这个重新配置的意义在于把具体cell信息传递给模板用来计算约束，算出最终的height
        [self setupModelOfCell:cell atIndexPath:indexPath];
    }];
}

@end
