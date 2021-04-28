//
//  FollowingWBViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "OriginalTableViewCell.h"
#import "WebViewController.h"
#import "FollowingWBViewController.h"
#import "WeiboCommentView.h"
#import "WeiboForwardView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FontAwesome.h"
#import "ViewManagerTool.h"

#define BUTTON_FONT [UIFont systemFontOfSize:13.0]
@interface OriginalTableViewCell()<WeiboLabelDelegate>{

}
@end

@implementation OriginalTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubView];
    }
    return self;
}

- (void) initSubView{
    self.containView = [[UIView alloc]init];
    self.containView.backgroundColor = [UIColor clearColor];
    //RGBACOLOR(245, 245, 245, 0.4);
    //self.containView.layer.cornerRadius = 10.0;
    //self.containView.layer.masksToBounds = YES;
    [self addSubview:self.containView];
    //头像
    _avatar = [[WeiboAvatarView alloc]init];
    [_avatar setStyle];
    [self.containView addSubview:_avatar];
    //用户名
    _userName = [[UILabel alloc]init];
    _userName.font = WBStatusCellUserNameFont;
    _userName.textColor = [UIColor whiteColor];
    [self.containView addSubview:_userName];
    //会员标识
    _mbType = [[UIImageView alloc]init];
    [self.containView addSubview:_mbType];
    //创建时间
    _createTime = [[UILabel alloc]init];
    _createTime.textColor = WBStatusGrayColor;
    _createTime.font = WBStatusCellCreatTimeFont;
    [self.containView addSubview:_createTime];
    //微博发布来源
    _source = [[UILabel alloc]init];
    _source.textColor = WBStatusGrayColor;
    _source.font = WBStatusCellSourceFont;
    [self.containView addSubview:_source];
    //微博详情
    _wbDetail = [[WeiboLabel alloc]init];
    _wbDetail.textColor = WBStatusGrayColor;
    _wbDetail.font = WBStatusCellDetailFont;
    //如果label行数没有设置则默认为1，设置为0则是不限行数
    _wbDetail.numberOfLines = 0;
    _wbDetail.lineBreakMode = NSLineBreakByCharWrapping;
    _wbDetail.isNeedAtAndPoundSign = YES;
    _wbDetail.weiboLabelDelegate = self;
    [self.containView addSubview:_wbDetail];
    //微博转发信息
    _wbForwardText = [[WeiboLabel alloc]init];
    _wbForwardText.numberOfLines = 0;
    _wbForwardText.textColor = WBStatusGrayColor;
    _wbForwardText.font = WBStatusCellForwardFont;
    _wbForwardText.weiboLabelDelegate = self;
    _wbForwardText.isNeedAtAndPoundSign = YES;
    [self.containView addSubview:_wbForwardText];
    //微博配图
    _imageView0 = [[WebImageView alloc]initWithStyleAndTag:0];
    _imageView0.tag = 0;
    [self.containView addSubview:_imageView0];
    _imageView1 = [[WebImageView alloc]initWithStyleAndTag:1];
    _imageView1.tag = 1;
    [self.containView addSubview:_imageView1];
    _imageView2 = [[WebImageView alloc]initWithStyleAndTag:2];
    _imageView2.tag = 2;
    [self.containView addSubview:_imageView2];
    _imageView3 = [[WebImageView alloc]initWithStyleAndTag:3];
    _imageView3.tag = 3;
    [self.containView addSubview:_imageView3];
    _imageView4 = [[WebImageView alloc]initWithStyleAndTag:4];
    _imageView4.tag = 4;
    [self.containView addSubview:_imageView4];
    _imageView5 = [[WebImageView alloc]initWithStyleAndTag:5];
    _imageView5.tag = 5;
    [self.containView addSubview:_imageView5];
    _imageView6 = [[WebImageView alloc]initWithStyleAndTag:6];
    _imageView6.tag = 6;
    [self.containView addSubview:_imageView6];
    _imageView7 =[[WebImageView alloc]initWithStyleAndTag:7];
    _imageView7.tag = 7;
    [self.containView addSubview:_imageView7];
    _imageView8 = [[WebImageView alloc]initWithStyleAndTag:8];
    _imageView8.tag = 8;
    [self.containView addSubview:_imageView8];
    //
    _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _praiseBtn.tag = 100;
    _praiseBtn.titleLabel.font = BUTTON_FONT;
    [_praiseBtn setImage:[UIImage imageWithIcon:@"fa-thumbs-o-up" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.containView addSubview:_praiseBtn];
    _forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forwardBtn.tag = 101;
    [_forwardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_forwardBtn setImage:[UIImage imageWithIcon:@"fa-share" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    _forwardBtn.titleLabel.font = BUTTON_FONT;
    [self.containView addSubview:_forwardBtn];
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.tag = 102;
    _commentBtn.titleLabel.font = BUTTON_FONT;
    [_commentBtn setImage:[UIImage imageWithIcon:@"fa-comment" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1] andSize:CGSizeMake(16.0f, 16.0f)] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.containView addSubview:_commentBtn];
    
    
    [self initNeedRemoveView];
}

- (void)initNeedRemoveView {


}

- (void)removeNeedRemoveView {
    [_imageView0 setHidden:YES];
    [_imageView1 setHidden:YES];
    [_imageView2 setHidden:YES];
    [_imageView3 setHidden:YES];
    [_imageView4 setHidden:YES];
    [_imageView5 setHidden:YES];
    [_imageView6 setHidden:YES];
    [_imageView7 setHidden:YES];
    [_imageView8 setHidden:YES];
    [_wbForwardText setEmojiText:@""];
    [_wbForwardText setBackgroundColor:[UIColor clearColor]];
    [_wbDetail setEmojiText:@""];
}


/////////////////////////////////////////////////////////
- (void)setWeiboMsg:(WeiboMsg *)weiboMsg{
    
    CGFloat width = IPHONE_SCREEN_WIDTH - 20;
    
    [self removeNeedRemoveView];
    
    //初始化 － 头像
    CGRect avatarRect = CGRectMake(10, 10, WBStatusCellAvatarWidth, WBStatusCellAvatarHeight);
    [_avatar sd_setImageWithURL:[NSURL URLWithString:weiboMsg.user.profile_image_url]];
    _avatar.userInfo = weiboMsg.user;
    _avatar.frame = avatarRect;
    
    //初始化 － 用户名
    CGFloat userNameX = CGRectGetMaxX(_avatar.frame) + WBStatusCellControlSpacing;
    CGFloat userNameY = 10;
    CGSize userNameSize = [weiboMsg.user.name sizeWithAttributes:@{NSFontAttributeName: WBStatusCellUserNameFont}];
    CGFloat userNameSizeX = userNameSize.width;
    CGFloat userNameSizeY = userNameSize.height;
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSizeX, userNameSizeY);
    _userName.text = weiboMsg.user.name;
    _userName.frame = userNameRect;
    
    //初始化 － 会员标识
    CGFloat mbTypeX = CGRectGetMaxX(_userName.frame) + WBStatusCellControlSpacing;
    CGFloat mbTypeY = 5;
    CGRect mbTypeRect = CGRectMake(mbTypeX, mbTypeY, WBStatusCellMBTypeWidth, WBStatusCellMBTypeHeight);
    if (weiboMsg.user.mbtype > 0) {
        _mbType.image = [UIImage imageNamed:@"vip"];
    }
    _mbType.frame = mbTypeRect;
    
    //初始化 － 创建时间
    CGSize createTimeSize = [weiboMsg.created_at sizeWithAttributes:@{NSFontAttributeName:WBStatusCellCreatTimeFont}]   ;
    CGFloat createTimeX = userNameX;
    CGFloat createTimeY = CGRectGetMaxY(_userName.frame)+5;
    CGRect createTimeRect = CGRectMake(createTimeX, createTimeY, createTimeSize.width, createTimeSize.height);
    _createTime.text = weiboMsg.created_at;
    _createTime.frame = createTimeRect;
    
    //初始化 － 微博发布来源
    CGSize sourceSize = [weiboMsg.source sizeWithAttributes:@{NSFontAttributeName:WBStatusCellSourceFont}];
    CGFloat sourceX = CGRectGetMaxX(_createTime.frame) + WBStatusCellControlSpacing;
    CGFloat sourceY = createTimeY;
    CGRect sourceRect = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    _source.text = weiboMsg.source;
    _source.frame = sourceRect;
    
    
    //初始化 － 微博详情
    CGFloat wbDetailX = 10;
    CGFloat wbDetailY = CGRectGetMaxY(_avatar.frame) + WBStatusCellControlSpacing;
    CGFloat wbDetailWidth = IPHONE_SCREEN_WIDTH - WBStatusCellControlSpacing * 2;
    [_wbDetail setText:weiboMsg.wbDetail];
    
    CGSize wbDetailSize = [weiboMsg.wbDetail
                           boundingRectWithSize:CGSizeMake(wbDetailWidth, MAXFLOAT)
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:WBStatusCellDetailFont}
                           context:nil].size;
    CGRect wbDetailRect = CGRectMake(wbDetailX, wbDetailY, wbDetailSize.width, wbDetailSize.height);
    _wbDetail.frame = wbDetailRect;
    [_wbDetail setEmojiText:weiboMsg.wbDetail];
    [_wbDetail sizeToFit];
    
    CGRect containViewRect;
    CGFloat imageHeight = 0.0;
    //初始化 － 是否为转发
    if (weiboMsg.retweeted_status) {
        CGFloat wbForwardTextX = 10;
        CGFloat wbForwardTextY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing;
        CGFloat wbForwardTextWidth = IPHONE_SCREEN_WIDTH - WBStatusCellControlSpacing*2;
        NSString *retweeted_text = [NSString stringWithFormat:@"@%@：%@",weiboMsg.retweeted_status.user.screen_name ,weiboMsg.retweeted_status.wbDetail];
        _wbForwardText.text = retweeted_text;
        CGSize wbForwardTextSize = [retweeted_text
                               boundingRectWithSize:CGSizeMake(wbForwardTextWidth, MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:WBStatusCellDetailFont}
                               context:nil].size;
        CGRect wbForwardTextRect = CGRectMake(wbForwardTextX, wbForwardTextY, wbForwardTextSize.width, wbForwardTextSize.height);
        _wbForwardText.frame = wbForwardTextRect;
        _wbForwardText.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
        [_wbForwardText setEmojiText:weiboMsg.wbDetail];
        [_wbForwardText sizeToFit];
        //转发。 有配图
        
        if (weiboMsg.retweeted_status.thumbnail_pic) {
            NSArray *pic_urls = [self getPicUrls:weiboMsg.retweeted_status.pic_urls];
            if (pic_urls.count == 1) {
                
                CGFloat imageHight = 120;
                CGFloat imageX = 10;
                CGFloat imageWidth = IPHONE_SCREEN_WIDTH - 30;
                CGFloat imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellControlSpacing;
                CGRect imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                _imageView0.hidden = NO;
                _imageView0.frame = imageRect;
                [self setImageOfView:_imageView0 Url:[self getBimmdlePicUrl:weiboMsg.retweeted_status.thumbnail_pic]];
                _imageView0.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                _imageView0.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                imageHeight = CGRectGetMaxY(_imageView0.frame);
            }else{
            for (int i = 0; i < pic_urls.count; i++) {
                CGFloat imageY;
                CGRect imageRect;
                CGFloat imageWidth ;
                
                if (pic_urls.count >= 3) {
                    imageWidth = (width -  WBStatusCellImageViewSpacing * 2 -  10)/3;
                }else {
                    imageWidth = (width -  10 - WBStatusCellImageViewSpacing)/2;
                }
                CGFloat imageHight = imageWidth ;
                if (i >= 6) {
                    CGFloat imageX = WBStatusCellImageViewSpacing*(i - 5) + imageWidth * (i - 6) + 10 -WBStatusCellImageViewSpacing;
                    imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellImageViewSpacing*2 + imageHight*2 + WBStatusCellControlSpacing;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }else if(i <= 2){
                    CGFloat imageX = WBStatusCellImageViewSpacing*(i + 1) + imageWidth * i + 10 - WBStatusCellImageViewSpacing;
                    imageY = CGRectGetMaxY(_wbForwardText.frame)  + WBStatusCellControlSpacing;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }else{
                    CGFloat imageX = WBStatusCellImageViewSpacing*(i - 2) + imageWidth * (i-3) + 10 - WBStatusCellImageViewSpacing;
                    imageY = CGRectGetMaxY(_wbForwardText.frame) + WBStatusCellImageViewSpacing + imageHight + WBStatusCellControlSpacing;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }
                switch (i) {
                    case 0:
                    {
                        _imageView0.hidden = NO;
                        _imageView0.frame = imageRect;
                        [self setImageOfView:_imageView0 Url:pic_urls[0]];
                        _imageView0.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView0.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                    }   break;
                    case 1:
                        _imageView1.hidden = NO;
                        _imageView1.frame = imageRect;
                        [self setImageOfView:_imageView1 Url:pic_urls[1]];
                        _imageView1.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView1.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 2:
                        _imageView2.hidden = NO;
                        _imageView2.frame = imageRect;
                        [self setImageOfView:_imageView2 Url:pic_urls[2]];
                        _imageView2.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView2.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 3:
                        _imageView3.hidden = NO;
                        _imageView3.frame = imageRect;
                        [self setImageOfView:_imageView3 Url:pic_urls[3]];
                        _imageView3.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView3.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 4:
                        _imageView4.hidden = NO;
                        _imageView4.frame = imageRect;
                        [self setImageOfView:_imageView4 Url:pic_urls[4]];
                        _imageView4.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView4.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 5:
                        _imageView5.hidden = NO;
                        _imageView5.frame = imageRect;
                        [self setImageOfView:_imageView5 Url:pic_urls[5]];
                        _imageView5.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView5.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 6:
                        _imageView6.hidden = NO;
                        _imageView6.frame = imageRect;
                        [self setImageOfView:_imageView6 Url:pic_urls[6]];
                        _imageView6.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView6.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 7:
                        _imageView7.hidden = NO;
                        _imageView7.frame = imageRect;
                        [self setImageOfView:_imageView7 Url:pic_urls[7]];
                        _imageView7.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView7.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    case 8:
                        _imageView8.hidden = NO;
                        _imageView8.frame = imageRect;
                        [self setImageOfView:_imageView8 Url:pic_urls[8]];
                        _imageView8.original_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.original_pic_urls ];
                        _imageView8.bmiddle_pic_urls = [self getPicUrls:weiboMsg.retweeted_status.bmiddle_pic_urls];
                        break;
                    default:
                        break;
                }
                if (i >= 6) {
                    imageHeight = CGRectGetMaxY(_imageView6.frame);
                    //CGRect commentBtnRect = CGRectMake(5, CGRectGetMaxY(_imageView6.frame) + 5, (IPHONE_SCREEN_WIDTH - 10)/3, 35);
                }else if(i <= 2){
                    imageHeight = CGRectGetMaxY(_imageView0.frame);
                }else{
                    imageHeight = CGRectGetMaxY(_imageView3.frame);
                }
                
        }
            }
        }else{
            //CGRect commentBtnRect = CGRectMake(5, CGRectGetMaxY(_wbForwardText.frame) + 5, (IPHONE_SCREEN_WIDTH - 10)/3, 35);
            imageHeight = CGRectGetMaxY(_wbForwardText.frame);
        }
    }
    //无转发
   else{
       if (weiboMsg.thumbnail_pic) {
           NSArray *pic_urls = [self getPicUrls:weiboMsg.pic_urls];
           if (pic_urls.count == 1) {
               CGFloat imageWidth = IPHONE_SCREEN_WIDTH - 30;
               CGFloat imageHight = 120;
               CGFloat imageX = 10;
               CGFloat imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellControlSpacing;
               CGRect imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               _imageView0.hidden = NO;
               _imageView0.contentMode = UIViewContentModeScaleAspectFill;
               _imageView0.frame = imageRect;
               [self setImageOfView:_imageView0 Url:[self getBimmdlePicUrl:weiboMsg.thumbnail_pic]];
               _imageView0.original_pic_url = weiboMsg.original_pic;
               _imageView0.bmiddle_pic_url = weiboMsg.bmiddle_pic;
               imageHeight = CGRectGetMaxY(_imageView0.frame);

           }else{
           for (int i = 0; i < pic_urls.count; i++) {
               CGFloat imageY;
               CGRect imageRect;
               CGFloat imageWidth ;
               CGFloat imageHight ;
               if (pic_urls.count >= 3) {
                   imageWidth = (width -  WBStatusCellImageViewSpacing * 2 -  10)/3;
               }else {
                   imageWidth = (width -  10 - WBStatusCellImageViewSpacing)/2;
               }
               imageHight = imageWidth ;
               if (i >= 6) {
                   CGFloat imageX = WBStatusCellImageViewSpacing*(i - 5) + imageWidth * (i - 6) + 10 -WBStatusCellImageViewSpacing;
                   imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellImageViewSpacing*2 + imageHight*2 + WBStatusCellControlSpacing;
                   imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               }else if(i <= 2){
                   CGFloat imageX = WBStatusCellImageViewSpacing*(i + 1) + imageWidth * i + 10 - WBStatusCellImageViewSpacing;
                   imageY = CGRectGetMaxY(_wbDetail.frame)  + WBStatusCellControlSpacing;
                   imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               }else{
                   CGFloat imageX = WBStatusCellImageViewSpacing*(i - 2) + imageWidth * (i-3) + 10 - WBStatusCellImageViewSpacing;
                   imageY = CGRectGetMaxY(_wbDetail.frame) + WBStatusCellImageViewSpacing + imageHight + WBStatusCellControlSpacing;
                   imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
               }
               switch (i) {
                   case 0:
                   {
                       _imageView0.hidden = NO;
                       _imageView0.frame = imageRect;
                       [self setImageOfView:_imageView0 Url:pic_urls[0]];
                       _imageView0.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView0.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                   }   break;
                   case 1:
                       _imageView1.hidden = NO;
                       _imageView1.frame = imageRect;
                       [self setImageOfView:_imageView1 Url:pic_urls[1]];
                       _imageView1.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView1.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 2:
                       _imageView2.hidden = NO;
                       _imageView2.frame = imageRect;
                       [self setImageOfView:_imageView2 Url:pic_urls[2]];
                       _imageView2.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView2.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 3:
                       _imageView3.hidden = NO;
                       _imageView3.frame = imageRect;
                       [self setImageOfView:_imageView3 Url:pic_urls[3]];
                       _imageView3.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView3.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 4:
                       _imageView4.hidden = NO;
                       _imageView4.frame = imageRect;
                       [self setImageOfView:_imageView4 Url:pic_urls[4]];
                       _imageView4.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView4.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 5:
                       _imageView5.hidden = NO;
                       _imageView5.frame = imageRect;
                       [self setImageOfView:_imageView5 Url:pic_urls[5]];
                       _imageView5.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView5.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 6:
                       _imageView6.hidden = NO;
                       _imageView6.frame = imageRect;
                       [self setImageOfView:_imageView6 Url:pic_urls[6]];
                       _imageView6.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView6.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 7:
                       _imageView7.hidden = NO;
                       _imageView7.frame = imageRect;
                       [self setImageOfView:_imageView7 Url:pic_urls[7]];
                       _imageView7.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView7.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   case 8:
                       _imageView8.hidden = NO;
                       _imageView8.frame = imageRect;
                       [self setImageOfView:_imageView8 Url:pic_urls[8]];
                       _imageView8.original_pic_urls = [self getPicUrls:weiboMsg.original_pic_urls];
                       _imageView8.bmiddle_pic_urls = [self getPicUrls:weiboMsg.bmiddle_pic_urls ];
                       break;
                   default:
                       break;
               }
               if (i >= 6) {
                   imageHeight = CGRectGetMaxY(_imageView6.frame);
               }else if(i <= 2){
                   imageHeight = CGRectGetMaxY(_imageView0.frame);
               }else{
                   imageHeight = CGRectGetMaxY(_imageView3.frame);
               }
               
           }
           }
       }else{
           imageHeight = CGRectGetMaxY(_wbDetail.frame);
       }
    }
    
    
    
    CGFloat btnWidth = IPHONE_SCREEN_WIDTH/6;
    
    CGRect commentRect = CGRectMake(IPHONE_SCREEN_WIDTH / 2 - 20 , imageHeight + 5, btnWidth, 30);
    _commentBtn.frame = commentRect;
    [_commentBtn setTitle:[self countToString:weiboMsg.comments_count.integerValue] forState:UIControlStateNormal];			
    CGRect forwardRect = CGRectMake(CGRectGetMaxX(_commentBtn.frame), imageHeight +5, btnWidth, 30);
    _forwardBtn.frame = forwardRect;
    [_forwardBtn setTitle:[self countToString:weiboMsg.reposts_count.integerValue] forState:UIControlStateNormal];
    CGRect praiseRect = CGRectMake(CGRectGetMaxX(_forwardBtn.frame), imageHeight +5, btnWidth, 30);
    _praiseBtn.frame = praiseRect;
    [_praiseBtn setTitle:[self countToString:weiboMsg.attitudes_count.integerValue] forState:UIControlStateNormal];
    
    
    containViewRect = CGRectMake(5, 5, IPHONE_SCREEN_WIDTH - 10, CGRectGetMaxY(_commentBtn.frame) + 5);
    self.containView.frame = containViewRect;
    
    CGFloat height = CGRectGetHeight(self.containView.frame)+ 10;
    weiboMsg.height = [NSNumber numberWithFloat:height];
    _weiboMsg = weiboMsg;
    [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [_forwardBtn addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    [_praiseBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
}

//button touch event
- (void)comment {
    [self bounceTargetView:_commentBtn];
    [[WeiboCommentView sharedWeiboCommentView]showCommentView:_weiboMsg.ids.integerValue];
}

//
- (void)forward {
    [self bounceTargetView:_forwardBtn];
    if (_weiboMsg.retweeted_status) {
        [[WeiboForwardView sharedWeiboForwardView]showForwardView:_weiboMsg.ids.integerValue withComment:_weiboMsg.wbDetail andUserName:_weiboMsg.user.screen_name];
    }
    else {
        [[WeiboForwardView sharedWeiboForwardView]showForwardView:_weiboMsg.ids.integerValue withComment:@"" andUserName:@""];
    }
}
//
- (void)like {
    [self bounceTargetView:_praiseBtn];
}


//
- (NSString *)countToString:(NSUInteger)count {
    if (count > 1000) {
        return [NSString stringWithFormat:@"  %dk",(int)count/1000];
    }
    else {
        return [NSString stringWithFormat:@"  %d", (int)count];
    }
}

//获得图片URL数组
- (NSArray *)getPicUrls:(NSString *)url {
    return [url componentsSeparatedByString:@","];
}

//转化小图为中图，因为有的长宽比过大
- (NSString *)getBimmdlePicUrl:(NSString *)url {
   return [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

//如果长宽比大于2或小于0.5，则替换为中图
- (void)setImageOfView: (UIImageView *)imageView Url:(NSString *)url {
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGSize imageSize = image.size;
        CGFloat multiple = imageSize.height / imageSize.width;
        
        if (multiple > 2 || multiple < 0.5) {
            NSString *bmiddleUrl = [self getBimmdlePicUrl:url];
            [imageView sd_setImageWithURL:[NSURL URLWithString:bmiddleUrl]];
        }
    }];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - WeiboLabelDelegate
- (void)mlEmojiLabel:(WeiboLabel *)emojiLabel didSelectLink:(NSString *)link withType:(WeiboLabelLinkType)type
{
    WebViewController *webview = [[WebViewController alloc]init];
    switch (type) {
        case MLEmojiLabelLinkTypeURL:
            [webview initWithLink:link];
            [[ViewManagerTool viewController:self].navigationController pushViewController:webview animated:YES];
            NSLog(@"点击了URL%@",link);
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

#pragma mark - Animation

- (void)bounceTargetView:(UIView *)target
{
    [UIView animateWithDuration:0.1 animations:^{
        target.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            target.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                target.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

@end
