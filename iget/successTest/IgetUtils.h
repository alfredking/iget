//
//  IgetUtils.h
//  iget
//
//  Created by alfredking－cmcc on 2022/2/15.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IgetUtils : NSObject

void iget_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector);

@end

NS_ASSUME_NONNULL_END
