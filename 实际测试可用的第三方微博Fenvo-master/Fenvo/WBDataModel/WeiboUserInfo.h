//
//  WeiboUserInfo.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUserInfo : NSObject
//int64	用户UID
@property (nonatomic, assign)long long ids;
//idstr	string	字符串型的用户UID
@property (nonatomic, copy)NSString *idStr;
//screen_name	string	用户昵称
@property (nonatomic, copy)NSString *screen_name;
//name	string	友好显示名称
@property (nonatomic, copy)NSString *name;
//province	int	用户所在省级ID
@property (nonatomic, assign)NSInteger province;
//city	int	用户所在城市ID
@property (nonatomic, assign)NSInteger city;
//location	string	用户所在地
@property (nonatomic, copy)NSString *location;
//description	string	用户个人描述

//***************description是类的一个方法系统的一个保留字不能以此作为变量会造成影响。
@property (nonatomic, copy)NSString *descriptions;
//profile_image_url	string	用户头像地址（中图），50×50像素
@property (nonatomic, copy)NSString *profile_image_url;
//url	string	用户博客地址
@property (nonatomic, copy)NSString *blogUrl;
//profile_url	string	用户的微博统一URL地址
@property (nonatomic, copy)NSString *profile_url;
//domain	string	用户的个性化域名
@property (nonatomic, copy)NSString *domain;
//weihao	string	用户的微号
@property (nonatomic, copy)NSString *weihao;
//gender	string	性别，m：男、f：女、n：未知
@property (nonatomic, copy)NSString *gender;
//followers_count	int	粉丝数
@property (nonatomic, assign)long long followers_count;
//friends_count	int	关注数
@property (nonatomic, assign)long long friends_count;
//statuses_count	int	微博数
@property (nonatomic, assign)long long statuses_count;
//favourites_count	int	收藏数
@property (nonatomic, assign)long long favourites_count;
//created_at	string	用户创建（注册）时间
@property (nonatomic, copy)NSString *created_at;
//allow_all_act_msg	boolean	是否允许所有人给我发私信，true：是，false：否
@property (nonatomic, assign)Boolean allow_all_act_msg;
//geo_enabled	boolean	是否允许标识用户的地理位置，true：是，false：否
@property (nonatomic, assign)Boolean geo_enabled;
//verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
@property (nonatomic, assign)Boolean verified;
//remark	string	用户备注信息，只有在查询用户关系时才返回此字段
@property (nonatomic, copy)NSString *remark;
//allow_all_comment	boolean	是否允许所有人对我的微博进行评论，true：是，false：否
@property (nonatomic, assign)Boolean allow_all_comment;
//avatar_large	string	用户头像地址（大图），180×180像素
@property (nonatomic, copy)NSString *avatar_large;
//avatar_hd	string	用户头像地址（高清），高清头像原图
@property (nonatomic, copy)NSString *avatar_hd;
//verified_reason	string	认证原因
@property (nonatomic, copy)NSString *verified_reason;
//follow_me	boolean	该用户是否关注当前登录用户，true：是，false：否
@property (nonatomic, assign)Boolean follow_me;
//是否同样关注。API未说明。待验证
@property (nonatomic, assign)Boolean following;

//online_status	int	用户的在线状态，0：不在线、1：在线
@property (nonatomic, assign)NSInteger online_status;
//bi_followers_count	int	用户的互粉数
@property (nonatomic, assign)NSInteger bi_followers_count;
//lang	string	用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
@property (nonatomic, copy)NSString *lang;
//
//
@property (nonatomic, assign)NSInteger mbtype;


//////////////////
#pragma mark - 根据download的字典信息初始化微博用户对象
- (WeiboUserInfo *)initWithDictionary:(NSDictionary *)dic;

#pragma mark - 静态方法初始化微博用户对象
+ (WeiboUserInfo *)statusWithDictionary:(NSDictionary *)dic;

@end
