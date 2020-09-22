//
//  UserManager.m
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "UserManager.h"
#import "WeiboUserInfo.h"

@implementation UserManager

+ (WeiboUserInfo *)queryObject:(NSNumber *)ID {
    return nil;
}

+ (NSManagedObjectContext *)context {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    return context;
}
@end
