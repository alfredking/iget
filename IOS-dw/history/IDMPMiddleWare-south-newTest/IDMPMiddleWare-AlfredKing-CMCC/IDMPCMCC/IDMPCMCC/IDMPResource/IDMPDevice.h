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
//+(BOOL)simExist;
+(NSString *)getDeviceID;
+(NSString *)getAppVersion;
+(BOOL) connectedToNetwork;
+(NSString*)GetCurrntNet;

+ (int)getAuthType;

/**
 *	获取运营商标识
 */
+ (NSString *)getOperatorCode;


/**
 *	获取设备类型
 */
+ (NSString *)getCurrentDeviceModel;

@end
