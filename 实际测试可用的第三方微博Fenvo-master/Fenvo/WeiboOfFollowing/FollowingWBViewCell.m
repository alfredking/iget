//
//  FollowingWBViewCell.m
//  Fenvo
//
//  Created by Caesar on 15/6/5.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "FollowingWBViewCell.h"
#import "UIImage+FontAwesome.h"
@interface FollowingWBViewCell(){
    UIButton *_favouriteBtn;
    BOOL _isFavourite;
}
@end
@implementation FollowingWBViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _favouriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _favouriteBtn.tag = 999;
        _favouriteBtn.titleLabel.font = WBStatusButtonFont;
        [self.containView addSubview:_favouriteBtn];
        [_favouriteBtn addTarget:self action:@selector(isFavourite) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setWeiboMsg:(WeiboMsg *)weiboMsg{
    [super setWeiboMsg:weiboMsg];
    _isFavourite = weiboMsg.favorited.boolValue;
    if (_isFavourite == true) {
        [_favouriteBtn setImage:[UIImage imageWithIcon:@"fa-star" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }else {
        [_favouriteBtn setImage:[UIImage imageWithIcon:@"fa-star-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }
    _favouriteBtn.frame = CGRectMake(self.containView.frame.size.width - 35, 10, 30, 20);
}

- (void)isFavourite {
    _isFavourite = !_isFavourite;
    if (_isFavourite == true) {
        [_favouriteBtn setImage:[UIImage imageWithIcon:@"fa-star" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }else {
        [_favouriteBtn setImage:[UIImage imageWithIcon:@"fa-star-o" backgroundColor:[UIColor clearColor] iconColor:RGBACOLOR(250, 143, 5, 1) andSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    }
}
@end
