//
//  NSObject+Person.m
//  shiyan
//
//  Created by liu on 2018/4/18.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "NSObject+Person.h"
#import <objc/runtime.h> //或者 #import <objc/message.h>
static NSString *nameKey = @"nameKey"; //name的key

@interface NSObject ()

@end

@implementation NSObject (Person)

/**
 setter方法
 */
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY);
}

/**
 getter方法
 */
- (NSString *)name {
    return objc_getAssociatedObject(self, &nameKey);
}

@end
