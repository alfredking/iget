//
//  WBAssetCollectionVC.h
//  ImageSelect
//
//  Created by Caesar on 15/6/23.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

// Delegate
#import "WBAssetCollectionViewControllerDelegate.h"
#import "WBImagePickerAssetCellDelegate.h"

// Controllers
#import "WBImagePickerVC.h"

@interface WBAssetCollectionVC : UIViewController <UITableViewDataSource, UITableViewDelegate, WBImagePickerAssetCellDelegate>

@property (nonatomic, assign) id<WBAssetCollectionViewControllerDelegate> delegate;
@property (nonatomic, retain) ALAssetsGroup *assetsGroup;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) WBImagePickerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL fullScreenLayoutEnabled;
@property (nonatomic, assign) BOOL showsHeaderButton;
@property (nonatomic, assign) BOOL showsFooterDescription;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL limitsMinimumNumberOfSelection;
@property (nonatomic, assign) BOOL limitsMaximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@end