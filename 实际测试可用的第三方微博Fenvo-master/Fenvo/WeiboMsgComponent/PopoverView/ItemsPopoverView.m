//
//  ItemsPopoverView.m
//  PopoverView
//
//  Created by Neil on 15/9/12.
//  Copyright © 2015年 Caesar. All rights reserved.
//

#import "ItemsPopoverView.h"

@interface ItemsPopoverView()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _popoverWidth;
    CGSize _popoverArrowSize;
    CGFloat _popoverCornerRadius;
}
@end

@implementation ItemsPopoverView
@synthesize maskType     = _maskType;
@synthesize arrowSize    = _arrowSize;
@synthesize arrowColor   = _arrowColor;
@synthesize cornerRadius = _cornerRadius;

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id /*<ItemsPopoverViewDelegate>*/)delegate
                containerView:(UIView *)containerView
                        size:(CGSize)size
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    
    if (self)
    {
        self.delegate       = self;
        self.dataSource     = self;
        self.frame          = CGRectMake(0, 0, size.width, size.height);
        self.itemHeight     = 50;
        self.backgroundColor = [UIColor blackColor];
        self.popoverWidth   = size.width;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        
        if (!delegate)
            return nil;
        else
            self.itemsDelegate = delegate;
        
        if (!containerView)
            return nil;
        else
            self.containerView = containerView;
        
        if (!title && ![title isEqualToString:@""])
            self.title = title;
        
        if (otherButtonTitles)
        {
            self.items  = [[NSMutableArray alloc]init];
            [self.items addObject:otherButtonTitles];
            
            NSString *title;
            va_list parameters;
            va_start(parameters, otherButtonTitles);
            while ((title = va_arg(parameters, NSString *)))
            {
                [self.items addObject:title];
            }
            va_end(parameters);
        }
        
        [self resetPopover];
        [self resetFrame];
    }
    
    return self;
}

- (void)resetPopover
{
    self.popover = [DXPopover new];
    self.popover.maskType = DXPopoverMaskTypeNone;
    self.popover.cornerRadius = 0.0f;
    self.popover.animationSpring = NO;
}

#pragma mark - TableView Delegate And DataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Show
- (void)showPopoverView
{
    CGPoint startPoint;
    
    DXPopoverPosition popoverDirection;
    
    if ([self.containerView convertRect:self.containerView.bounds toView:nil].origin.y + self.containerView.frame.size.height > IPHONE_SCREEN_HIGHT / 3 * 2) {
        popoverDirection = DXPopoverPositionUp;
        startPoint = CGPointMake(CGRectGetMidX(self.containerView.frame), CGRectGetMinY(self.containerView.frame) - 20);
        
        self.popover.contentColor = self.backgroundColor;

    }else {
        popoverDirection = DXPopoverPositionDown;
        startPoint = CGPointMake(CGRectGetMidX(self.containerView.frame), CGRectGetMaxY(self.containerView.frame) + 20);
        self.popover.contentColor = self.backgroundColor;
    }
    
    CGRect rect = [self.containerView convertRect:self.containerView.bounds toView:nil];
    if (CGRectGetMaxX(rect) < 45) {
        startPoint = CGPointMake(startPoint.x + 10, startPoint.y);
    }else if(CGRectGetMaxX(rect) > IPHONE_SCREEN_WIDTH - 45) {
        startPoint = CGPointMake(startPoint.x - 10, startPoint.y);
    }
    
    [self.popover showAtPoint:startPoint
               popoverPostion:popoverDirection
              withContentView:self
                       inView:[self viewController:self.containerView].view];
    
    __weak typeof(self)weakSelf     = self;
    self.popover.didDismissHandler  = ^{
        [weakSelf bounceTargetView:weakSelf.containerView];
    };
}

- (void)bounceTargetView:(UIView *)targetView
{
    [UIView animateWithDuration:0.1 animations:^{
        targetView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            targetView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                targetView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

#pragma mark - ItemPopoverDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    [self deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.itemsDelegate && [self.itemsDelegate respondsToSelector:@selector(popoverView:clickedItemAtIndex:)]) {
        [self.itemsDelegate popoverView:self clickedItemAtIndex:index];
    }
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return self.itemHeight;
}

#pragma mark - Setter or Getter
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius               = cornerRadius;
    self.popover.cornerRadius   = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return _cornerRadius;
}

- (void)setMainColor:(UIColor *)mainColor
{
    _mainColor = mainColor;
    self.backgroundColor = mainColor;
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    [self resetFrame];
}

- (void)resetFrame
{
    self.frame = CGRectMake(0, 0, self.frame.size.width, _itemHeight * _items.count - 2);
}

#pragma mark - Others
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
