//
//  IDMPAlertView.h
//  IDMPCMCC
//
//  Created by wj on 2017/7/23.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IDMPAlertWidthType) {
    IDMPAlertWidthShort = 155,
    IDMPAlertWidthLong  = 207
};
static const CGFloat IDMPAlertHeight = 38;


typedef NS_ENUM(NSInteger, IDMPPopupAlertType) {
    IDMPPopupAlertError,            // 错误
    IDMPPopupAlertWarn,             // 警告
    IDMPPopupAlertSuccess,          // 正确
};

@interface IDMPAlertView : UIView

- (instancetype)initWithMessage:(NSString *)message alertType:(IDMPPopupAlertType)alertType;

- (void)setMessage:(NSString *)message alertType:(IDMPPopupAlertType)alertType;
- (void)setMessage:(NSString *)message alertType:(IDMPPopupAlertType)alertType alertWidth:(IDMPAlertWidthType)alertWidth;
@end
