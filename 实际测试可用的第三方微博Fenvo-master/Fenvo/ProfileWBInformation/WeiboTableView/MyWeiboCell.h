//
//  FollowingWBViewCell.h
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"


@interface MyWeiboCell : UITableViewCell
//数据模型对象
@property (nonatomic, strong)WeiboMsg *weiboMsg;
//背景框
@property(nonatomic, strong)UIView *containView;
@end
