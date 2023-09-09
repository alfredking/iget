//
//  IgetUtils.m
//  iget
//
//  Created by alfredking－cmcc on 2022/2/15.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "IgetUtils.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation IgetUtils

void iget_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
