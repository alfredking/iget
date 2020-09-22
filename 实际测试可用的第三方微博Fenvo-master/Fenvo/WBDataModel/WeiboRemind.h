//
//  WeiboRemind.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboRemind : NSObject
//status	int	新微博未读数
@property (nonatomic, assign)NSUInteger weiboMsg;
//follower	int	新粉丝数
@property (nonatomic, assign)NSUInteger follower;
//cmt	int	新评论数
@property (nonatomic, assign)NSUInteger cmt;
//dm	int	新私信数
@property (nonatomic, assign)NSUInteger dm;
//mention_status	int	新提及我的微博数
@property (nonatomic, assign)NSUInteger mention_status;
//mention_cmt	int	新提及我的评论数
@property (nonatomic, assign)NSUInteger mention_cmt;
//group	int	微群消息未读数
@property (nonatomic, assign)NSUInteger group;
//private_group	int	私有微群消息未读数
@property (nonatomic, assign)NSUInteger private_group;
//notice	int	新通知未读数
@property (nonatomic, assign)NSUInteger notice;
//invite	int	新邀请未读数
@property (nonatomic, assign)NSUInteger invite;
//badge	int	新勋章数
@property (nonatomic, assign)NSUInteger badge;
//photo	int	相册消息未读数
@property (nonatomic, assign)NSUInteger photo;
//msgbox	int	{{{3}}}
@property (nonatomic, assign)NSUInteger msgbox;
@end
