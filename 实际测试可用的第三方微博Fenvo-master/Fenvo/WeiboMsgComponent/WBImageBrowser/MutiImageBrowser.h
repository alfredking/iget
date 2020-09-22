//
//  WeiboImageBrowser.h
//  Fenvo
//
//  Created by Caesar on 15/4/6.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutiImageView.h"


@interface MutiImageBrowser : NSObject
+(MutiImageBrowser *)sharedMutiImageBrowser;
-(void)show:(NSArray *)imageArray withTag:(NSInteger)tag andImageView:(MutiImageView *)img;
-(void)close:(UITapGestureRecognizer *)tap;
@end
