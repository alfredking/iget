//
//  BaseHeaderView.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "BaseHeaderView.h"
#import "StyleOfRemindSubviews.h"
#import "WeiboCommentView.h"

@implementation BaseHeaderView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    
    _avatar = [[WeiboAvatarView alloc]init];
    [_avatar setStyle];
    [self addSubview:_avatar];
    
    
    _username = [[UILabel alloc]init];
    _username.font = [StyleOfRemindSubviews largeFont];
    _username.textColor = [UIColor whiteColor];
    [self addSubview:_username];
    
    
    _createAt = [[UILabel alloc]init];
    _createAt.font = [StyleOfRemindSubviews smallFont];
    _createAt.textColor = [UIColor whiteColor];
    _createAt.numberOfLines = 1;
    [self addSubview:_createAt];
    
    _source = [[UILabel alloc]init];
    _source.font = [StyleOfRemindSubviews smallFont];
    _source.textColor = [UIColor whiteColor];
    _source.numberOfLines = 1;
    [self addSubview:_source];
    
    _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customBtn.titleLabel.font = [StyleOfRemindSubviews buttonFont];
    [_customBtn setBackgroundColor:[UIColor clearColor]];
    [_customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_customBtn];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _avatar.frame = CGRectMake(0, 0, height, height);
    
    CGFloat avatarX = CGRectGetMaxX(_avatar.frame) + 12;
    _username.frame = CGRectMake(avatarX, 0, width - avatarX - 50, 18.0);
    
    CGFloat usernameY = CGRectGetMaxY(_username.frame);
    _createAt.frame = CGRectMake(avatarX, usernameY, 80, 12.0);
    
    CGFloat createAtX = CGRectGetMaxX(_createAt.frame);
    CGFloat usernameWidth = CGRectGetWidth(_username.frame);
    CGFloat createAtWidth = CGRectGetWidth(_createAt.frame);
    _source.frame = CGRectMake(createAtX, usernameY, usernameWidth - createAtWidth, 12.0);
    
    CGFloat usernameX = CGRectGetMaxX(_username.frame) + 5;
    _customBtn.frame = CGRectMake(usernameX, 5, 40, 20);
}



@end
