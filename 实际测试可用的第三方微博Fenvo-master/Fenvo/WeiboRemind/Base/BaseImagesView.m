//
//  BaseImagesView.m
//  Fenvo
//
//  Created by Caesar on 15/8/9.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "BaseImagesView.h"
#import "WebImageView.h"

#import "StringFormatTool.h"
#import "UIImageView+WebCache.h"

@interface BaseImagesView() {
 
    
    
}
@end
@implementation BaseImagesView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    _imageView0 = [[WebImageView alloc]initWithStyleAndTag:0];
    _imageView0.tag = 0;
    [self addSubview:_imageView0];
    _imageView1 = [[WebImageView alloc]initWithStyleAndTag:1];
    _imageView1.tag = 1;
    [self addSubview:_imageView1];
    _imageView2 = [[WebImageView alloc]initWithStyleAndTag:2];
    _imageView2.tag = 2;
    [self addSubview:_imageView2];
    _imageView3 = [[WebImageView alloc]initWithStyleAndTag:3];
    _imageView3.tag = 3;
    [self addSubview:_imageView3];
    _imageView4 = [[WebImageView alloc]initWithStyleAndTag:4];
    _imageView4.tag = 4;
    [self addSubview:_imageView4];
    _imageView5 = [[WebImageView alloc]initWithStyleAndTag:5];
    _imageView5.tag = 5;
    [self addSubview:_imageView5];
    _imageView6 = [[WebImageView alloc]initWithStyleAndTag:6];
    _imageView6.tag = 6;
    [self addSubview:_imageView6];
    _imageView7 =[[WebImageView alloc]initWithStyleAndTag:7];
    _imageView7.tag = 7;
    [self addSubview:_imageView7];
    _imageView8 = [[WebImageView alloc]initWithStyleAndTag:8];
    _imageView8.tag = 8;
    [self addSubview:_imageView8];
    
}

