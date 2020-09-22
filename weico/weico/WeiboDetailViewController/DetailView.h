//
//  DetailView.h
//  Fenvo
//
//  Created by Caesar on 15/8/11.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"

@interface DetailView : UIView
@property (nonatomic, strong)WeiboMsg *weiboMsg;
@property (nonatomic, assign)CGFloat height;
@end
