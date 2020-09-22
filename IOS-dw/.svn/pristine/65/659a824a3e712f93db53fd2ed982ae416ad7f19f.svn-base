//
//  IDMPHttpRequest.h
//  httptest
//
//  Created by zwk on 14/11/11.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ASIBasicBlock)(void);
typedef void (^accessBlock)(NSDictionary *parameters);


@interface IDMPHttpRequest : NSObject

- (void)getAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
- (void)postAsynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
- (void)postSynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
- (void)getWapAsynWithHeads:(NSDictionary *)heads urlStr:(NSString *)urlStr timeOut:(float)aTime isRetry:(BOOL)isRetry successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

//只用与获取本机号码接口
- (void)getWapMobileAsynWithHeads:(NSDictionary *)heads url:(NSURL *)url timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

@end
