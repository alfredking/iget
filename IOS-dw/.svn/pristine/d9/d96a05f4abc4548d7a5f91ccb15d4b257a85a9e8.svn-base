//
//  IDMPAppDelegate.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-13.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAppDelegate.h"
#import "IDMPTestViewController.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"


///**
// *	现网
// */
//#define APPID @"00100218"
//#define APPKEY @"72ECDCA973BA51C7"


///**
// *    和飞信
// */
//#define APPID @"01000104"
//#define APPKEY @"D6683D3B5245D064"



///**
// *	联调
// */
#define APPID @"10000023"
#define APPKEY @"183C92B79EA6E96B"

///**
// *	能力开放平台
// */
//#define APPID @"f4e0472d2d0b4faf99cb6f4e060607b0"
//#define APPKEY @"fbcffec54439423e9dd414d08298d985"



//测试
//#define APPID @"10000012"
//#define APPKEY @"09D7E14438266A60"


//河南移动
//#define APPID @"03500165"
//#define APPKEY @"25E689866CCB83EE"

//开发
//#define APPID @"10000003"
//#define APPKEY @"8697A3AA64BB4B4D"



extern NSMutableDictionary *CollectDeviceDataDictionary;




@implementation IDMPAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    IDMPTestViewController *testVC = [[IDMPTestViewController alloc]init];
//    [self.window makeKeyAndVisible];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = testVC;
//    NSLog(@"%@",NSHomeDirectory());
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    
//    [application setStatusBarHidden:NO];
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
//    [self getLocation];
    
   IDMPAutoLoginViewController *autoLogin= [[IDMPAutoLoginViewController alloc] init];
   [autoLogin validateWithAppid:APPID appkey:APPKEY timeoutInterval:20
   finishBlock:^(NSDictionary *paraments)
    {
//            NSLog(@"初始化成功:%@",paraments);
        
    }
    failBlock:^(NSDictionary *paraments)
    {
//            NSLog(@"初始化失败:%@",paraments);
    }];
    return YES;
    
}

//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"deviceToken：%@",deviceToken);

    if (!CollectDeviceDataDictionary) {
        CollectDeviceDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [CollectDeviceDataDictionary setObject:deviceToken forKey:kDeviceToken];
}

//注册消息推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    NSLog(@"Register Remote Notifications error:{%@}",error);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"Receive remote notification : %@",userInfo);
    
}


- (void)getLocation
{
    //判断定位服务是否可用
    if ([CLLocationManager locationServicesEnabled]){
        
        self.locationManager=[[CLLocationManager alloc] init];

        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        self.locationManager.delegate = self;

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        
    }else{
        
        NSLog(@"不能使用定位服务!");
    }
    
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{

    CLLocation *location=[locations lastObject];

    NSString *lat = [NSString stringWithFormat:@"%.2f",location.coordinate.latitude];

    NSString *lng = [NSString stringWithFormat:@"%.2f",location.coordinate.longitude];
    
    NSString *loc_info = [NSString stringWithFormat:@"%@,%@",lng,lat];
    
    NSLog(@"loc_info：%@",loc_info);
    
    if (!CollectDeviceDataDictionary) {
        CollectDeviceDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [CollectDeviceDataDictionary setObject:loc_info forKey:kloc_info];

    
    [manager stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
