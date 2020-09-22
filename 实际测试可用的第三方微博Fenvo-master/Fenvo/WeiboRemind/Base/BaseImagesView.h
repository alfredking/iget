//
//  BaseImagesView.h
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"

@interface BaseImagesView : UIView
@property (nonatomic, copy)NSString *thumbnailUrl;
@property (nonatomic, assign)CGFloat imagesHeight;

//配图集合
@property(nonatomic, strong)WebImageView *imageView0;
@property(nonatomic, strong)WebImageView *imageView1;
@property(nonatomic, strong)WebImageView *imageView2;
@property(nonatomic, strong)WebImageView *imageView3;
@property(nonatomic, strong)WebImageView *imageView4;
@property(nonatomic, strong)WebImageView *imageView5;
@property(nonatomic, strong)WebImageView *imageView6;
@property(nonatomic, strong)WebImageView *imageView7;
@property(nonatomic, strong)WebImageView *imageView8;

@end
