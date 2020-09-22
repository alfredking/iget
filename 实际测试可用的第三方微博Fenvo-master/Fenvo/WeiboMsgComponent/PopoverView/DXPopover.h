//
//  DXPopover.h
//
//  Created by xiekw on 11/14/14.
//  Modified by Chan on 08/28/15.
//

#import <UIKit/UIKit.h>

#define IPHONE_SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define IPHONE_SCREEN_HIGHT     [[UIScreen mainScreen] bounds].size.height
#define IS_IPAD                 ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

typedef NS_ENUM(NSUInteger, DXPopoverPosition) {
    DXPopoverPositionUp = 1,
    DXPopoverPositionDown,
};

typedef NS_ENUM(NSUInteger, DXPopoverMaskType) {
    DXPopoverMaskTypeBlack,
    DXPopoverMaskTypeNone,
};


@interface DXPopover : UIView

+ (instancetype)popover;

@property (nonatomic, assign) CGPoint arrowShowPoint;

@property (nonatomic, strong)UIColor *contentColor;

/**
 *  If the popover is stay up or down the showPoint
 *  弹出视图的位置，在上方还是在下方
 */
@property (nonatomic, assign, readonly) DXPopoverPosition popoverPosition;

/**
 *  The popover arrow size, default is {10.0, 10.0};
 *  弹出视图的尖角大小，默认10.0*10.0
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  The popover corner radius, default is 7.0;
 *  弹出视图圆角大小，默认7.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  The popover animation show in duration, default is 0.4;
 *  弹出视图弹出动画时间，默认0.4
 */
@property (nonatomic, assign) CGFloat animationIn;

/**
 *  The popover animation dismiss duration, default is 0.3;
 *  消失时间，默认0.3s
 */
@property (nonatomic, assign) CGFloat animationOut;

/**
 *  If the drop in animation using spring animation, default is YES;
 *  是否弹出弹出视图的控件要使用弹动动画。默认YES
 *
 */
@property (nonatomic, assign) BOOL animationSpring;

/**
 *  The background of the popover, default is DXPopoverMaskTypeBlack;
 *  弹出视图的背景颜色，即遮罩样式
 */
@property (nonatomic, assign) DXPopoverMaskType maskType;

/**
 *  when you using atView show API, this value will be used as the distance between popovers'arrow and atView. Note: this value is invalid when popover show using the atPoint API
 *  当你使用showAtView的函数时，这个值将会被应用于弹出视图视图与视图的距离，当使用showAtPoint时此值无效
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;


/**
 * Decide the nearest edge between the containerView's border and popover, default is 4.0
 * 弹出框与尖角之间的间距，默认为4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;

/**
 *  The callback when popover did show in the containerView
 *  弹出视图弹出后的回调事件
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when popover did dismiss in the containerView;
 *  弹出视图消失后的回调事件
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

/**
 *  Show API
 *
 *  @param point         the point in the container coordinator system.
 *  @param position      stay up or stay down from the showAtPoint
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtPoint:(CGPoint)point popoverPostion:(DXPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point will be caluclated for you, try it!
 *
 *  @param atView        The view to show at
 *  @param position      stay up or stay down from the atView, if up or down size is not enough for contentView, then it will be set correctly auto.
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtView:(UIView *)atView popoverPostion:(DXPopoverPosition)position withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, try it!
 *
 *  @param atView        The view to show at
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain 
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView inView:(UIView *)containerView;

/**
 *  Lazy show API        The show point and show position will be caluclated for you, using application's keyWindow as containerView, try it!
 *
 *  @param atView        The view to show at
 *  @param contentView   the contentView to show
 */
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView;

- (void)dismiss;


@end
