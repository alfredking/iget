//
//  FollowingListViewTableViewController.m
//  Fenvo
//
//  Created by Caesar on 15/6/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowingListTableViewController.h"
#import "KVNProgress.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "WeiboUserInfo.h"
#import "UIImageView+WebCache.h"
#import "FollowingListViewCell.h"
#import "MJRefresh.h"

#define WBAPIURL_FOLLOWING @"https://api.weibo.com/2/friendships/friends.json"

@interface FollowingListTableViewController ()<UIScrollViewDelegate>
{
    NSMutableArray *_followingArray;
    NSMutableArray *_weiboCells;
    long long _next_cursor;
    long long _previous_cursor;
    long long _total_number;
}
@end

@implementation FollowingListTableViewController

- (void)viewDidLoad {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"opaque_b.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = RGBACOLOR(250, 143, 5, 1);
    [self setTitle:@"Following"];
    
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    
    [super viewDidLoad];
    _next_cursor = 0;
    _previous_cursor = 0;
    _followingArray = [[NSMutableArray alloc]init];
    [self addRefreshViewController];
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
    [self downloadData];
}

- (void)addRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    //
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;
    self.tableView.footer.font = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor = TEXT_COLOR;
    //
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"客官您稍等，我马上帮你拉" forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"上拉加载更多" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.footer setTitle:@"客官您稍等，我马上拉给你 " forState:MJRefreshFooterStateRefreshing];
}

- (void)downloadData{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30.0f];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.0f;
    configuration.fullScreen = YES;
    configuration.allowUserInteraction = YES;
    
    [KVNProgress setConfiguration:configuration];
    [KVNProgress showWithStatus:@"Loading..."];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
            //http请求头应该添加text/plain。接受类型内容无text/plain
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            NSString *getFollowingUrl = WBAPIURL_FOLLOWING;
            NSDictionary *dict0 = [[NSDictionary alloc]init];
            //NSNumber *next_cursor = [NSNumber numberWithLongLong:_next_cursor];
            dict0 = @{@"access_token":delegate.wbtoken, @"uid":_uid};
            [manager GET:getFollowingUrl
              parameters:dict0
                 success:^(AFHTTPRequestOperation *operation, id responserObject){
                     NSError *error;
                     NSLog(@"%@",responserObject);
                     //解析数据
                     NSData *jsonDatas = [responserObject
                                          JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                          error:&error];
                     NSString *jsonStrings = [[NSString alloc]
                                              initWithData:jsonDatas
                                              encoding:NSUTF8StringEncoding];
                     NSArray *followingArray = [self getNormalJSONString:jsonStrings];
                     _followingArray = [[NSMutableArray alloc]init];
                     //若请求数据解析成功
                     if (followingArray.count > 0) {
                         for (int i = 0; i < followingArray.count; i ++) {
                             NSDictionary *dict = followingArray[i];
                             WeiboUserInfo *userInfo = [WeiboUserInfo createdByDictionary:dict];
                             [_followingArray addObject:userInfo];
                         }
                     }
                     
                     
                     //刷新界面
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadData];
                         [self.tableView.header endRefreshing];
                         [self.tableView.footer endRefreshing];
                         [KVNProgress dismiss];
                     });
                 }
                 //若失败
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     [KVNProgress showError];
                     [self.tableView.header endRefreshing];
                     [self.tableView.footer endRefreshing];
                     [KVNProgress dismiss];
                 }];
        });
}

-(void)getMoreData {
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getFollowingUrl = WBAPIURL_FOLLOWING;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *next_cursor = [NSNumber numberWithLongLong:_next_cursor];
        dict0 = @{@"access_token":delegate.wbtoken, @"uid":_uid, @"cursor":next_cursor};
        [manager GET:getFollowingUrl
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 //解析数据
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 NSArray *followingArray = [self getNormalJSONString:jsonStrings];
                 
                 
                 //添加到数组
                 if (followingArray.count > 0) {
                     for (long i = 0; i < followingArray.count; i ++) {
                         NSDictionary *dict = followingArray[i];
                         WeiboUserInfo *userInfo = [WeiboUserInfo createdByDictionary:dict];
                         [_followingArray addObject:userInfo];
                     }
                 }
                 
                 //主线程刷新数据
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                     [KVNProgress showSuccess];
                     [self.tableView.footer endRefreshing];
                 });
                 
             }
             //如果失败
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [KVNProgress showError];
             }];
    });


}


#pragma mark - 微博API返回的数据不是标准的json格式数据。我们需要返回的String类型JSON数据进行一定的处理

- (NSArray *)getNormalJSONString:(NSString *)jsonStrings{
    NSDictionary *jsonDictionary = [jsonStrings objectFromJSONString];
    _next_cursor = [jsonDictionary[@"next_cursor"]longLongValue];
    _previous_cursor = [jsonDictionary[@"previous_cursor"]longLongValue];
    _total_number = [jsonDictionary[@"total_number"]intValue];
    NSArray *user = jsonDictionary[@"users"];
    NSLog(@"*********%@",user);
    return user;
}


- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _followingArray.count;
}


- (FollowingListViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"followingCell";//注意cell中，它的identifier设置为“cell”
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    FollowingListViewCell *cell;
        
    cell = (FollowingListViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        UINib *nibs = [UINib nibWithNibName:@"FollowingListViewCell" bundle:nil];
        cell = [nibs instantiateWithOwner:nil options:nil][0];
           
    }
    
    // Configure the cell...
    WeiboUserInfo *userInfo = _followingArray[indexPath.row];
    cell.userInfo = userInfo;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
/*
 //设置上滑隐藏导航栏，但体验不好
#pragma mark - UIScorllViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (velocity.y > 0.2) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
