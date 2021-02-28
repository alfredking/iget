//
//  LoadingViewVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/22.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "LoadingViewVC.h"

@interface LoadingViewVC ()
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@property(nonatomic,strong)CAShapeLayer *shapeLayerTwo;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)CGFloat timeD;
@property(nonatomic,strong)UIView *loadingView;
@end

@implementation LoadingViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(200, 300, 100, 100)];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    loadingView.backgroundColor = [UIColor blueColor];
    
    [self recell];
   
    float Intervaltime = 0.5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:Intervaltime target:self selector:@selector(circleAnimation) userInfo:nil repeats:YES];
}

- (void)recell{
    //创建出CAShapelasyer
    self.shapeLayer = [CAShapeLayer layer];
    //填充颜色
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 4.0f;
    self.shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    
    
    self.shapeLayerTwo = [CAShapeLayer layer];
    self.shapeLayerTwo.fillColor = [UIColor clearColor].CGColor;
    //设置第二条背景线条的宽度和颜色
    self.shapeLayerTwo.lineWidth = 4.0f;
    self.shapeLayerTwo.strokeColor = [UIColor redColor].CGColor;
    
    //画贝塞尔曲线//画出一个园
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //moveToPoint:去设置初始线段的起点
    [path moveToPoint:CGPointMake(100, 50)];
    [path addArcWithCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    //设置第一条第一条曲线与设定的贝塞尔曲线相同，所以在设定两条曲线的时候，可以不需要设置大小与位置
    self.shapeLayer.path = path.CGPath;
    self.shapeLayerTwo.path = path.CGPath;
    
    //设置起始点.保证圈不被显示出来
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    //加载
    [self.loadingView.layer addSublayer:self.shapeLayerTwo];
    [self.loadingView.layer addSublayer:self.shapeLayer];
}


//定时器每次时间到了执行
- (void)circleAnimation{
    _timeD = 0.5;
    //利用定时器控制始位置的方式做动画。
    self.shapeLayer.strokeEnd +=_timeD;
    if (self.shapeLayer.strokeEnd == 1) {
        //停止计时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
