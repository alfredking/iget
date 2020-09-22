//
//  WeiboAtMeStore.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboAtMeStore.h"
#import "WeiboMsg.h"


@implementation WeiboAtMeStore

@dynamic atMeID;
@dynamic weiboMsg;
@dynamic height;

+ (WeiboAtMeStore *)createByWeiboMsg:(WeiboMsg *)weiboMsg {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboAtMeStore *atMeStore = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboAtMeStore class]) inManagedObjectContext:managedObjectContext];
    
    atMeStore.weiboMsg = weiboMsg;
    atMeStore.atMeID = weiboMsg.ids;
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"%@",[error description]);
    }
    return atMeStore;
}

@end
