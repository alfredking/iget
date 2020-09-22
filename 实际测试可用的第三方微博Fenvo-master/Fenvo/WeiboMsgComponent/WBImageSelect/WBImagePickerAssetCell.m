//
//  QBImagePickerAssetCell.m
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WBImagePickerAssetCell.h"

// Views
#import "WBImagePickerAssetView.h"

@interface WBImagePickerAssetCell ()

- (void)addAssetViews;

@end

@implementation WBImagePickerAssetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(NSUInteger)numberOfAssets margin:(CGFloat)margin
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.imageSize = imageSize;
        self.numberOfAssets = numberOfAssets;
        self.margin = margin;
        
        [self addAssetViews];
    }
    
    return self;
}

- (void)setAssets:(NSArray *)assets
{
    _assets = assets;
    
    // Set assets
    for(NSUInteger i = 0; i < self.numberOfAssets; i++) {
        WBImagePickerAssetView *assetView = (WBImagePickerAssetView *)[self.contentView viewWithTag:(1 + i)];
        
        if(i < self.assets.count) {
            assetView.hidden = NO;
            
            assetView.asset = [self.assets objectAtIndex:i];
        } else {
            assetView.hidden = YES;
        }
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Set property
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[WBImagePickerAssetView class]]) {
            [(WBImagePickerAssetView *)subview setAllowsMultipleSelection:self.allowsMultipleSelection];
        }
    }
}

- (void)dealloc
{

}


#pragma mark - Instance Methods

- (void)addAssetViews
{
    // Remove all asset views
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[WBImagePickerAssetView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    // Add asset views
    for(NSUInteger i = 0; i < self.numberOfAssets; i++) {
        // Calculate frame
        CGFloat offset = (self.margin + self.imageSize.width) * i;
        CGRect assetViewFrame = CGRectMake(offset + self.margin, self.margin, self.imageSize.width, self.imageSize.height);
        
        // Add asset view
        WBImagePickerAssetView *assetView = [[WBImagePickerAssetView alloc] initWithFrame:assetViewFrame];
        assetView.delegate = self;
        assetView.tag = 1 + i;
        assetView.autoresizingMask = UIViewAutoresizingNone;
        
        [self.contentView addSubview:assetView];
    }
}

- (void)selectAssetAtIndex:(NSUInteger)index
{
    WBImagePickerAssetView *assetView = (WBImagePickerAssetView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = YES;
}

- (void)deselectAssetAtIndex:(NSUInteger)index
{
    WBImagePickerAssetView *assetView = (WBImagePickerAssetView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = NO;
}

- (void)selectAllAssets
{
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[WBImagePickerAssetView class]]) {
            if(![(WBImagePickerAssetView *)subview isHidden]) {
                [(WBImagePickerAssetView *)subview setSelected:YES];
            }
        }
    }
}

- (void)deselectAllAssets
{
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[WBImagePickerAssetView class]]) {
            if(![(WBImagePickerAssetView *)subview isHidden]) {
                [(WBImagePickerAssetView *)subview setSelected:NO];
            }
        }
    }
}


#pragma mark - QBImagePickerAssetViewDelegate

- (BOOL)assetViewCanBeSelected:(WBImagePickerAssetView *)assetView
{
    return [self.delegate assetCell:self canSelectAssetAtIndex:(assetView.tag - 1)];
}

- (void)assetView:(WBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected
{
    [self.delegate assetCell:self didChangeAssetSelectionState:selected atIndex:(assetView.tag - 1)];
}

@end

