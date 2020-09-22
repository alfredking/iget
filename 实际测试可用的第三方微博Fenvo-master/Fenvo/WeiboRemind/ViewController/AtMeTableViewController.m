//
//  AtMeTableViewController.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AtMeTableViewController.h"
#import "AtMeTableViewCell.h"

#import "WeiboAtMeStore.h"
#import "WeiboAtMeManaer.h"
#import "AtMeRPC.h"
#import "WeiboMsg.h"

#import "MJRefresh.h"

@interface AtMeTableViewController ()
{
    NSMutableArray *_atMeArray;
    
    //下次返回比since_id晚的微博, 或者比max_id早的微博
    NSNumber *_since_id;
    NSNumber *_max_id;
    
    BOOL _isFindInCoreData;
}
@end

@implementation AtMeTableViewController



- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = RGBACOLOR(250, 143, 5, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFindInCoreData = true;
    
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.tableView = [[ANBlurredTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [self.tableView setEndTintAlpha:0.6f];
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    
    _atMeArray = [[NSMutableArray alloc]init];
    [self getAtMeWhenViewDidLoad];
}

- (void)addHeaderRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshAtMe)];
    
    //
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;
    
    //
    [self.tableView.header setTitle:@"Pull up to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Refreshing" forState:MJRefreshHeaderStateRefreshing];
    
}

- (void)addFooterRefreshViewController {
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreAtMe)];
    self.tableView.footer.font = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor = TEXT_COLOR;
    
    [self.tableView.footer setTitle:@"Pull down to refresh" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"Release to refresh" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.footer setTitle:@"Refreshing" forState:MJRefreshFooterStateRefreshing];
    
}

- (void)getAtMeWhenViewDidLoad {
    
    [WeiboAtMeManaer queryAllAtMeStoreSucces:^(NSArray *atMeArray, NSNumber *max_id) {
        _atMeArray = [[NSMutableArray alloc]initWithArray:atMeArray];
        WeiboMsg *weiboMsg = ((WeiboAtMeStore *)[_atMeArray firstObject]).weiboMsg;
        _max_id = max_id;
        _since_id = weiboMsg.ids;
        [self reloadData];
        [self addFooterRefreshViewController];
    } failure:^(NSString *desc) {
        [self clearAndRequestFromRemote];
    }];
    
    [self addHeaderRefreshViewController];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    });
}

- (void)clearAndRequestFromRemote {
    
    _isFindInCoreData = false;
    
    //清除所有缓存
    [WeiboAtMeManaer removeAllAtMeStore];
    [AtMeRPC getAtMeWithSinceId:nil
                        orMaxId:nil
                       atMeType:AtMeType_FromAll
                        success:^(NSArray *atMeArray, NSNumber *max_id) {
                            _max_id = max_id;
                            WeiboMsg *weiboMsg = ((WeiboAtMeStore *)[_atMeArray firstObject]).weiboMsg;
                            _since_id = weiboMsg.ids;
                            _atMeArray = [[NSMutableArray alloc]initWithArray:atMeArray];
                            [self addFooterRefreshViewController];
                            [self reloadData];
                        } failure:^(NSString *desc, NSError *error) {
                            NSLog(@"%@", desc);
                            [self reloadData];
                        }];
    
}

- (void)refreshAtMe{
    
    if (_since_id == nil) {
        [self clearAndRequestFromRemote];
        return;
    }
    [AtMeRPC getAtMeWithSinceId:_since_id
                        orMaxId:nil
                       atMeType:AtMeType_FromAll
                        success:^(NSArray *atMeArray, NSNumber *max_id) {
                            if (atMeArray.count > 0) {
                                for (long i = (atMeArray.count - 1); i >= 0; i --) {
                                    WeiboAtMeStore *atMe = (WeiboAtMeStore *)atMeArray[i];
                                    [_atMeArray insertObject:atMe atIndex:0];
                                }
                                _max_id = max_id;
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                                [self.tableView.header endRefreshing];
                            });
                        } failure:^(NSString *desc, NSError *error) {
                            [self.tableView.header endRefreshing];
                            NSLog(@"AtMeVC:RefreshAtMe---Get AtMe Failure.");
                        }];
    
}

- (void)getMoreAtMe{
    
    if (_isFindInCoreData == false) {
        [self getMoreAtMeFromRemote];
        return;
    };
    [WeiboAtMeManaer queryAtMeStoreWithMaxId:_max_id
                                     success:^(NSArray *atMeArray, NSNumber *max_id) {
                                         if (atMeArray.count > 0) {
                                             [self reloadData:atMeArray];
                                         }
                                         else {
                                             [self getMoreAtMeFromRemote];
                                         }
                                     } failure:^(NSString *desc) {
                                         [self getMoreAtMeFromRemote];
                                     }];
}

- (void)getMoreAtMeFromRemote {
    
    _isFindInCoreData = false;
    
    [AtMeRPC getAtMeWithSinceId:nil
                        orMaxId:_max_id
                       atMeType:AtMeType_FromAll
                        success:^(NSArray *atMeArray, NSNumber *max_id) {
                            [self reloadData:atMeArray];
                            [self.tableView.footer endRefreshing];
                        } failure:^(NSString *desc, NSError *error) {
                            NSLog(@"AtMeVC:getMoreAtMeFromRemote---Get AtMe Failure");
                            [self.tableView.footer endRefreshing];
                        }];
}

- (void)reloadData:(NSArray *)atMeArray {
    
    if (atMeArray.count > 0) {
        for (int i = 1; i < atMeArray.count; i ++) {
            WeiboAtMeStore *atMe = (WeiboAtMeStore *)atMeArray[i];
            [_atMeArray addObject:atMe];
        }
    }else {
        NSLog(@"CommentVC:getMoreCommentFromRemote---Get Comment Count: 0.");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    });
    
    [self getMaxId:((WeiboAtMeStore *)[_atMeArray lastObject]).weiboMsg];
}

- (void)getMaxId:(WeiboMsg *)weiboMsg {
    
    _max_id = weiboMsg.ids;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _atMeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //去除重用机制
    NSString *cellIdentifier = @"atMeCell";
    
    AtMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[AtMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    
    WeiboAtMeStore *atMe = _atMeArray[indexPath.row];
    cell.atMeStore = atMe;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboAtMeStore *atMe = _atMeArray[indexPath.row];
    CGFloat yHeight = atMe.height.floatValue;
    return yHeight;
}


@end
