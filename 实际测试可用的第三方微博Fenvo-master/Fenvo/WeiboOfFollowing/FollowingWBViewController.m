//
//  FollowingWBViewController.m
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//
#import "FollowingWBViewController.h"
#import "WeiboDetailViewController.h"
#import "WeiboMsg.h"
#import "WeiboMsgManager.h"
#import "FollowingWBViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "WeiboViewController.h"
#import "JSONKit.h"
#import "MJRefresh.h"
#import "WeiboAvatarView.h"
#import "WebViewController.h"
#import "KVNProgress.h"
#import "TimeLineRPC.h"
#import "WeiboStoreManager.h"
#import "WeiboStore.h"
#import "WeiboGetBlurImage.h"
#import "AppDelegate.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"
#import "NewWeiboVC.h"
#import "CoreDataManager.h"
#import "DiskCacheManager.h"
#import "WeiboSDK.h"
#import "WBHttpRequest.h"
#import "WBHttpResponseResultKit.h"
#import "AnimationTool.h"
#import "PopoverView.h"
#import "ItemsPopoverView.h"

@interface FollowingWBViewController ()<WeiboLabelDelegate,UIScrollViewDelegate,WBHttpRequestDelegate,ItemsPopoverViewDelegate>
{
    //Data
    NSMutableArray      *_weiboCells;
    NSMutableArray      *_array;
    NSMutableArray      *_tmp;
    
    //根据max_id返回比max_id早的微博,since_id返回比since_id早的微博
    //next_cursor、previous_cursor指定返回的之后、之前的游标值。暂未支持
    NSNumber            *_since_id;
    NSNumber            *_max_id;
    NSNumber            *_next_cursor;
    NSNumber            *_previous_cursor;
    //Other
    CGSize              screenSize;
    NSInteger           page;
    NSInteger           refreshtime;
    //是从coredata中找数据还是从服务器上
    BOOL                _isFindInCoredata;
    
    //Subviews
    UIBarButtonItem     *_writeNewWeibo;
    UIButton            *_titleButton;
    ItemsPopoverView    *_itemsPopover;
}
@end

@implementation FollowingWBViewController

@synthesize weiboMsgArray = _weiboMsgArray;
@synthesize wbtoken = _wbtoken;

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isFindInCoredata           = true;
        _weiboMsgArray              = [[NSMutableArray alloc]init];
        AppDelegate *appdelegate    = [UIApplication sharedApplication].delegate;
        _wbtoken                    = appdelegate.wbtoken;
        _since_id                   = @(0);
        _max_id                     = @(0);
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
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
    
    _writeNewWeibo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithIcon:@"fa-pencil-square-o"
                                                                  backgroundColor:[UIColor clearColor]
                                                                        iconColor:RGBACOLOR(250, 143, 5, 1)
                                                                          andSize:CGSizeMake(20, 20)]
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(writeWeibo)];
    
    self.navigationItem.rightBarButtonItem = _writeNewWeibo;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor   = RGBACOLOR(250, 143, 5, 1);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //自己添加的，因为导航栏会遮盖下面的视图
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self initNavigationBar];
    
    //取消tableview向下延伸。避免被tabBar遮盖
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.tableView                  = [[ANBlurredTableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;

    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    
    // We want to animate our background's alpha, so switch this to yes.
    //[self.tableView setAnimateTintAlpha:YES];
    //[self.tableView setStartTintAlpha:0.2f];
    [self.tableView setEndTintAlpha:0.6f];
    
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    [center addObserver:self selector:@selector(getWeiboMsg:) name:WBNOTIFICATION_DOWNLOADDATA object:nil];
    
    //自己测试用
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"50" forKey:@"count"];
    [self getWeiboMsgFromRemote:dic];
    //自己测试用
    
    //开始请求微博数据
    [self getWeiboMsg:nil];
    
    [self addRefreshViewController];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Get Data From Disk Cache

- (void)getWeiboMsg:(NSNotification *)notification
{
    [DiskCacheManager extractObjectWithKey:@"HomeTimeLine" objectType:CacheObjectType_Status success:^(NSArray *arrTimeLine, NSNumber *since_id, NSNumber *max_id) {
        
        _weiboMsgArray  = [[NSMutableArray alloc]initWithArray:arrTimeLine];
        
        _max_id         = max_id;
        
        _since_id       = since_id;
        NSLog(@"get cache success");
        
    } failure:^(NSString *description) {
        
        NSLog(@"get cache fail");
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:@"50" forKey:@"count"];
        
        [self getWeiboMsgFromRemote:dic];
    }];
}

