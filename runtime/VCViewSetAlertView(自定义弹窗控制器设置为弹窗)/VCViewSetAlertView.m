//
//  VCViewSetAlertView.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "VCViewSetAlertView.h"
#import "LGAlertView.h"
#import "alertviewViewController.h"

#import "YFGIFImageView.h"

@interface VCViewSetAlertView ()<LGAlertViewDelegate>
@property(nonatomic,strong)alertviewViewController *alertVC;
@end

@implementation VCViewSetAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, STATUS_NAV_HEIGHT, 80, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"弹窗" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (alertviewViewController *)alertVC{
    if (!_alertVC) {
        _alertVC = [alertviewViewController new];
        _alertVC.view.frame = CGRectMake(0, 0, 200, 200);
    }
    return _alertVC;
}

- (void)btnAction{
    [[[LGAlertView alloc] initWithViewAndTitle:@"Autolayouts" message:@"You need to set width and height constraints" style:LGAlertViewStyleAlert view:self.alertVC.view buttonTitles:@[@"Done"] cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil delegate:self] showAnimated:YES completionHandler:nil];
    
    
//    NSLog(@"~~~~~~点击蓝牙~~~~~");
//    EGmyAlertView *alertView = [EGmyAlertView new];
//    [self.view addSubview:alertView];
//    alertView.frame = [UIScreen mainScreen].bounds;
//    imagePickerViewController *contentView = [imagePickerViewController new];
//    alertView.contentView = contentView;
//    [alertView show];
//
//    [self gifPlay2];
}

#pragma mark - LGAlertViewDelegate

- (void)alertView:(LGAlertView *)alertView clickedButtonAtIndex:(NSUInteger)index title:(nullable NSString *)title {
    NSLog(@"action {title: %@, index: %lu}", title, (long unsigned)index);
}

- (void)alertViewCancelled:(LGAlertView *)alertView {
    NSLog(@"cancel");
}

- (void)alertViewDestructed:(LGAlertView *)alertView {
    NSLog(@"destructive");
}

-(void)gifPlay2  {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    [self.view addSubview:view];
    [view bringSubviewToFront:self.view];
    
    NSString  *gifPath=[[NSBundle mainBundle] pathForResource:@"22" ofType:@"gif"];
    YFGIFImageView  *gifview=[[YFGIFImageView alloc]init];
    gifview.backgroundColor=[UIColor clearColor];
    gifview.gifPath=gifPath;
    gifview.frame=view.frame;
    [view addSubview:gifview];
    [gifview startGIF];
}
@end
