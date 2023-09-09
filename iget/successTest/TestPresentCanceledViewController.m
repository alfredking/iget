//
//  TestPresentCanceledViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2022/5/3.
//  Copyright © 2022 alfredking. All rights reserved.
//

#import "TestPresentCanceledViewController.h"

@interface TestPresentCanceledViewController ()

@property (nonatomic,strong)UIViewController *VCA;
@property (nonatomic,strong)UIViewController *VCB;

@end

@implementation TestPresentCanceledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
    
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.VCA];
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController :nav animated:YES completion:^{
//        UINavigationController *navb = [[UINavigationController alloc]initWithRootViewController:self.VCB];
//        navb.modalPresentationStyle = UIModalPresentationFullScreen;
//        [nav presentViewController: navb animated:YES completion:nil];
//    } ];
    UIViewController *currentVC = [self findCurrentShowingViewController];
    NSLog(@"currentVC is %@",currentVC);
    [self presentViewController:self.VCA animated:NO completion:nil];
    currentVC = [self findCurrentShowingViewController];
    NSLog(@"currentVC is %@",currentVC);
    [self presentViewController:self.VCB animated:NO completion:nil];
    
    
    
//    [self.navigationController pushViewController:_VCA animated:YES];
}

-(UIViewController *)VCA
{
    if (!_VCA) {
        _VCA = [[UIViewController alloc]init];
        _VCA.view.frame = self.view.frame;
        _VCA.view.backgroundColor = [UIColor yellowColor];
        _VCA.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return  _VCA;
}

-(UIViewController *)VCB
{
    if (!_VCB) {
        _VCB = [[UIViewController alloc]init];
        _VCB.view.frame = self.view.frame;
        _VCB.view.backgroundColor = [UIColor blueColor];
        _VCB.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return  _VCB;
}

- (UIViewController *)findCurrentShowingViewController
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}


- (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    UIViewController *currentShowingVC;
    if ([vc presentedViewController])
    {
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]])
    {
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]])
    {
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    }
    else
    {
        currentShowingVC = vc;
    }
    return currentShowingVC;
}


-(nullable UIViewController *)findBelongViewControllerForView:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
