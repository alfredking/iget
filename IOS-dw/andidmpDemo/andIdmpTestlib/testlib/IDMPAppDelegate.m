//
//  IDMPAppDelegate.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-13.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAppDelegate.h"
#import "IDMPTestViewController.h"
#import "IDMPAutoLoginViewController.h"


#define APPID @"10000023"
#define APPKEY @"183C92B79EA6E96B"


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
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    
//    [application setStatusBarHidden:NO];
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self getLocation];

    IDMPAutoLoginViewController *autoLogin=[[IDMPAutoLoginViewController alloc]init];
    [autoLogin validateWithAppid:APPID appkey:APPKEY timeoutInterval:20  finishBlock:^(NSDictionary *paraments) {
        NSLog(@"初始化成功:%@",paraments);
    } failBlock:^(NSDictionary *paraments) {
        NSLog(@"初始化失败:%@",paraments);
    }];
//    NSString *lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastVersion"];
//    NSString *currentVersion=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    if (!lastVersion)
//    {
//    
//        [autoLogin validateWithAppid:APPID appkey:APPKEY timeoutInterval:20  finishBlock:^(NSDictionary *paraments) {
//            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"lastVersion"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSLog(@"初始化成功:%@",paraments);
//        } failBlock:^(NSDictionary *paraments) {
//            NSLog(@"初始化失败:%@",paraments);
//            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"lastVersion"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }];
//        
//    }
//    else if(![currentVersion isEqualToString:lastVersion])
//    {
//        
//        [autoLogin validateWithAppid:APPID appkey:APPKEY timeoutInterval:20  finishBlock:^(NSDictionary *paraments) {
//            NSLog(@"初始化成功:%@",paraments);
//            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"lastVersion"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        } failBlock:^(NSDictionary *paraments) {
//            NSLog(@"初始化失败:%@",paraments);
//            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"lastVersion"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }];
//        
//    }


    return YES;
    
}





//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"deviceToken：%@",deviceToken);
    
   
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
