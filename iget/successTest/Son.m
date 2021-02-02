//
//  Son.m
//  iget
//
//  Created by alfredking－cmcc on 2021/1/29.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "Son.h"
#import "Fathers.h"


@implementation Son
- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
        NSLog(@"%@", NSStringFromClass([Fathers class]));
        NSLog(@"[self class] is %@",[self class]);
        NSLog(@"[super class] is %@",[super class]);
        
        
        
        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
                BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
                BOOL res3 = [(id)[Son class] isKindOfClass:[Son class]];
                BOOL res4 = [(id)[Son class] isMemberOfClass:[Son class]];
                NSLog(@"%d %d %d %d", res1, res2, res3, res4);

       
        
    }
    return self;
}
@end

