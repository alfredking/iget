//
//  weiboVideoView.h
//  weico
//
//  Created by alfredking－cmcc on 2020/7/9.
//  Copyright © 2020 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeiboVideoView : UIView


-(void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl;

@end

NS_ASSUME_NONNULL_END
