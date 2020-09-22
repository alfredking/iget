//
//  IDMPHttpRequest.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-25.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPHttpRequest.h"
#import "ASIHttpRequest/ASIFormDataRequest.h"
#import "ASIHttpRequest/Reachability/Reachability.h"


@implementation IDMPHttpRequest
-(void)addHeadKey:(NSString *)headKey andValue:(NSString *)headValue
{
    [self addRequestHeader:headKey value:headValue];
}

-(void)addHeadByDic:(NSDictionary *)headDic
{
    for (NSString *key in headDic.allKeys) {
        [self addHeadKey :key andValue:(NSString *)[headDic objectForKey:key]];
    }
}

+(IDMPHttpRequest *)getHttpByHeads:(NSDictionary *)heads url:(NSString *)urlStr successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock;
{
    IDMPHttpRequest *getRequest = [[IDMPHttpRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [getRequest addHeadByDic:heads];
    [getRequest setCompletionBlock:successBlock];
    [getRequest setFailedBlock:failBlock];
    [getRequest startAsynchronous];
    return getRequest;
}

+(ASIFormDataRequest *)postHttpByUrl:(NSString *)urlStr postParament:(NSMutableDictionary *)postParament successBlock:(ASIBasicBlock)successBlock failBlock:(ASIBasicBlock)failBlock
{
    ASIFormDataRequest *postRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    for (NSString *key in postParament.allKeys) {
        [postRequest setPostValue:[postParament objectForKey:key] forKey:key];
    }
    [postRequest setCompletionBlock:successBlock];
    
    [postRequest setFailedBlock:failBlock];
    
    [postRequest startAsynchronous];
    
    return postRequest;
}

+(BOOL)isConnectionNet
{
    Reachability *re = [Reachability reachabilityForInternetConnection];
    return [re isReachable];
}

@end
