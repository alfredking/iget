//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

//样式
typedef NS_ENUM(NSInteger, CalendarStyle){
    CalendarStyle1,
    CalendarStyle2
};
@interface FDCalendar : UIView

- (instancetype)initWithCurrentDate:(NSDate *)date weekBackColor:(UIColor *)weekBackColor dateArray:(NSArray <NSDate *> *)dateArray addCalendarStyle:(CalendarStyle)style;

- (void)showDatePicker;

@end
