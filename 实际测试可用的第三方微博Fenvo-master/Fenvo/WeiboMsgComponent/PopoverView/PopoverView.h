//
//  PopoverView.h
//  PopoverView
//
//  Created by 我的宝宝 on 15/8/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXPopover.h"

@protocol PopoverViewDelegate;

@interface PopoverView : UIView
/*Show Message*/
@property (nonatomic, strong) NSString       *message;
@property (nonatomic, strong) DXPopover      *popover;

/*Component*/
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UILabel        *remindLabel;
@property (nonatomic, strong) UIView         *containerView;

/*Style*/
@property (nonatomic, assign) CGFloat         popoverWidth;
@property (nonatomic, strong) UIColor        *mainColor;
@property (nonatomic, strong) UIColor        *arrowColor;
@property (nonatomic, assign) DXPopoverMaskType maskType;
@property (nonatomic, assign) CGSize            arrowSize;
@property (nonatomic, assign) CGFloat           cornerRadius;
@property (nonatomic, assign) BOOL              isAnimation;

/*Delegate*/
@property (nonatomic, assign) id<PopoverViewDelegate> delegate;

/*Initialize*/
- (instancetype)initWithMessage:(NSString *)message
                       delegate:(id /*<PopoverViewDelegate>*/)delegate
                  containerView:(UIView *)containerView
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end


#pragma mark - PopoverViewDelegate

@protocol PopoverViewDelegate <NSObject>
@optional

- (void)popoverView:(PopoverView *)popoverView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
