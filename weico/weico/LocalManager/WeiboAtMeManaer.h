//
//  WeiboAtMeManaer.h
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboAtMeManaer : NSObject
typedef void(^queryAtMeSuccessBlock)(NSArray *atMeArray, NSNumber *max_id);
typedef void(^queryAtMeFailureBlock)(NSString *desc);

+ (void)queryAtMeStoreWithMaxId:(NSNumber *)max_id
                      success:(queryAtMeSuccessBlock)success
                      failure:(queryAtMeFailureBlock)failure;
+ (void)queryAllAtMeStoreSucces:(queryAtMeSuccessBlock)success
                      failure:(queryAtMeFailureBlock)failure;

+ (void)removeAllAtMeStore;
+ (void)removeAtMeStore:(NSNumber *)ids;

+ (BOOL)isAtMeStoreExist:(NSNumber *)ids;
+ (void)saveInCoreData;
@end
