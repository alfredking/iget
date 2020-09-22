//
//  IDMPDate.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPDate.h"

@implementation IDMPDate

+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2 {
    if (!date1 || !date2) {
        return NO;
    }
    //calendar transform nsdate will add zone.
    NSCalendar *calendar = [NSCalendar currentCalendar];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
#pragma clang diagnostic pop
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

+ (NSDate *)currentDateWithGMT8 {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *fixDate = [date dateByAddingTimeInterval:interval];
    return fixDate;
}

@end
