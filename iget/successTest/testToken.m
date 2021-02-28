//
//  testToken.m
//  iget
//
//  Created by alfredking－cmcc on 2021/2/8.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "testToken.h"

@implementation testToken
NSString *getToken()
{
  
    static NSLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
        NSLog(@"lock init");
    });
    
    NSLog(@"lock is %@",lock);
    [lock lock];
    
    NSLog(@"IN THE MIDDLE OF lock init");
    [lock unlock];
    
    NSString *result = @"test";
    return result;


}
@end
