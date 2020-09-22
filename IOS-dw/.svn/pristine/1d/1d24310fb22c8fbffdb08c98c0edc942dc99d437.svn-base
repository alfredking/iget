//
//  IDMPDevice.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "secReachability.h"

typedef NS_ENUM (NSUInteger, OperatorName) {
    CMCC,
    CUCC,
    CTCC,
    Unkown
};

@interface IDMPDevice : NSObject



/**
 移动卡状态
 
 @return 是否是移动卡
 */
+(BOOL)checkChinaMobile;

/**
 sim卡状态
 
 @return 是否存在
 */
+(BOOL)simExist;

/**
 设备id
 
 @return ifdv
 */
+(NSString *)getDeviceID;

/**
 网络开启状态
 
 @return 网络开启状态
 */
+(NetworkStatus)GetCurrntNet;

/**
 cellular开启状态
 
 @return cellular开启状态
 */
+(BOOL)checkCellular;
    
    
    
/**
 celluar权限判断

 @return celluar权限状态
 */
+(BOOL)hasCellularAuthority;
    
/**
 获取运营商名称
 
 @return 运营商名称
 */
+ (OperatorName)getChinaOperatorName;


/**
 *  接口用于收集手机设备信息
 */
+ (void)collectUserDeviceData;

/**
 *    读取设备信息
 */
+ (NSString *)getLocalUserDeviceData;

    
/**
  获取系统名称

 @return 系统名称
 */
+ (NSString *)getSystemName;
/**
 越狱检测
 
 @return 检测状态
 */
+ (BOOL)checkJailbroken;
@end

