//
//  IDMPDevice.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPDevice.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "secReachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "IDMPConst.h"
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "IDMPAES128.h"
#import "userInfoStorage.h"
#import "OpenUDID.h"
#include <sys/types.h>
#include <sys/sysctl.h>

extern NSMutableDictionary *CollectDeviceDataDictionary;

@implementation IDMPDevice

+(BOOL)checkChinaMobile
{
    BOOL ret = NO;
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (carrier == nil)
    {
        return NO;
    }
    
    NSString *code = [carrier mobileNetworkCode];
    if (code == nil)
    {
        return NO;
    }
    
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"])
    {
        ret = YES;
    }
    return ret;
}

+(BOOL)simExist
{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *code = [carrier mobileNetworkCode];
    NSLog(@"mobileNetworkCode is %@",[carrier mobileNetworkCode]);
    NSLog(@"carrierName is %@",[carrier carrierName]);
    NSLog(@"mobileCountryCode is %@",[carrier mobileCountryCode]);
    NSLog(@"isoCountryCode is %@",[carrier isoCountryCode]);
    NSLog(@"allowsVOIP %d",[carrier allowsVOIP]);
    if (code == nil)
    {
        //NSLog(@"no sim");
        return NO;
    }
    else
    {
        //NSLog(@"sim exist");
        return YES;
    }
}

+(NSString *)getDeviceID
{
    NSString *deviceId=[userInfoStorage getInfoWithKey:deviceIdsk];
    if (deviceId)
    {
        return deviceId;
    }
    else
    {
        deviceId=[[UIDevice currentDevice].identifierForVendor UUIDString];
        [userInfoStorage setInfo:deviceId withKey:deviceIdsk];
        return deviceId;
 
    }
}

+(NSString *)getAppVersion
{
    return @"1.0";
}


+(NSString*)GetCurrntNet
{
    NSString* result=nil;
    secReachability *r = [secReachability reachabilityWithHostName:@"www.baidu.com"];
    NSLog(@"[r currentReachabilityStatus]  %d",[r currentReachabilityStatus]);
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:// 没有网络连接
            result=nil;
            break;
        case ReachableViaWWAN:// 使用4G网络
            result=@"4g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            result=@"wifi";
            break;
    }
    return result;
}


//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPadmini4";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    
    return platform;
}

#pragma mark -----获取运营商标识-----
+ (NSString *)getOperatorCode
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    NSString *code = [carrier mobileNetworkCode];
    
    if (carrier && code)
    {
        return code;
    }
    return nil;
}




#pragma mark -------采集数据接口--------
+ (void)collectUserDeviceData
{
    NSString *openUDID = [OpenUDID value];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *deviceModel = [self getCurrentDeviceModel];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *os = [NSString stringWithFormat:@"%@ %@",systemName,systemVersion];
    NSString *operatorCode = [IDMPDevice getOperatorCode];
    NSString *Loc = [[NSUserDefaults standardUserDefaults] objectForKey:kloc_info] ? [[NSUserDefaults standardUserDefaults] objectForKey:kloc_info] : @"";
    
    if (!CollectDeviceDataDictionary)
    {
        CollectDeviceDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    
    [CollectDeviceDataDictionary setObject:openUDID forKey:kopenUDID];
    [CollectDeviceDataDictionary setObject:IDFV forKey:kIDFV];
    [CollectDeviceDataDictionary setObject:deviceModel forKey:kphoneModel];
    [CollectDeviceDataDictionary setObject:os forKey:kos];
    [CollectDeviceDataDictionary setObject:Loc forKey:kloc_info];
    if(operatorCode)
    {
        [CollectDeviceDataDictionary setObject:operatorCode forKey:kmnc];
    }
    else
    {
        [CollectDeviceDataDictionary setObject:@"" forKey:kmnc];
    }
    
    
    NSString *wifiSSID = [IDMPDevice getWiFiSSID];
    if (wifiSSID)
    {
        NSData *data_wifissid = [wifiSSID dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64_wifissid = [IDMPAES128 base64EncodingWithData:data_wifissid];
        [CollectDeviceDataDictionary setObject:base64_wifissid forKey:kwifiSSID];
    }
}



#pragma mark ----获取当前WiFiSSID----
+ (NSString *)getWiFiSSID {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return [[info objectForKey:@"SSID"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}


#pragma mark -----读取本地的用户设备信息-------
+ (NSString *)getLocalUserDeviceData
{
    [self collectUserDeviceData];
    
    NSDictionary *dic = CollectDeviceDataDictionary;
    
    NSArray *arr = [dic allKeys];
    
    if (!dic)
    {
        return nil;
    }
    
    NSString *RC_data = @"";
    
    for (int i = 0; i < [arr count]; i++)
    {
        
        NSString *value = [dic objectForKey:arr[i]];
        if (i == [arr count] -1)
        {
            RC_data = [RC_data stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\"",arr[i],value]];
        }
        else
        {
            RC_data = [RC_data stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\",",arr[i],value]];
        }
    }
    RC_data = [NSString stringWithFormat:@"{%@}",RC_data];
    
    
    return RC_data;
}


@end
