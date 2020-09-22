//
//  WeiboImageBrowser.h
//  Fenvo
//
//  Created by Caesar on 15/4/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebImageView.h"


@interface WebImageBrowser : NSObject
+(WebImageBrowser *)sharedWebImageBrowser;
-(void)showBmiddlePic:(WebImageView *)webImageView andTag:(NSInteger)tag;
-(void)closeBmiddlePic:(UITapGestureRecognizer *)tap;
@end
