//
//  WeiboForwardView.h
//  Fenvo
//
//  Created by Caesar on 15/6/4.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeiboForwardView : NSObject
+ (WeiboForwardView *)sharedWeiboForwardView;
- (void)showForwardView:(long long)weiboID withComment:(NSString *)wbDetail andUserName:(NSString *)userName;
@end

