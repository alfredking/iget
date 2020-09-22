//
//  IDMPHttpRequest.h
//  httptest
//
//  Created by zwk on 14/11/11.
//  Copyright (c) 2014年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ASIBasicBlock)(void);

@interface IDMPHttpRequest : NSObject
@property (nonatomic,strong) NSDictionary   *responseHeaders;
@property (nonatomic,strong) NSString       *responseStr;
@property (nonatomic,assign) NSInteger httpStatusCode;


- (void)getAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;
- (void)getWapAsynWithHeads:(NSDictionary *)heads url:(NSString *)urlStr timeOut:(float)aTime  successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;
@end
