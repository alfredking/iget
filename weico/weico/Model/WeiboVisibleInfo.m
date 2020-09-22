//
//  WeiboVisibleInfo.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboVisibleInfo.h"


@implementation WeiboVisibleInfo

@dynamic list_id;
@dynamic type;


+ (WeiboVisibleInfo *)createdByDictionary:(NSDictionary *)visible{
    WeiboVisibleInfo *visibleInfo = [WeiboVisibleInfo createdInCoreData];
    
    visibleInfo.type = [NSNumber numberWithInteger:[visible[@"type"]integerValue]];
    visibleInfo.list_id = [NSNumber numberWithInteger:[visible[@"list_id"]integerValue] ];
    
    return visibleInfo;
}

+ (WeiboVisibleInfo *)createdInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboVisibleInfo *visibleInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboVisibleInfo class]) inManagedObjectContext:managedObjectContext];
    
    return visibleInfo;
}
@end
