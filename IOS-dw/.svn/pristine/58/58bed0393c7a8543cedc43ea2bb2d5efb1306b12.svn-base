//
//  IDMPDevice.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-26.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPDevice.h"
#import "OpenUDID.h"
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




+ (NSString *)ntnu_deviceDescription
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NTNUDeviceType)ntnu_deviceType
{
    NSDictionary *dic = [self ntnu_deviceTypeLookupTable];
    NSString *str = [self ntnu_deviceDescription];
    NSNumber *deviceType = [dic objectForKey:str];
    return [deviceType unsignedIntegerValue];
}

+ (NSDictionary *)ntnu_deviceTypeLookupTable
{
    return @{
             @"i386": @(DeviceAppleSimulator),
             @"x86_64": @(DeviceAppleSimulator),
             @"iPod1,1": @(DeviceAppleiPodTouch),
             @"iPod2,1": @(DeviceAppleiPodTouch2G),
             @"iPod3,1": @(DeviceAppleiPodTouch3G),
             @"iPod4,1": @(DeviceAppleiPodTouch4G),
             @"iPhone1,1": @(DeviceAppleiPhone),
             @"iPhone1,2": @(DeviceAppleiPhone3G),
             @"iPhone2,1": @(DeviceAppleiPhone3GS),
             @"iPhone3,1": @(DeviceAppleiPhone4),
             @"iPhone3,3": @(DeviceAppleiPhone4),
             @"iPhone4,1": @(DeviceAppleiPhone4S),
             @"iPhone5,1": @(DeviceAppleiPhone5),
             @"iPhone5,2": @(DeviceAppleiPhone5),
             @"iPhone5,3": @(DeviceAppleiPhone5C),
             @"iPhone5,4": @(DeviceAppleiPhone5C),
             @"iPhone6,1": @(DeviceAppleiPhone5S),
             @"iPhone6,2": @(DeviceAppleiPhone5S),
             @"iPhone7,1": @(DeviceAppleiPhone6_Plus),
             @"iPhone7,2": @(DeviceAppleiPhone6),
             @"iPhone8,1": @(DeviceAppleiPhone6S),
             @"iPhone8,2": @(DeviceAppleiPhone6S_Plus),
             @"iPad1,1": @(DeviceAppleiPad),
             @"iPad2,1": @(DeviceAppleiPad2),
             @"iPad3,1": @(DeviceAppleiPad3G),
             @"iPad3,4": @(DeviceAppleiPad4G),
             @"iPad2,5": @(DeviceAppleiPadMini),
             @"iPad4,1": @(DeviceAppleiPad5G_Air),
             @"iPad4,2": @(DeviceAppleiPad5G_Air),
             @"iPad4,4": @(DeviceAppleiPadMini2G),
             @"iPad4,5": @(DeviceAppleiPadMini2G)
             };
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
    NTNUDeviceType phoneModel = [IDMPDevice ntnu_deviceType];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *os = [NSString stringWithFormat:@"%@ %@",systemName,systemVersion];
    NSString *operatorCode = [IDMPDevice getOperatorCode];
    
    NSArray *DeviceAppleArray = [NSArray arrayWithObjects:@"DeviceAppleUnknown",@"DeviceAppleSimulator",@"DeviceAppleiPhone",@"DeviceAppleiPhone3G",@"DeviceAppleiPhone3GS",@"DeviceAppleiPhone4",@"DeviceAppleiPhone4S",@"DeviceAppleiPhone5",@"DeviceAppleiPhone5C",@"DeviceAppleiPhone5S",@"DeviceAppleiPhone6",@"DeviceAppleiPhone6_Plus",@"DeviceAppleiPhone6S",@"DeviceAppleiPhone6S_Plus",@"DeviceAppleiPodTouch",@"DeviceAppleiPodTouch2G",@"DeviceAppleiPodTouch3G",@"DeviceAppleiPodTouch4G",@"DeviceAppleiPad",@"DeviceAppleiPad2",@"DeviceAppleiPad3G",@"DeviceAppleiPad4G",@"DeviceAppleiPad5G_Air",@"DeviceAppleiPadMini",@"DeviceAppleiPadMini2G", nil];
    
    if (!CollectDeviceDataDictionary)
    {
        CollectDeviceDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    
    [CollectDeviceDataDictionary setObject:openUDID forKey:kopenUDID];
    [CollectDeviceDataDictionary setObject:IDFV forKey:kIDFV];
    [CollectDeviceDataDictionary setObject:DeviceAppleArray[(unsigned long)phoneModel] forKey:kphoneModel];
    [CollectDeviceDataDictionary setObject:os forKey:kos];
    
    if(operatorCode)
    {
        [CollectDeviceDataDictionary setObject:operatorCode forKey:kmnc];
    }
    else
    {
        [CollectDeviceDataDictionary setObject:@"" forKey:kmnc];
    }
    
    NSString *wifiSSID = [IDMPDevice getWiFiSSID];
    if (wifiSSID) {
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
    
    NSLog(@"RC_data:%@",RC_data);
    return RC_data;
}


@end
