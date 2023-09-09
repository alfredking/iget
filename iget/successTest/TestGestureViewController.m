//
//  TestGestureViewController.m
//  iget
//
//  Created by alfredking－cmcc on 2021/12/22.
//  Copyright © 2021 alfredking. All rights reserved.
//

#import "TestGestureViewController.h"

@interface TestGestureViewController ()
@property(nonatomic,strong) UIView *currentView;
@property(nonatomic,strong) UIButton *button;
@end

@implementation TestGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];
    [self.view addSubview:self.currentView];
    [self.view addSubview:self.button];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
//    NSLog(@"touchesBegan touch is %@",touches);
//    NSLog(@"touchesBegan event is %@",event );
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    UIView *result = [self.view hitTest:point withEvent: event];
    if ( !self.currentView.hidden) {
        self.currentView.hidden = YES;
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
        NSLog(@"test");
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
//    NSLog(@"touchesEnded touch is %@",touches);
//    NSLog(@"touchesEnded event is %@",event );
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
//    NSLog(@"touchesMoved touch is %@",touches);
//    NSLog(@"touchesMoved event is %@",event );
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
//    NSLog(@"touchesCancelled touch is %@",touches);
//    NSLog(@"touchesCancelled event is %@",event );
}

-(void)longPress:(UIGestureRecognizer *)longPress
{
    self.currentView.hidden = NO;
    CGPoint pointTouch = [longPress locationInView:self.view];
    [self.currentView setFrame:CGRectMake(pointTouch.x, pointTouch.y, 50, 50)] ;
    
    
}

-(void)buttonClicked:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"测试" message:@"测试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

-(UIView *)currentView
{
    if (!_currentView) {
        _currentView = [[UIView alloc]init];
        _currentView.backgroundColor = [UIColor yellowColor];
    }
    return _currentView;
}

-(UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 50, 50)];
        _button.backgroundColor = [UIColor greenColor];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"point is %@",NSStringFromCGPoint(point));
    return nil;
}

@end


