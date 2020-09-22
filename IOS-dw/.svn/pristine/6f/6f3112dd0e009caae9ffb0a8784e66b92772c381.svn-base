//
//  IDMPPopViewController.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPPopViewController.h"
#import "IDMPScreen.h"
#import "IDMPReAuthViewController.h"
#import "IDMPReAuthForgetPwdViewController.h"


@interface IDMPPopViewController ()

@property (nonatomic, strong)UIViewController *popVC;

@end

@implementation IDMPPopViewController

#pragma mark - life cycle
- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.popVC = viewController;
        if ([viewController isKindOfClass:[IDMPReAuthViewController class]]) {
            IDMPReAuthViewController *reAuthVC = (IDMPReAuthViewController *)viewController;
            __weak __typeof__(self) weakSelf = self;
            reAuthVC.returnBlcok = ^(NSDictionary *parameters) {
                __strong __typeof__(self) strongSelf = weakSelf;
                if ([parameters[@"result"] isEqualToString:@"forgetPwd"]) {
                    IDMPReAuthForgetPwdViewController *forgetPwdVC = [IDMPReAuthForgetPwdViewController new];
                    [strongSelf pushViewController:forgetPwdVC animated:YES];
                } else {
                    strongSelf.closeBlcok(parameters);
                }
            };
        }
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.shadeView.frame = self.view.bounds;
    [self.view addSubview:self.shadeView];
    [self.containerView addSubview:self.popVC.view];
    [self.view addSubview:self.containerView];
    __weak __typeof__(self) weakSelf = self;
    weakSelf.shadeView.closeBlcok = ^{
        __strong __typeof__(self) strongSelf = weakSelf;
        strongSelf.closeBlcok(nil);
    };
}

- (void)dealloc {
    NSLog(@"dealloc %@",self);
}

#pragma mark - push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.containerView addSubview:viewController.view];
}

#pragma mark - lazy load
- (IDMPShadeView *)shadeView {
    if (!_shadeView) {
        IDMPShadeView *shadeView = [[IDMPShadeView alloc] init];
        shadeView.opaque = NO;
        shadeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _shadeView = shadeView;
        
    }
    return _shadeView;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 483 * IDMPWidthScale, [UIScreen mainScreen].bounds.size.width, 483 * IDMPWidthScale)];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        _containerView = containerView;
    }
    return _containerView;
}



@end
