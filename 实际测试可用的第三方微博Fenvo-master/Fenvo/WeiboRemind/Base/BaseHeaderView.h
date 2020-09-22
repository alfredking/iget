//
//  BaseHeaderView.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboAvatarView.h"

@interface BaseHeaderView : UIView

@property (nonatomic, strong)WeiboAvatarView * avatar;
@property (nonatomic, strong)UILabel * username;
@property (nonatomic, strong)UILabel * createAt;
@property (nonatomic, strong)UILabel * source;
@property (nonatomic, strong)UIButton * customBtn;

@end
