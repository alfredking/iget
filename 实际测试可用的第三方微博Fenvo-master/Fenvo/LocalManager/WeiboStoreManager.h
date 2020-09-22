//
//  WeiboStoreManager.h
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboStore.h"


@interface WeiboStoreManager : NSObject

typedef void(^querySuccessBlock)(NSArray *timeLineArr, long long max_id);
typedef void(^queryfailureBlock)(NSString *desc);

+ (void)queryTimeLineWithMaxId:(NSNumber *)max_id
                       success:(querySuccessBlock)success
                       failure:(queryfailureBlock)failure;
+ (void)queryAllWeiboStoreSucces:(querySuccessBlock)success
                         failure:(queryfailureBlock)failure;

+ (void)removeAllWeiboStore;
+ (void)removeWeiboMsg:(long long)weiboID;

+ (WeiboStore *)updateWeiboStore:(NSDictionary *)dic;
+ (BOOL)isWeiboStoreExist:(NSNumber *)weiboID;
+ (void)saveInCoreData;

@end
