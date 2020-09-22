//
//  DetailTableViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/8/14.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "BaseHeaderView.h"
#import "WeiboLabel.h"
#import "StyleOfRemindSubviews.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"

#import "WeiboComment.h"
#import "WeiboMsg.h"
#import "WeiboUserInfo.h"

@interface DetailTableViewCell()<WeiboLabelDelegate>
{
    UIView *_contentView;
}
@end

@implementation DetailTableViewCell

#pragma mark - Initialize

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType      = UITableViewCellAccessoryNone;
        self.backgroundColor    = RGBACOLOR(0, 0, 0, 0);
        self.selectionStyle     = UITableViewCellSelectionStyleNone;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    _contentView = [[UIView alloc]init];
    [self addSubview:_contentView];
    
    _header = [[BaseHeaderView alloc]init];
    [_contentView addSubview:_header];
    
    _text               = [[WeiboLabel alloc]init];
    _text.textColor     = WBStatusGrayColor;
    _text.font          = WBStatusCellDetailFont;
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByCharWrapping;
    _text.isNeedAtAndPoundSign = YES;
    _text.weiboLabelDelegate = self;
    [_contentView addSubview:self.text];
}

#pragma mark - Property setter or getter

- (void)setObject:(id)object
{
    //Get Data
    NSURL    *avatarUrl;
    NSString *username;
    NSString *createAt;
    NSString *text;
    NSString *customTitle;
    WeiboUserInfo *user;
    BOOL      isComment;

    if ([object isKindOfClass:[WeiboComment class]])
    {
        WeiboComment *comment = (WeiboComment *)object;
        avatarUrl   = [NSURL URLWithString:comment.user.profile_image_url];
        username    = comment.user.name;
        createAt    = comment.created_at;
        text        = comment.text;
        user        = comment.user;
        customTitle = [NSString stringWithFormat:@"%ld",comment.weiboMsg.attitudes_count.integerValue];
        isComment   = YES;
    }
    else if ([object isKindOfClass:[WeiboMsg class]])
    {
        WeiboMsg *weiboMsg = (WeiboMsg *)object;
        avatarUrl   = [NSURL URLWithString:weiboMsg.user.profile_image_url];
        username    = weiboMsg.user.name;
        text        = weiboMsg.wbDetail;
        createAt    = weiboMsg.created_at;
        user        = weiboMsg.user;
        customTitle = [NSString stringWithFormat:@"%ld",weiboMsg.reposts_count.integerValue];
        isComment   = NO;
    }
    
    
    //Set Frame
    CGFloat horizontalSpacing   = [StyleOfRemindSubviews componentSpacing_large];
    CGFloat verticalSpacing     = [StyleOfRemindSubviews componentSpacing];
    CGFloat width               = self.frame.size.width - 2 * horizontalSpacing;
    
    _contentView.frame  = CGRectMake(horizontalSpacing, verticalSpacing, width, 0);
    
    _header.frame       = CGRectMake(0, 0, width, 30);
    
    CGFloat headerY     = CGRectGetMaxY(_header.frame) + verticalSpacing;
    CGFloat avatarX     = CGRectGetMaxX(_header.avatar.frame) + horizontalSpacing;
    CGSize textSize     = [text
                           boundingRectWithSize:CGSizeMake((width - avatarX), MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName:WBStatusCellDetailFont}
                           context:nil].size;
    CGRect textRect     = CGRectMake(avatarX, headerY, textSize.width, textSize.height);
    _text.frame         = textRect;
    [_text setEmojiText:text];
    [_text sizeToFit];

    CGFloat textY       = CGRectGetMaxY(_text.frame) + verticalSpacing;
    _contentView.frame  = CGRectMake(horizontalSpacing, verticalSpacing, width, textY);
    
    
    //Set Data
    [_header.avatar sd_setImageWithURL:avatarUrl];
    _header.avatar.userInfo = user;
    _header.username.text   = username;
    _header.createAt.text   = createAt;
    if (isComment)
    {
        [_header.customBtn setImage:[UIImage imageWithIcon:@"fa-thumbs-o-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
        [_header.customBtn setTitle:customTitle forState:UIControlStateNormal];
        [_header.customBtn setUserInteractionEnabled:YES];
    }
    else
    {
        [_header.customBtn setImage:[UIImage imageWithIcon:@"fa-share" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
        [_header.customBtn setTitle:customTitle forState:UIControlStateNormal];
        [_header.customBtn setUserInteractionEnabled:NO];
    }
    
    
    
    if ([object isKindOfClass:[WeiboComment class]])
    {
        WeiboComment *comment   = (WeiboComment *)object;
        comment.height          = @(CGRectGetMaxY(_contentView.frame));
    }
    else if ([object isKindOfClass:[WeiboMsg class]])
    {
        WeiboMsg *weiboMsg  = (WeiboMsg *)object;
        weiboMsg.height     = @(CGRectGetMaxY(_contentView.frame));
    }

}

@end
