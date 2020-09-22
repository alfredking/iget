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

@property (nonatomic,strong) NSDictionary   *responseHeaders;
@property (nonatomic,strong) NSString       *responseStr;
@property (nonatomic,assign) NSInteger httpStatusCode;

@property (nonatomic,copy) ASIBasicBlock  socketFinishblock;
@property (nonatomic,copy) ASIBasicBlock  socketErrorblock;
@property (nonatomic,strong) NSDictionary *socketHeads;
@property (nonatomic,strong) NSURL *socketUrl;
@property (nonatomic,assign) float socketTimeout;
@property (nonatomic,assign) BOOL isRetry;

@property (strong, nonatomic) IDMPHttpRequest *wapReTryRequest;



- (void)getAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
- (void)postAsynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
- (void)postSynWithBody:(NSDictionary *)body url:(NSString *)urlStr timeOut:(float)aTime successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;
//- (void)uploadAsynWithBody:(NSDictionary *)body data:(NSData *)data url:(NSString *)urlStr timeOut:(float)aTime successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;
- (void)getWapAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime  successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;
@end
