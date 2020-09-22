//
//  SingleWebImageBrowser.h
//  WebImageBrowserDemo
//
//  Created by Caesar on 15/4/16.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleWebImageView.h"

@interface SingleWebImageBrowser : NSObject
+(SingleWebImageBrowser *)sharedSingleWebImageBrowser;
-(void)showBmiddlePic:(SingleWebImageView *)webImageView;
-(void)closeBmiddlePic:(UITapGestureRecognizer *)tap;
@end
