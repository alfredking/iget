//
//  WBHttpResponseResultKit.m
//  Fenvo
//
//  Created by Neil on 15/8/31.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import "WBHttpResponseResultKit.h"
#import "WeiboMsg.h"

@implementation WBHttpResponseResultKit
+ (void)timelineStringToArray:(NSString *)string
                      success:(void(^)(NSArray *array, NSNumber *since_id, NSNumber *max_id))success
                      failure:(void(^)(NSString *description))failure
{
    
    NSDictionary *dict      = [string objectFromJSONString];
    NSNumber *since_id      = @([dict[@"since_id"] longLongValue]);
    NSNumber *max_id        = @([dict[@"max_id"] longLongValue]);
    NSArray *statuses       = dict[@"statuses"];
    
    NSMutableArray *array   = [NSMutableArray array];
    
    if (statuses && statuses.count > 0)
    {
            for (int i = 0; i < statuses.count; i ++) {
                NSDictionary *dict = statuses[i];
                WeiboMsg *weiboMsg = [WeiboMsg createByDictionary:dict Option:YES];
                [array addObject:weiboMsg];
        }
        success(array, since_id, max_id);
    }
    else
    {
        failure(@"WBHttpResponseResultKit-timelineStringToArray: !array || array.count <= 0");
    }
}

@end
