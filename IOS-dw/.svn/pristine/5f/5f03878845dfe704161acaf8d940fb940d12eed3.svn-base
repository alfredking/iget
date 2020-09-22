//
//  IDMPDevice.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, NTNUDeviceType) {
    DeviceAppleUnknown,
    DeviceAppleSimulator,
    DeviceAppleiPhone,
    DeviceAppleiPhone3G,
    DeviceAppleiPhone3GS,
    DeviceAppleiPhone4,
    DeviceAppleiPhone4S,
    DeviceAppleiPhone5,
    DeviceAppleiPhone5C,
    DeviceAppleiPhone5S,
    DeviceAppleiPhone6,
    DeviceAppleiPhone6_Plus,
    DeviceAppleiPhone6S,
    DeviceAppleiPhone6S_Plus,
    DeviceAppleiPodTouch,
    DeviceAppleiPodTouch2G,
    DeviceAppleiPodTouch3G,
    DeviceAppleiPodTouch4G,
    DeviceAppleiPad,
    DeviceAppleiPad2,
    DeviceAppleiPad3G,
    DeviceAppleiPad4G,
    DeviceAppleiPad5G_Air,
    DeviceAppleiPadMini,
    DeviceAppleiPadMini2G
};



@interface IDMPDevice : NSObject

+(BOOL)checkChinaMobile;
+(BOOL)simExist;
+(NSString *)getDeviceID;
+(NSString *)getAppVersion;
+(BOOL) connectedToNetwork;
+(NSString*)GetCurrntNet;


+ (NSString *)ntnu_deviceDescription;
+ (NTNUDeviceType)ntnu_deviceType;
+ (NSString *)getOperatorCode;

+ (int)getAuthType;

/**
 *	获取运营商标识
 */
+ (NSString *)getOperatorCode;

/**
 *  接口用于收集手机设备信息
 */
+ (void)collectUserDeviceData;

/**
 *	读取设备信息
 */
+ (NSString *)getLocalUserDeviceData;
@end
