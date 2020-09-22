//
//  UnionSafeKeyboard.h
//  SecurityControl
//
//  Created by zmfeng on 2017/7/27.
//  Copyright © 2017年 union. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PasswordStrengthEnum) {
    PasswordIsEmpty = 0,
    PasswordLenLessThanSix,
    PasswordLenMoreThanFiveIncludeOneOfThreeCharacterType,
    PasswordLenMoreThanFiveIncludeTwoOfThreeCharacterType,
    PasswordLenMoreThanFiveIncludeAllCharacterType,
    PasswordLenEqualToSixIncludeOnlyNumber,
    PasswordLenMoreThanFiveIncludeNumberAndLetter,
};

typedef NS_ENUM(NSUInteger, SafeKeyboardStyle) {
    SafeKeyboardStyleBlack = 0,
    SafeKeyboardStyleGray,
    SafeKeyboardStyleWhite,
};

@interface MSKSafeKeyboard : UIView

/**
 初始化键盘
 
 @param style 键盘风格
 @param height 键盘高度
 @param random 是否打开按键随机
 @param len 允许的最大输入长度
 @param sec 是否打开安全模式
 @return 初始化后的键盘实例
 */
- (nonnull instancetype) initWithStyle:(SafeKeyboardStyle)style
                                height:(CGFloat)height
                                random:(BOOL)random
                                maxlen:(NSUInteger)len
                              security:(BOOL)sec;

/**
 初始化键盘
 
 @param height 键盘高度
 @param random 是否打开按键随机
 @param len 允许的最大输入长度
 @param sec 是否打开安全模式
 @return 初始化后的键盘实例
 */
- (nonnull instancetype) initWithHeight:(CGFloat) height
                                 random:(BOOL)random
                                 maxlen:(NSUInteger)len
                               security:(BOOL)sec;

/**
 绑定密码输入框，并指定密码输入框的键盘类型。onlyNumberKey = true 纯数字键盘；onlyNumberKey = false 全字符键盘
 
 @param textField 密码输入框
 @param onlyNumberKey 键盘类型
 */
- (void) bind:(nonnull UITextField *)textField onlyNumberKey:(BOOL)onlyNumberKey;

// 回调接口
- (void) inputEventCallback:(void(^_Nullable)(NSUInteger len))blockCallback;
- (void) deleteEventCallback:(void(^_Nullable)(NSUInteger len))blockCallback;
- (void) sureEventCallback:(void(^_Nullable)(NSString * _Nullable text))blockCallback;

// 键盘展示，清空，关闭接口
- (void) show;
- (void) clear;
- (void) close;

- (PasswordStrengthEnum) passwordStrength;

// 获取密文
- (nonnull NSString *) getCipher:(nonnull NSString *)msk index:(NSUInteger)index;
- (nonnull NSString *) getCipher:(nonnull NSString *)name index:(NSUInteger)index serverRandom:(nonnull NSString *)rs;

- (void) setTitle:(nullable NSString *)text image:(nullable UIImage *)image;

// 配置接口
- (void) configKeyboardFont:(CGFloat) titleFont
                  letterKey:(CGFloat) letterKeyFont
          letterFunctionKey:(CGFloat) letterFunctionKeyFont
                  numberKey:(CGFloat) numberKeyFont
          numberFunctionKey:(CGFloat) numberFunctionKeyFont;

// 本接口已过期
- (void) configLogoPadding:(CGFloat) top
                      left:(CGFloat) left
                    bottom:(CGFloat) bottom
                     right:(CGFloat) right;

@end
