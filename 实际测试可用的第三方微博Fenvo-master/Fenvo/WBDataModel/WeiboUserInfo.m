//
//  WeiboUserInfo.m
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//
/*
 id	int64	用户UID
 idstr	string	字符串型的用户UID
 screen_name	string	用户昵称
 name	string	友好显示名称
 province	int	用户所在省级ID
 city	int	用户所在城市ID
 location	string	用户所在地
 description	string	用户个人描述
 url	string	用户博客地址
 profile_image_url	string	用户头像地址（中图），50×50像素
 profile_url	string	用户的微博统一URL地址
 domain	string	用户的个性化域名
 weihao	string	用户的微号
 gender	string	性别，m：男、f：女、n：未知
 followers_count	int	粉丝数
 friends_count	int	关注数
 statuses_count	int	微博数
 favourites_count	int	收藏数
 created_at	string	用户创建（注册）时间
 */
#import "WeiboUserInfo.h"

@implementation WeiboUserInfo
- (WeiboUserInfo *)initWithDictionary:(NSDictionary *)dict{
    self.ids = [dict[@"id"]longLongValue];
    self.idStr = dict[@"idstr"];
    self.screen_name = dict[@"screen_name"];
    self.name = dict[@"name"];
    self.province = [dict[@"province"]integerValue];
    self.city = [dict[@"city"]integerValue];
    self.location = dict[@"location"];
    self.descriptions = dict[@"description"];
    self.blogUrl = dict[@"url"];
    self.profile_image_url = dict[@"profile_image_url"];
    self.profile_url = dict[@"profile_url"];
    self.domain = dict[@"domain"];
    //self.weihao
    NSString *genderStr = dict[@"gender"];
    if ([genderStr isEqualToString:@"m"] == 1) {
        self.gender = @"男";
    }else if ([genderStr isEqualToString:@"f"] == 1){
        self.gender = @"女";
    }else{
        self.gender = @"未知";
    }
    self.followers_count = [dict[@"followers_count" ] longLongValue];
    self.friends_count = [dict[@"friends_count"]longLongValue];
    self.statuses_count = [dict[@"statuses_count"] longLongValue];
    self.favourites_count = [dict[@"favourites_count"]longLongValue];
    NSString *creatAtStr = dict[@"created_at"];
    self.created_at = [self getTimeString:creatAtStr];
    NSLog(@"self is %@",_created_at);
    self.allow_all_act_msg = [dict[@"allow_all_act_msg"]boolValue];
    self.geo_enabled = [dict[@"geo_enabled"]boolValue];
    self.verified = [dict[@"verified"]boolValue];
    self.remark = dict[@"remark"];
    self.allow_all_comment = [dict[@"allow_all_comment"]boolValue];
    self.avatar_large = dict[@"avata_large"];
    self.avatar_hd = dict[@"avatar_hd"];
    self.verified_reason = dict[@"verified_reason"];
    self.follow_me = [dict[@"follow_me"]boolValue];
    self.following = [dict[@"following"]boolValue];
    self.bi_followers_count = [dict[@"bi_followers_count"]integerValue];
    self.lang = dict[@"lang"];
    
    //
    self.mbtype = [dict[@"mbtype"]integerValue];
    return self;
}
- (NSString *) getTimeString : (NSString *) string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy MMM dd"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}
/*
 following	boolean	暂未支持
 allow_all_act_msg	boolean	是否允许所有人给我发私信，true：是，false：否
 geo_enabled	boolean	是否允许标识用户的地理位置，true：是，false：否
 verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
 verified_type	int	暂未支持
 remark	string	用户备注信息，只有在查询用户关系时才返回此字段
 status	object	用户的最近一条微博信息字段 详细
 allow_all_comment	boolean	是否允许所有人对我的微博进行评论，true：是，false：否
 avatar_large	string	用户头像地址（大图），180×180像素
 avatar_hd	string	用户头像地址（高清），高清头像原图
 verified_reason	string	认证原因
 follow_me	boolean	该用户是否关注当前登录用户，true：是，false：否
 online_status	int	用户的在线状态，0：不在线、1：在线
 bi_followers_count	int	用户的互粉数
 lang	string	用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
 */
//+ (WeiboUserInfo *)statusWithDictionary:(NSDictionary *)dict{}
@end
