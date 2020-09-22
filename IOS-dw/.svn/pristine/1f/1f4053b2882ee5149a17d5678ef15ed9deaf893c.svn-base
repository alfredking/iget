//
//  PhoneSimCardSeparateAlertView.m
//  IDMPCMCC
//
//  Created by wj on 2017/11/30.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "PhoneSimCardSeparateAlertView.h"
#import "UIColor+Hex.h"
#import "FreeFlowButton.h"
#import "IDMPScreen.h"

//static const CGFloat AlertViewHeight = 333;
//static const CGFloat AlertViewWidth = 312;

@interface PhoneSimCardSeparateAlertView()

//控件
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UILabel *messageLbl;
@property (nonatomic, strong)FreeFlowButton *cancelBtn;
@property (nonatomic, strong)FreeFlowButton *confirmBtn;

@property (nullable, nonatomic, strong) UIWindow *window;

@property (nonatomic, copy)voidBlcok confirmBlock;      //confirm block
@property (nonatomic, copy)voidBlcok cancelBlock;       //cancel block

@property (nonatomic, strong)NSDictionary *configureColorDic;   //configure color

@property (nonatomic, assign)CGSize alertSize;    //alert size

@property (nonatomic, assign)CGSize headerViewSize;     //header view height

@property (nonatomic, strong)UIImage *headerImage; //header image
@property (nonatomic, assign)CGSize headerImageSize;     //header image size

@property (nonatomic, strong)NSAttributedString *message; //alert message
@property (nonatomic, assign)CGPoint messagePoint;

@property (nonatomic, assign)CGFloat buttonBottomSpace;     //button bottom to view bottom space
@property (nonatomic, strong)NSString *cancelButtonTitle;
@property (nonatomic, strong)NSString *confirmButtonTitle;

@end

@implementation PhoneSimCardSeparateAlertView

- (instancetype)initWithAlertSize:(CGSize)alertSize headerViewSize:(CGSize)headerViewSize headerImageSize:(CGSize)headerImageSize headerImage:(UIImage *)headerImage messagePoint:(CGPoint)messagePoint message:(NSAttributedString *)message buttonBottomSpace:(CGFloat)buttonBottomSpace cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle confirmHandler:(voidBlcok)confirmHandler cancelHandler:(voidBlcok)cancelHandler{
    if (self = [super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"FreeFlowConfigure" ofType:@"plist"];
        NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.alertSize = alertSize;
        self.headerViewSize = headerViewSize;
        self.headerImage = headerImage;
        self.headerImageSize = headerImageSize;
        self.message = message;
        self.messagePoint = messagePoint;
        self.buttonBottomSpace = buttonBottomSpace;
        self.confirmButtonTitle = confirmButtonTitle;
        self.cancelButtonTitle = cancelButtonTitle;
        self.confirmBlock = confirmHandler;
        self.cancelBlock = cancelHandler;
        
        self.configureColorDic = data;
        [self setup];

    }
    return self;
}

- (UIWindow *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
    
}

