//
//  DiskCacheManager.m
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "DiskCacheManager.h"
#import "WeiboMsg.h"
#import "WeiboComment.h"
#import "NSString+MD5String.h"
#import "CoreDataManager.h"

@implementation DiskCacheManager

+ (void)setDiskCache:(NSString *)key
              object:(id)object {
    if (!key || [key isEqualToString:@""]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:[NSString MD5:key]];
}

+ (void)getDiskCache:(NSString *)key
             success:(void(^)(id responseObject))success
             failure:(void(^)(NSString *decription))failure {
    if (!key || [key isEqualToString:@""]) {
        failure(@"DiskCacheManager-GetDiskCache-Failure: !key || [key isEqualToString:@""]");
    }
    id object = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString MD5:key]];
    if (!object) {
        failure(@"DiskCacheManager-GetDiskCache-Failure: !object");
    }else {
        success(object);
    }
}

//WeiboMsg Disk Cache
+ (void)compressObject:(NSArray *)arrTimeLine
            ObjectType:(CacheObjectType)type
           autoSaveKey:(NSString *)key {
    if (!arrTimeLine || arrTimeLine.count == 0) {
        return;
    }
    
    NSMutableArray *arrID = [[NSMutableArray alloc]init];

    switch (type) {
        case CacheObjectType_Status:
            for (WeiboMsg *weibo in arrTimeLine) {
                [arrID addObject:weibo.ids];
            }
            break;
        case CacheObjectType_Comment:
            for (WeiboComment *comment in arrTimeLine) {
                [arrID addObject:comment.ids];
            }
            break;
        default:
            break;
    }
    
    NSData *encodeData_arrID = [NSKeyedArchiver archivedDataWithRootObject:(NSArray *)[arrID copy]];
    if (key && ![key isEqualToString:@""]) {
        [DiskCacheManager setDiskCache:[NSString MD5:key] object:encodeData_arrID];
    }
}

+ (void)extractObjectWithKey:(NSString *)key
                  objectType:(CacheObjectType)type
                     success:(void(^)(NSArray *arrTimeLine, NSNumber *since_id, NSNumber *max_id))success
                     failure:(void(^)(NSString *description))failure
{
    if (!key || [key isEqualToString:@""]) {
        failure(@"DiskCacheManager-ExtractObject-Failure: !key || [key isEqualToString:@""]");
    }
    
    [DiskCacheManager getDiskCache:[NSString MD5:key] success:^(id responseObject) {
        
        NSArray *arrID = [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
        
        if (!arrID || arrID.count == 0) {
            failure(@"DiskCacheManager-ExtractObject-Failure: !arrID || arrID.count == 0");
        }
        
        NSMutableArray *arrTimeLine = [[NSMutableArray alloc]init];
        
        NSNumber *sinceID;
        NSNumber *maxID;
        
        switch (type) {
            case CacheObjectType_Status:
            {
                for (NSNumber *ID in arrID) {
                    WeiboMsg *weibo = [CoreDataManager queryObjectInClass:NSStringFromClass([WeiboMsg class]) ID:ID];
                    if (weibo) [arrTimeLine addObject:weibo];
                }
                WeiboMsg *firstObject   = [arrTimeLine firstObject];
                WeiboMsg *lastObject    = [arrTimeLine lastObject];
                sinceID                 = firstObject.ids;
                maxID                   = lastObject.ids;
            }
                break;
            case CacheObjectType_Comment:
            {
                for (NSNumber *ID in arrID) {
                    WeiboComment *comment = [CoreDataManager queryObjectInClass:NSStringFromClass([WeiboComment class]) ID:ID];
                    if (comment) [arrTimeLine addObject:comment];
                }
                WeiboComment *firstObject   = [arrTimeLine firstObject];
                WeiboComment *lastObject    = [arrTimeLine lastObject];
                sinceID                     = firstObject.ids;
                maxID                       = lastObject.ids;
            }
                break;
            default:
                break;
        }
        
        
        if (arrTimeLine.count > 0) {
            success(arrTimeLine,sinceID,maxID);
        }else {
            failure(@"DiskCacheManager-ExtractObject-Failure: arrTimeLine.count == 0");
        }
        
    } failure:^(NSString *decription) {
        failure(decription);
    }];
}

//Clear
+ (BOOL)clearDiskCache:(NSString *)key
                 error:(void(^)(NSString *description))error
{
    if (!key || [key isEqualToString:@""]) {
        error(@"DiskCacheManager-ClearDiskCache-Failure: !key || [key isEqualToString:@""]");
        return NO;
    }
    
    [DiskCacheManager getDiskCache:[NSString MD5:key] success:^(id responseObject) {
        NSArray *arrID = [NSKeyedUnarchiver unarchiveObjectWithData:responseObject];
        
        if (!arrID || arrID.count == 0) {
            error(@"DiskCacheManager-ClearDiskCache-Failure: !arrID || arrID.count == 0");
        }
        
        for (NSNumber *ID in arrID) {
            [CoreDataManager removeObjectInClass:NSStringFromClass([WeiboMsg class]) ID:ID];
        }
    } failure:^(NSString *decription) {
        error(decription);
    }];
    return YES;
}

@end
