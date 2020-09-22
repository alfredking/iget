//
//  GTVideoPlayer.m
//  SampleApp
//
//  Created by alfredking－cmcc on 2019/7/23.
//  Copyright © 2019 alfredking. All rights reserved.
//

#import "GTVideoPlayer.h"
#import "AVFoundation/AVFoundation.h"
#import <Photos/Photos.h>

@interface GTVideoPlayer ()

@property (nonatomic,strong,readwrite) AVPlayerItem *videoItem;
@property (nonatomic,strong,readwrite) AVPlayer *avPlayer ;
@property (nonatomic,strong,readwrite) AVPlayerLayer *playerLayer ;

@end
@implementation GTVideoPlayer

+(GTVideoPlayer *)Player
{
    //static 变量有什么特点
    static GTVideoPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[GTVideoPlayer alloc]init];
    });
    
    return player;
}
-(void)playVideoWithUrl: (NSString *)videoUrl attachView:(UIView *) attachView
{
    
    [self _stopPlay];
    
    //带视频的网页需要进一步解析
//    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[[NSURL URLWithString:videoUrl]] options:nil];
//    NSLog(@"result count is %lu",(unsigned long)result.count);
//
//    PHAsset * passet = result.firstObject;
//
//
//    /// 包含该视频的基础信息
//    PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: passet] firstObject];
//
//    NSLog(@"%@",resource);
//
    
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:videoUrl]];
    _videoItem = [AVPlayerItem playerItemWithAsset:asset];
    [_videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [_videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    CMTime duration = _videoItem.duration; //duration为什么不用加*号，因为是数值类型
    CGFloat videoDuration = CMTimeGetSeconds(duration);
    
    _avPlayer = [AVPlayer playerWithPlayerItem:_videoItem];
    
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"播放进度 %@",@(CMTimeGetSeconds(time)));
    }];
    
    //avplayerviewcontroller 待实现
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    
    //    playerLayer.frame = _coverView.frame; 为什么不是frame
    _playerLayer.frame = attachView.bounds;
    [attachView.layer addSublayer:_playerLayer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handlePlayerEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    NSLog(@"playVideoWithUrl");
}


#pragma mark private method



-(void)_handlePlayerEnd
{

    //循环播放
    //    [_avPlayer seekToTime:CMTimeMake(0, 1)];
    //    [_avPlayer play];
    NSLog(@"_handlePlayerEnd");
}

-(void)_stopPlay
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_playerLayer removeFromSuperlayer];
    [_videoItem removeObserver:self forKeyPath:@"status"];
    [_videoItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _videoItem = nil;
    _avPlayer = nil;
    NSLog(@"_stopPlay");
}



#pragma mark -kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (((NSNumber * )[change objectForKey:NSKeyValueChangeNewKey]).integerValue ==AVPlayerItemStatusReadyToPlay
            )
        {
            [_avPlayer play];
        }
        else
        {
            NSLog(@"AVPlayerItemStatusReadyToPlay");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        NSLog(@"缓冲：%@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
}
@end
