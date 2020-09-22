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
#import "IDMPAutoLoginViewController.h"

/**
 *   杭研现网http://112.54.207.14/client/appkey
 */
#define APPID @"10000019"
#define APPKEY @"CB0861A02AE52305"



@implementation IDMPAppDelegate


- (void)redirectNSlogToDocumentFolder
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString* lLogDir = [documentDirectory stringByAppendingPathComponent:@"log"];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];// 注意不是NSData!
    NSString *logFilePath = [lLogDir stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    // 生成log目录，如果目录不存在
    if(![defaultManager fileExistsAtPath:lLogDir isDirectory:NULL])
    {
        NSError* lError = nil;
        [defaultManager createDirectoryAtPath:lLogDir withIntermediateDirectories:YES attributes:NULL error:&lError];
    }
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (SIMULATOR == 1) {
        NSLog(@"模拟器");
    }
    else
    {
        NSLog(@"真机");
//        [self redirectNSLogToDocumentFolder];
    }
    

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    IDMPTestViewController *testVC = [[IDMPTestViewController alloc]init];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = testVC;
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"clientPrivateKey" ofType:@"pem"]);
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
    
//    [[IDMPAutoLoginViewController alloc] initWithAppid:APPID Appkey:APPKEY finishBlock:^(NSDictionary *paraments) {
//        NSLog(@"初始化成功:%@",paraments);
//    } failBlock:^(NSDictionary *paraments) {
//        NSLog(@"初始化失败:%@",paraments);
//    }];
    
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

    [manager stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
