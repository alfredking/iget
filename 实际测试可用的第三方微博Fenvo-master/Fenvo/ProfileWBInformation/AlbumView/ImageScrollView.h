//
//  ImageScrollView.h
//  Fenvo
//
//  Created by Caesar on 15/5/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboMsg.h"

@interface ImageScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong)NSString *access_token;
- (void)setAccess_token;
@end
