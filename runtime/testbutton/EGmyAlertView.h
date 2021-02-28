//
//  EGmyAlertView.h
//  EntranceGuard
//
//  Created by 大碗豆 on 16/12/5.
//  Copyright © 2016年 大碗豆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGmyAlertView : UIView

@property (strong, nonatomic) UIViewController *contentView;
@property (nonatomic,assign)CGFloat contentViewHeight;

- (void)show;

- (void)hide;


@end
