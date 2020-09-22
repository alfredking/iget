//
//  WeiboDetailViewController.m
//  Fenvo
//
//  Created by Caesar on 15/8/11.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "DetailTableViewCell.h"
#import "DetailView.h"
#import "StyleOfRemindSubviews.h"
#import "BottomView.h"
#import "MJRefresh.h"
#import "AnimationTool.h"

#import "CommentRPC.h"
#import "WeiboComment.h"

#define ShowCommentUrl @"https://api.weibo.com/2/comments/show.json"

typedef NS_ENUM(NSInteger, ShowType)
{
    ShowType_Comment,
    ShowType_Repost
};

@interface WeiboDetailViewController ()
{
    DetailView *_detailView;
    BottomView *_buttonView;
    UIActivityIndicatorView *_indicatorView;
    
    NSMutableArray *_commentArray;
    NSMutableArray *_repostArray;
    NSNumber *_commentSinceID;
    NSNumber *_commentMaxID;
    NSNumber *_repostSinceID;
    NSNumber *_repostMaxID;
    
    ShowType  _showType;
}
@end

@implementation WeiboDetailViewController

@dynamic tableView;

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self initData];
    }
    return self;
}

- (void)initData
{
    _showType       = ShowType_Comment;
    
    _commentArray   = [[NSMutableArray alloc]init];
    _commentSinceID = @(0);
    _commentMaxID   = @(0);
    
    _repostArray    = [[NSMutableArray alloc]init];
    _repostSinceID  = @(0);
    _repostMaxID    = @(0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.title = @"DETAIL";
    
    if (![self.tableView isKindOfClass:[ANBlurredTableView class]])
    {
        self.tableView = [[ANBlurredTableView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 44) style:UITableViewStyleGrouped];
    }
    
    self.tableView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, self.view.bounds.size.height);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView setBlurTintColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    [self.tableView setEndTintAlpha:0.6f];
    [self.tableView setBackgroundImage:[UIImage imageNamed:@"beach.jpg"]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_buttonView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:_buttonView];
}

#pragma mark - Property Setter And Getter

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg
{
    _weiboMsg   = weiboMsg;
    self.ID     = weiboMsg.ids;
    
    if (![self.tableView isKindOfClass:[ANBlurredTableView class]])
    {
        self.tableView = [[ANBlurredTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    _detailView             = [[DetailView alloc]init];
    _detailView.frame       = CGRectMake(0, 0, self.view.frame.size.width, 0);
    _detailView.weiboMsg    = weiboMsg;
    _detailView.frame       = CGRectMake(0, 0, self.view.frame.size.width, _detailView.height);
    self.tableView.tableHeaderView = _detailView;
    
    UIView *view = self.tableView.tableHeaderView;
    CGRect frame = view.frame;
    self.tableView.tableHeaderView.frame = frame;
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    
    _buttonView             = [[BottomView alloc]init];
    _buttonView.frame       = CGRectMake(0, IPHONE_SCREEN_HEIGHT - [StyleOfRemindSubviews bottomHeight], IPHONE_SCREEN_WIDTH, [StyleOfRemindSubviews bottomHeight]);
    _buttonView.weiboMsg    = weiboMsg;
    [window addSubview:_buttonView];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.center = self.view.center;
    
    [_indicatorView startAnimating];
    
    [self getDataFromServer:YES];
}

#pragma mark - Remote Request

- (void)addHeaderRefreshControl
{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshEvent)];
    
    self.tableView.header.font      = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = TEXT_COLOR;
}

- (void)addFooterRefreshControl
{
   [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreEvent)];
    
    self.tableView.footer.font      = [UIFont systemFontOfSize:15];
    self.tableView.footer.textColor = TEXT_COLOR;
}

- (void)refreshEvent
{
    [self getDataFromServer:YES];
}

- (void)getMoreEvent
{
    [self getDataFromServer:NO];
}

- (void)getDataFromServer:(BOOL)isRefresh
{
    if (isRefresh)
    {
        [CommentRPC getCommentWithURL:ShowCommentUrl
                                   ID:self.ID
                              sinceID:_commentSinceID
                                maxID:nil
                                 page:nil
                                count:nil
                         filterOption:nil
                              success:^(NSArray *commentArr, NSNumber *since_id, NSNumber *max_id) {
                                  _commentSinceID = since_id;
                                  
                                  for (WeiboComment *comment in commentArr) {
                                      [_commentArray insertObject:comment atIndex:0];
                                  }
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tableView reloadData];
                                  });
                                  
                                  [_indicatorView stopAnimating];
                              } failure:^(NSString *desc, NSError *error) {
                                  NSLog(@"%@",desc);
                                  [_indicatorView stopAnimating];

                              }];
    }
    else
    {
        [CommentRPC getCommentWithURL:ShowCommentUrl
                                   ID:self.ID
                              sinceID:nil
                                maxID:_commentMaxID
                                 page:nil
                                count:nil
                         filterOption:nil
                              success:^(NSArray *commentArr, NSNumber *since_id, NSNumber *max_id) {
                                  _commentMaxID = max_id;
                                  
                                  [_commentArray addObjectsFromArray:commentArr];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tableView reloadData];
                                  });
                                  
                                  [_indicatorView stopAnimating];
                              } failure:^(NSString *desc, NSError *error) {
                                  NSLog(@"%@",desc);
                                  [_indicatorView startAnimating];
                              }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"dfdf";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
//    if (sectionTitle == nil) {
//        return  nil;
//    }
//    
//    BottomView *bottom = [[BottomView alloc]init];
//    bottom.frame = CGRectMake(0, 0, tableView.bounds.size.width, 22);
//    
//    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
//    [sectionView setBackgroundColor:[UIColor blackColor]];
//    [sectionView addSubview:bottom];
//    return sectionView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"detailCell";
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    //cell.backgroundColor = [StyleOfRemindSubviews whiteOpaqueColor];
    cell.object = _commentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (_showType) {
        case ShowType_Comment:
        {
            WeiboComment *comment = _commentArray[indexPath.row];
            return comment.height.floatValue;
        }
            break;
            
        case ShowType_Repost:
        {
            WeiboMsg *weiboMsg = _repostArray[indexPath.row];
            return weiboMsg.height.floatValue;
        }
            break;
            
        default:
            break;
    }
    
    return 44;
}


- (void)tableView:(nonnull UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row < 10) {
        return;
    }
    [AnimationTool bounceTargetView:cell];
}

#pragma mark - Table View Delegate
/*
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

@end
