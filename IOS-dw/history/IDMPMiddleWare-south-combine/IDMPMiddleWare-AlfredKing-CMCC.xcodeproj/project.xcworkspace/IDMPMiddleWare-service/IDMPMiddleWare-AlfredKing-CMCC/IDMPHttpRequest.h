//
//  IDMPHttpRequest.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-25.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPConst.h"
#import "ASIHttpRequest/ASIHTTPRequest.h"
@class ASIFormDataRequest;

@interface IDMPHttpRequest : ASIHTTPRequest

-(void)addHeadKey:(NSString *)headKey andValue:(NSString *)headValue;//增加http请求报文头内容

-(void)addHeadByDic:(NSDictionary *)headDic;

+(IDMPHttpRequest *)getHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;

+(ASIFormDataRequest *)postHttpByUrl:(NSString *)urlStr postParament:(NSMutableDictionary *)postParament successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;

+(BOOL)isConnectionNet;

@end
