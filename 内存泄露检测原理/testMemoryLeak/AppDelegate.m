//
//  AppDelegate.m
//  testMemoryLeak
//
//  Created by alfredking－cmcc on 2021/3/6.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

//原文链接：https://blog.csdn.net/u010713935/article/details/104754971/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
          
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    ViewController *vc =[[ViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


#pragma mark - UISceneSession lifecycle




@end
