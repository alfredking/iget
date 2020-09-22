//
//  WeiboUserInfo.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboUserInfo.h"


@implementation WeiboUserInfo

@dynamic allow_all_act_msg;
@dynamic allow_all_comment;
@dynamic avatar_hd;
@dynamic avatar_large;
@dynamic bi_followers_count;
@dynamic blogUrl;
@dynamic city;
@dynamic created_at;
@dynamic descriptions;
@dynamic domain;
@dynamic follow_me;
@dynamic followers_count;
@dynamic following;
@dynamic favourites_count;
@dynamic friends_count;
@dynamic gender;
@dynamic geo_enabled;
@dynamic ids;
@dynamic idStr;
@dynamic lang;
@dynamic location;
@dynamic mbtype;
@dynamic name;
@dynamic online_status;
@dynamic profile_image_url;
@dynamic profile_url;
@dynamic province;
@dynamic remark;
@dynamic statuses_count;
@dynamic screen_name;
@dynamic verified;
@dynamic verified_reason;
@dynamic weihao;


+ (WeiboUserInfo *)createdByDictionary:(NSDictionary *)dict {
    WeiboUserInfo *userInfo = [WeiboUserInfo createdInCoreData];
    
    userInfo.ids =[NSNumber numberWithLongLong:[dict[@"id"]longLongValue]];
    userInfo.idStr = dict[@"idstr"];
    userInfo.screen_name = dict[@"screen_name"];
    userInfo.name = dict[@"name"];
    userInfo.province = [NSNumber numberWithInteger:[dict[@"province"]integerValue]];
    userInfo.city = [NSNumber numberWithInteger:[dict[@"city"]integerValue]];
    userInfo.location = dict[@"location"];
    userInfo.descriptions = dict[@"description"];
    userInfo.blogUrl = dict[@"url"];
    userInfo.profile_image_url = dict[@"profile_image_url"];
    userInfo.profile_url = dict[@"profile_url"];
    userInfo.domain = dict[@"domain"];
    //self.weihao
    NSString *genderStr = dict[@"gender"];
    if ([genderStr isEqualToString:@"m"] == 1) {
        userInfo.gender = @"男";
    }else if ([genderStr isEqualToString:@"f"] == 1){
        userInfo.gender = @"女";
    }else{
        userInfo.gender = @"未知";
    }
    userInfo.followers_count = [NSNumber numberWithLongLong:[dict[@"followers_count" ]longLongValue]];
    userInfo.friends_count = [NSNumber numberWithLongLong:[dict[@"friends_count"]longLongValue]];
    userInfo.statuses_count = [NSNumber numberWithLongLong:[dict[@"statuses_count"] longLongValue] ];
    userInfo.favourites_count = [NSNumber numberWithLongLong:[dict[@"favourites_count"]longLongValue] ];
    NSString *creatAtStr = dict[@"created_at"];
    userInfo.created_at = [WeiboUserInfo getTimeString:creatAtStr];
    userInfo.allow_all_act_msg = [NSNumber numberWithBool:[dict[@"allow_all_act_msg"]boolValue] ];
    userInfo.geo_enabled = [NSNumber numberWithBool:[dict[@"geo_enabled"]boolValue] ];
    userInfo.verified = [NSNumber numberWithBool:[dict[@"verified"]boolValue] ];
    userInfo.remark = dict[@"remark"];
    userInfo.allow_all_comment = [NSNumber numberWithBool:[dict[@"allow_all_comment"]boolValue]];
    userInfo.avatar_large = dict[@"avata_large"];
    userInfo.avatar_hd = dict[@"avatar_hd"];
    userInfo.verified_reason = dict[@"verified_reason"];
    userInfo.follow_me = [NSNumber numberWithBool:[dict[@"follow_me"]boolValue]];
    userInfo.following = [NSNumber numberWithBool:[dict[@"following"]boolValue]];
    userInfo.bi_followers_count = [NSNumber numberWithInteger:[dict[@"bi_followers_count"]integerValue]];
    userInfo.lang = dict[@"lang"];
    
    //
    userInfo.mbtype = [NSNumber numberWithInteger:[dict[@"mbtype"]integerValue] ];
    return userInfo;
}

+ (NSString *) getTimeString : (NSString *) string {
    
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

+ (WeiboUserInfo *)createdInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboUserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboUserInfo class]) inManagedObjectContext:managedObjectContext];
    
    return userInfo;
}
@end

