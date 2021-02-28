//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"
#import "UIColor+HEX.h"


//#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define typeViewBackgroundColor @"f3f3f3"
#define NavBarColorHex @"ff2854"
#define IMG(name)       [UIImage imageNamed:name]
#define LineViewBackgroundColor @"D9D9D9"
#define detailTextColol @"292929"

#define Weekdays @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]

static NSDateFormatter *dateFormattor;

@interface FDCalendar () <UIScrollViewDelegate, FDCalendarItemDelegate>
{

    CGFloat _weekHeaderHeight;
}
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (nonatomic, strong) UIColor *weekBackColor;

@end

@implementation FDCalendar

- (instancetype)initWithCurrentDate:(NSDate *)date weekBackColor:(UIColor *)weekBackColor dateArray:(NSArray<NSDate *> *)dateArray addCalendarStyle:(CalendarStyle)style{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.date = date;
        self.weekBackColor = weekBackColor;
        if (style == CalendarStyle1) {

            _weekHeaderHeight = 100;


            [self setupTitleBar];
            [self setupWeekHeader];
        }else{

            _weekHeaderHeight = 105;
            [self configerTitleHeader];
    
        }

        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        
        [self setCurrentDate:self.date];
        self.centerCalendarItem.dateArray = dateArray;
    }
    return self;
}

-(void)configerTitleHeader{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _weekHeaderHeight)];
    backView.backgroundColor = [UIColor colorWithHexString:typeViewBackgroundColor];
    [self addSubview:backView];
    
    UIView *instructionView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    instructionView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:instructionView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, 16, 16)];
    imageView.image = IMG(@"mer_fangxing_red");
    imageView.layer.cornerRadius = 4;
    imageView.layer.masksToBounds = YES;
    [instructionView addSubview:imageView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(47, 5.5, kScreenWidth - 47, 19)];
    [instructionView addSubview:titleLable];
  
    // NSString *classificationStr = @"  婚纱摄影-西安";
    NSString *titleStr = @"红色已定档期";
    NSString *classificationStr =[NSString stringWithFormat:@"   %@",@"注:具体档期请与商家核实"];
    NSString *str = [NSString stringWithFormat:@"%@%@",titleStr,classificationStr];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:titleStr].location, [[noteStr string] rangeOfString:titleStr].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:NavBarColorHex] range:redRange];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.f] range:redRange];
    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:classificationStr].location, [[noteStr string] rangeOfString:classificationStr].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:redRangeTwo];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:redRangeTwo];
    [titleLable setAttributedText:noteStr];
    [titleLable sizeToFit];
    
   
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(instructionView.frame), kScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:LineViewBackgroundColor];
    [backView addSubview:lineView1];
    

    UIView *weekDayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame), kScreenWidth, 44)];
    weekDayView.backgroundColor = [UIColor colorWithHexString:typeViewBackgroundColor];
    [backView addSubview:weekDayView];
    
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 0;
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 0, (DeviceWidth) / count, 44)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.text = Weekdays[i];
        
        if (i == 0 || i == count - 1) {
            weekdayLabel.textColor = [UIColor colorWithHexString:NavBarColorHex];
        } else {
            weekdayLabel.textColor = [UIColor colorWithHexString:detailTextColol];
        }
        [weekDayView addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weekDayView.frame), kScreenWidth, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:LineViewBackgroundColor];
    [backView addSubview:lineView2];
    
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView2.frame), kScreenWidth, 30)];
    [titleButton setTitleColor:[UIColor colorWithHexString:detailTextColol]forState:UIControlStateNormal];
    titleButton.backgroundColor =[ UIColor whiteColor];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview:titleButton];
    
    self.titleButton = titleButton;
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePickerView)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    
    [self addSubview:_backgroundView];
    
    return _backgroundView;
}

- (UIView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 40)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.clipsToBounds = YES;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, 40)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:NavBarColorHex] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 50, 40)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor colorWithHexString:NavBarColorHex] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(selectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:okButton];
        
        [_datePickerView addSubview:self.datePicker];
    }
    
//    NSLog(@"%lf",_datePickerView.frame.size.height);
    [self addSubview:_datePickerView];
    
    return _datePickerView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        CGRect frame = _datePicker.frame;
        frame.origin = CGPointMake(0, 32);
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.frame = CGRectMake(0, 40, self.frame.size.width, 200);
    }
    
    return _datePicker;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"YYYY-MM-dd"];
    }
    return [dateFormattor stringFromDate:date];
}

// 设置上层的titleBar
- (void)setupTitleBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    titleView.backgroundColor = [UIColor colorWithHexString:NavBarColorHex];
    [self addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 32, 24)];
    [leftButton setImage:[UIImage imageNamed:@"icon_previous"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 37, 10, 32, 24)];
    [rightButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleButton.center = titleView.center;
//    [titleButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
//    titleButton.backgroundColor = [UIColor orangeColor];
    [titleView addSubview:titleButton];
    
    self.titleButton = titleButton;
}

// 设置星期文字的显示
- (void)setupWeekHeader {
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 0;
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 50, (DeviceWidth) / count, 50)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.text = Weekdays[i];
        
        if (i == 0 || i == count - 1) {
            weekdayLabel.textColor = [UIColor whiteColor];
        } else {
            weekdayLabel.textColor = [UIColor whiteColor];
        }
        weekdayLabel.backgroundColor = self.weekBackColor;
        
        [self addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 74, DeviceWidth - 30, 1)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView];
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, _weekHeaderHeight, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
//    self.scrollView.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[FDCalendarItem alloc] init];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.centerCalendarItem = [[FDCalendarItem alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.rightCalendarItem = [[FDCalendarItem alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date {
    self.centerCalendarItem.date = date;
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
    [self.titleButton setTitle:[self stringFromDate:self.centerCalendarItem.date] forState:UIControlStateNormal];
}

// 重新加载日历items的数据
- (void)reloadCalendarItems {
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x == self.scrollView.frame.size.width) { //防止滑动一点点并不切换scrollview的视图
        return;
    }
    
    if (offset.x > self.scrollView.frame.size.width) {
        [self setNextMonthDate];
    } else {
        [self setPreviousMonthDate];
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

- (void)showDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0.4;
        self.datePickerView.frame = CGRectMake(0, 44, self.frame.size.width, 250);
    }];
}

- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        self.datePickerView.frame = CGRectMake(0, 44, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
    }];
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate {
    [self setCurrentDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate {
    [self setCurrentDate:[self.centerCalendarItem nextMonthDate]];
}

- (void)showDatePicker {
    [self showDatePickerView];
}

// 选择当前日期
- (void)selectCurrentDate {
    [self setCurrentDate:self.datePicker.date];
    [self hideDatePickerView];
}

- (void)cancelSelectCurrentDate {
    [self hideDatePickerView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCalendarItems];
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date {
    self.date = date;
    [self setCurrentDate:self.date];
}

@end
