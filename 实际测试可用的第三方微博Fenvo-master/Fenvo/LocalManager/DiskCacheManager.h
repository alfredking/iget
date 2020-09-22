//
//  DiskCacheManager.h
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CacheObjectType)
{
    CacheObjectType_Status,
    CacheObjectType_Comment
};

@interface DiskCacheManager : NSObject
+ (void)setDiskCache:(NSString *)key
              object:(id)object;
+ (void)getDiskCache:(NSString *)key
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSString *decription))failure;

+ (void)compressObject:(NSArray *)arrTimeLine
            ObjectType:(CacheObjectType)type
           autoSaveKey:(NSString *)key;
+ (void)extractObjectWithKey:(NSString *)key
                  objectType:(CacheObjectType)type
                     success:(void(^)(NSArray *arrTimeLine, NSNumber *since_id, NSNumber *max_id))success
                     failure:(void(^)(NSString *description))failure;
@end
