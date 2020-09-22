//
//  CommentRPC.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CommentRPC.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "WeiboComment.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CommentRPC

+ (void)getCommentWithSinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id success:(requestCommentSuccessBlock)success failure:(requestCommentFailureBlock)failure {
    
    dispatch_queue_t getCommentQueue = dispatch_queue_create("comment.withId.get", NULL);
    dispatch_async(getCommentQueue, ^{
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
        //http请求头应该添加text/plain。接受类型内容无text/plain
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSDictionary *dict;
        if (since_id == nil && max_id == nil) {
            dict = @{@"access_token":WEIBO_TOKEN};
        }else if(since_id != nil && max_id == nil){
            dict = @{@"access_token":WEIBO_TOKEN, @"since_id":since_id};
        }else if(since_id == nil && max_id != nil){
            dict = @{@"access_token":WEIBO_TOKEN, @"max_id":max_id};
        }
        
        [manager GET:Comment_ToMe
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSArray *commentDictionary = [jsonStrings objectFromJSONString];
                 
                 
                 if (commentDictionary.count > 0) {
                     
                     for (int i = 0; i < commentDictionary.count; i ++) {
                         NSDictionary *dict = commentDictionary[i];
                         WeiboComment *comment = [WeiboComment createByDictionary:dict Option:YES];
                         [commentArr addObject:comment];
                     }
                     
                 }
                 
                 NSNumber *since_id = ((WeiboComment *)[commentArr firstObject]).ids;
                 NSNumber *max_id = ((WeiboComment *)[commentArr lastObject]).ids;
                 
                 success([commentArr copy], since_id, max_id);
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 failure(@"Get comment failure.",error);
             }];
    });
}

+ (void)getCommentWithID:(NSNumber *)ID success:(requestCommentSuccessBlock)success failure:(requestCommentFailureBlock)failure {
    dispatch_queue_t getCommentQueue = dispatch_queue_create("comment.withId.get", NULL);
    dispatch_async(getCommentQueue, ^{
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
        //http请求头应该添加text/plain。接受类型内容无text/plain
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSDictionary *dict;
        dict = @{@"access_token":WEIBO_TOKEN, @"id":ID, @"count":@(50)};
        
        [manager GET:Comment_Show
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSArray *commentDictionary = [jsonStrings objectFromJSONString];
                 
                 
                 if (commentDictionary.count > 0) {
                     
                     for (int i = 0; i < commentDictionary.count; i ++) {
                         NSDictionary *dict = commentDictionary[i];
                         WeiboComment *comment = [WeiboComment createByDictionary:dict Option:NO];
                         [commentArr addObject:comment];
                     }
                     
                 }
                 
                 NSNumber *since_id = ((WeiboComment *)[commentArr firstObject]).ids;
                 NSNumber *max_id = ((WeiboComment *)[commentArr lastObject]).ids;
                 
                 success([commentArr copy], since_id, max_id);
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 failure(@"Get comment failure.",error);
             }];
    });
    
}

+ (void)getCommentWithID:(NSNumber *)ID SinceId:(NSNumber *)since_id orMaxId:(NSNumber *)max_id success:(requestCommentSuccessBlock)success failure:(requestCommentFailureBlock)failure {
    dispatch_queue_t getCommentQueue = dispatch_queue_create("comment.withId.get", NULL);
    dispatch_async(getCommentQueue, ^{
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
        //http请求头应该添加text/plain。接受类型内容无text/plain
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSDictionary *dict;
        if (since_id == nil && max_id == nil) {
            dict = @{@"access_token":WEIBO_TOKEN, @"id":ID};
        }else if(since_id != nil && max_id == nil){
            dict = @{@"access_token":WEIBO_TOKEN, @"id":ID, @"since_id":since_id};
        }else if(since_id == nil && max_id != nil){
            dict = @{@"access_token":WEIBO_TOKEN, @"id":ID, @"max_id":max_id};
        }
        
        [manager GET:Comment_ToMe
          parameters:dict
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas = [responserObject
                                      JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                      error:&error];
                 NSString *jsonStrings = [[NSString alloc]
                                          initWithData:jsonDatas
                                          encoding:NSUTF8StringEncoding];
                 
                 jsonStrings = [self getNormalJSONString:jsonStrings];
                 NSArray *commentDictionary = [jsonStrings objectFromJSONString];
                 
                 
                 if (commentDictionary.count > 0) {
                     
                     for (int i = 0; i < commentDictionary.count; i ++) {
                         NSDictionary *dict = commentDictionary[i];
                         WeiboComment *comment = [WeiboComment createByDictionary:dict Option:NO];
                         [commentArr addObject:comment];
                     }
                     
                 }
                 
                 NSNumber *since_id = ((WeiboComment *)[commentArr firstObject]).ids;
                 NSNumber *max_id = ((WeiboComment *)[commentArr lastObject]).ids;
                 
                 success([commentArr copy], since_id, max_id);
                 
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 failure(@"Get comment failure.",error);
             }];
    });
}

