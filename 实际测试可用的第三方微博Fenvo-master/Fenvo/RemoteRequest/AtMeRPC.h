//
//  AtMeRPC.h
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AtMe_FromComment @"https://api.weibo.com/2/comments/to_me.json"
#define AtMe_FromAll @"https://api.weibo.com/2/statuses/mentions.json"


typedef NS_ENUM(NSInteger, AtMeType) {
    AtMeType_FromComment,
    AtMeType_FromAll,
    AtMeType_FromOriginStatus
};

typedef void(^requestAtMeSuccessBlock)(NSArray *atMeArray, NSNumber *max_id);
typedef void(^requestAtMeFailureBlock)(NSString *desc, NSError *error);

@interface AtMeRPC : NSObject

+ (void)getAtMeWithSinceId:(NSNumber *)since_id
                   orMaxId:(NSNumber *)max_id
                  atMeType:(AtMeType)atMeType
                   success:(requestAtMeSuccessBlock)success
                   failure:(requestAtMeFailureBlock)failure;

@end
