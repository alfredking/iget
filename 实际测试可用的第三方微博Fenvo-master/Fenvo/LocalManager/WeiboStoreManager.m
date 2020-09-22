//
//  WeiboStoreManager.m
//  Fenvo
//
//  Created by Caesar on 15/7/29.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboStoreManager.h"
#import "WeiboStore.h"
#import "WeiboMsg.h"

@implementation WeiboStoreManager


+ (void)queryTimeLineWithMaxId:(NSNumber *)max_id success:(querySuccessBlock)success failure:(queryfailureBlock)failure {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];

    
    dispatch_queue_t fetchQueue = dispatch_queue_create("coredata.query.withMaxId", NULL);
    
    dispatch_async(fetchQueue, ^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
        //升序则ascending为YES，否则为NO
        NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc]initWithKey:@"weiboMsg.ids" ascending:NO];
        [request setSortDescriptors:@[sortDesciptor]];
        request.predicate = [NSPredicate predicateWithFormat:@"weiboMsg.ids.longLongValue < %lld", max_id.longLongValue];
        request.fetchLimit = 20;
        NSArray *arr = [context executeFetchRequest:request error:nil];
       
        if (arr.count > 0) {
            
            NSMutableArray *weiboArr = [[NSMutableArray alloc]init];
            for (WeiboStore *weiboStore in arr) {
                [weiboArr addObject:weiboStore.weiboMsg];
            }
            WeiboMsg *weibo = [weiboArr lastObject];
        
            long long max_id = [weibo.ids longLongValue];
            success([weiboArr copy], max_id);
        }else {
            failure(@"That is no cache.");
        }
        
    });
    
}


+ (void)queryAllWeiboStoreSucces:(querySuccessBlock)success failure:(queryfailureBlock)failure {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    dispatch_queue_t queryQueue = dispatch_queue_create("coredata.query.all", NULL);
    dispatch_async(queryQueue, ^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"weiboMsg.ids" ascending:NO];
        [request setSortDescriptors:@[sortDesc]];
        request.fetchLimit = 20;
        NSArray *arr = [context executeFetchRequest:request error:nil];
        
        NSMutableArray *weiboArr = [[NSMutableArray alloc]init];
        for (WeiboStore *weiboStore in arr) {
            [weiboArr addObject:weiboStore.weiboMsg];
        }
        
        if (weiboArr.count > 0) {
            success(weiboArr, 0);
        }
        else {
            failure(@"That is no cache.");
        }
    });
}

+ (NSArray *)sortArray:(NSArray *)array {
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        WeiboStore *obj_1 = (WeiboStore *)obj1;
        WeiboStore *obj_2 = (WeiboStore *)obj2;
        NSComparisonResult result = [obj_1.weiboID compare:obj_2.weiboID];
        return result;
    }];
    return sortArray;
}

+ (void)removeAllWeiboStore {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    for (WeiboStore *weiboStore in arr) {
        [context deleteObject:weiboStore];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboStoreManager--delete all object success");
    }else {
        NSLog(@"WeiboStoreManager--delete all object fail");
    }
    
}

+ (void)removeWeiboMsg:(long long)weiboID {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"weiboID = %ld",weiboID];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboStore *weiboStore in result) {
        [context deleteObject:weiboStore];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboStoreManager--delete object success");
    }else {
        NSLog(@"WeiboStoreManager--delete object fail");
    }
    
}

+ (WeiboStore *)updateWeiboStore:(NSDictionary *)dic {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"weiboID = %lld",[dic[@"id"] longLongValue]];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboStore *weiboStore_query in result) {
        WeiboMsg *weiboMsg = weiboStore_query.weiboMsg;
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
    
    return (WeiboStore *)result[0];
}

+ (BOOL)isWeiboStoreExist:(NSNumber *)weiboID {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboStore class])];
    request.predicate = [NSPredicate predicateWithFormat:@"weiboID = %lld",weiboID.longLongValue];
    
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
