//
//  BottomView.m
//  Fenvo
//
//  Created by Caesar on 15/8/13.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "BottomView.h"
#import "UIImage+FontAwesome.h"
#import "StyleOfRemindSubviews.h"
#import "WeiboCommentView.h"
#import "WeiboForwardView.h"
#import "WeiboUserInfo.h"
#import "AnimationTool.h"

@implementation BottomView

- (instancetype)init
{    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [StyleOfRemindSubviews deepBlackColor];
    
    _like = [UIButton buttonWithType:UIButtonTypeCustom];
    _like.titleLabel.font =[StyleOfRemindSubviews buttonFont];
    [_like setImage:[UIImage imageWithIcon:@"fa-thumbs-o-up" backgroundColor:[UIColor clearColor] iconColor:[StyleOfRemindSubviews orangeColor] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_like setTitle:@" LIKE" forState:UIControlStateNormal];
    [_like setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_like];
    
    _repost = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repost setImage:[UIImage imageWithIcon:@"fa-share" backgroundColor:[UIColor clearColor] iconColor:[StyleOfRemindSubviews orangeColor] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_repost setTitle:@" REPOST" forState:UIControlStateNormal];
    _repost.titleLabel.font = [StyleOfRemindSubviews buttonFont];
    [self addSubview:_repost];
    
    _comment = [UIButton buttonWithType:UIButtonTypeCustom];
    _comment.titleLabel.font = [StyleOfRemindSubviews buttonFont];
    [_comment setImage:[UIImage imageWithIcon:@"fa-comment" backgroundColor:[UIColor clearColor] iconColor:[StyleOfRemindSubviews orangeColor] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_comment setTitle:@" COMMENT" forState:UIControlStateNormal];
    [_comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_comment];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat btnWidth = (width - 24)/3;
    
    CGRect commentRect = CGRectMake(12 , 0, btnWidth, height);
    _comment.frame = commentRect;
    
    CGRect forwardRect = CGRectMake(CGRectGetMaxX(_comment.frame), 0, btnWidth, height);
    _repost.frame = forwardRect;
    
    CGRect praiseRect = CGRectMake(CGRectGetMaxX(_repost.frame), 0, btnWidth, height);
    _like.frame = praiseRect;
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg
{
    _weiboMsg = weiboMsg;
    
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
    [AnimationTool bounceTargetView:_comment];
    [[WeiboCommentView sharedWeiboCommentView]showCommentView:_weiboMsg.ids.integerValue];
}

- (void)repostEvent {
    [AnimationTool bounceTargetView:_repost];
    if (_weiboMsg.retweeted_status) {
        [[WeiboForwardView sharedWeiboForwardView]showForwardView:_weiboMsg.ids.integerValue withComment:_weiboMsg.wbDetail andUserName:_weiboMsg.user.screen_name];
    }
    else {
        [[WeiboForwardView sharedWeiboForwardView]showForwardView:_weiboMsg.ids.integerValue withComment:@"" andUserName:@""];
    }
}

- (void)likeEvent {
    [AnimationTool bounceTargetView:_like];
}



@end
