//
//  WeiboDetailViewController.h
//  Fenvo
//
//  Created by Caesar on 15/8/11.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"
#import "DetailView.h"
#import "ANBlurredTableView.h"

@interface WeiboDetailViewController : UITableViewController

@property (nonatomic, strong)ANBlurredTableView *tableView;
@property (nonatomic, strong)WeiboMsg *weiboMsg;
@property (nonatomic, strong)NSNumber *ID;

@end
