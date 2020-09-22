//
//  FollowingWBViewCell.h
//  Fenvo
//
//  Created by Caesar on 15/3/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"
#import "WeiboAvatarView.h"
#import "WeiboLabel.h"
#import "WebImageView.h"
#import "WeiboVideoView.h"

@interface WeiboTableViewCell : UITableViewCell
//数据模型对象
@property (nonatomic, strong)WeiboMsg *weiboMsg;
//背景框
@property(nonatomic, strong)UIView *containView;
@property(nonatomic, strong)WeiboAvatarView *avatar;
@property(nonatomic, strong)UIImageView *mbType;
@property(nonatomic, strong)UILabel *userName;
@property(nonatomic, strong)UILabel *createTime;
@property(nonatomic, strong)UILabel *source;
@property(nonatomic, strong)WeiboLabel *wbForwardText;
@property(nonatomic, strong)WeiboLabel *wbDetail;

//配图集合
@property(nonatomic, strong)WebImageView *imageView0;
@property(nonatomic, strong)WebImageView *imageView1;
@property(nonatomic, strong)WebImageView *imageView2;
@property(nonatomic, strong)WebImageView *imageView3;
@property(nonatomic, strong)WebImageView *imageView4;
@property(nonatomic, strong)WebImageView *imageView5;
@property(nonatomic, strong)WebImageView *imageView6;
@property(nonatomic, strong)WebImageView *imageView7;
@property(nonatomic, strong)WebImageView *imageView8;

//视频
@property(nonatomic, strong)WeiboVideoView *weiboVideoView;


@property(nonatomic, strong)UIButton *praiseBtn;
@property(nonatomic, strong)UIButton *forwardBtn;
@property(nonatomic, strong)UIButton *commentBtn;

@end
