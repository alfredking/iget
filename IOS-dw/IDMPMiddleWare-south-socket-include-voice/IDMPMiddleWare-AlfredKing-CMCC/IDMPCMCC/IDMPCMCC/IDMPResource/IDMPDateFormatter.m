//
//  IDMPDateFormatter.m
//  IDMPCMCC
//
//  Created by wj on 2017/6/29.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPDateFormatter.h"

static NSDateFormatter *cachedDateFormatter = nil;


@implementation IDMPDateFormatter

+ (NSDateFormatter *)cachedDateFormatter {
    
    // If the date formatters aren't already set up, create them and cache them for reuse.
    
    if (!cachedDateFormatter) {
        
        cachedDateFormatter = [[NSDateFormatter alloc] init];
        
        [cachedDateFormatter setLocale:[NSLocale currentLocale]];
        
        [cachedDateFormatter setDateFormat: @"yyyyMMddHHmmssSSS"];
        
    }
    return cachedDateFormatter;
}

@end
