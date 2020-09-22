//
//  ViewController.m
//  weico
//
//  Created by alfredking－cmcc on 2017/9/7.
//  Copyright © 2017年 alfredking－cmcc. All rights reserved.
//

#import "WeiboViewController.h"
#import "KVNProgress.h"
#import "AFHTTPRequestOperationManager.h"
#import  "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboMsg.h"
#import "WBHttpResponseResultKit.h"
#import "DiskCacheManager.h"
#import "WeiboUserInfo.h"
#import "WeiboTableViewCell.h"
#import "WeiboDetailViewController.h"
#import "UIImage+FontAwesome.h"
#import "MJRefresh.h"
#import "TimeLineRPC.h"
@interface WeiboViewController ()<WBHttpRequestDelegate>
{
    //刷新微博
    //下次返回比since_id晚的微博
    long long _since_id;
    //根据max_id返回比max_id早的微博
    //long long _max_id;
    
    NSNumber            *_max_id;
    
    UIButton            *_titleButton;
    UIBarButtonItem     *_writeNewWeibo;
    
    //是从coredata中找数据还是从服务器上
    BOOL                _isFindInCoredata;
    
}

@end

@implementation WeiboViewController
@synthesize weiboMsgArray = _weiboMsgArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _access_token = @"2.00XkPSpB0wyYP7cb0bc3dd35Pu6NaB";
    _weiboMsgArray              = [[NSMutableArray alloc]init];
    //[self ssoButtonPressed];
    
//    UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(load)];
//    [self.view addGestureRecognizer:re];
    
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"50" forKey:@"count"];
    
    [self getWeiboMsgFromRemote:dic];
    
    [self initNavigationBar];
    
    [self addRefreshViewController];
    
    self.tableView.delegate = self;
   
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor   = RGBACOLOR(250, 143, 5, 1);
}

- (void)initNavigationBar
{
    _titleButton                    = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 200, 44)];
    
    _titleButton.backgroundColor    = [UIColor clearColor];
    
    _titleButton.titleLabel.font    = [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0];
    
    [_titleButton setTitleColor:RGBACOLOR(250, 143, 5, 1) forState:UIControlStateNormal];
    
    [_titleButton setTitle:@"HOME" forState:UIControlStateNormal];
    
    [_titleButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView   = _titleButton;
    
    _writeNewWeibo = [[UIBarButtonItem alloc] initWithImage:
                      [UIImage imageWithIcon:@"fa-pencil-square-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] style:UIBarButtonItemStyleDone target:self action:@selector(writeWeibo)];
    
    self.navigationItem.rightBarButtonItem = _writeNewWeibo;
}


- (void)addRefreshViewController
{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(clearAndRefreshData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreWeiboFromRemote)];
    
    self.tableView.header.font          = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor     = TEXT_COLOR;
    self.tableView.footer.font          = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor     = TEXT_COLOR;
    
    [self.tableView.header setTitle:@"下拉刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"客官您稍等，我马上帮你拉" forState:MJRefreshHeaderStateRefreshing];
    
    [self.tableView.footer setTitle:@"上拉加载更多" forState:MJRefreshFooterStateIdle];
    [self.tableView.footer setTitle:@"没骗你释放马上帮你刷" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.footer setTitle:@"客官您稍等，我马上拉给你 " forState:MJRefreshFooterStateRefreshing];
}


- (void)clearAndRefreshData
{
    
    //[CoreDataManager removeAllObjectInClass:NSStringFromClass([WeiboMsg class])];
    
    [DiskCacheManager setDiskCache:@"HomeTimeLine" object:nil];
    
    [TimeLineRPC getHomeTimeLineWithSinceId:nil orMaxId:nil success:^(NSArray *timeLineArr, NSNumber *since_id, NSNumber *max_id, NSNumber *previous_cursor, NSNumber *next_cursor)
     {
         _weiboMsgArray = [[NSMutableArray alloc]initWithArray:timeLineArr];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
         
         [self.tableView.header endRefreshing];
         
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             [DiskCacheManager compressObject:[_weiboMsgArray copy]
                                   ObjectType:CacheObjectType_Status
                                  autoSaveKey:@"HomeTimeLine"];
         });
         
     } failure:^(NSString *desc, NSError *error) {
         [self.tableView.header endRefreshing];
         
     }];
}


