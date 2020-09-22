//
//  TimeLineRPC.h
//  Fenvo
//
//  Created by Caesar on 15/7/26.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Public_TimeLine @"https://api.weibo.com/2/statuses/public_timeline.json"
#define Home_TimeLine   @"https://api.weibo.com/2/statuses/home_timeline.json"

typedef void(^publicTimeLineBlock)(NSArray *timeLineArr, NSNumber *since_id, NSNumber *max_id, NSNumber *previous_cursor, NSNumber *next_cursor);
typedef void(^homeTimeLineBlock)(NSArray *timeLineArr, NSNumber *since_id, NSNumber *max_id, NSNumber *previous_cursor, NSNumber *next_cursor);
typedef void(^failureBlock)(NSString *desc, NSError *error);

@interface TimeLineRPC : NSObject

+ (void)getPublicTimeLineWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id
                             success:(publicTimeLineBlock)success
                             failure:(failureBlock)failure;

+ (void)getHomeTimeLineWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id
                           success:(homeTimeLineBlock)success
                           failure:(failureBlock)failure;

+ (void)downloadTimeLineWithCount:(NSNumber *)count
                          success:(homeTimeLineBlock)success
                          failure:(failureBlock)failure;
@end
