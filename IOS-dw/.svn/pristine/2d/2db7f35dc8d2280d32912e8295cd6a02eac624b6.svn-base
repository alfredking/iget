//
//  IDMPAppDelegate.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-13.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPAppDelegate.h"
#import "IDMPLoginViewController.h"
#import "IDMPTestViewController.h"
#import "IDMPAuthLoginViewController.h"
#import "IDMPAutoLoginViewController.h"
#import "IDMPConst.h"
#import "IDMPDevice.h"

extern NSMutableDictionary *CollectDeviceDataDictionary;

@implementation IDMPAppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"url is %@",url);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    NSLog(@"now:%@",[[NSUserDefaults standardUserDefaults]objectForKey:nowLoginUser]);
    IDMPAuthLoginViewController *testV = [[IDMPAuthLoginViewController alloc]init];
    NSArray *parament = [[url query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=,"]];
    testV.callBackUrl=parament[1];
    testV.isSip = parament[3];
    self.window.rootViewController = testV;
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"SandBox:%@",NSHomeDirectory());
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Override point for customization after application launch.
    // 真机测试时保存日志 (此时模拟器真机同时保存)
    if (SIMULATOR == 1) {
        NSLog(@"模拟器");
    }
    else
    {
        NSLog(@"真机");
    }
//    [self redirectNSLogToDocumentFolder];
    NSLog(@"初始化");
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    IDMPTestViewController *testVC = [[IDMPTestViewController alloc]init];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = testVC;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        UIPasteboard *urlschemePasteBoard = [UIPasteboard pasteboardWithName:@"com.cmcc.idmp.urlschemeList" create:YES];
        urlschemePasteBoard.persistent = YES;
        urlschemePasteBoard.strings = [NSArray arrayWithObjects:@"IDMPCMCC://", nil];
        NSMutableArray *mutableURL=[urlschemePasteBoard.strings mutableCopy];
        [mutableURL addObject:@"IDMPCMCC://"];
        urlschemePasteBoard.strings=mutableURL;
        NSLog(@"第一次启动");
    }
    else
    {
        NSLog(@"不是第一次启动");
    }
    
#pragma mark----------推送-----------
    
    if (IS_IOS8)
    {
        //接受按钮
        UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
        acceptAction.identifier = @"acceptAction";
        acceptAction.title = @"接受";
        acceptAction.activationMode = UIUserNotificationActivationModeBackground;
        //拒绝按钮
        UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
        rejectAction.identifier = @"rejectAction";
        rejectAction.title = @"拒绝";
        //        rejectAction.activationMode = UIUserNotificationActivationModeBackground;
        rejectAction.activationMode = UIUserNotificationActivationModeBackground;
        //        rejectAction.authenticationRequired = NO;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        //        rejectAction.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";
        NSArray *actions = @[acceptAction, rejectAction];
        [categorys setActions:actions forContext:UIUserNotificationActionContextDefault];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:[NSSet setWithObject:categorys]]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self getLocation];
    
    [IDMPDevice collectUserDeviceData];
    
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

#pragma mark--------------------获取地理位置信息----------------------------------


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




/**
 *  @author xu_xi, 15-06-12 13:06:57
 *
 *  方法说明
 *  保存log日志到Document路径下
 *  保存文件名称为 项目名称&日期.log
 */
- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //获取项目名称
    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *nameAndDate = [NSString stringWithFormat:@"%@&%@",executableFile,[NSDate date]];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",nameAndDate];
    NSLog(@"打印日志路径:%@",documentsDirectory);
    _logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([_logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
/**
 *  @author xu_xi, 15-06-12 13:06:28
 *
 *  清除log日志
 */
-(void)cleanNSLogCache
{
    /*
     NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL isDelete=[fileManager removeItemAtPath:_logFilePath error:nil];
     NSLog(@"%d",isDelete);
     */
}
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *url = @"http://itunes.apple.com/lookup?id=你的应用程序的ID";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
//    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    if ([self.window.rootViewController isKindOfClass:[IDMPAuthLoginViewController class]]) {
//        IDMPTestViewController *testV = [[IDMPTestViewController alloc]init];
//        self.window.rootViewController = testV;
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([self.window.rootViewController isKindOfClass:[IDMPAuthLoginViewController class]]) {
        IDMPTestViewController *testV = [[IDMPTestViewController alloc]init];
        self.window.rootViewController = testV;
    }

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
