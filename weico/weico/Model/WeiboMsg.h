//
//  WeiboMsg.h
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeiboGeoInfo, WeiboMsg, WeiboUserInfo, WeiboVisibleInfo;

#define SimpleDataKey_AttitudesCount @"attitudes_count"
#define SimpleDataKey_BmiddlePic @"bmiddle_pic"
#define SimpleDataKey_CommentCount @"comments_count"
#define SimpleDataKey_CreatedAt @"created_at"
#define SimpleDataKey_Favorited @"favorited"
#define SimpleDataKey_ID @"id"
#define SimpleDataKey_Mid @"mid"
#define SimpleDataKey_IDStr @"idstr"
#define SimpleDataKey_RepostsCount @"reposts_count"
#define SimpleDataKey_Source @"source"
#define SimpleDataKey_ThumbnailPic @"thumbnail_pic"
#define SimpleDataKey_Truncated @"truncated"
#define SimpleDataKey_Status @"status"
#define SimpleDataKey_PicUrls @"pic_urls"
#define SimpleDataKey_PicIDs @"pic_ids"
#define SimpleDataKey_OriginalPicUrls @"original_pic_urls"
#define SimpleDataKey_BmiddlePicUrls @"bmiddle_pic_urls"
#define SimpleDataKey_OriginalPic @"original_pic"
#define SimpleDataKey_Height @"height"
#define CustomDataKey_Geo @"geo"
#define CustomDataKey_RetweetedStatus @"retweeted_status"
#define CustomDataKey_User @"user"
#define CustomDataKey_Visible @"visible"
#define SimpleDataKey_VideoUrl @"video_url"

@interface WeiboMsg : NSManagedObject<NSCoding>

@property (nonatomic, retain) NSNumber * attitudes_count;
@property (nonatomic, retain) NSString * bmiddle_pic;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * ids;
@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) NSNumber * mid;
@property (nonatomic, retain) NSNumber * reposts_count;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * thumbnail_pic;
@property (nonatomic, retain) NSNumber * truncated;
@property (nonatomic, retain) NSString * wbDetail;
@property (nonatomic, retain) NSString * pic_urls;
@property (nonatomic, retain) NSString * video_url;
@property (nonatomic, retain) NSString * pic_ids;
@property (nonatomic, retain) NSString * original_pic_urls;
@property (nonatomic, retain) NSString * bmiddle_pic_urls;
@property (nonatomic, retain) NSString * original_pic;
@property (nonatomic, retain) WeiboGeoInfo *geo;
@property (nonatomic, retain) WeiboMsg *retweeted_status;
@property (nonatomic, retain) WeiboUserInfo *user;
@property (nonatomic, retain) WeiboVisibleInfo *visible;

+ (WeiboMsg *)createByDictionary:(NSDictionary *)dic Option:(BOOL)isSave;
@end
