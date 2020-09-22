//
//  BaseRetweetView.h
//  Fenvo
//
//  Created by Caesar on 15/8/12.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"
#import "BaseImagesView.h"
#import "WeiboLabel.h"

@interface BaseRetweetView : UIView<WeiboLabelDelegate>

@property (nonatomic, strong)BaseImagesView *imagesView;
@property (nonatomic, strong)WeiboLabel *text;

@property (nonatomic, strong)WeiboMsg *weiboMsg;

@end