- (void)show {
    UIViewController *viewController = [UIViewController new];
    UIWindow *window = [self sharedInstance];
    if ([UIDevice currentDevice].systemVersion.intValue == 9) {
        window.windowLevel = CGFLOAT_MAX;
    } else {
        window.windowLevel = UIWindowLevelAlert;
    }
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    self.window = window;
    
    UIView *shadeView = [UIView new];
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0.5;
    [viewController.view addSubview:shadeView];
    [viewController.view addSubview:self];

    [shadeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *shadeViewTop = [NSLayoutConstraint constraintWithItem:shadeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *shadeViewBottom = [NSLayoutConstraint constraintWithItem:shadeView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *shadeViewLeft = [NSLayoutConstraint constraintWithItem:shadeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *shadeViewRight = [NSLayoutConstraint constraintWithItem:shadeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [viewController.view addConstraints:@[shadeViewTop,shadeViewLeft,shadeViewRight,shadeViewBottom]];
    
    NSLayoutConstraint *alertCenterX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *alertCenterY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [viewController.view addConstraints:@[alertCenterX,alertCenterY]];
    
    [self.window layoutIfNeeded];

    
}

- (void)setup {
    self.layer.cornerRadius = 7;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *alertHeight = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.alertSize.height * IDMPWidthScale];
    NSLayoutConstraint *alertWidth = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.alertSize.width * IDMPWidthScale];
    [self addConstraints:@[alertWidth,alertHeight]];
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.imgView];
    [self addSubview:self.messageLbl];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    
    [self.headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *headerViewHeight = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewSize.height * IDMPWidthScale];
    NSLayoutConstraint *headerViewWidth = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewSize.width * IDMPWidthScale];
    NSLayoutConstraint *headerViewCenterX = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *headerViewTop = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.headerView addConstraints:@[headerViewHeight,headerViewWidth]];
    [self addConstraints:@[headerViewTop,headerViewCenterX]];
        
    [self.imgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *imgHeight = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerViewSize.height * IDMPWidthScale];
    NSLayoutConstraint *imgWidth = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.headerImageSize.width * IDMPWidthScale];
    NSLayoutConstraint *imgCenterX = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *imgCenterY = [NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.imgView addConstraints:@[imgHeight,imgWidth]];
    [self addConstraints:@[imgCenterX,imgCenterY]];
    
    [self.messageLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *lblTop = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.messagePoint.y * IDMPWidthScale];
    NSLayoutConstraint *lblLeft = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant: self.messagePoint.x * IDMPWidthScale];
    NSLayoutConstraint *lblCenterX = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *lblBottom = [NSLayoutConstraint constraintWithItem:self.messageLbl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cancelBtn attribute:NSLayoutAttributeTop multiplier:1.0 constant:-10 * IDMPWidthScale];
    [self addConstraints:@[lblTop,lblLeft,lblCenterX,lblBottom]];
    
    [self.cancelBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *cancelBtnHeight = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:38 * IDMPWidthScale];
    NSLayoutConstraint *cancelBtnLeft = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:40 * IDMPWidthScale];
    NSLayoutConstraint *cancelBtnBottom = [NSLayoutConstraint constraintWithItem:self.cancelBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.buttonBottomSpace * IDMPWidthScale];
    
    [self.confirmBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *confirmBtnHeight = [NSLayoutConstraint constraintWithItem:self.confirmBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:38 * IDMPWidthScale];
    NSLayoutConstraint *confirmBtnBottom = [NSLayoutConstraint constraintWithItem:self.confirmBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.buttonBottomSpace * IDMPWidthScale];
    NSLayoutConstraint *confirmBtnRight = [NSLayoutConstraint constraintWithItem:self.confirmBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40 * IDMPWidthScale];
    NSLayoutConstraint *sameBtnWidth = [NSLayoutConstraint constraintWithItem:self.confirmBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.cancelBtn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *confirmBtnLeft = [NSLayoutConstraint constraintWithItem:self.confirmBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cancelBtn attribute:NSLayoutAttributeRight multiplier:1.0 constant:17 * IDMPWidthScale];
    
    [self.cancelBtn addConstraint:cancelBtnHeight];
    [self.confirmBtn addConstraint:confirmBtnHeight];
    
    [self addConstraints:@[cancelBtnLeft,cancelBtnBottom,confirmBtnBottom,
                           confirmBtnRight,sameBtnWidth,confirmBtnLeft]];
}

- (void)tapConfirmBtn:(FreeFlowButton *)sender {
    [self close];
    self.confirmBlock();
}

- (void)tapCancelBtn:(FreeFlowButton *)sender {
    [self close];
    self.cancelBlock();
}

- (void)close {
    [self removeFromSuperview];
    self.window.rootViewController = nil;
    self.window.hidden = YES;
    self.window = nil;
}

#pragma mark - lazy load
- (UIView *)headerView {
    if (!_headerView) {
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor idmp_colorWithHexString:self.configureColorDic[@"unsubscribeWarnHeaderViewBgColor"]];
        _headerView = headerView;
    }
    return _headerView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *imgView = [UIImageView new];
        imgView.image = self.headerImage;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView = imgView;
    }
    return _imgView;
}

- (UILabel *)messageLbl {
    if (!_messageLbl) {
        UILabel *messageLbl = [UILabel new];
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.font = [UIFont systemFontOfSize:14.0 * IDMPWidthScale];
        messageLbl.textColor = [UIColor idmp_colorWithHexString:self.configureColorDic[@"phoneSimSepMsgColor1"]];
        messageLbl.textAlignment = NSTextAlignmentLeft;
        messageLbl.attributedText = self.message;
        messageLbl.lineBreakMode = NSLineBreakByWordWrapping;
        messageLbl.numberOfLines = 0;
        messageLbl.preferredMaxLayoutWidth = 50;
        _messageLbl = messageLbl;
    }
    return _messageLbl;
}

- (FreeFlowButton *)confirmBtn {
    if (!_confirmBtn) {
        FreeFlowButton *btn = [FreeFlowButton new];
        [btn setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor idmp_colorWithHexString:self.configureColorDic[@"phoneSimSepRightBtnTitleColor"]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 * IDMPWidthScale];
        [btn setBackgroundColor:[UIColor idmp_colorWithHexString:self.configureColorDic[@"phoneSimSepRightBtnBgColor"]]];
        [btn.layer setCornerRadius:4.0 * IDMPWidthScale];
        btn.layer.masksToBounds = YES;
        [btn.layer setBorderColor:[UIColor idmp_colorWithHexString:self.configureColorDic[@"phoneSimSepBtnBorderColor"]].CGColor];
        [btn.layer setBorderWidth:1.0];
        [btn addTarget:self action:@selector(tapConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.highlighted = NO;
        _confirmBtn = btn;
    }
    return _confirmBtn;
}

- (FreeFlowButton *)cancelBtn {
    if (!_confirmBtn) {
        FreeFlowButton *btn = [[FreeFlowButton alloc] initWithBgStartColor:self.configureColorDic[@"phoneSimSepLeftBtnBgStartColor"] bgEndColor:self.configureColorDic[@"phoneSimSepLeftBtnBgEndColor"]];
        [btn setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor idmp_colorWithHexString:self.configureColorDic[@"phoneSimSepLeftBtnTitleColor"]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 * IDMPWidthScale];
        [btn.layer setCornerRadius:4.0 * IDMPWidthScale];
        btn.layer.masksToBounds = YES;
        [btn.layer setBorderColor:[UIColor idmp_colorWithHexString:self.configureColorDic[@"phoneSimSepBtnBorderColor"]].CGColor];
        [btn.layer setBorderWidth:1.0];
        [btn addTarget:self action:@selector(tapCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.highlighted = YES;
        _cancelBtn = btn;
    }
    return _cancelBtn;
}


@end
