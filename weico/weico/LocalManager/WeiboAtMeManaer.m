//
//  WeiboAtMeManaer.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboAtMeManaer.h"
#import "WeiboAtMeStore.h"
#import "WeiboMsg.h"

@implementation WeiboAtMeManaer

+ (void)queryAtMeStoreWithMaxId:(NSNumber *)max_id success:(queryAtMeSuccessBlock)success failure:(queryAtMeFailureBlock)failure {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    dispatch_queue_t fetchQueue = dispatch_queue_create("coredata.queryAtMe.withMaxId", NULL);
    
    dispatch_async(fetchQueue, ^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboAtMeStore class])];
        //升序则ascending为YES，否则为NO
        NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc]initWithKey:@"weiboMsg.ids" ascending:NO];
        [request setSortDescriptors:@[sortDesciptor]];
        request.predicate = [NSPredicate predicateWithFormat:@"weiboMsg.ids.longLongValue < %lld", max_id.longLongValue];
        request.fetchLimit = 20;
        NSArray *arr = [context executeFetchRequest:request error:nil];
        
        if (arr.count > 0) {
            
            NSMutableArray *atMeArray = [[NSMutableArray alloc]init];
            for (WeiboAtMeStore *atMe in arr) {
                [atMeArray addObject:atMe];
            }
            WeiboMsg *weibo = ((WeiboAtMeStore *)[atMeArray lastObject]).weiboMsg;
            
            success([atMeArray copy], weibo.ids);
        }else {
            failure(@"That is no cache.");
        }
        
    });
    
}


+ (void)queryAllAtMeStoreSucces:(queryAtMeSuccessBlock)success failure:(queryAtMeFailureBlock)failure {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    dispatch_queue_t queryQueue = dispatch_queue_create("coredata.queryAtMe.all", NULL);
    dispatch_async(queryQueue, ^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboAtMeStore class])];
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"weiboMsg.ids" ascending:NO];
        [request setSortDescriptors:@[sortDesc]];
        request.fetchLimit = 20;
        NSArray *arr = [context executeFetchRequest:request error:nil];
        
        NSMutableArray *atMeArray = [[NSMutableArray alloc]init];
        for (WeiboAtMeStore *atMe in arr) {
            [atMeArray addObject:atMe];
        }
        
        if (atMeArray.count > 0) {
            success(atMeArray, 0);
        }
        else {
            failure(@"That is no cache.");
        }
    });
}

+ (void)removeAllAtMeStore {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboAtMeStore class])];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    for (WeiboAtMeStore *atMe in arr) {
        [context deleteObject:atMe];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboAtMeManager--delete all object success");
    }else {
        NSLog(@"WeiboAtMeManager--delete all object fail");
    }
    
}

+ (void)removeAtMeStore:(NSNumber *)ids {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboAtMeStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"atMeID.longLongValue = %ld",ids.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboAtMeStore *atMe in result) {
        [context deleteObject:atMe];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboAtMeManager--delete object success");
    }else {
        NSLog(@"WeiboAtMeManager--delete object fail");
    }
    
}

+ (WeiboAtMeStore *)updateWeiboStore:(NSDictionary *)dic {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboAtMeStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"atMeID.longLongValue = %lld",[dic[@"id"] longLongValue]];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboAtMeStore *atMe_query in result) {
        WeiboMsg *weiboMsg = atMe_query.weiboMsg;
        weiboMsg.attitudes_count = [NSNumber numberWithInteger:[dic[@"attitudes_count"]integerValue]];
        weiboMsg.reposts_count = [NSNumber numberWithInteger:[dic[@"reposts_count"]integerValue]];
        weiboMsg.comments_count = [NSNumber numberWithInteger:[dic[@"comments_count"]integerValue]];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete object success");
    }else {
        NSLog(@"WeiboMsgManager--delete object fail");
    }
    
    return (WeiboAtMeStore *)result[0];
}

+ (BOOL)isAtMeStoreExist:(NSNumber *)ids {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboAtMeStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"atMeID.longLongValue = %lld",ids.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    if (result.count > 0)return true;
    else return false;
}

+ (void)saveInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

@end
