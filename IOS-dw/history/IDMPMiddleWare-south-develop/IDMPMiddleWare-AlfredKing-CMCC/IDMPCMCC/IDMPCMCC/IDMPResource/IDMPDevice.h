//
//  IDMPDevice.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPDevice : NSObject

+(BOOL)checkChinaMobile;
+(BOOL)simExist;
+(NSString *)getDeviceID;
+(NSString *)getAppVersion;
+(NSString*)GetCurrntNet;

/**
 *	获得设备型号
 */
+ (NSString *)getCurrentDeviceModel;

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