#pragma mark - Get Data From Server

//Home
- (void)getWeiboMsgFromRemote:(NSDictionary *)dic
{
    [WBHttpRequest requestWithAccessToken:self.wbtoken
                                      url:WeiboSDKHttpRequestURLType_Statuses_HomeTimeline
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:@"GetHomeTimeline"];
    
}
//Public
- (void)getweiboMsgFromRemote_Public:(NSDictionary *)dic
{
    [WBHttpRequest requestWithAccessToken:self.wbtoken
                                      url:WeiboSDKHttpRequestURLType_Statuses_PublicTimeline
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:@"GetPublicTimeline"];
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

- (void)getMoreWeiboFromRemote {
    
    _isFindInCoredata = false;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSNumber *max_id = _max_id;
        [TimeLineRPC getHomeTimeLineWithSinceId:nil
                                        orMaxId:max_id
                                        success:^(NSArray *timeLineArr, NSNumber *since_id, NSNumber *max_id, NSNumber *previous_cursor, NSNumber *next_cursor) {
                                            
                                            [self reloadData:timeLineArr];
                                            
                                            _max_id = max_id;
                                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                                [DiskCacheManager compressObject:[_weiboMsgArray copy]
                                                                      ObjectType:CacheObjectType_Status
                                                                     autoSaveKey:@"HomeTimeLine"];
                                            });
                                        } failure:^(NSString *desc, NSError *error) {
                                            [self.tableView.footer endRefreshing];
                                            NSLog(@"%@",desc);
                                        }];
        
    });
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

#pragma mark - WeiboSDK Http Request Delegate

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"I'm from wb http request. response result is :  %@", response);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    if (!result || [result isEqualToString:@""]) return;
    
    [WBHttpResponseResultKit timelineStringToArray:result success:^(NSArray *array, NSNumber *since_id, NSNumber *max_id) {

        [_weiboMsgArray addObjectsFromArray:array];
        
        NSLog(@"new weibo is %@",_weiboMsgArray);
        
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
        NSLog(@"didFinishLoadingWithResult:%@",description);
    }];
}


#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _weiboMsgArray.count;
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier    = @"followingCell";

    FollowingWBViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[FollowingWBViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
    }
    
    WeiboMsg *weiboMsg          = _weiboMsgArray[indexPath.row];
    cell.weiboMsg               = weiboMsg;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row < 5) {
        return;
    }
    //[AnimationTool translationTargetView:cell];
    
    if (indexPath.row == _weiboMsgArray.count - 10) {
        [self.tableView.footer beginRefreshing];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboMsg *weiboMsg                  = _weiboMsgArray[indexPath.row];
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detailVC.weiboMsg                   = weiboMsg;
    //自己做测试的
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor greenColor];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboMsg *weiboMsg  = _weiboMsgArray[indexPath.row];
    CGFloat yHeight     = weiboMsg.height.floatValue;
    
    return yHeight;
}
#pragma mark - UI Event Deal Function

- (void)writeWeibo
{
    NewWeiboVC *newWeiboVC              = [[NewWeiboVC alloc]init];
    newWeiboVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:newWeiboVC animated:YES];
}

- (void)showPopover:(id)sender
{
    //    _popover = [[PopoverView alloc]initWithMessage:@""
    //                                          delegate:self
    //                                     containerView:self.btn
    //                                 otherButtonTitles:@"sdf",@"erw",nil];
    //    _popover.popoverWidth = 200.0;
    //    _popover.mainColor = [UIColor darkGrayColor];
    //    [_popover show];
    if (!_itemsPopover.window) {
        _itemsPopover = [[ItemsPopoverView alloc]initWithTitle:@"Title"
                                                      delegate:self
                                                 containerView:_titleButton
                                                          size:CGSizeMake(self.view.frame.size.width, 80)
                                             otherButtonTitles:@"关注的人",@"公共微博",@"热门微博", nil];
        _itemsPopover.mainColor = RGBACOLOR(26, 30, 36, 0.75);
        [_itemsPopover showPopoverView];
    }
    
}

//- (void)popoverView:(ItemsPopoverView *)popoverView clickedItemAtIndex:(NSInteger)index
//{
//    switch (index) {
//        case 0:
//            NSLog(@"I'm the first button.");
//            break;
//        case 1:
//            NSLog(@"I'm second button.");
//            break;
//
//        default:
//            break;
//    }
//}

@end
