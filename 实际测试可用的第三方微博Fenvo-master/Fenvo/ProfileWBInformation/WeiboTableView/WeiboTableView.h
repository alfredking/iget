//
//  WeiboTableView.h
//  Fenvo
//
//  Created by Caesar on 15/5/21.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboLabel.h"
#import "WebImageView.h"
@interface WeiboTableView : UITableViewController<WeiboLabelDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSString *access_token;
@property(strong, nonatomic)NSMutableArray *weiboMsgArray;
- (void) setAccess_tokenAndDownload:(NSString *)access_token;
- (void)refreshWeiboMsg;
@end
