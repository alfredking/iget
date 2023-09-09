//
//  QLPerson.h
//  iget
//
//  Created by alfredking－cmcc on 2022/1/7.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLPerson : NSObject

@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,strong) QLStudent *student;

@end

NS_ASSUME_NONNULL_END
