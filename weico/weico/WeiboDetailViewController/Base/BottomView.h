//
//  BottomView.h
//  Fenvo
//
//  Created by Caesar on 15/8/13.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"

@interface BottomView : UIView
@property (nonatomic, strong)UIButton *comment;
@property (nonatomic, strong)UIButton *like;
@property (nonatomic, strong)UIButton *repost;

@property (nonatomic, strong)WeiboMsg *weiboMsg;
@end
