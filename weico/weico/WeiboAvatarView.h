//
//  WeiboAvatarView.h
//  Fenvo
//
//  Created by Caesar on 15/4/1.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "WeiboUserInfo.h"

@interface WeiboAvatarView : UIImageView
-(void)setStyle;

//微博接口限制奶奶个腿
//接口升级后，对未授权本应用的uid，将无法获取其个人简介、认证原因、粉丝数、关注数、微博数及最近一条微博内容
@property(nonatomic, assign)long long uid;

//直接从获取的微博信息中截取
@property(nonatomic, copy)WeiboUserInfo *userInfo;
@end
