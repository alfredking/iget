//
//  TestPerson.h
//  iget
//
//  Created by alfredking－cmcc on 2022/1/7.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestPerson : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int age;

@property (nonatomic, assign) int height;

+ (instancetype)personFromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
