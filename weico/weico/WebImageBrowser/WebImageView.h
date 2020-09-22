//
//  WeiboImageView.h
//  Fenvo
//
//  Created by Caesar on 15/3/31.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebImageView : UIImageView
@property(nonatomic, copy)NSString *original_pic_url;
@property(nonatomic, copy)NSString *bmiddle_pic_url;
@property(nonatomic, copy)NSArray *bmiddle_pic_urls;
@property(nonatomic, copy)NSArray *original_pic_urls;

-(WebImageView *)initWithStyleAndTag:(NSInteger)tag;
@end
