//
//  WeiboCommentManager.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboCommentManager.h"

@implementation WeiboCommentManager


+ (void)queryCommentWithMaxId:(NSNumber *)max_id success:(queryCommentSuccessBlock)success failure:(queryCommentFailureBlock)failure {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    dispatch_queue_t fetchQueue = dispatch_queue_create("coredata.comment.queryWithMaxId", NULL);
    
    dispatch_async(fetchQueue, ^{
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboComment class])];
        //升序则ascending为YES，否则为NO
        NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc]initWithKey:@"ids" ascending:NO];
        [request setSortDescriptors:@[sortDesciptor]];
        request.predicate = [NSPredicate predicateWithFormat:@"ids < %lld", max_id.longLongValue];
        request.fetchLimit = 20;
        
        
        NSArray *arr = [context executeFetchRequest:request error:nil];
        
        if (arr.count > 0) {
            WeiboComment *comment = [arr lastObject];
            success(arr, [comment.ids copy]);
        }else {
            failure(@"That is no cache.");
        }
        
    });
    
}

+ (void)queryAllCommentSucces:(queryCommentSuccessBlock)success failure:(queryCommentFailureBlock)failure {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    dispatch_queue_t queryQueue = dispatch_queue_create("coredata.comment.queryAll", NULL);
    dispatch_async(queryQueue, ^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboComment class])];
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"ids" ascending:NO];
        [request setSortDescriptors:@[sortDesc]];
        request.fetchLimit = 20;
        
        
        NSArray *arr = [context executeFetchRequest:request error:nil];
        
        if (arr.count > 0) {
            WeiboComment *comment = [arr lastObject];
            success(arr, comment.ids);
        }else {
            failure(@"That is no cache.");
        }
        
    });
}

+ (void)removeAllComment {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    dispatch_queue_t queryQueue = dispatch_queue_create("coredata.comment.removeAll", NULL);
    dispatch_async(queryQueue, ^{
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboComment class])];
        
        NSArray *arr = [context executeFetchRequest:request error:nil];
        
        for (WeiboComment *comment in arr) {
            [context deleteObject:comment];
        }
        
        if ([context save:nil]) {
            NSLog(@"WeiboStoreManager--delete all object success");
        }else {
            NSLog(@"WeiboStoreManager--delete all object fail");
        }
    });
}

+ (void)removeComment:(NSNumber *)ids {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboComment class])];
    request.predicate = [NSPredicate predicateWithFormat:@"ids.longLongValue = %ld",ids.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboComment *comment in result) {
        [context deleteObject:comment];
    }

    if ([context save:nil]) {
        NSLog(@"WeiboStoreManager--delete object success");
    }else {
        NSLog(@"WeiboStoreManager--delete object fail");
    }
    
}

+ (BOOL)isCommentExist:(NSNumber *)ids {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboComment class])];
    request.predicate = [NSPredicate predicateWithFormat:@"ids.longLongValue = %lld",ids.longLongValue];
    
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
