//
//  NSString+add.m
//  historyDemo
//
//  Created by 陈乐杰 on 2018/8/9.
//  Copyright © 2018年 nst. All rights reserved.
//

#import "NSString+add.h"

@implementation NSString (add)
- (BOOL)isValid {
    if (self == nil || (NSNull *)self == [NSNull null] || self.length == 0 ) return NO;
    return YES;
}
@end
