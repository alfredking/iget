//
//  WeiboCommentManager.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboComment.h"

@interface WeiboCommentManager : NSObject

typedef void(^queryCommentSuccessBlock)(NSArray *commentArr, NSNumber *max_id);
typedef void(^queryCommentFailureBlock)(NSString *desc);

+ (void)queryCommentWithMaxId:(NSNumber *)max_id
                       success:(queryCommentSuccessBlock)success
                       failure:(queryCommentFailureBlock)failure;
+ (void)queryAllCommentSucces:(queryCommentSuccessBlock)success
                         failure:(queryCommentFailureBlock)failure;

+ (void)removeAllComment;
+ (void)removeComment:(NSNumber *)ids;

+ (BOOL)isCommentExist:(NSNumber *)ids;
+ (void)saveInCoreData;

@end
