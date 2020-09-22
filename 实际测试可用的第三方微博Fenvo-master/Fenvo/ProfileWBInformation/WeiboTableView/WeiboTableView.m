//
//  WeiboTableView.m
//  Fenvo
//
//  Created by Caesar on 15/5/21.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboMsg.h"
#import "PersonalWeiboViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "WeiboViewController.h"
#import "JSONKit.h"
#import "MJRefresh.h"
#import "WeiboAvatarView.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "KVNProgress.h"


@interface WeiboTableView(){
    //NSMutableArray *_weiboMsgArray;
    NSMutableArray *_weiboCells;;
    NSMutableArray *_array;
    
    CGSize screenSize;
    NSInteger page;
    NSMutableArray *_tmp;
    NSInteger refreshtime;
    
    //刷新微博
    //下次返回比since_id晚的微博
    long long _since_id;
    //根据max_id返回比max_id早的微博
    long long _max_id;
    //next_cursor、previous_cursor指定返回的之后、之前的游标值。暂未支持
    long long _next_cursor;
    long long _previous_cursor;
}
@end

@implementation WeiboTableView
@synthesize weiboMsgArray = _weiboMsgArray;

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"opaque_b.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor =  RGBACOLOR(250, 143, 5, 1);
    self.title = @"MyWeibo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    refreshtime = 1;
    //
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    _weiboMsgArray = [[NSMutableArray alloc]init];
    [self addRefreshViewController];
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WEIBOEVENT_DELETE object:nil];
    [center addObserver:self selector:@selector(deleteWeibo:) name:WEIBOEVENT_DELETE object:nil];
    
    //download data
    [self getWeiboMsg];
    
}

- (void)addRefreshViewController{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshWeiboMsg)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreWeibo)];
    
    //
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;
    self.tableView.footer.font = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor = TEXT_COLOR;
    //
    [self.tableView.header setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"客官您稍等，我马上帮你拉" forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.footer setTitle:@"客官您稍等，我马上拉给你 " forState:MJRefreshFooterStateRefreshing];
}


- (void)getWeiboMsg {

    [KVNProgress showWithStatus:@"Loading..."];
    
    //get access_token
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    _access_token = delegate.wbtoken;
    
    //async request
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //http get request
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_MYWEIBOS;
        NSDictionary *dict0 = [NSDictionary
                               dictionaryWithObject:_access_token
                               forKey:@"access_token"];
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 [KVNProgress dismiss];
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
                 NSLog(@"%ld",(unsigned long)weiboMsgDictionary.count);
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (int i = 0; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:NO];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                     
                     //提取since_id、max_id的值
                     [self getFlagMsg:_weiboMsgArray];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [KVNProgress showError];
                 [KVNProgress dismiss];
             }];
        
        
    });
    
}
- (void)refreshWeiboMsg{
    refreshtime ++;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_MYWEIBOS;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *since_id = [NSNumber numberWithLongLong:_since_id];
        dict0= @{@"access_token":_access_token, @"since_id":since_id};
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSLog(@"get weibo: %@",jsonStrings);
                 
                 NSArray *weiboMsgDictionary = [jsonStrings objectFromJSONString];
                 if (weiboMsgDictionary.count > 0) {
                     
                     //将数据加入数组
                     for (long i = (weiboMsgDictionary.count - 1); i >= 0; i --) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:NO];
                         [_weiboMsgArray insertObject:weiboMsg atIndex:0];
                         
                     }
                     
                     //提取since_id、max_id的值
                     [self getFlagMsg:_weiboMsgArray];
                 }else {
                     [KVNProgress showSuccessWithStatus:@"No More Weibo"];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"%lld",_since_id);
                     [self.tableView reloadData];
                     [self.tableView.header endRefreshing];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.tableView.header endRefreshing];
                 [KVNProgress showError];
                 [KVNProgress dismiss];
             }];
    });
}
- (void)getMoreWeibo{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        //http请求头应该添加text/plain。接受类型内容无text/plain
        manager.responseSerializer.acceptableContentTypes =
        [manager.responseSerializer.acceptableContentTypes
         setByAddingObject:@"text/plain"];
        NSString *getPublicWeiboTmp = WBAPIURL_MYWEIBOS;
        NSDictionary *dict0 = [[NSDictionary alloc]init];
        NSNumber *max_id = [NSNumber numberWithLongLong:_max_id];
        dict0= @{@"access_token":_access_token, @"max_id":max_id};
        //
        [manager GET:getPublicWeiboTmp
          parameters:dict0
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 [KVNProgress showSuccess];
                 [KVNProgress dismiss];
                 NSError *error;
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonString = [[NSString alloc] initWithData:jsonDatas encoding:NSUTF8StringEncoding];
                 
                 jsonString = [self getNormalJSONString:jsonString];
                 
                 
                 NSArray *weiboMsgDictionary = [jsonString objectFromJSONString];
                 if (weiboMsgDictionary.count > 0) {
                     
                     for (int i = 1; i < weiboMsgDictionary.count; i ++) {
                         NSDictionary *dict = weiboMsgDictionary[i];
                         WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:NO];
                         [_weiboMsgArray addObject:weiboMsg];
                         
                     }
                     //提取since_id、max_id的值
                     [self getFlagMsg:_weiboMsgArray];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"%lld",_max_id);
                     [self.tableView reloadData];
                     [self.tableView.footer endRefreshing];
                 });
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [self.tableView.footer endRefreshing];
                 [KVNProgress showError];
                 [KVNProgress dismiss];
             }];
    });
}


#pragma mark - 微博API返回的数据不是标准的json格式数据。我们需要返回的String类型JSON数据进行一定的处理

- (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    /*
    NSLog(@"get weibo: %@",jsonStrings);
    NSDictionary *dict = [jsonStrings objectFromJSONString];
    _since_id = [dict[@"since_id"] longLongValue];
    _max_id = [dict[@"max_id"] longLongValue];
    _previous_cursor = [dict[@"previous_cursor"] longLongValue];
    _next_cursor = [dict[@"next_cursor"] longLongValue];
     */
    
    NSString *str1;
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"statuses\":"];
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    
    NSRange rangeRight = [str1 rangeOfString:@"\"total_n"];
    if (rangeRight.length > 0) {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}


//微博API中返回个人微博只返回前5条，since_id、max_id、previous_cursor、next_cursor全为0.故自己提取

- (void)getFlagMsg:(NSArray *)weiboArray {
    WeiboMsg *weibo = weiboArray[0];
    _since_id = weibo.ids;
    weibo = weiboArray.lastObject;
    _max_id = weibo.ids ;
    NSLog(@"%lld  %lld",_since_id, _max_id);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _weiboMsgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //去除重用机制
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.row,refreshtime];
    
    PersonalWeiboViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[PersonalWeiboViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    WeiboMsg *weiboMsg = _weiboMsgArray[indexPath.row];
    cell.weiboMsg = weiboMsg;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboMsg *weiboMsg = _weiboMsgArray[indexPath.row];
    NSInteger yHeight = weiboMsg.height;
    return yHeight;
}


///
- (void)deleteWeibo:(NSNotification *)notice{
    long long ids = [notice.object longLongValue];
    for (WeiboMsg *weiboMsg in _weiboMsgArray) {
        if (weiboMsg.ids == ids) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_weiboMsgArray removeObject:weiboMsg];
                [self.tableView reloadData];
            });
            break;
        }
    }
}

@end
