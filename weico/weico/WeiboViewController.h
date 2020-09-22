//
//  ViewController.h
//  weico
//
//  Created by alfredking－cmcc on 2017/9/7.
//  Copyright © 2017年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSString *access_token;
@property(strong, nonatomic)NSMutableArray *weiboMsgArray;

- (void)clearAndRefreshData;
@end

