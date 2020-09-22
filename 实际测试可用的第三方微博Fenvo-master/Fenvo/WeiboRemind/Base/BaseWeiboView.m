//
//  RemindBaseView.m
//  Fenvo
//
//  Created by Caesar on 15/8/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "BaseWeiboView.h"
#import "StyleOfRemindSubviews.h"

@implementation BaseWeiboView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [StyleOfRemindSubviews lightGreyColor];
    

    _image = [[UIImageView alloc]init];
    [self addSubview:_image];
    
    
    _username = [[UILabel alloc]init];
    _username.font = [StyleOfRemindSubviews middleFont];
    _username.textColor = [StyleOfRemindSubviews deepBlackColor];
    [self addSubview:_username];
    
    
    _detail = [[UILabel alloc]init];
    _detail.font = [StyleOfRemindSubviews smallFont];
    _detail.textColor = [StyleOfRemindSubviews deepBlackColor];
    _detail.numberOfLines = 2;
    [self addSubview:_detail];

}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _image.frame = CGRectMake(0, 0, height, height);
    
    CGFloat imageX = CGRectGetMaxX(_image.frame) + 8;
    _username.frame = CGRectMake(imageX, 2, width - imageX, [StyleOfRemindSubviews usernameHeight]);
    
    CGFloat usernameY = CGRectGetMaxY(_username.frame);
    _detail.frame = CGRectMake(imageX, usernameY, width - imageX, [StyleOfRemindSubviews detailHeight]);
}


@end
