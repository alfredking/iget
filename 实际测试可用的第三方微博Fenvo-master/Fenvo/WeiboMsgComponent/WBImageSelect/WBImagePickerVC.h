//
//  QBImagePickerController.h
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Delegate
#import "WBAssetCollectionViewControllerDelegate.h"

typedef enum {
    WBImagePickerFilterTypeAllAssets,
    WBImagePickerFilterTypeAllPhotos,
    WBImagePickerFilterTypeAllVideos
} WBImagePickerFilterType;

@class WBImagePickerVC;

@protocol WBImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerControllerWillFinishPickingMedia:(WBImagePickerVC *)imagePickerController;
- (void)imagePickerController:(WBImagePickerVC *)imagePickerController didFinishPickingMediaWithInfo:(id)info;
- (void)imagePickerControllerDidCancel:(WBImagePickerVC *)imagePickerController;
- (NSString *)descriptionForSelectingAllAssets:(WBImagePickerVC *)imagePickerController;
- (NSString *)descriptionForDeselectingAllAssets:(WBImagePickerVC *)imagePickerController;
- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos;
- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos;
- (NSString *)imagePickerController:(WBImagePickerVC *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos;

@end

@interface WBImagePickerVC : UIViewController <UITableViewDataSource, UITableViewDelegate, WBAssetCollectionViewControllerDelegate>

@property (nonatomic, assign) id<WBImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) WBImagePickerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL fullScreenLayoutEnabled;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL limitsMinimumNumberOfSelection;
@property (nonatomic, assign) BOOL limitsMaximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@end

