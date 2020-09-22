//
//  SingleWebImageBrowser.h
//  WebImageBrowserDemo
//
//  Created by Caesar on 15/4/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleImageView.h"

@interface SingleImageBrowser : NSObject
+(SingleImageBrowser *)sharedSingleWebImageBrowser;
-(void)show:(SingleImageView *)webImageView;
-(void)close:(UITapGestureRecognizer *)tap;
@end
