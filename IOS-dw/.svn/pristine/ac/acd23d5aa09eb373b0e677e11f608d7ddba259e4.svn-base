//
//  NSTimer+IDMPBlocks.m
//  IDMPCMCC
//
//  Created by wj on 2017/5/2.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "NSTimer+IDMPBlocks.h"

@implementation NSTimer (IDMPBlocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)(void))inBlock repeats:(BOOL)inRepeats
{
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jsp_ExecuteBlock:) userInfo:[inBlock copy] repeats:inRepeats];
    return ret;
}

+(void)jsp_ExecuteBlock:(NSTimer *)inTimer
{
    if([inTimer userInfo])
    {
        void (^block)(void) = (void (^)(void))[inTimer userInfo];
        block();
    }
}

@end