- (void)setThumbnailUrl:(NSString *)thumbnailUrl {
    
    NSArray *thumbnail_urls = [StringFormatTool getPicUrls:thumbnailUrl];
    NSArray *bmiddle_urls = [StringFormatTool getPicUrls:[StringFormatTool getBimmdlePicUrl:thumbnailUrl] ];
    NSArray *original_urls = [StringFormatTool getPicUrls:[StringFormatTool getOriginalPicUrl:thumbnailUrl]];
    
    CGFloat selfHeight;
    CGFloat width = self.frame.size.width;
    
    if (thumbnail_urls.count == 1) {
        CGFloat imageWidth = width;
        CGFloat imageHeight = 120;
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        CGRect imageRect = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        _imageView0.hidden = NO;
        _imageView0.contentMode = UIViewContentModeScaleAspectFill;
        _imageView0.frame = imageRect;
        [_imageView0 sd_setImageWithURL:[NSURL URLWithString:bmiddle_urls[0]]];
        _imageView0.original_pic_url = original_urls[0];
        _imageView0.bmiddle_pic_url = bmiddle_urls[0];
        selfHeight = CGRectGetMaxY(_imageView0.frame);
    }else{
        for (int i = 0; i < thumbnail_urls.count; i++) {

            dispatch_queue_t loadImageQueue = dispatch_queue_create("baseImagesView.setThumbnail.loadImage", NULL);
            dispatch_async(loadImageQueue, ^{
                CGFloat imageY;
                CGRect  imageRect;
                CGFloat imageWidth ;
                CGFloat imageHight ;
                if (thumbnail_urls.count >= 3) {
                    imageWidth = (width -  WBStatusCellImageViewSpacing * 2)/3;
                }else {
                    imageWidth = (width - WBStatusCellImageViewSpacing)/2;
                }
                imageHight = imageWidth ;
                if (i >= 6) {
                    CGFloat imageX = WBStatusCellImageViewSpacing*(i - 5) + imageWidth * (i - 6) - WBStatusCellImageViewSpacing;
                    imageY = WBStatusCellImageViewSpacing*2 + imageHight*2;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }else if(i <= 2){
                    CGFloat imageX = WBStatusCellImageViewSpacing*(i + 1) + imageWidth * i - WBStatusCellImageViewSpacing;
                    imageY = 0;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }else{
                    CGFloat imageX = WBStatusCellImageViewSpacing*(i - 2) + imageWidth * (i-3)  - WBStatusCellImageViewSpacing;
                    imageY = WBStatusCellImageViewSpacing + imageHight;
                    imageRect = CGRectMake(imageX, imageY, imageWidth, imageHight);
                }
                switch (i) {
                    case 0:
                    {
                        _imageView0.hidden = NO;
                        _imageView0.frame = imageRect;
                        [self setImageOfView:_imageView0 Url:thumbnail_urls[0]];
                        _imageView0.original_pic_urls = original_urls;
                        _imageView0.bmiddle_pic_urls = bmiddle_urls;
                    }   break;
                    case 1:
                        _imageView1.hidden = NO;
                        _imageView1.frame = imageRect;
                        [self setImageOfView:_imageView1 Url:thumbnail_urls[1]];
                        _imageView1.original_pic_urls = original_urls;
                        _imageView1.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 2:
                        _imageView2.hidden = NO;
                        _imageView2.frame = imageRect;
                        [self setImageOfView:_imageView2 Url:thumbnail_urls[2]];
                        _imageView2.original_pic_urls = original_urls;
                        _imageView2.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 3:
                        _imageView3.hidden = NO;
                        _imageView3.frame = imageRect;
                        [self setImageOfView:_imageView3 Url:thumbnail_urls[3]];
                        _imageView3.original_pic_urls = original_urls;
                        _imageView3.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 4:
                        _imageView4.hidden = NO;
                        _imageView4.frame = imageRect;
                        [self setImageOfView:_imageView4 Url:thumbnail_urls[4]];
                        _imageView4.original_pic_urls = original_urls;
                        _imageView4.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 5:
                        _imageView5.hidden = NO;
                        _imageView5.frame = imageRect;
                        [self setImageOfView:_imageView5 Url:thumbnail_urls[5]];
                        _imageView5.original_pic_urls = original_urls;
                        _imageView5.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 6:
                        _imageView6.hidden = NO;
                        _imageView6.frame = imageRect;
                        [self setImageOfView:_imageView7 Url:thumbnail_urls[6]];
                        _imageView6.original_pic_urls = original_urls;
                        _imageView6.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 7:
                        _imageView7.hidden = NO;
                        _imageView7.frame = imageRect;
                        [self setImageOfView:_imageView7 Url:thumbnail_urls[7]];
                        _imageView7.original_pic_urls = original_urls;
                        _imageView7.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    case 8:
                        _imageView8.hidden = NO;
                        _imageView8.frame = imageRect;
                        [self setImageOfView:_imageView8 Url:thumbnail_urls[8]];
                        _imageView8.original_pic_urls = original_urls;
                        _imageView8.bmiddle_pic_urls = bmiddle_urls;
                        break;
                    default:
                        break;
                }
    
            });
        }
        
        CGFloat imageWidth;
        if (thumbnail_urls.count >= 3) {
           imageWidth = (width -  WBStatusCellImageViewSpacing * 2)/3;
        }else {
           imageWidth = (width -  WBStatusCellImageViewSpacing)/2;
        }
        
        if (thumbnail_urls.count > 6) {
            selfHeight = WBStatusCellImageViewSpacing*2 + imageWidth*3;
        }else if(thumbnail_urls.count <= 3){
            selfHeight = imageWidth;
        }else{
            selfHeight = imageWidth*2 + WBStatusCellImageViewSpacing;
        }
    }
    self.imagesHeight = selfHeight;
    
}

//如果长宽比大于2或小于0.5，则替换为中图
- (void)setImageOfView: (UIImageView *)imageView Url:(NSString *)url {
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGSize imageSize = image.size;
        CGFloat multiple = imageSize.height / imageSize.width;
        
        if (multiple > 2 || multiple < 0.5) {
            NSString *bmiddleUrl = [StringFormatTool getBimmdlePicUrl:url];
            [imageView sd_setImageWithURL:[NSURL URLWithString:bmiddleUrl]];
        }
    }];
}

@end
