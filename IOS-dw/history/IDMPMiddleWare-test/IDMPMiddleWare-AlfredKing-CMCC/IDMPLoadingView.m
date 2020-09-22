//
//  IDMPLoadingView.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/12.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPLoadingView.h"

@implementation IDMPLoadingView
{
    UIView *_backView;
    UIView *_loadBackV;
    UILabel *_loadLabel;
}
/*
- (instancetype)init
{
    if (self = [super init]) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        self.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
        self.bounds = CGRectMake(0, 0, bounds.size.width-40, bounds.size.height-300);
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 40)];
        titleLabel.textColor = [UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        titleLabel.text = @"中国移动账号";
        [self addSubview:titleLabel];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 70, 270, 3)];
        lineLabel.backgroundColor = [UIColor colorWithRed:20/255.0 green:130/255.0 blue:190/255.0 alpha:1.0];
        [self addSubview:lineLabel];
        _testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _testActivityIndicator.center = CGPointMake(130, 130);
        [_testActivityIndicator startAnimating];
        [self addSubview:_testActivityIndicator];
        _testActivityIndicator.color = [UIColor grayColor];
        UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 150, 100, 40)];
        remindLabel.text = @"正在登陆...";
        remindLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:remindLabel];
        _backView = [[UIView alloc]init];
    }
    return self;
}
*/

- (instancetype)init
{
    if (self = [super init]) {
//        _loadBackV = [[UIView alloc]init];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.layer.cornerRadius = 3.0;
        _loadLabel = [[UILabel alloc]init];
        _testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_loadLabel];
//        [self addSubview:_loadBackV];
        [self addSubview:_testActivityIndicator];
        _backView = [[UIView alloc]init];
    }
    return self;
}

- (void)setSubViewWithFrame:(CGRect)rect
{
    self.bounds = CGRectMake(0, 0, 60, 60);
    self.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    _testActivityIndicator.center = CGPointMake(30, 20);
    [_testActivityIndicator startAnimating];
    _loadLabel.frame = CGRectMake(0, 40, 60, 20);
    _loadLabel.text = @"loading...";
    _loadLabel.textAlignment = NSTextAlignmentCenter;
    _loadLabel.font = [UIFont systemFontOfSize:12.0];
    _loadLabel.textColor = [UIColor whiteColor];
}

- (void)showInView:(UIView *)superV
{
    [self setSubViewWithFrame:superV.frame];
    _backView.frame = superV.frame;
    _backView.backgroundColor = [UIColor clearColor];
    [_backView addSubview:self];
    [superV addSubview:_backView];
}

- (void)dismissView
{
    [self removeFromSuperview];
    [_backView removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
