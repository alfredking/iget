//
//  WeiboMsgManager.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboMsgManager.h"
#import "WeiboMsg.h"

@implementation WeiboMsgManager

+ (NSArray *)getWeiboMsgInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    
    /**************
     通过CoreData获取sqlite中的WeiboMsg数据
     *************/
    
    //通过实体名进行请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([WeiboMsg class])];
    
    //定义分组与排序规则：通过weiboMsg.ids进行排序
    NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc]initWithKey:@"ids" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDesciptor]];
    
    //请求结果进行转换，转换为WeiboMsg数据对象
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                                              managedObjectContext:managedObjectContext
                                                                                                sectionNameKeyPath:nil
                                                                                                         cacheName:nil];
    
    NSError *error;
    if ([fetchedResultsController performFetch:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    
    NSArray *weiboMsgArr = [fetchedResultsController fetchedObjects];
    
    return weiboMsgArr;
}



+ (NSArray *)queryAllWeiboMsg {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboMsg class])];
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    return arr;
}

+ (void)removeAllWeiboMsg {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboMsg class])];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    for (WeiboMsg *weiboMsg in arr) {
        [context deleteObject:weiboMsg];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete all object success");
    }else {
        NSLog(@"WeiboMsgManager--delete all object fail");
    }
    
}

+ (void)removeWeiboMsg:(long long)weiboID {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboMsg class])];
    request.predicate = [NSPredicate predicateWithFormat:@"ids = %ld",weiboID];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (WeiboMsg *weiboMsg in result) {
        [context deleteObject:weiboMsg];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete object success");
    }else {
        NSLog(@"WeiboMsgManager--delete object fail");
    }
    
}

+ (void)modifiedWeibo:(WeiboMsg *)weiboMsg {
    
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboMsg class])];
    request.predicate = [NSPredicate predicateWithFormat:@"ids = %ld",weiboMsg.ids.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];

    for (WeiboMsg *weiboMsg_query in result) {
        weiboMsg_query.favorited = weiboMsg.favorited;
        weiboMsg_query.comments_count = weiboMsg.comments_count;
        weiboMsg_query.reposts_count = weiboMsg.reposts_count;
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete object success");
    }else {
        NSLog(@"WeiboMsgManager--delete object fail");
    }
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

+ (WeiboMsg *)queryObject:(NSNumber *)ID {

    NSManagedObjectContext *context = [WeiboMsgManager context];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WeiboMsg class])];
    request.predicate = [NSPredicate predicateWithFormat:@"ids.longLongValue = %lld",ID.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    if (result.count > 0)return result[0];
    else return nil;
}

+ (NSManagedObjectContext *)context {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    return context;
}
@end
