//
//  CommentTableViewCell.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboComment.h"

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) WeiboComment * comment;

@end
