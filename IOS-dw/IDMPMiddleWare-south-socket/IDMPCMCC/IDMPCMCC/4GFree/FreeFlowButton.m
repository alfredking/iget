//
//  FreeFlowButton.m
//  IDMPCMCC
//
//  Created by wj on 2017/12/2.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "FreeFlowButton.h"
#import "UIColor+Hex.h"

@interface FreeFlowButton()

@property (nonatomic, strong)CAGradientLayer *gradientLayer;
@property (nonatomic, strong)NSString *bgStartColor;
@property (nonatomic, strong)NSString *bgEndColor;


@end

@implementation FreeFlowButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithBgStartColor:(NSString *)bgStartColor bgEndColor:(NSString *)bgEndColor {
    if (self = [super init]) {
        self.bgStartColor = bgStartColor;
        self.bgEndColor = bgEndColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.gradientLayer = [CAGradientLayer new];
    self.gradientLayer.colors=@[(__bridge id)[UIColor idmp_colorWithHexString:self.bgStartColor].CGColor,(__bridge id)[UIColor idmp_colorWithHexString:self.bgEndColor].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.frame = self.bounds;
    if (self.highlighted) {
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
}


@end
