//
//  TestLayerPositionVC.m
//  iget
//
//  Created by alfredking－cmcc on 2023/6/28.
//  Copyright © 2023 alfredking. All rights reserved.
//

#import "TestLayerPositionVC.h"

@interface TestLayerPositionVC ()

@end

@implementation TestLayerPositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        bView.backgroundColor = [UIColor redColor];
        [self.view.layer addSublayer:bView.layer];
     
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
        aView.backgroundColor = [UIColor greenColor];
        [bView.layer addSublayer:aView.layer];
    NSLog(@"初始化后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
        
//    aView.layer.anchorPoint = CGPointMake(0.5, 1);
//    aView.layer.position = CGPointMake(50, 50);
//    aView.frame = CGRectMake(0, 0, 50, 50);
//        NSLog(@"修改layer.anchorPoint后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
    
//        aView.layer.position = CGPointMake(50, 100);
//    NSLog(@"修改layer.position后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//    aView.layer.transform = CATransform3DMakeRotation(M_PI/4.0, 0, 0, 1);
//    });
    
    // 场景一：修改 锚点 + 结构框架，即 layer.anchorPoint + layer.frame
//        NSLog(@"初始化后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
//
//        aView.layer.anchorPoint = CGPointMake(1.5, 1.5);
//        NSLog(@"修改layer.anchorPoint后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
//
//         //修改frame的本质其实是修改layer.frame，所以修改layer.frame就是修改frame
//        aView.layer.frame = CGRectMake(50, 50, 100, 100);
//        NSLog(@"接着修改frame后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
//
//        aView.layer.anchorPoint = CGPointMake(1.0, 1.0);
//        NSLog(@"再次修改layer.anchorPoint后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));


        /**
         输出：
         2023-01-06 14:21:59.496431+0800 Demo[8398:1402935] 初始化后，aView.layer的frame值：{{50, 50}, {50, 50}}，aView.layer的anchorPoint值：{0.5, 0.5}，aView.layer的position值：{75, 75}，
         2023-01-06 14:21:59.496994+0800 Demo[8398:1402935] 修改layer.anchorPoint后，aView.layer的frame值：{{0, 0}, {50, 50}}，aView.layer的anchorPoint值：{1.5, 1.5}，aView.layer的position值：{75, 75}，
         2023-01-06 14:21:59.497796+0800 Demo[8398:1402935] 接着修改frame后，aView.layer的frame值：{{50, 50}, {100, 100}}，aView.layer的anchorPoint值：{1.5, 1.5}，aView.layer的position值：{200, 200}，
         2023-01-06 14:21:59.498687+0800 Demo[8398:1402935] 再次修改layer.anchorPoint后，aView.layer的frame值：{{100, 100}, {100, 100}}，aView.layer的anchorPoint值：{1, 1}，aView.layer的position值：{200, 200}，
         
         关于锚点，根据输出结果，描述如下：
         1、确定好frame后，当前view的中心点，就是view的默认锚点（0.5，0.5），此时view的右下角为锚点原点（0，0）；
         2、设置锚点（比如设置为（1.5，1.5）），都是中心点带动view在 父view 上移动，以旧的锚点（0.5，0.5）开始向新的锚点（1.5，1.5）移动，此时view在 父view 上的位置会发生改变，即frame的（x，y）发生改变；
         3、如果view的frame发生变化，那么锚点的值（1.5，1.5）不会改变且还是中心点，但锚点在 父view 上的位置发生了改变，不再是之前的位置；
         4、再次设置锚点（比如设置为（1.0，1.0）），即旧的锚点（1.5，1.5）开始向新的锚点（1.0，1.0）移动，此时view在 父view 上的位置会发生改变，即frame的（x，y）发生改变；
         
         记住：
         1、view的左上角和右下角的对折线，对折线向右下角方向的延伸可找到锚点原点（0，0），以 view 为参照物；
         2、锚点的改变不会改变position的坐标位置；
         3、锚点在view上的位置是固定的中心点，在 父view 上的位置会根据设置的锚点值或者view.frame的改变而改变；
         4、锚点anchorPoint的修改，会对frame造成修改；
         
         */
     
        
         //场景二：修改 位置 + 结构框架，即 layer.position + layer.frame
//        NSLog(@"初始化后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
//
//        aView.layer.position = CGPointMake(25, 25);
//        NSLog(@"修改layer.position后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
//         //修改frame的本质其实是修改layer.frame，所以修改layer.frame就是修改frame
//        aView.layer.frame = CGRectMake(50, 50, 100, 100);
//        NSLog(@"接着修改frame后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
//
//        aView.layer.position = CGPointMake(0, 0);
//        NSLog(@"再次修改layer.position后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));
         
        
        /**
         输出：
         2023-01-06 15:08:19.506259+0800 Demo[8428:1407276] 初始化后，aView.layer的frame值：{{50, 50}, {50, 50}}，aView.layer的anchorPoint值：{0.5, 0.5}，aView.layer的position值：{75, 75}，
         2023-01-06 15:08:19.506564+0800 Demo[8428:1407276] 修改layer.position后，aView.layer的frame值：{{0, 0}, {50, 50}}，aView.layer的anchorPoint值：{0.5, 0.5}，aView.layer的position值：{25, 25}，
         2023-01-06 15:08:19.506714+0800 Demo[8428:1407276] 接着修改frame后，aView.layer的frame值：{{50, 50}, {100, 100}}，aView.layer的anchorPoint值：{0.5, 0.5}，aView.layer的position值：{100, 100}，
         2023-01-06 15:08:19.506824+0800 Demo[8428:1407276] 再次修改layer.position后，aView.layer的frame值：{{-50, -50}, {100, 100}}，aView.layer的anchorPoint值：{0.5, 0.5}，aView.layer的position值：{0, 0}，
         
         关于position，根据输出结果，描述如下：
         1、确定好frame后，当前view的中心点，在 父view 上的坐标，即为position的坐标值；
         2、设置position坐标（比如设置为（25，25）），都是中心点带动view在 父view 上移动，以旧的position坐标（75，75）开始向新的position坐标（25，25）移动，此时view在 父view 上的位置会发生改变，即frame的（x，y）发生改变；
         3、如果view的frame发生变化，position的值会改变但还是中心点，此时中心点在 父view 上的坐标，即为position的新的坐标值；
         4、再次设置position坐标（比如设置为（0，0）），即旧的position坐标（100，100）开始向新的position坐标（0，0）移动，此时view在 父view 上的位置会发生改变，即frame的（x，y）发生改变；
         
         记住：（不修改锚点anchorPoint的前提下）
         1、position的坐标值是view的中心点在 父view 上的位置，以 父view 为坐标系；
         2、frame的改变会修改position的坐标值，但依然是中心点在 父view 上的坐标值；
         3、position的修改，会对frame造成修改，但不会修改锚点的值；
         
         */
        
        // 场景三：探究修改 锚点 + 结构框架，即 layer.position + layer.frame 后，对 layer.position的影响
        NSLog(@"初始化后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));

        aView.layer.anchorPoint = CGPointMake(1.5, 1.5);
        NSLog(@"修改layer.anchorPoint后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));

        // 修改frame的本质其实是修改layer.frame，所以修改layer.frame就是修改frame
        aView.layer.frame = CGRectMake(50, 50, 100, 100);
        NSLog(@"接着修改frame后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));

    //    aView.layer.position = CGPointMake(25, 25);
    //    NSLog(@"修改layer.position后，aView.layer的frame值：%@，aView.layer的anchorPoint值：%@，aView.layer的position值：%@，", NSStringFromCGRect(aView.layer.frame), NSStringFromCGPoint(aView.layer.anchorPoint), NSStringFromCGPoint(aView.layer.position));

        UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(150, 150, 100, 100)];
        cView.backgroundColor = [UIColor blueColor];
        [bView.layer addSublayer:cView.layer];
        NSLog(@"初始化后，cView.layer的frame值：%@，cView.layer的anchorPoint值：%@，cView.layer的position值：%@，", NSStringFromCGRect(cView.layer.frame), NSStringFromCGPoint(cView.layer.anchorPoint), NSStringFromCGPoint(cView.layer.position));
        
        /**
         输出：
         2023-01-06 16:23:09.769934+0800 Demo[8469:1412907] 初始化后，aView.layer的frame值：{{50, 50}, {50, 50}}，aView.layer的anchorPoint值：{0.5, 0.5}，aView.layer的position值：{75, 75}，
         2023-01-06 16:23:09.770143+0800 Demo[8469:1412907] 修改layer.anchorPoint后，aView.layer的frame值：{{0, 0}, {50, 50}}，aView.layer的anchorPoint值：{1.5, 1.5}，aView.layer的position值：{75, 75}，
         2023-01-06 16:23:09.770258+0800 Demo[8469:1412907] 接着修改frame后，aView.layer的frame值：{{50, 50}, {100, 100}}，aView.layer的anchorPoint值：{1.5, 1.5}，aView.layer的position值：{200, 200}，
         2023-01-06 16:23:09.770406+0800 Demo[8469:1412907] 初始化后，cView.layer的frame值：{{150, 150}, {100, 100}}，cView.layer的anchorPoint值：{0.5, 0.5}，cView.layer的position值：{200, 200}，
         
         关于修改 锚点 + 结构框架，即 layer.position + layer.frame 后，对 layer.position的影响，根据输出结果，描述如下：
         1、确定好frame后，当前view的中心点，就是view的默认锚点（0.5，0.5），也是position的坐标值；
         2、设置锚点（比如设置为（1.5，1.5）），此时view在 父view 上的位置会发生改变，即frame的（x，y）发生改变，但position的坐标值未改变，依然是默认锚点（0.5，0.5）对应的坐标值；
         3、view的frame改变，锚点的值（1.5，1.5）不会改变且还是中心点，但position的坐标值发生了改变，取得是view当前位置下，根据中心点，也就是新锚点（1.5，1.5）找到默认锚点（0.5，0.5）对应的坐标值；
         4、根据cView的输出结果，得到第3条的验证；
         
         记住：
         1、position的坐标值是跟默认锚点（0.5，0.5）一一对应的，即两者可以互相得到彼此的位置；
         2、如果先改变锚点值，再改变frame，需要先确定当前新锚点（即中心点）位置下，默认锚点（0.5，0.5）的位置，即可确认position的坐标值；
         3、锚点anchorPoint、position的修改，都会对frame造成修改；
         4、position的位置在哪儿，默认锚点（0.5，0.5）的位置就在哪儿，或者默认锚点（0.5，0.5）的位置就在哪儿，position的位置在哪儿；
         5、锚点anchorPoint指的就是view的中心点，position指的是默认锚点（0.5，0.5）的位置，position这个点不一定在 view 上；
         6、锚点anchorPoint、position都是一个点，带动整个view在路线上运动；
         
         */
     
     
        // 添加横分割线
        for (int i = 0; i < 12; i++) {
            UIView *hengLineV = [[UIView alloc] initWithFrame:CGRectMake(0, i*50, [UIScreen mainScreen].bounds.size.width, 1)];
            hengLineV.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:hengLineV];
        }
     
        // 添加竖分割线
        for (int i = 0; i < 8; i++) {
            UIView *shuLineV = [[UIView alloc] initWithFrame:CGRectMake(i*50, 0, 1, [UIScreen mainScreen].bounds.size.height)];
            shuLineV.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:shuLineV];
        }
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
