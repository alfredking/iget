//
//  QYHTTPRequest.m
//  QYWB
//
//  Created by iOS on 16/8/15.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "AnyHTTPRequest.h"

@implementation AnyHTTPRequest

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [set copy];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];

    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 10.0f;
    
    [manager.requestSerializer setTimeoutInterval:10.f];
    
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 10.f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //[AFHTTPResponseSerializer serializer];// NSData
    //[AFJSONResponseSerializer serializer]; // JSON
    //[AFXMLParserResponseSerializer serializer]; // NSXMLParser
    //[AFImageResponseSerializer serializer]; // UIImage
    //[AFPropertyListResponseSerializer serializer];
    //[AFCompoundResponseSerializer serializer];
    
    return manager;
}

+ (AFHTTPSessionManager *)dataManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [set copy];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
//    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer setTimeoutInterval:10.f];
    
    //    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //    manager.requestSerializer.timeoutInterval = 10.f;
    //    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return manager;
}

// GET请求
+ (void)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))downloadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[self manager] GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
}

// 普通的POST请求
+ (void)POST:(NSString *)URLString parameters:(id)parameters flag:(NSString *)flag progress:(void (^)(NSProgress *progress))uploadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *arrUser = [NSMutableArray new];
        
        [arrUser addObject:responseObject];
        
        if (success) {
            success(task,[arrUser copy]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        ActivityIndicator(NO);
    }];
    
    
    
}

// 文件上传的POST请求
+ (void)POST:(NSString *)URLString parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))uploadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [[self manager] POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

@end
