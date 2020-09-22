//
//  WBImagePickerAssetCellDelegate.h
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

@class WBImagePickerAssetCell;

@protocol WBImagePickerAssetCellDelegate <NSObject>

@required
- (BOOL)assetCell:(WBImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index;
- (void)assetCell:(WBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index;
@end
