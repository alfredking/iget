//
//  QYHTTPRequest.h
//  QYWB
//
//  Created by iOS on 16/8/15.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AnyHTTPRequest : NSObject

+ (void)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

+ (void)POST:(NSString *)URLString parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)POST:(NSString *)URLString parameters:(id)parameters flag:(NSString *)flag progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;


@end
