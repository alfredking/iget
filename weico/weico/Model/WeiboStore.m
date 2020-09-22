//
//  WeiboStore.m
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboStore.h"
#import "WeiboMsg.h"


@implementation WeiboStore

@dynamic weiboID;
@dynamic weiboMsg;

+ (WeiboStore *)createByWeiboMsg:(WeiboMsg *)weiboMsg {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboStore *weiboStore = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboStore class]) inManagedObjectContext:managedObjectContext];
    
    weiboStore.weiboMsg = weiboMsg;
    weiboStore.weiboID = [NSNumber numberWithLongLong:weiboMsg.ids];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"%@",[error description]);
    }
    return weiboStore;
}

@end
