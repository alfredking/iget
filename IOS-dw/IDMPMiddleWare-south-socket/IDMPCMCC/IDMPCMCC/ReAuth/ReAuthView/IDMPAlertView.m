//
//  IDMPAlertView.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/23.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPAlertView.h"
#import "UIColor+Hex.h"

@interface IDMPAlertView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) UIImageView *tintImgView;
@property (nonatomic, strong) NSLayoutConstraint *lblWidth;
@property (nonatomic, strong) NSLayoutConstraint *imgLeft;
@property (nonatomic, strong) NSLayoutConstraint *lblRight;
@property (nonatomic, strong) NSLayoutConstraint *width;
@property (nonatomic, assign) CGFloat alertWidth;
@end

@implementation IDMPAlertView

- (void)setMessage:(NSString *)message alertType:(IDMPPopupAlertType)alertType {
    [self setMessage:message alertType:alertType alertWidth:([UIScreen mainScreen].bounds.size.width - 24)];
}

- (void)setMessage:(NSString *)message alertType:(IDMPPopupAlertType)alertType alertWidth:(IDMPAlertWidthType)alertWidth {
    self.tintImgView.image = [self imageWithAlertType:alertType];
    self.messageLbl.text = message;
    self.alertWidth = alertWidth;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateConstraintsWithContainerView:self.containerView andMessage:message];
    });
    
}

- (instancetype)initWithMessage:(NSString *)message alertType:(IDMPPopupAlertType)alertType{
    if (self = [super init]) {
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        
        NSLayoutConstraint *alertHeight = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:IDMPAlertHeight];
        [self addConstraint:alertHeight];
        
        [self addSubview:self.containerView];
        self.messageLbl.text = message;
        [self.containerView addSubview:self.messageLbl];
        self.tintImgView.image = [self imageWithAlertType:alertType];
        [self.containerView addSubview:self.tintImgView];
        
        
        //constraint
        [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *ctCenterX = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSLayoutConstraint *ctCenterY = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *ctLeft = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *ctTop = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraints:@[ctCenterX,ctCenterY,ctLeft,ctTop]];
        
        [self.tintImgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *imgWidth = [NSLayoutConstraint constraintWithItem:self.tintImgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:17];
        NSLayoutConstraint *imgHeight = [NSLayoutConstraint constraintWithItem:self.tintImgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:17];
        [self.tintImgView addConstraints:@[imgWidth,imgHeight]];
        
        [self.messageLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *imgCenterY = [NSLayoutConstraint constraintWithItem:self.tintImgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *lblCenterY = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.containerView addConstraints:@[imgCenterY,lblCenterY]];
        
        NSLayoutConstraint *lblHeight = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];
        [self.messageLbl addConstraint:lblHeight];
        
        [self updateConstraintsWithContainerView:self.containerView andMessage:message];
        
    }
    return self;
}

- (void)updateConstraintsWithContainerView:(UIView *)containerView andMessage:(NSString *)message{
    //remove old contraints
    if (self.width) {
        [self removeConstraint:self.width];
        self.width = nil;
    }
    
    if (self.lblWidth) {
        [self.messageLbl removeConstraint:self.lblWidth];
        self.lblWidth = nil;
    }
    
    if (self.imgLeft) {
        [containerView removeConstraint:self.imgLeft];
        self.imgLeft = nil;
    }
    
    if (self.lblRight) {
        [containerView removeConstraint:self.lblRight];
        self.lblRight = nil;
    }
    
    
    //add new contraints
    self.width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.alertWidth];
    [self addConstraint:self.width];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize messageSize = [message sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
#pragma clang diagonostic pop
    CGFloat messageWidth = messageSize.width;
    self.lblWidth = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:messageWidth+1];
    [self.messageLbl addConstraint:self.lblWidth];
    
    CGFloat padding =  (CGFloat)(self.alertWidth - (messageWidth + 17 + 8)) / 2.0;
    self.imgLeft = [NSLayoutConstraint constraintWithItem:self.tintImgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
    self.lblRight = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
    [containerView addConstraints:@[self.imgLeft,self.lblRight]];
}

- (UIImage *)imageWithAlertType:(IDMPPopupAlertType)alertType {
    UIImage *image;
    switch (alertType) {
        case IDMPPopupAlertWarn:
            image = [UIImage imageNamed:@"IDMPCMCC.bundle/icon_warn"];
            break;
        case IDMPPopupAlertError:
            image = [UIImage imageNamed:@"IDMPCMCC.bundle/icon_error"];
            break;
        case IDMPPopupAlertSuccess:
            image = [UIImage imageNamed:@"IDMPCMCC.bundle/icon_correct"];
            break;
        default:
            break;
    }
    return image;
}

#pragma mark - lazy load
- (UIView *)containerView {
    if (!_containerView) {
        UIView *containerView = [UIView new];
        containerView.backgroundColor = [UIColor idmp_colorWithHex:0x343434];
        _containerView = containerView;
    }
    return _containerView;
}

- (UILabel *)messageLbl {
    if (!_messageLbl) {
        UILabel *messageLbl = [UILabel new];
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.font = [UIFont systemFontOfSize:16.0];
        messageLbl.textColor = [UIColor whiteColor];
        _messageLbl = messageLbl;
    }
    return _messageLbl;
}

- (UIImageView *)tintImgView {
    if (!_tintImgView) {
        UIImageView *tintImgView = [UIImageView new];
        _tintImgView = tintImgView;
    }
    return _tintImgView;
}




@end
