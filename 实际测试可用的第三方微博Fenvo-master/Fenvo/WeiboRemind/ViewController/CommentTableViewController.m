//
//  CommentTableViewController.m
//  Fenvo
//
//  Created by Caesar on 15/8/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentTableViewCell.h"

#import "WeiboComment.h"
#import "WeiboCommentManager.h"
#import "CommentRPC.h"
#import "DiskCacheManager.h"

#import "MJRefresh.h"

@interface CommentTableViewController ()
{
    NSMutableArray *_commentArray;
    
    //下次返回比since_id晚的微博, 或者比max_id早的微博
    NSNumber *_since_id;
    NSNumber *_max_id;
    
    BOOL _isFindInCoreData;
    UIActivityIndicatorView *_indicator;
}
@end

@implementation CommentTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = RGBACOLOR(250, 143, 5, 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFindInCoreData = true;
    
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.tableView = [[ANBlurredTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
//    [self.tableView setAnimateTintAlpha:YES];
//    [self.tableView setStartTintAlpha:0.2f];
    [self.tableView setEndTintAlpha:0.6f];
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    
    _commentArray = [[NSMutableArray alloc]init];
    _indicator = [[UIActivityIndicatorView alloc]init];
    _indicator.center = self.view.center;
    [self.tableView addSubview: _indicator];
    [self addHeaderRefreshViewController];
    [self getCommentWhenViewDidLoad];
}

- (void)addHeaderRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshComment)];

    //
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;

    //
    [self.tableView.header setTitle:@"Pull up to refresh" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"Release to refresh" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"Refreshing" forState:MJRefreshHeaderStateRefreshing];
    
}

- (void)addFooterRefreshViewController {
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreCommentFromRemote)];
    self.tableView.footer.font = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor = TEXT_COLOR;
    
    [self.tableView.footer setTitle:@"Pull down to refresh" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"Release to refresh" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.footer setTitle:@"Refreshing" forState:MJRefreshFooterStateRefreshing];

}


- (void)getCommentWhenViewDidLoad {
    
    [_indicator startAnimating];
    
    [DiskCacheManager extractObjectWithKey:@"CommentToMe"
                                objectType:CacheObjectType_Comment
                                   success:^(NSArray *arrTimeLine, NSNumber *since_id, NSNumber *max_id) {
                                       
                                       _commentArray    = [[NSMutableArray alloc]initWithArray:arrTimeLine];
                                       
                                       _max_id          = max_id;
                                       _since_id        = since_id;
                                       
                                       [self reloadData];
                                       
                                       [self addFooterRefreshViewController];
                                       
                                       [_indicator stopAnimating];
                                       
                                   } failure:^(NSString *description) {
                                       [self clearAndRequestFromRemote];
                                   }];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)clearAndRequestFromRemote {
    
    _isFindInCoreData = false;
    
    //清除所有缓存
    [WeiboCommentManager removeAllComment];
    
    [CommentRPC getCommentWithSinceId:nil
                              orMaxId:nil
                              success:^(NSArray *commentArr, NSNumber *since_id, NSNumber *max_id) {
                                  
                                  _since_id     = since_id;
                                  _max_id       = max_id;
                                  _commentArray = [[NSMutableArray alloc]initWithArray:commentArr];
                                  
                                  [self reloadData];
                                  
                                  [self addFooterRefreshViewController];
                                  
                                  [_indicator stopAnimating];
                                  
                                  dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                      [DiskCacheManager compressObject:[_commentArray copy]
                                                            ObjectType:CacheObjectType_Comment
                                                           autoSaveKey:@"CommentToMe"];
                                  });
                                  
                              } failure:^(NSString *desc, NSError *error) {
                                  NSLog(@"%@", desc);
                              }];
    
}
     
- (void)refreshComment{
    
    if (_since_id == nil) {
        [self clearAndRequestFromRemote];
        return;
    }
    
    [CommentRPC getCommentWithSinceId:_since_id
                              orMaxId:nil
                              success:^(NSArray *commentArr, NSNumber *since_id, NSNumber *max_id) {
                                  if (commentArr.count > 0) {
                                      for (long i = (commentArr.count - 1); i >= 0; i --) {
                                          WeiboComment *comment = (WeiboComment *)commentArr[i];
                                          [_commentArray insertObject:comment atIndex:0];
                                      }
                                      _max_id = max_id;
                                  }
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tableView reloadData];
                                      [self.tableView.header endRefreshing];
                                  });
                                  
                                  dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                      [DiskCacheManager compressObject:[_commentArray copy]
                                                            ObjectType:CacheObjectType_Comment
                                                           autoSaveKey:@"CommentToMe"];
                                  });
                                  
                              } failure:^(NSString *desc, NSError *error) {
                                  [self.tableView.header endRefreshing];
                                  NSLog(@"CommentVC:RefreshComment---Get Comment Failure.");
                              }];
    
    
}

- (void)getMoreCommentFromRemote {
    
    _isFindInCoreData = false;
    
    [CommentRPC getCommentWithSinceId:nil
                              orMaxId:_max_id
                              success:^(NSArray *commentArr, NSNumber *since_id, NSNumber *max_id) {
                                  [self reloadData:commentArr];
                                  [self.tableView.footer endRefreshing];
                                  
                                  dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                      [DiskCacheManager compressObject:[_commentArray copy]
                                                            ObjectType:CacheObjectType_Comment
                                                           autoSaveKey:@"CommentToMe"];
                                  });
                                  
                              } failure:^(NSString *desc, NSError *error) {
                                  NSLog(@"CommentVC:getMoreCommentFromRemote---Get Comment Failure");
                                  [self.tableView.footer endRefreshing];
                                  
                              }];
    
}

- (void)reloadData:(NSArray *)commentArr {
    
    if (commentArr.count > 0) {
        for (int i = 1; i < commentArr.count; i ++) {
            WeiboComment *comment = (WeiboComment *)commentArr[i];
            [_commentArray addObject:comment];
        }
    }else {
        NSLog(@"CommentVC:getMoreCommentFromRemote---Get Comment Count: 0.");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    });
    
    [self getMaxId:[_commentArray lastObject]];
}

- (void)getMaxId:(WeiboComment *)comment {
    
    _max_id = comment.ids;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"commentCell";
    //[NSString stringWithFormat:@"cell%ld%ld",indexPath.row,refreshtime];
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    
    WeiboComment *comment = _commentArray[indexPath.row];
    cell.comment = comment;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboComment *comment = _commentArray[indexPath.row];
    CGFloat yHeight = comment.height.floatValue;
    return yHeight;
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
