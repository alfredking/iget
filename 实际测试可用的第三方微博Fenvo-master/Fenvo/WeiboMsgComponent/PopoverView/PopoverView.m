//
//  PopoverView.m
//  PopoverView
//
//  Created by 我的宝宝 on 15/8/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "PopoverView.h"

#define IPHONE_SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define IPHONE_SCREEN_HIGHT     [[UIScreen mainScreen] bounds].size.height
#define IS_IPAD                 ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define LABEL_VERTICAL_SPACING      10.0f
#define LABEL_HORIZONTAL_SPACING    10.0f
#define BUTTON_HEIGHT           (IS_IPAD ? 50 : 40)
#define LABEL_HEIGHT            (IS_IPAD ? 65 : 55)

@implementation PopoverView
@synthesize maskType     = _maskType;
@synthesize arrowSize    = _arrowSize;
@synthesize arrowColor   = _arrowColor;
@synthesize cornerRadius = _cornerRadius;
#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message
                       delegate:(id)delegate
                  containerView:(UIView *)containerView
              otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    
    if (self)
    {
        if (!delegate) return nil;
        
        if (!containerView) return nil;
        
        if (otherButtonTitles)
        {
            self.buttonArray  = [[NSMutableArray alloc]init];
            UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
            [self initButtonStyle:button title:otherButtonTitles];
            [self.buttonArray addObject:button];
            
            NSString *title;
            va_list parameters;
            va_start(parameters, otherButtonTitles);
            while ((title = va_arg(parameters, NSString *)))
            {
                UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
                [self initButtonStyle:button title:title];
                [self.buttonArray addObject:button];
            }
            va_end(parameters);
        }
        
        [self initSubviews];
        
        if (message)
        {
            self.delegate       = delegate;
            self.containerView  = containerView;
            [self setMessage:message];
        }
        else
        {
            self.delegate       = delegate;
            self.containerView  = containerView;
            [self setMessage:@""];
        }
        
        [self resetPopover];
    }
    return self;
}

