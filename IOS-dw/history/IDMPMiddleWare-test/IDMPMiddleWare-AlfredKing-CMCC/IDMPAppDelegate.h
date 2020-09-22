//
//  IDMPAppDelegate.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-13.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IDMPAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,copy)NSString *logFilePath;
@property (strong, nonatomic)CLLocationManager *locationManager;

@end
