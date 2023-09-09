//
//  TestPerson.m
//  iget
//
//  Created by alfredking－cmcc on 2022/1/7.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestPerson.h"

@implementation TestPerson

+ (instancetype)personFromDict:(NSDictionary *)dict {
    TestPerson *person = [[TestPerson alloc] init];

    [person setValuesForKeysWithDictionary:dict];

    return person;

}

// 避免属性和key没有一一对应时程序崩溃

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}


@end
