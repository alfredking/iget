//
//  FreeFlowButton.h
//  IDMPCMCC
//
//  Created by wj on 2017/12/2.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeFlowButton : UIButton


/**
 初始化带有渐变色的button

 @param bgStartColor 起点色
 @param bgEndColor 终点色
 @return button
 */
- (instancetype)initWithBgStartColor:(NSString *)bgStartColor bgEndColor:(NSString *)bgEndColor;

@end
