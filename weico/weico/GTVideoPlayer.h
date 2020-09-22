//
//  GTVideoPlayer.h
//  SampleApp
//
//  Created by alfredking－cmcc on 2019/7/23.
//  Copyright © 2019 alfredking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>  //自己加的，不知道课程视频里面为什么没有

NS_ASSUME_NONNULL_BEGIN

@interface GTVideoPlayer : NSObject

+(GTVideoPlayer *)Player;

-(void)playVideoWithUrl: (NSString *)videoUrl attachView:(UIView *) attachView;

@end

NS_ASSUME_NONNULL_END
