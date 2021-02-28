//
//  CalendarCustomVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "CalendarCustomVC.h"
#import "FDCalendar.h"

@interface CalendarCustomVC ()
@property (nonatomic ,strong) FDCalendar *calendar;
@end

@implementation CalendarCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCalendar];
}

- (void)addCalendar{
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date] weekBackColor:[UIColor orangeColor] dateArray:nil addCalendarStyle:CalendarStyle1];
    self.calendar = calendar;
    //    CGRect frame = calendar.frame;
    //    frame.origin.y = 0;
    calendar.frame = CGRectMake(0, STATUS_NAV_HEIGHT, kScreenWidth, kScreenHeight - 70 - 10);
    [self.view addSubview:calendar];
}

@end
