//
//  IDMPHttpRequest.h
//  httptest
//
//  Created by zwk on 14/11/11.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ASIBasicBlock)(void);
typedef void (^accessBlock)(NSDictionary *paraments);

@interface IDMPHttpRequest : NSObject

@property (nonatomic,strong) NSDictionary *responseHeaders;
@property (nonatomic,strong) NSDictionary *responseStr;

@property (nonatomic,copy) ASIBasicBlock  socketFinishblock;
@property (nonatomic,copy) ASIBasicBlock  socketErrorblock;
@property (nonatomic,strong) NSDictionary *socketHeads;
@property (nonatomic,strong) NSURL *socketUrl;
@property (nonatomic,assign) float socketTimeout;

- (void)getHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;

- (void)getWapHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;

- (void)getWithHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;


- (void)getHttpWithDict:(NSDictionary *)content url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;

- (void)xmlHttpRequestWithXml:(NSString *)xml url:(NSString *)urlStr successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

@end