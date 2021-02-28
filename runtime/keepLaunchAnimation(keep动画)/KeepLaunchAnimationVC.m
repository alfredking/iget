//
//  KeepLaunchAnimationVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "KeepLaunchAnimationVC.h"

#import <AVKit/AVKit.h>

@interface KeepLaunchAnimationVC ()

@property (nonatomic, strong) AVPlayerViewController *playerVC;

@end

@implementation KeepLaunchAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self keepLaunchAnimation];
}

/// keep首页动画
- (void)keepLaunchAnimation{
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"keep" ofType:@"mp4"];
    
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
    self.playerVC.view.frame = self.view.bounds;
    self.playerVC.showsPlaybackControls = NO;
    //self.playerVC.entersFullScreenWhenPlaybackBegins = YES;//开启这个播放的时候支持（全屏）横竖屏哦
    //self.playerVC.exitsFullScreenWhenPlaybackEnds = YES;//开启这个所有 item 播放完毕可以退出全屏
    [self.view addSubview:self.playerVC.view];
    
//    if (self.playerVC.readyForDisplay) {
        [self.playerVC.player play];
//    }
}

@end
