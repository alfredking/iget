//
//  WeiboVisibleInfo.m
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboVisibleInfo.h"

@implementation WeiboVisibleInfo
-(WeiboVisibleInfo *)initWithDictionary:(NSDictionary *)visible{
    self.type = [visible[@"type"]integerValue];
    self.list_id = [visible[@"list_id"]integerValue];
    return self;
}
@end
