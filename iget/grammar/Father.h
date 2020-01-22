//
//  Father.h
//  iget
//
//  Created by alfredking－cmcc on 2019/8/3.
//  Copyright © 2019 alfredking. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

//Xcode的#import比#include的好处是解决多重包含的问题，遇到了相互包含头文件的问题property with 'retain(or strong)' attribute must be of object type”解决方案就是在出错头文件中实现@class 文件名;


@interface Father : NSObject


-(void )testcopy;
-(void )testblock;

@end

NS_ASSUME_NONNULL_END
