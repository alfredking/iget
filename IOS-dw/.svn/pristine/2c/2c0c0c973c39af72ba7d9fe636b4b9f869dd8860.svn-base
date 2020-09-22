//
//  IDMPPopTool.m
//  IDMPCMCC
//
//  Created by wj on 2017/7/19.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPPopTool.h"
#import "IDMPPopViewController.h"

@interface IDMPPopTool()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) IDMPPopViewController *popViewController;
@property (nonatomic, strong) UIViewController *presentViewController;

@end

@implementation IDMPPopTool

+ (IDMPPopTool *)sharedInstance {
    static IDMPPopTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [IDMPPopTool new];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.tapOutsideToDismiss = YES;
    }
    return self;
}

- (void)showWithPresentViewController:(UIViewController *)presentViewController completion:(completeBlock)completion animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.window.opaque = NO;
        
        self.popViewController = [[IDMPPopViewController alloc] initWithViewController:presentViewController];
        self.window.rootViewController = self.popViewController;
        __weak __typeof__(self) weakSelf = self;
        weakSelf.popViewController.closeBlcok = ^(NSDictionary *parameters){
            __strong __typeof__(self) strongSelf = weakSelf;
            [strongSelf.popViewController.view endEditing:YES];
            [strongSelf closeAnimated:animated];
            completion(parameters);
        };

        [self showAnimated:animated];
        
    });
}

- (void)showAnimated:(BOOL)animated {
    [self.window makeKeyAndVisible];
    if (!animated) {
        return;
    }
    self.popViewController.shadeView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.popViewController.shadeView.alpha = 1;
    }];
    self.popViewController.containerView.alpha = 0;
    self.popViewController.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    [UIView animateWithDuration:0.3 animations:^{
        self.popViewController.containerView.alpha = 1;
        self.popViewController.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.popViewController.containerView.alpha = 1;
            self.popViewController.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        }];
    }];
}

- (void)closeAnimated:(BOOL)animated{
    if (!animated) {
        [self cleanup];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.popViewController.shadeView.alpha = 0;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.popViewController.view.alpha = 1;
            self.popViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.popViewController.view.alpha = 0;
                self.popViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
            } completion:^(BOOL finished) {
                [self cleanup];
            }];
        }];
        
    });
}

- (void)cleanup {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.popViewController.containerView removeFromSuperview];
        self.popViewController.containerView = nil;
        [self.popViewController.shadeView removeFromSuperview];
        self.popViewController.shadeView = nil;
        [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
        [self.window removeFromSuperview];
        self.presentViewController = nil;
        self.popViewController = nil;
        self.window.rootViewController = nil;
        self.window = nil;
    });
}

- (void)dealloc {
    NSLog(@"dealloc idmppoptool");
    [self cleanup];
}

@end
