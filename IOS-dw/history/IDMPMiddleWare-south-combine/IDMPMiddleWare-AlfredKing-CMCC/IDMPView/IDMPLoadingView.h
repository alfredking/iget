//
//  IDMPLoadingView.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by zwk on 14/11/12.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDMPLoadingView : UIView

@property (nonatomic,strong) UIActivityIndicatorView *testActivityIndicator;

- (instancetype)init;

- (void)showInView:(UIView *)superV;

- (void)dismissView;

@end
