//
//  CommentRPC.h
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Comment_ToMe @"https://api.weibo.com/2/comments/to_me.json"
#define Comment_Show @"https://api.weibo.com/2/comments/show.json"

typedef void(^requestCommentSuccessBlock)(NSArray *commentArr, NSNumber *since_id, NSNumber *max_id);
typedef void(^requestCommentFailureBlock)(NSString *desc, NSError *error);

@interface CommentRPC : NSObject

+ (void)getCommentWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id
                      success:(requestCommentSuccessBlock)success
                      failure:(requestCommentFailureBlock)failure;

+ (void)getCommentWithID:(NSNumber *)ID
                 success:(requestCommentSuccessBlock)success
                 failure:(requestCommentFailureBlock)failure;

+ (void)getCommentWithID:(NSNumber *)ID
                 SinceId:(NSNumber *)since_id
                 orMaxId:(NSNumber *)max_id
                 success:(requestCommentSuccessBlock)success
                 failure:(requestCommentFailureBlock)failure;

+ (void)getCommentWithURL:(NSString *)url
                       ID:(NSNumber *)ID
                  sinceID:(NSNumber *)sinceID
                    maxID:(NSNumber *)maxID
                     page:(NSNumber *)page
                    count:(NSNumber *)count
             filterOption:(NSNumber *)filterByAuthor
                  success:(requestCommentSuccessBlock)success
                  failure:(requestCommentFailureBlock)failure;

@end
