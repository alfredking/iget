//
//  AtMeTableViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AtMeTableViewCell.h"
#import "WeiboLabel.h"
#import "BaseHeaderView.h"
#import "BaseWeiboView.h"
#import "BaseButtonView.h"
#import "BaseImagesView.h"

#import "StyleOfRemindSubviews.h"

#import "WeiboMsg.h"

@interface AtMeTableViewCell()<WeiboLabelDelegate> {
    UIView *_mainContentView;
    
    BaseHeaderView *_header;
    WeiboLabel *_text;
    BaseWeiboView *_weiboView;
    BaseButtonView *_buttonView;
    BaseImagesView *_imagesView;
}
@end

@implementation AtMeTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    _mainContentView = [[UIView alloc]init];
    _mainContentView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    _mainContentView.layer.cornerRadius = 3.0;
    //_mainContentView.layer.borderWidth = 3.0;
    //_mainContentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_mainContentView.layer.masksToBounds = YES;
    // _mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    //_mainContentView.layer.shadowOffset = CGSizeMake(3, 3);
    //_mainContentView.layer.shadowOpacity = 0.6;
    //_mainContentView.layer.shadowRadius = 3.0;
    [self addSubview:_mainContentView];
    
    _header = [[BaseHeaderView alloc]init];
    _header.customBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _header.customBtn.layer.borderWidth = 1.0f;
    _header.customBtn.layer.cornerRadius = 3.0;
    _header.customBtn.layer.masksToBounds = YES;
    [_header.customBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_header.customBtn addTarget:self action:@selector(customEvent) forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_header];
    
    _text = [[WeiboLabel alloc]init];
    _text.textColor = [UIColor whiteColor];
    _text.font = [StyleOfRemindSubviews middleFont];
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByCharWrapping;
    _text.weiboLabelDelegate = self;
    _text.isNeedAtAndPoundSign = YES;
    [_mainContentView addSubview:_text];

    
    _weiboView = [[BaseWeiboView alloc]init];
    [_weiboView setHidden:YES];
    [_mainContentView addSubview:_weiboView];
    
    
    _buttonView = [[BaseButtonView alloc]init];
    [_mainContentView addSubview:_buttonView];
}

- (void)setAtMeStore:(WeiboAtMeStore *)atMeStore {
    
    _atMeStore = atMeStore;
    WeiboMsg *weiboMsg = _atMeStore.weiboMsg;
    
    _mainContentView.frame = CGRectMake(12, 4, self.frame.size.width - 24, 0);
    CGFloat width = _mainContentView.frame.size.width - 16;
    CGFloat spacing = [StyleOfRemindSubviews componentSpacing];
    
    _header.frame = CGRectMake(spacing, spacing, width, 30);
    _header.username.text = weiboMsg.user.name;
    _header.createAt.text = weiboMsg.created_at;
    _header.source.text = weiboMsg.source;
    [_header.avatar sd_setImageWithURL:[NSURL URLWithString:weiboMsg.user.profile_image_url]];
    [_header.avatar setUserInfo:weiboMsg.user];
    CGFloat headerY = CGRectGetMaxY(_header.frame) + spacing;
    
    
    CGSize textSize = [weiboMsg.wbDetail
                       boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@ "HYQiHei-BEJ" size:15.0]}
                       context:nil].size;
    CGRect textRect = CGRectMake(spacing, headerY, width, textSize.height);
    _text.frame = textRect;
    [_text setEmojiText:weiboMsg.wbDetail];
    CGFloat textY = CGRectGetMaxY(_text.frame) + spacing;
    
    if (weiboMsg.retweeted_status){
        _weiboView.frame = CGRectMake(spacing, textY, width, [StyleOfRemindSubviews baseWeiboHeight]);
        if(weiboMsg.retweeted_status.thumbnail_pic){
            [_weiboView.image sd_setImageWithURL:[NSURL URLWithString:weiboMsg.retweeted_status.thumbnail_pic]];
        }else {
            [_weiboView.image sd_setImageWithURL:[NSURL URLWithString:weiboMsg.retweeted_status.user.profile_image_url]];
        }
        _weiboView.detail.text = weiboMsg.retweeted_status.wbDetail;
        _weiboView.username.text = weiboMsg.retweeted_status.user.name;
        textY = CGRectGetMaxY(_weiboView.frame) + spacing;
    }else if(weiboMsg.pic_urls){
        BaseImagesView *imagesView = [[BaseImagesView alloc]init];
        [self addSubview:imagesView];
        imagesView.frame = CGRectMake(spacing, textY, width, 0);
        imagesView.thumbnailUrl = weiboMsg.pic_urls;
        imagesView.frame = CGRectMake(spacing, textY, width, imagesView.imagesHeight);
        textY = CGRectGetMaxY(imagesView.frame) + spacing;
    }
    
    _buttonView.frame = CGRectMake(spacing, textY, width, 20);
    
    CGFloat height = CGRectGetMaxY(_buttonView.frame) + spacing;
    
    _mainContentView.frame = CGRectMake(12, 8, self.frame.size.width - 24, height);
    CGFloat mainContentViewHeight = CGRectGetMaxY(_mainContentView.frame) + spacing;
    
    _atMeStore.height = @(mainContentViewHeight);
}


@end
