//
//  ImagRotateVC.m
//  testbutton
//
//  Created by lmcqc on 2020/10/26.
//  Copyright © 2020 大碗豆. All rights reserved.
//

#import "ImagRotateVC.h"
#import "EFButton.h"

@interface ImagRotateVC ()
@property (nonatomic,assign) NSInteger tmpFlag;
@end

@implementation ImagRotateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EFButton *btn = [EFButton new];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 600, 140, 60);
    //    btn.center = CGPointMake(100, 100);
    [btn setTitle:@"客服服务" forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"qwas.png"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    self.tmpFlag = 0;
}

-(void)click:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self imagRotate:btn];
    [self convertCreateImageWithUIView];
}

#pragma mark - 使用uiview创建image
//旋转UIview然后截图生成image
- (void)convertCreateImageWithUIView{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    tmpView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:tmpView];
    
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    imag.image = [UIImage imageNamed:@"rp"];
    imag.transform = CGAffineTransformMakeRotation(223);
    [tmpView addSubview:imag];
    
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    imag1.image = [UIImage imageNamed:@"rp"];
    [self.view addSubview:imag1];
    
    UIGraphicsBeginImageContextWithOptions(tmpView.bounds.size, NO, [UIScreen mainScreen].scale);
    [tmpView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imag1.image = viewImage;
}


#pragma mark - icon旋转
- (void)imagRotate:(UIButton *)btn{
    if (self.tmpFlag > 7) {
        self.tmpFlag = 0;
    }
    //    double aaa = atan(-1);
    //    double asina = sin(M_PI/6);
    //    NSLog(@"%f ~~~~ %f~~~~%f",aaa,asina,M_PI);
    
    //    double angle1 = [self getBearingWithLat1:5 whitLng1:4 whitLat2:6 whitLng2:5];
    //    double angle2 = [self getBearingWithLat1:5 whitLng1:4 whitLat2:6 whitLng2:3];
    //    double angle3 = [self getBearingWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:3];
    //    double angle4 = [self getBearingWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:5];
    //    NSLog(@"第一象限%f~~~第二象限%f~~~~第三象限%f~~~~第四象限%f",angle1,angle2,angle3,angle4);
    
    //    double angle1 = [self getTanWithLat1:5 whitLng1:4 whitLat2:6 whitLng2:5];
    //    double angle2 = [self getTanWithLat1:5 whitLng1:4 whitLat2:6 whitLng2:3];
    //    double angle3 = [self getTanWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:3];
    //    double angle4 = [self getTanWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:5];
    //    NSLog(@"第一象限%f~~~第二象限%f~~~~第三象限%f~~~~第四象限%f",angle1,angle2,angle3,angle4);
    
    switch (self.tmpFlag) {
        case 0:
        {
            double angle1 = [self getTanWithLat1:5 whitLng1:4 whitLat2:8 whitLng2:5];
            NSLog(@"第一象限%f",angle1);
            btn.transform = CGAffineTransformMakeRotation(angle1);
        }
            break;
        case 1:
        {
            double angle2 = [self getTanWithLat1:5 whitLng1:4 whitLat2:6 whitLng2:3];
            NSLog(@"第二象限%f",angle2);
            btn.transform = CGAffineTransformMakeRotation(angle2);
        }
            break;
        case 2:
        {
            double angle3 = [self getTanWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:3];
            NSLog(@"第三象限%f",angle3);
            btn.transform = CGAffineTransformMakeRotation(angle3);
        }
            break;
        case 3:
        {
            double angle4 = [self getTanWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:5];
            NSLog(@"第四象限%f",angle4);
            btn.transform = CGAffineTransformMakeRotation(angle4);
        }
            break;
        case 4:
        {
            double angle4 = [self getTanWithLat1:5 whitLng1:4 whitLat2:6 whitLng2:4];
            NSLog(@"y上半轴%f",angle4);
            btn.transform = CGAffineTransformMakeRotation(angle4);
        }
            break;
        case 5:
        {
            double angle4 = [self getTanWithLat1:5 whitLng1:4 whitLat2:4 whitLng2:4];
            NSLog(@"y下半轴%f",angle4);
            btn.transform = CGAffineTransformMakeRotation(angle4);
        }
            break;
        case 6:
        {
            double angle4 = [self getTanWithLat1:5 whitLng1:4 whitLat2:5 whitLng2:5];
            NSLog(@"x右半轴%f",angle4);
            btn.transform = CGAffineTransformMakeRotation(angle4);
        }
            break;
            
        case 7:
        {
            double angle4 = [self getTanWithLat1:5 whitLng1:4 whitLat2:5 whitLng2:3];
            NSLog(@"x左半轴%f",angle4);
            btn.transform = CGAffineTransformMakeRotation(angle4);
        }
            break;
            
        default:
            break;
    }
    self.tmpFlag += 1;
}

//使用tan计算两点之间的转角
-(double)getTanWithLat1:(double)latY1 whitLng1:(double)lngX1 whitLat2:(double)latY2 whitLng2:(double)lngX2{
    
    if (latY1 == latY2 && lngX1 == lngX2) {
        return 0;
    }
    
    //y轴点
    if (lngX2 == lngX1) {
        if (latY2 > latY1) {
            return -90;
        }else{
            return 90;
        }
    }
    //x轴点
    if (latY2 == latY1) {
        if (lngX2 > lngX1) {
            return 0;
        }else{
            return 180;
        }
    }
    
    double d = 0;
    //绝对值
    double fabs(double d);
    double X = fabs(lngX2 - lngX1);
    double Y = fabs(latY2 - latY1);
    double radian = atan(Y * 1.0 / X);
    double angle = [self angle:radian];
    d = angle;
    
    if (latY2 > latY1) {
        if (lngX2 > lngX1) {
            return -d;
        }else{
            return d - 180;
        }
    }else{
        if (lngX2 > lngX1) {
            return d;
        }else{
            return 180 - d;
        }
    }
    return d;
}

//根据弧度计算角度
-(double)angle:(double)r{
    return r * 180/M_PI;
}

//根据角度计算弧度
-(double)radian:(double)d{
    return d * M_PI/180.0;
}

//两个经纬度之间的角度
-(double)getBearingWithLat1:(double)lat1 whitLng1:(double)lng1 whitLat2:(double)lat2 whitLng2:(double)lng2{
    
    double d = 0;
    double radLat1 =  [self radian:lat1];
    double radLat2 =  [self radian:lat2];
    double radLng1 = [self radian:lng1];
    double radLng2 =  [self radian:lng2];
    d = sin(radLat1)*sin(radLat2)+cos(radLat1)*cos(radLat2)*cos(radLng2-radLng1);
    d = sqrt(1-d*d);
    d = cos(radLat2)*sin(radLng2-radLng1)/d;
    d = [self angle:asin(d)];
//    double fabs(double d);
//    d = fabs(d);
    //    if(lat2 < lat1){
    //        d = 180-d;
    //    }
    return d;
}
@end
