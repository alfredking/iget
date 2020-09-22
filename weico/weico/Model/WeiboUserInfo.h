//
//  WeiboUserInfo.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeiboUserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * allow_all_act_msg;
@property (nonatomic, retain) NSNumber * allow_all_comment;
@property (nonatomic, retain) NSString * avatar_hd;
@property (nonatomic, retain) NSString * avatar_large;
@property (nonatomic, retain) NSNumber * bi_followers_count;
@property (nonatomic, retain) NSString * blogUrl;
@property (nonatomic, retain) NSNumber * city;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * domain;
@property (nonatomic, retain) NSNumber * follow_me;
@property (nonatomic, retain) NSNumber * followers_count;
@property (nonatomic, retain) NSNumber * following;
@property (nonatomic, retain) NSNumber * friends_count;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * geo_enabled;
@property (nonatomic, retain) NSNumber * ids;
@property (nonatomic, retain) NSString * idStr;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * mbtype;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * online_status;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * profile_url;
@property (nonatomic, retain) NSNumber * province;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSString * verified_reason;
@property (nonatomic, retain) NSString * weihao;
@property (nonatomic, retain) NSNumber * statuses_count;
@property (nonatomic, retain) NSNumber * favourites_count;

+ (WeiboUserInfo *)createdByDictionary:(NSDictionary *)dict;
@end
