//
//  CoreDataManager.h
//  Fenvo
//
//  Created by Caesar on 15/8/20.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject
+ (id)queryObjectInClass:(NSString *)className ID:(NSNumber *)ID;
+ (void)removeObjectInClass:(NSString *)className ID:(NSNumber *)ID;
+ (void)removeAllObjectInClass:(NSString *)className;
@end
