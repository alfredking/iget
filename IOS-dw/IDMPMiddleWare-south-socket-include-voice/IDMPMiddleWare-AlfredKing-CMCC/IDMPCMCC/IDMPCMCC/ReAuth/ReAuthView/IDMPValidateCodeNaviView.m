//
//  IDMPValidateCodeNaviView.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/23.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPValidateCodeNaviView.h"
#import "UIColor+Hex.h"

@interface IDMPValidateCodeNaviView()

@property (nonatomic, strong) UILabel *titleLbl;
@end

@implementation IDMPValidateCodeNaviView

- (void)setNaviTitle:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLbl.text = title;
        [self layoutIfNeeded];
    });
}

- (instancetype)init {
    if (self = [super init]) {
        UILabel *lbl = [UILabel new];
        lbl.text = @"请设置统一认证安全码";
        lbl.textColor = [UIColor colorWithHex:0x1979bc];
        lbl.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:lbl];
        [lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *lblCenterX = [NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *lblTop = [NSLayoutConstraint constraintWithItem:lbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:17];
        [self addConstraints:@[lblTop,lblCenterX]];
        self.titleLbl = lbl;
        
        UIButton *backBtn = [UIButton new];
        UIImage *backImg = [UIImage imageNamed:@"IDMPCMCC.bundle/icon_back"];
        [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        [backBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *btnLeft = [NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
        NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
        [backBtn addConstraints:@[btnWidth,btnHeight]];
        [self addConstraints:@[btnCenterY,btnLeft]];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:0xbfc6ca];
        [self addSubview:line];
        [line setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *lineBottom = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        NSLayoutConstraint *lineLeft = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *lineRight = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *lineHeight = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
        [line addConstraint:lineHeight];
        [self addConstraints:@[lineBottom,lineRight,lineLeft]];
    }
    return self;
}

- (void)close:(UIButton *)sender {
    self.closeBlcok();
}

@end
