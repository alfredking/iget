//
//  QBImagePickerAssetView.m
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WBImagePickerAssetView.h"

// Views
#import "WBImagePickerVideoInfoView.h"

@interface WBImagePickerAssetView ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) WBImagePickerVideoInfoView *videoInfoView;
@property (nonatomic, retain) UIImageView *overlayImageView;

- (UIImage *)thumbnail;
- (UIImage *)tintedThumbnail;

@end

@implementation WBImagePickerAssetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        /* Initialization */
        // Image View
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:imageView];
        self.imageView = imageView;
        
        // Video Info View
        WBImagePickerVideoInfoView *videoInfoView = [[WBImagePickerVideoInfoView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 17, self.bounds.size.width, 17)];
        videoInfoView.hidden = YES;
        videoInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:videoInfoView];
        self.videoInfoView = videoInfoView;
        
        // Overlay Image View
        UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
        overlayImageView.clipsToBounds = YES;
        overlayImageView.image = [UIImage imageNamed:@"overlay.png"];
        overlayImageView.hidden = YES;
        overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:overlayImageView];
        self.overlayImageView = overlayImageView;
    }
    
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    // Set thumbnail image
    self.imageView.image = [self thumbnail];
    
    if([self.asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
        double duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        
        self.videoInfoView.hidden = NO;
        self.videoInfoView.duration = round(duration);
    } else {
        self.videoInfoView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected
{
    if(self.allowsMultipleSelection) {
        self.overlayImageView.hidden = !selected;
    }
}

- (BOOL)selected
{
    return !self.overlayImageView.hidden;
}

- (void)dealloc
{
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate assetViewCanBeSelected:self] && !self.allowsMultipleSelection) {
        self.imageView.image = [self tintedThumbnail];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate assetViewCanBeSelected:self]) {
        self.selected = !self.selected;
        
        if(self.allowsMultipleSelection) {
            self.imageView.image = [self thumbnail];
        } else {
            self.imageView.image = [self tintedThumbnail];
        }
        
        [self.delegate assetView:self didChangeSelectionState:self.selected];
    } else {
        if(self.allowsMultipleSelection && self.selected) {
            self.selected = !self.selected;
            self.imageView.image = [self thumbnail];
            
            [self.delegate assetView:self didChangeSelectionState:self.selected];
        } else {
            self.imageView.image = [self thumbnail];
        }
        
        [self.delegate assetView:self didChangeSelectionState:self.selected];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.imageView.image = [self thumbnail];
}


#pragma mark - Instance Methods

- (UIImage *)thumbnail
{
    return [UIImage imageWithCGImage:[self.asset thumbnail]];
}

- (UIImage *)tintedThumbnail
{
    UIImage *thumbnail = [self thumbnail];
    
    UIGraphicsBeginImageContext(thumbnail.size);
    
    CGRect rect = CGRectMake(0, 0, thumbnail.size.width, thumbnail.size.height);
    [thumbnail drawInRect:rect];
    
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    
    UIImage *tintedThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedThumbnail;
}

@end

