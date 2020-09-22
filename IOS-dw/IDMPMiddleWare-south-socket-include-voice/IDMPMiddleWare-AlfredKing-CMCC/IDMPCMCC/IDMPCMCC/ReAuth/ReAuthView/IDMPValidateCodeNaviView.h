//
//  IDMPValidateCodeNaviView.h
//  IDMPCMCC
//
//  Created by wj on 2017/7/23.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDMPValidateCodeNaviView : UIView
@property (nonatomic, copy) void(^closeBlcok)(void);

- (void)setNaviTitle:(NSString *)title;

@end
