//
//  weiboVideoView.m
//  weico
//
//  Created by alfredking－cmcc on 2020/7/9.
//  Copyright © 2020 alfredking－cmcc. All rights reserved.
//

#import "WeiboVideoView.h"
#import "GTVideoPlayer.h"

@interface WeiboVideoView()

@property(nonatomic, strong,readwrite) UIImageView *coverView;
@property(nonatomic, strong,readwrite) UIImageView *playButton;
@property(nonatomic,copy,readwrite)NSString *videoUrl;//这里为什么要用copy  因为是要从外面传到里面

@end

@implementation WeiboVideoView



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];//是不是外层 alloc init的时候调用
    if (self) {
        [self addSubview:({
            _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
            _coverView;
        })];
        
        [_coverView addSubview:({
            _playButton = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width -50)/2,(frame.size.height -50)/2,50,50)];
            
            
            _playButton;
        })];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_tapToPlay)];
        [self addGestureRecognizer:tapGesture];
        
        
    }
    return self;
}


#pragma mark public method
-(void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl
{
    _coverView.image = [UIImage imageNamed:videoCoverUrl];
    _playButton.image = [UIImage imageNamed:@"icon.bundle/video@2x.png"];
    //videoUrl = videoUrl; 为什么这一行不行
    _videoUrl = videoUrl;
    
}


-(void)_tapToPlay
{
    
    [[GTVideoPlayer Player] playVideoWithUrl:_videoUrl attachView:self];
}

@end
