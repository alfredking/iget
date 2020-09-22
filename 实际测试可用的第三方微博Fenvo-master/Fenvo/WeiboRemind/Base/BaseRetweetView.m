//
//  BaseRetweetView.m
//  Fenvo
//
//  Created by Caesar on 15/8/12.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "BaseRetweetView.h"
#import "StyleOfRemindSubviews.h"
#import "WeiboUserInfo.h"

@implementation BaseRetweetView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    _text = [[WeiboLabel alloc]init];
    _text.textColor = [StyleOfRemindSubviews greyColor];
    _text.font = WBStatusCellForwardFont;
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByCharWrapping;
    _text.weiboLabelDelegate = self;
    _text.isNeedAtAndPoundSign = YES;
    [self addSubview:_text];
    
    _imagesView = [[BaseImagesView alloc]init];
    [_imagesView setHidden:YES];
    [self addSubview:_imagesView];

    self.backgroundColor = [StyleOfRemindSubviews whiteOpaqueColor];
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg {
    _weiboMsg = weiboMsg;
    
    CGFloat width = self.frame.size.width - [StyleOfRemindSubviews componentSpacing]*2;
    CGFloat spacing = [StyleOfRemindSubviews componentSpacing];
    
    NSString *text = [NSString stringWithFormat:@"@%@ :%@",weiboMsg.user.name, weiboMsg.wbDetail];
    CGSize textSize = [text
                       boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@ "HYQiHei-BEJ" size:15.0]}
                       context:nil].size;
    CGRect textRect = CGRectMake(spacing, spacing, width, textSize.height);
    _text.frame = textRect;
    [_text setEmojiText:text];
    CGFloat textY = CGRectGetMaxY(_text.frame) + spacing;
    
    if (weiboMsg.pic_urls && ![weiboMsg.pic_urls isEqualToString:@""]) {
        _imagesView.frame = CGRectMake(spacing, textY, width, 0);
        _imagesView.thumbnailUrl = weiboMsg.pic_urls;
        _imagesView.frame = CGRectMake(spacing, textY, width, _imagesView.imagesHeight);
        [_imagesView setHidden:NO];
        textY = CGRectGetMaxY(_imagesView.frame) + spacing;
    }
    
    _weiboMsg.height = @(textY);
}


@end
