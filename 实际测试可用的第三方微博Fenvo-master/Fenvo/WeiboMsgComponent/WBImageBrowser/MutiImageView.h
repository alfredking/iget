//
//  WeiboImageView.h
//  Fenvo
//
//  Created by Caesar on 15/3/31.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MutiImageView : UIImageView
-(MutiImageView *)initWithImageArray:(NSArray *)imageArray AndTag:(NSInteger)tag;
-(void)setImageArray:(NSArray *)imageArray andTag:(NSInteger)tag;
@end
