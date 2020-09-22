//
//  WeiboMsg.m
//  Fenvo
//
//  Created by Caesar on 15/3/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//
/*
 created_at	string	微博创建时间
 id	int64	微博ID
 mid	int64	微博MID
 idstr	string	字符串型的微博ID
 text	string	微博信息内容
 source	string	微博来源
 favorited	boolean	是否已收藏，true：是，false：否
 truncated	boolean	是否被截断，true：是，false：否
 in_reply_to_status_id	string	（暂未支持）回复ID
 in_reply_to_user_id	string	（暂未支持）回复人UID
 in_reply_to_screen_name	string	（暂未支持）回复人昵称
 thumbnail_pic	string	缩略图片地址，没有时不返回此字段
 bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
 original_pic	string	原始图片地址，没有时不返回此字段
 geo	object	地理信息字段 详细
 user	object	微博作者的用户信息字段 详细
 retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
 reposts_count	int	转发数
 comments_count	int	评论数
 attitudes_count	int	表态数
 mlevel	int	暂未支持
 visible	object	微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
 pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
 ad	object array	微博流内的推广微博ID
 */
#import "WeiboMsg.h"

@implementation WeiboMsg
#pragma mark - 根据download的字典信息初始化微博对象
- (WeiboMsg *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ids = [dic[@"id"] longLongValue];
        self.mid = [dic[@"mid"]longLongValue];
        self.idstr = dic[@"idstr"];
        self.wbDetail = dic[@"text"];
        self.source = dic[@"source"];
        self.favorited = [dic[@"favorited"]boolValue];
        self.truncated = [dic[@"truncated"]boolValue];
        self.thumbnail_pic = dic[@"thumbnail_pic"];
        self.bmiddle_pic = dic[@"bmiddle_pic"];
        self.original_pic = dic[@"original_pic"];
        //
        //NSDictionary *geos = dic[@"geo"];
        //if (geos) {
         //   self.geo = [[WeiboGeoInfo alloc]initWithDictionary:geos];
       // }
        //
        NSDictionary *user = dic[@"user"];
        self.user = [[WeiboUserInfo alloc]initWithDictionary:user];
        //
        NSDictionary *retweeted_weibo = dic[@"retweeted_status"];
        if (retweeted_weibo) {
            self.retweeted_status = [[WeiboMsg alloc]initWithDictionary:retweeted_weibo];
        }
        // attitudes_count	int	表态数
        self.attitudes_count = [dic[@"attitudes_count"]integerValue];
        self.reposts_count = [dic[@"reposts_count"]integerValue];
        self.comments_count = [dic[@"comments_count"]integerValue];
        //
        NSDictionary *visible = dic[@"visible"];
        self.visible = [[WeiboVisibleInfo alloc]initWithDictionary:visible];
        //
        self.pic_ids = dic[@"pic_ids"];

        self.pic_urls = [[NSMutableArray alloc]init];
        NSArray *pics= dic[@"pic_urls"];
        for (int i = 0; i < pics.count; i++) {
            NSDictionary *dict = pics[i];
            NSString *pic_url = dict[@"thumbnail_pic"];
            [self.pic_urls addObject:pic_url];
        }
        
        self.original_pic_urls = [self getOriginalPicUrl:self.pic_urls];
        self.bmiddle_pic_urls = [self getBmiddlePicUrl:self.pic_urls];
        
        NSString *timeStr = dic[@"created_at"];
        self.created_at = [self getTimeString:timeStr];
        NSString *wbSource = dic[@"source"];
        wbSource = [self getSourceString:wbSource];
        if (wbSource != nil && ![wbSource isEqualToString:@""]) {
            self.source = [NSString stringWithFormat:@"来自 %@", wbSource];
        }else{
            self.source = @"";
        }
        
    }
    return self;
}
- (NSString *) getTimeString : (NSString *)timeStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *input = [inputFormatter dateFromString:timeStr];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *output = [outputFormatter stringFromDate:input];
    return output;
}

- (NSString *) getSourceString:(NSString *)src{
    if(src.length > 0){
    NSString *tmpStr = [[NSString alloc]init];
    NSRange range = [src rangeOfString:@">"];
    tmpStr = [src substringFromIndex:range.location + 1];
    range = [tmpStr rangeOfString:@"</a>"];
    src = [tmpStr substringToIndex:range.location];
    }
    return src;
}
- (NSMutableArray *) getOriginalPicUrl:(NSMutableArray *)thumbnail_pic_urls{
    NSMutableArray *original_pic_urls = [[NSMutableArray alloc]init];
    for (int i = 0; i < thumbnail_pic_urls.count; i++) {
        NSString *url = thumbnail_pic_urls[i];
        NSLog(@"thumbnail is :%@",url);
        url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
        NSLog(@"original is :%@",url);
        [original_pic_urls addObject:url];
        
    }
    return original_pic_urls;
}
- (NSMutableArray *) getBmiddlePicUrl:(NSMutableArray *)thumbnail_pic_urls{
    NSMutableArray *bmiddle_pic_urls = [[NSMutableArray alloc]init];
    for (int i = 0; i < thumbnail_pic_urls.count; i++) {
        NSString *url = thumbnail_pic_urls[i];
        url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        [bmiddle_pic_urls addObject:url];
    }
    return bmiddle_pic_urls;
}

- (void) setCellHeight:(CGFloat)height{
    self.height = height;
}
 
#pragma mark - 静态方法初始化微博对象
+ (WeiboMsg *)statusWithDictionary:(NSDictionary *)dic{
    WeiboMsg *weiboMsg = [[WeiboMsg alloc]initWithDictionary:dic];
    return weiboMsg;
}

@end
