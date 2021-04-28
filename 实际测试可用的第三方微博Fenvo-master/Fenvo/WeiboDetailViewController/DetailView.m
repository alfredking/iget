//
//  DetailView.m
//  Fenvo
//
//  Created by Caesar on 15/8/11.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "DetailView.h"
#import "WeiboLabel.h"
#import "BaseHeaderView.h"
#import "BaseWeiboView.h"
#import "BaseImagesView.h"
#import "BaseButtonView.h"
#import "BaseRetweetView.h"

#import "StyleOfRemindSubviews.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"
#import "ViewManagerTool.h"

@interface DetailView()<WeiboLabelDelegate>{
    BaseHeaderView *_header;
    WeiboLabel *_text;
    BaseRetweetView *_retweetView;
    BaseImagesView *_imagesView;
}
@end
@implementation DetailView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    _header = [[BaseHeaderView alloc]init];
    _header.customBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _header.customBtn.layer.borderWidth = 1.0f;
    _header.customBtn.layer.cornerRadius = 3.0;
    _header.customBtn.layer.masksToBounds = YES;
    [_header.customBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_header.customBtn addTarget:self action:@selector(customEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_header];
    
    _text = [[WeiboLabel alloc]init];
    _text.textColor = [UIColor whiteColor];
    _text.font = WBStatusCellForwardFont;
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByCharWrapping;
    _text.weiboLabelDelegate = self;
    _text.isNeedAtAndPoundSign = YES;
    
    [self addSubview:_text];
    
    _retweetView = [[BaseRetweetView alloc]init];
    [_retweetView setHidden:YES];
    [self addSubview:_retweetView];
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg {
    _weiboMsg = weiboMsg;

    CGFloat spacing = [StyleOfRemindSubviews componentSpacing_large];
    CGFloat width = self.frame.size.width - 2 * spacing;
    
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
    [_text sizeToFit];
    CGFloat textY = CGRectGetMaxY(_text.frame) + spacing;
    
    if (weiboMsg.retweeted_status){
        _retweetView.frame = CGRectMake(spacing, textY, width, 1);
        _retweetView.weiboMsg = weiboMsg.retweeted_status;
        _retweetView.frame = CGRectMake(spacing, textY, width, weiboMsg.retweeted_status.height.floatValue);
        [_retweetView setHidden:NO];
        textY = CGRectGetMaxY(_retweetView.frame) + spacing;
    }else if(weiboMsg.pic_urls && ![weiboMsg.pic_urls isEqualToString:@""]){
        BaseImagesView *imagesView = [[BaseImagesView alloc]init];
        [self addSubview:imagesView];
        imagesView.frame = CGRectMake(spacing, textY, width, 0);
        imagesView.thumbnailUrl = weiboMsg.pic_urls;
        imagesView.frame = CGRectMake(spacing, textY, width, imagesView.imagesHeight);
        textY = CGRectGetMaxY(imagesView.frame) + spacing;
    }
    
    
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, textY);
    _height = textY;
}

#pragma mark - WeiboLabelDelegate
- (void)mlEmojiLabel:(WeiboLabel *)emojiLabel didSelectLink:(NSString *)link withType:(WeiboLabelLinkType)type
{
    WebViewController *webview = [[WebViewController alloc]init];
    switch (type) {
        case MLEmojiLabelLinkTypeURL:
            [webview initWithLink:link];
            
            NSLog(@"current navigationController is %@",[ViewManagerTool viewController:self].navigationController);
            NSLog(@"current viewcontroller is %@",[ViewManagerTool viewController:self]);
            [[ViewManagerTool viewController:self].navigationController pushViewController:webview animated:YES];
            NSLog(@"点击了URL没反应 %@",link);
            break;
            
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}
@end
