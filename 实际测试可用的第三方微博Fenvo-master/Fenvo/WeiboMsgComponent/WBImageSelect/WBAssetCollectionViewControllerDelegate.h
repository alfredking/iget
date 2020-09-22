//
//  WBAssetCollectionViewControllerDelegate.h
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

@class WBAssetCollectionViewController;

@protocol WBAssetCollectionViewControllerDelegate <NSObject>

@required
//Single pick
- (void)assetCollectionViewController:(WBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAsset:(ALAsset *)asset;
//Multi pick
- (void)assetCollectionViewController:(WBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets;

//cancel pick
- (void)assetCollectionViewControllerDidCancel:(WBAssetCollectionViewController *)assetCollectionViewController;
//select all or deselect all
- (NSString *)descriptionForSelectingAllAssets:(WBAssetCollectionViewController *)assetCollectionViewController;
- (NSString *)descriptionForDeselectingAllAssets:(WBAssetCollectionViewController *)assetCollectionViewController;

//
- (NSString *)assetCollectionViewController:(WBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos;
- (NSString *)assetCollectionViewController:(WBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos;
- (NSString *)assetCollectionViewController:(WBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos;

@end

