//
//  AppDelegate.m
//  Fenvo
//
//  Created by Caesar on 15/3/17.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "WeiboSDK.h"
#import "LoginViewController.h"


@interface AppDelegate ()<WeiboSDKDelegate>{
    MainViewController *_mainVC;
}
@property (strong, nonatomic) WeiboViewController *loginView;
@end

@implementation AppDelegate
@synthesize wbtoken = _wbtoken;
@synthesize uid = _uid;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    [self.window makeKeyAndVisible];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiboAppKey];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,RGBACOLOR(250, 143, 5, 1),NSForegroundColorAttributeName, nil]];
    }
    
    [self login];
    
    return YES;
}

- (void)login
{
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    
    NSString *wbtoken               = [userDefaults stringForKey:@"wbtoken"];
    NSString *wbCurrentUserID       = [userDefaults stringForKey:@"wbCurrentUserID"];
    
    if (wbtoken)
    {
        _wbtoken            = wbtoken;
        _wbCurrentUserID    = wbCurrentUserID;
        
        [self showMainViewController];
        
        return;
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        self.window.rootViewController = loginVC;
    }
}

- (void)showMainViewController
{
    if (_mainVC == nil)
    {
        _mainVC                 = [[MainViewController alloc]init];
    }
    
    NSDictionary *userInfo      = @{@"token":_wbtoken,@"uid":_wbCurrentUserID};
    [[NSNotificationCenter defaultCenter]postNotificationName:WBNOTIFICATION_DOWNLOADDATA object:nil userInfo:userInfo];
    
    self.window.rootViewController = _mainVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "DC.Fenvo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Fenvo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fenvo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Open Weibo Authorize

- (BOOL)application:(nonnull UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(nonnull UIApplication *)application handleOpenURL:(nonnull NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (!response) return;
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        NSLog(@"Authorize result : %@", message);
        
        if (![(WBAuthorizeResponse *)response accessToken] || [[(WBAuthorizeResponse *)response accessToken] isEqualToString:@""]) return;
        
        self.wbtoken            = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID    = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken     = [(WBAuthorizeResponse *)response refreshToken];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject: self.wbtoken forKey:@"wbtoken"];
        [userDefaults setObject: self.wbCurrentUserID forKey:@"wbCurrentUserID"];
        [userDefaults setObject: self.wbRefreshToken forKey:@"wbRefreshToken"];
        [userDefaults synchronize];
        
        [self showMainViewController];
    }

}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

#pragma mark - Auth2.0网页认证。现不使用

- (void)loginStateChange:(NSNotification *)notification {
    //UINavigationController *nav = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults synchronize];
    NSString *access_token = [userDefaults stringForKey:@"access_token"];
    NSString *uid = [userDefaults stringForKey:@"uid"];
    if (access_token) {
        if (_mainVC == nil) {
            _mainVC = [[MainViewController alloc]init];
            _mainVC.selectedIndex = 0;
            //nav = [[UINavigationController alloc]initWithRootViewController:_mainVC];
        }
        _wbtoken = access_token;
        _uid = uid;
        NSDictionary *userInfo = @{@"token":access_token,@"uid":uid};
        [[NSNotificationCenter defaultCenter]postNotificationName:WBNOTIFICATION_DOWNLOADDATA object:nil userInfo:userInfo];
        self.window.rootViewController = _mainVC;
        return;
    }else{
        
        BOOL loginSuccess = [notification.object boolValue];
        if (loginSuccess) {
            
            if (_mainVC == nil) {
                _mainVC = [[MainViewController alloc]init];
                _mainVC.selectedIndex = 0;
                //nav = [[UINavigationController alloc]initWithRootViewController:_mainVC];
                //nav = (UINavigationController *)_mainVC.selectedViewController;
            }else{
                //nav = (UINavigationController *)_mainVC.selectedViewController;
            }
            NSString *token = [notification.userInfo objectForKey:@"token"];
            NSString *uid = [notification.userInfo objectForKey:@"uid"];
            _wbtoken = token;
            _uid = uid;
            
            [userDefaults setObject: token forKey:@"access_token"];
            [userDefaults setObject: uid forKey:@"uid"];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:WBNOTIFICATION_DOWNLOADDATA object:nil userInfo:notification.userInfo];
            
            self.window.rootViewController = _mainVC;
            return;
        }
        else{
            _mainVC = nil;
            WeiboViewController *loginVC = [[WeiboViewController alloc]init];
            UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            loginVC.title = @"登陆授权";
            self.window.rootViewController = nav;
        }
    }
}

@end
