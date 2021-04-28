//
//  Person.m
//  iget
//
//  Created by alfredking－cmcc on 2021/4/21.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "Person.h"
 
@implementation Person
 
+(void)initialize {
    NSLog(@"%s  %@", __FUNCTION__, [self class]);
}
 
-(instancetype)init {
    NSLog(@"%s", __FUNCTION__);
    return  self;
}
 
+(void)load {
    NSLog(@"%s", __FUNCTION__);
//    NSLog(@"%s  %@", __FUNCTION__, [self class]);
}
 
@end
