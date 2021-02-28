//
//  ANPopoverView.h
//  testbutton
//
//  Created by 大豌豆 on 19/J/29.
//  Copyright © 2019 大碗豆. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ANPopoverAction.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PopoverViewStyle) {
    PopoverViewStyleDefault = 0, // 默认风格, 白色
    PopoverViewStyleDark, // 黑色风格
};


@interface ANPopoverView : UIView

@property (nonatomic, assign) BOOL hideAfterTouchOutside; ///< 是否开启点击外部隐藏弹窗, 默认为YES.
@property (nonatomic, assign) BOOL showShade; ///< 是否显示阴影, 如果为YES则弹窗背景为半透明的阴影层, 否则为透明, 默认为NO.
@property (nonatomic, assign) PopoverViewStyle style; ///< 弹出窗风格, 默认为 PopoverViewStyleDefault(白色).

+ (instancetype)popoverView;

/*! @brief 指向指定的View来显示弹窗
 *  @param pointView 箭头指向的View
 *  @param contents 内容
 */
- (void)showToView:(UIView *)pointView withActions:(NSString *)contents;

/*! @brief 指向指定的点来显示弹窗
 *  @param toPoint 箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 *  @param contents 内容
 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSString *)contents;

@end

NS_ASSUME_NONNULL_END
