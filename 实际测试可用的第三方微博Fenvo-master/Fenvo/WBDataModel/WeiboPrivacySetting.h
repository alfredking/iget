//
//  WeiboPrivacySetting.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboPrivacySetting : NSObject
//comment	int	是否可以评论我的微博，0：所有人、1：关注的人、2：可信用户
@property (nonatomic, assign)NSUInteger comment;
//geo	int	是否开启地理信息，0：不开启、1：开启
@property (nonatomic, assign)NSUInteger geo;
//message	int	是否可以给我发私信，0：所有人、1：我关注的人、2：可信用户
@property (nonatomic, assign)NSUInteger message;
//realname	int	是否可以通过真名搜索到我，0：不可以、1：可以
@property (nonatomic, assign)NSUInteger realname;
//badge	int	勋章是否可见，0：不可见、1：可见
@property (nonatomic, assign)NSUInteger badge;
//mobile	int	是否可以通过手机号码搜索到我，0：不可以、1：可以
@property (nonatomic, assign)NSUInteger mobile;
//webim	int	是否开启webim， 0：不开启、1：开启
@property (nonatomic, assign)NSUInteger webim;
@end