- (void)reloadData:(NSArray *)timeLineArr {
    
    if (timeLineArr.count > 0) {
        for (int i = 0; i < timeLineArr.count; i ++) {
            WeiboMsg *weiboMsg = (WeiboMsg *)timeLineArr[i];
            [_weiboMsgArray addObject:weiboMsg];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    });
    [self getMaxId:[_weiboMsgArray lastObject]];
}


- (void)getMaxId:(WeiboMsg *)weiboMsg {
    
    _max_id = weiboMsg.ids;
}



- (void)getMoreWeiboFromRemote {
    
    _isFindInCoredata = false;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSNumber *max_id = _max_id;
        [TimeLineRPC getHomeTimeLineWithSinceId:nil
        orMaxId:max_id
        success:^(NSArray *timeLineArr, NSNumber *since_id, NSNumber *max_id, NSNumber *previous_cursor, NSNumber *next_cursor)
        {
                                            
            [self reloadData:timeLineArr];
            _max_id = max_id;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [DiskCacheManager compressObject:[_weiboMsgArray copy]
                    ObjectType:CacheObjectType_Status
                    autoSaveKey:@"HomeTimeLine"];
            });
            }
            failure:^(NSString *desc, NSError *error)
            {
                [self.tableView.footer endRefreshing];
                NSLog(@"%@",desc);
            }];
        
    });
}


#pragma mark SSO Authorization
- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


//Home
- (void)getWeiboMsgFromRemote:(NSDictionary *)dic
{
    [WBHttpRequest requestWithAccessToken:_access_token
                                      url:WeiboSDKHttpRequestURLType_Statuses_HomeTimeline
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:@"GetHomeTimeline"];
    
}

- (void)getWeiboMsg {
    

    
    [KVNProgress showWithStatus:@"Loading..."];
    
    //get access_token
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //_access_token = delegate.wbtoken;
    
    NSLog(@"_access_token is %@",_access_token);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WeiboSDK Http Request Delegate

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"I'm from wb http request. response result is :  %@", response);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
    NSLog(@"result is %@",result);
    if (!result || [result isEqualToString:@""]) return;
    
    [WBHttpResponseResultKit timelineStringToArray:result success:^(NSArray *array, NSNumber *since_id, NSNumber *max_id) {
        
        [_weiboMsgArray addObjectsFromArray:array];
        
        _since_id   = since_id;
        _max_id     = max_id;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [DiskCacheManager compressObject:[_weiboMsgArray copy]
                                  ObjectType:CacheObjectType_Status
                                 autoSaveKey:@"HomeTimeLine"];
        });
    } failure:^(NSString *description) {
        NSLog(@"%@",description);
    }];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%s",__FUNCTION__);
    return _weiboMsgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboMsg *weiboMsg  = _weiboMsgArray[indexPath.row];
    CGFloat yHeight     = weiboMsg.height.floatValue;
    NSLog(@"yHeight is %f",yHeight);
    return yHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path is %@",indexPath);
    WeiboMsg *weiboMsg                  = _weiboMsgArray[indexPath.row];
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detailVC.view.backgroundColor = [UIColor greenColor];
    detailVC.weiboMsg                   = weiboMsg;
    
    

    [self.navigationController pushViewController:detailVC animated:YES];
    
   
}

//默认UITableViewCell有四种布局模式https://blog.csdn.net/hmt20130412/article/details/20831377
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//使用原始cell的方法
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineTableViewCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineTableViewCell"];
//
//    }
//
//    if (_weiboMsgArray) {
//        WeiboMsg *weiboMsg          = _weiboMsgArray[indexPath.row];
//        WeiboUserInfo *userinfo =weiboMsg.user;
//        NSLog(@"userinfo.name is %@",userinfo.name);
//        cell.textLabel.text = userinfo.name;
//
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weiboMsg.pic_urls]]];
//    }
    NSString *cellIdentifier    = @"weiboCell";
    
    WeiboTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[WeiboTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
    }
    
    if (_weiboMsgArray)
    {
       WeiboMsg *weiboMsg          = _weiboMsgArray[indexPath.row];
    cell.weiboMsg               = weiboMsg;
    }
    
    NSLog(@"%s",__FUNCTION__);
    return cell;
}

@end
