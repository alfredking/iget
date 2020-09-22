//
//  FollowingWBViewController.h
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"
#import "WeiboLabel.h"
#import "ANBlurredTableView.h"

@interface FollowingWBViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,WeiboLabelDelegate>
@property(strong, nonatomic)NSString *wbtoken;
@property(strong, nonatomic)ANBlurredTableView *tableView;
@property(strong, nonatomic)NSMutableArray *weiboMsgArray;
@end