+ (NSDictionary *)requestParameters:(NSNumber *)ID
                            sinceID:(NSNumber *)sinceID
                              maxID:(NSNumber *)maxID
                               page:(NSNumber *)page
                              count:(NSNumber *)count
                       filterOption:(NSNumber *)filterByAuthor
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (WEIBO_TOKEN) [dic setObject:WEIBO_TOKEN forKey:@"access_token"];
    
    if (ID)             [dic setObject:ID       forKey:@"id"];
    if (sinceID)        [dic setObject:sinceID  forKey:@"since_id"];
    if (maxID)          [dic setObject:maxID    forKey:@"max_id"];
    if (page)           [dic setObject:page     forKey:@"page"];
    if (count)          [dic setObject:count    forKey:@"count"];
    if (filterByAuthor) [dic setObject:filterByAuthor forKey:@"filter_by_author"];
    
    return [dic copy];
}

+ (void)remoteRequest:(NSDictionary *)dic
                  URL:(NSString *)url
              success:(void(^)(id responseObject))success
              failure:(void(^)(NSString *decription))failure
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("remote.request", NULL);
    dispatch_async(downloadQueue, ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        [manager GET:url
          parameters:dic
             success:^(AFHTTPRequestOperation *operation, id responserObject){
                 NSError *error;
                 
                 NSData *jsonDatas      = [responserObject  JSONDataWithOptions:NSJSONWritingPrettyPrinted
                                                                          error:&error];
                 
                 NSString *jsonStrings  = [[NSString alloc] initWithData:jsonDatas
                                                                encoding:NSUTF8StringEncoding];
                 
                 if (!jsonStrings || [jsonStrings isEqualToString:@""])
                 {
                     failure(@"JSON Data is empty.");
                 }
                 else
                 {
                     success(jsonStrings);
                 }
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 
                 NSLog(@"AFHTTPRequestOperation error is %@",error.localizedDescription);
                 failure(@"Get JSON Data Failure.");
             }];
    });
    
}

+ (void)getCommentWithURL:(NSString *)url
                       ID:(NSNumber *)ID
                  sinceID:(NSNumber *)sinceID
                    maxID:(NSNumber *)maxID
                     page:(NSNumber *)page
                    count:(NSNumber *)count
             filterOption:(NSNumber *)filterByAuthor
                  success:(requestCommentSuccessBlock)success
                  failure:(requestCommentFailureBlock)failure
{
    NSDictionary *dic = [CommentRPC requestParameters:ID
                                              sinceID:sinceID
                                                maxID:maxID
                                                 page:page
                                                count:count
                                         filterOption:filterByAuthor];
    
    [CommentRPC remoteRequest:dic URL:url success:^(id responseObject) {
        
        NSString *jsonStrings       = [self getNormalJSONString:responseObject];
        
        NSArray  *commentDictionary = [jsonStrings objectFromJSONString];
        
        NSMutableArray *commentArr  = [[NSMutableArray alloc]init];
        
        if (commentDictionary.count > 0) {
            
            for (int i = 0; i < commentDictionary.count; i ++) {
                NSDictionary *dict = commentDictionary[i];
                WeiboComment *comment = [WeiboComment createByDictionary:dict Option:NO];
                [commentArr addObject:comment];
            }
            
        }
        
        NSNumber *since_id  = ((WeiboComment *)[commentArr firstObject]).ids;
        
        NSNumber *max_id    = ((WeiboComment *)[commentArr lastObject]).ids;
        
        success([commentArr copy], since_id, max_id);
        
    } failure:^(NSString *decription) {
        
        failure(decription,nil);
        
    }];
}


+ (NSString *)getNormalJSONString:(NSString *)jsonStrings{
    
    NSString *str1;
    
    NSRange rangeLeft = [jsonStrings rangeOfString:@"\"comments\":"];
    
    str1 = [jsonStrings substringFromIndex:rangeLeft.location+rangeLeft.length];
    
    NSRange rangeRight = [str1 rangeOfString:@"\"hasvi"];
    
    if (rangeRight.length > 0)
    {
        jsonStrings = [str1 substringToIndex:rangeRight.location - 4];
    }
    
    return jsonStrings;
}

@end
