//
//  WeiboCommentView.h
//  Fenvo
//
//  Created by Caesar on 15/6/2.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeiboCommentView : NSObject
+ (WeiboCommentView *)sharedWeiboCommentView;
- (void)showCommentView:(long long)weiboID ;
@end
