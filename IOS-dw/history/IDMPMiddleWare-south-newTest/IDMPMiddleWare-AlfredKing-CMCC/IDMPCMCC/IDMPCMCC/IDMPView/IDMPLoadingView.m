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

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.layer.cornerRadius = 3.0;
        _loadLabel = [[UILabel alloc]init];
        _testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_loadLabel];
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

@end
