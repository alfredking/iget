//
//  ItemsPopoverView.h
//  PopoverView
//
//  Created by Neil on 15/9/12.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXPopover.h"

@protocol ItemsPopoverViewDelegate;

@interface ItemsPopoverView : UITableView

/*Data*/
@property (nonatomic, strong) NSMutableArray*items;

/*Subview*/
@property (nonatomic, strong) UIView         *containerView;
@property (nonatomic, copy)   NSString       *title;
@property (nonatomic, strong) DXPopover      *popover;

/*Style*/
@property (nonatomic, assign) CGFloat        popoverWidth;
@property (nonatomic, strong) UIColor        *mainColor;
@property (nonatomic, strong) UIColor        *arrowColor;
@property (nonatomic, assign) DXPopoverMaskType maskType;
@property (nonatomic, assign) CGSize         arrowSize;
@property (nonatomic, assign) CGFloat        cornerRadius;
@property (nonatomic, assign) CGFloat        itemHeight;

/*Delegate*/
@property (nonatomic, assign) id<ItemsPopoverViewDelegate> itemsDelegate;

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id /*<ItemsPopoverViewDelegate>*/)delegate
                containerView:(UIView *)containerView
                         size:(CGSize)size
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)showPopoverView;
@end

#pragma mark - PopoverViewDelegate

@protocol ItemsPopoverViewDelegate <NSObject>
@optional

- (void)popoverView:(ItemsPopoverView *)popoverView clickedItemAtIndex:(NSInteger)index;

@end