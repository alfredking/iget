//
//  CoreDataManager.m
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@implementation CoreDataManager

+ (id)queryObjectInClass:(NSString *)className ID:(NSNumber *)ID
{
    NSManagedObjectContext *context = [CoreDataManager context];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    request.predicate = [NSPredicate predicateWithFormat:@"ids.longLongValue = %lld",ID.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    if (result.count > 0)return result[0];
    else return nil;
}

+ (void)removeObjectInClass:(NSString *)className ID:(NSNumber *)ID
{
    NSManagedObjectContext *context = [CoreDataManager context];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    request.predicate = [NSPredicate predicateWithFormat:@"ids.longLongValue = %lld",ID.longLongValue];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (id object in result) {
        [context deleteObject:object];
    }
    
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete all object success");
    }else {
        NSLog(@"WeiboMsgManager--delete all object fail");
    }
}

+ (void)removeAllObjectInClass:(NSString *)className
{
    NSManagedObjectContext *context = [CoreDataManager context];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:className];
    
    NSArray *arr = [context executeFetchRequest:request error:nil];
    
    for (id object in arr) {
        [context deleteObject:object];
    }
    
    //save
    if ([context save:nil]) {
        NSLog(@"WeiboMsgManager--delete all object success");
    }else {
        NSLog(@"WeiboMsgManager--delete all object fail");
    }
}

+ (NSManagedObjectContext *)context
{
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    return context;
}

@end
