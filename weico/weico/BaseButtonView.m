//
//  BaseButtonView.m
//  Fenvo
//
//  Created by Caesar on 15/8/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "BaseButtonView.h"
#import "UIImage+FontAwesome.h"
#import "StyleOfRemindSubviews.h"

@implementation BaseButtonView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    _like = [UIButton buttonWithType:UIButtonTypeCustom];
    _like.titleLabel.font =[StyleOfRemindSubviews buttonFont];
    [_like setImage:[UIImage imageWithIcon:@"fa-thumbs-o-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_like setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_like];
    
    _repost = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repost setImage:[UIImage imageWithIcon:@"fa-share" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    _repost.titleLabel.font = [StyleOfRemindSubviews buttonFont];
    [self addSubview:_repost];
    
    _comment = [UIButton buttonWithType:UIButtonTypeCustom];
    _comment.titleLabel.font = [StyleOfRemindSubviews buttonFont];
    [_comment setImage:[UIImage imageWithIcon:@"fa-comment" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_comment];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat btnWidth = width/6;
    
    CGRect commentRect = CGRectMake(width / 2 , 0, btnWidth, height);
    _comment.frame = commentRect;
    
    CGRect forwardRect = CGRectMake(CGRectGetMaxX(_comment.frame), 0, btnWidth, height);
    _repost.frame = forwardRect;

    CGRect praiseRect = CGRectMake(CGRectGetMaxX(_repost.frame), 0, btnWidth, height);
    _like.frame = praiseRect;

    [_comment addTarget:self
                 action:@selector(commentEvent)
       forControlEvents:UIControlEventTouchUpInside];
    [_repost addTarget:self
                action:@selector(repostEvent)
      forControlEvents:UIControlEventTouchUpInside];
    [_like addTarget:self
              action:@selector(likeEvent)
    forControlEvents:UIControlEventTouchUpInside];
}

- (void)commentEvent {
    
}

- (void)repostEvent {
    
}

- (void)likeEvent {
    
}

@end
