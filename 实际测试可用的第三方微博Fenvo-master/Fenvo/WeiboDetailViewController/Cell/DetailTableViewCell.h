//
//  DetailTableViewCell.h
//  Fenvo
//
//  Created by Caesar on 15/8/14.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboComment,BaseHeaderView,WeiboLabel;

@interface DetailTableViewCell : UITableViewCell
@property (nonatomic, strong)id object;
@property (nonatomic, strong)BaseHeaderView *header;
@property (nonatomic, strong)WeiboLabel *text;
@end