- (void)initSubviews
{
    //self.backgroundColor             = [UIColor orangeColor];
    self.remindLabel                 = [[UILabel alloc]init];
    self.remindLabel.font            = [UIFont systemFontOfSize:17.0];
    self.remindLabel.textColor       = [UIColor darkGrayColor];
    self.remindLabel.backgroundColor = [UIColor whiteColor];
    self.remindLabel.numberOfLines   = 0;
    
    [self addSubview:self.remindLabel];
    
    for (NSInteger i = 0; i < self.buttonArray.count; i ++)
    {
        UIButton *button = self.buttonArray[i];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

- (void)initButtonStyle:(UIButton *)button title:(NSString *)title
{
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)resetPopover
{
    self.popover = [DXPopover new];
    self.popover.maskType = DXPopoverMaskTypeBlack;
    self.isAnimation = YES;
}

#pragma mark - Show

- (void)show
{
    [self showPopoverView];
}

- (void)showPopoverView
{
    CGPoint startPoint;
    
    DXPopoverPosition popoverDirection;
    
    UIView *rootView = [self viewController:self.containerView].view;
    CGRect rectSelf = [self.containerView convertRect:self.containerView.bounds toView:rootView];
    
    if ([self.containerView convertRect:self.containerView.bounds toView:nil].origin.y + self.containerView.frame.size.height > IPHONE_SCREEN_HIGHT / 3 * 2) {
        popoverDirection = DXPopoverPositionUp;
        startPoint = CGPointMake(CGRectGetMidX(self.containerView.frame), rectSelf.origin.y - 5);
        if (!self.buttonArray && self.buttonArray.count <= 0) {
            self.popover.contentColor = self.remindLabel.backgroundColor;
        }else {
            self.popover.contentColor = ((UIButton *)self.buttonArray[0]).backgroundColor;
        }
    }else {
        popoverDirection = DXPopoverPositionDown;
        startPoint = CGPointMake(CGRectGetMidX(self.containerView.frame), rectSelf.origin.y + rectSelf.size.height + 5);
        self.popover.contentColor = self.remindLabel.backgroundColor;
    }
    
//
//    if (CGRectGetMaxX(rectSelf) < 45) {
//        startPoint = CGPointMake(startPoint.x + 10, startPoint.y);
//    }else if(CGRectGetMaxX(rectSelf) > IPHONE_SCREEN_WIDTH - 45) {
//        startPoint = CGPointMake(startPoint.x - 10, startPoint.y);
//    }
    
    [self.popover showAtPoint:startPoint
               popoverPostion:popoverDirection
              withContentView:self
                       inView:[self viewController:self.containerView].view];
    
    __weak typeof(self)weakSelf     = self;
    self.popover.didDismissHandler  = ^{
        if (weakSelf.isAnimation)
            [weakSelf bounceTargetView:weakSelf.containerView];
    };
}

- (void)showWithContainerView:(UIView *)containerView
{
    CGPoint startPoint;
    
    DXPopoverPosition popoverDirection;
    
    if ([containerView convertRect:containerView.bounds toView:nil].origin.y + containerView.frame.size.height > IPHONE_SCREEN_HIGHT / 3 * 2) {
        popoverDirection = DXPopoverPositionUp;
        startPoint = CGPointMake(CGRectGetMidX(containerView.frame), CGRectGetMinY(containerView.frame) - 5);
    }else {
        popoverDirection = DXPopoverPositionDown;
        startPoint = CGPointMake(CGRectGetMidX(containerView.frame), CGRectGetMaxY(containerView.frame) + 5);
    }
    
    self.popover.contentColor = _arrowColor;

    [self.popover showAtPoint:startPoint
               popoverPostion:popoverDirection
              withContentView:self
                       inView:containerView.superview];

    __weak typeof(self)weakSelf     = self;
    self.popover.didDismissHandler  = ^{
        if (weakSelf.isAnimation)
            [weakSelf bounceTargetView:containerView];
    };
}

#pragma mark - Animation

- (void)bounceTargetView:(UIView *)target
{
    [UIView animateWithDuration:0.1 animations:^{
        target.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            target.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                target.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

#pragma mark - Property Setter Or Getter

- (void)setMessage:(NSString *)message
{
    NSMutableParagraphStyle *style;
    
    style                     = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = LABEL_HORIZONTAL_SPACING;
    style.headIndent          = LABEL_HORIZONTAL_SPACING;
    style.tailIndent          = -LABEL_HORIZONTAL_SPACING;
    NSMutableAttributedString *mutableMessage = [[NSMutableAttributedString alloc]initWithString:message];
    [mutableMessage addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, message.length)];
    
    _remindLabel.attributedText = mutableMessage;
    
    _message = message;
}

- (void)setMainColor:(UIColor *)mainColor
{
    for (NSInteger i = 0; i < self.buttonArray.count; i ++)
    {
        UIButton *button = self.buttonArray[i];
        [button setTitleColor:mainColor forState:UIControlStateNormal];
    }
    self.remindLabel.backgroundColor = mainColor;
    self.backgroundColor = mainColor;
    
    
}

- (void)setPopoverWidth:(CGFloat)popoverWidth
{
    CGFloat width = popoverWidth;
    
    CGSize textSize;
    if ([_message isEqualToString:@""])
        textSize             = CGSizeMake(width, LABEL_HEIGHT);
    else
        textSize             = [_message
                                boundingRectWithSize:CGSizeMake(width - 2 * LABEL_HORIZONTAL_SPACING, MAXFLOAT)
                                options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]}
                                context:nil].size;
    
    self.remindLabel.adjustsFontSizeToFitWidth = NO;
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    
    self.remindLabel.frame = (textSize.height >= LABEL_HEIGHT) ? CGRectMake(0, 0, width, textSize.height) : CGRectMake(0, 0, width, LABEL_HEIGHT);
    
    
    if (self.buttonArray && self.buttonArray.count > 0)
    {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(self.remindLabel.frame) - 0.5f, width, 1);
        layer.borderWidth = 1;
        layer.borderColor = [UIColor grayColor].CGColor;
        [self.layer addSublayer:layer];
    };
    
    CGFloat messageY        = CGRectGetMaxY(self.remindLabel.frame);
    
    CGFloat buttonWidth     = width / self.buttonArray.count;
    
    for (NSInteger i = 0; i < self.buttonArray.count; i ++)
    {
        UIButton *button    = self.buttonArray[i];
        button.frame        = CGRectMake(i * buttonWidth, messageY, buttonWidth, BUTTON_HEIGHT);
        if (i < self.buttonArray.count - 1)
        {
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(CGRectGetMaxX(button.frame) + 0.5, messageY + 3, 1, BUTTON_HEIGHT - 6);
            layer.borderWidth = 1;
            layer.borderColor = [UIColor grayColor].CGColor;
            [self.layer addSublayer:layer];
        }
    }
    
    if (self.buttonArray && self.buttonArray.count > 0) {
        [self setFrame: CGRectMake(0,
                                   0,
                                   width,
                                   CGRectGetMaxY(((UIButton *)self.buttonArray[0]).frame))];
    }
    else {
        [self setFrame: CGRectMake(0,
                                   0,
                                   width,
                                   CGRectGetMaxY(self.remindLabel.frame))];
    }
    
}

- (void)setArrowColor:(UIColor *)arrowColor
{
    _arrowColor                 = arrowColor;
    self.popover.contentColor   = arrowColor;
}

- (void)setMaskType:(DXPopoverMaskType)maskType
{
    _maskType               = maskType;
    self.popover.maskType   = maskType;
}

- (DXPopoverMaskType)maskType
{
    return _maskType;
}

- (void)setArrowSize:(CGSize)arrowSize
{
    _arrowSize              = arrowSize;
    self.popover.arrowSize  = arrowSize;
}

- (CGSize)arrowSize
{
    return _arrowSize;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius               = cornerRadius;
    self.popover.cornerRadius   = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return _cornerRadius;
}


#pragma mark - Delegate

- (void)clickButton:(id)sender
{
    
    NSInteger index = 0;
    for (UIButton *btn in self.buttonArray) {
        if (btn == sender) index = [self.buttonArray indexOfObject:btn];
    }
    NSLog(@"I was touched. %ld",index);
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverView:clickedButtonAtIndex:)]) {
        [self.delegate popoverView:self clickedButtonAtIndex:index];
    }
}

- (UIViewController*)viewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
