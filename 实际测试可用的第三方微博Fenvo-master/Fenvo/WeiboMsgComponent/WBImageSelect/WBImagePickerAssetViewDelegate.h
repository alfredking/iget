//
//  WBImagePickerAssetViewDelegate.h
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

@class WBImagePickerAssetView;

@protocol WBImagePickerAssetViewDelegate <NSObject>

@required
- (BOOL)assetViewCanBeSelected:(WBImagePickerAssetView *)assetView;
- (void)assetView:(WBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected;

@end

