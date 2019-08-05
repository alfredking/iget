//
//  Son.h
//  iget
//
//  Created by alfredking－cmcc on 2019/8/3.
//  Copyright © 2019 alfredking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Father.h"
NS_ASSUME_NONNULL_BEGIN

@class Father;
@interface Son : NSObject

@property(strong,nonatomic)Father *father;

@end

NS_ASSUME_NONNULL_END
