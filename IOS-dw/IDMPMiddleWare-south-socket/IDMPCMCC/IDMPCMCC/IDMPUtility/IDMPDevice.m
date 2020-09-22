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
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NSData+IDMPAdd.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTCellularData.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <sys/sysctl.h>
#import "IDMPCellularData.h"
#import "userInfoStorage.h"

NSMutableDictionary *CollectDeviceDataDictionary = nil;

//设备参数文本
#define kIDFV @"idfv"
#define ksystemVersion @"systemVersion"
#define kos @"os"
#define kphoneModel @"dev_model"
#define kwifiSSID @"wifi_ssid"
#define kmnc @"mnc"
#define deviceIdsk @"deviceId"

@implementation IDMPDevice

#pragma mark -----获取运营商标识-----
+ (NSString *)getOperatorNetworkCode:(CTCarrier *)carrier {
    NSString *networkCode = [carrier mobileNetworkCode];
    NSLog(@"current network code is %@", networkCode);
    return networkCode;
}

+ (NSString *)getOperatorCountryCode:(CTCarrier *)carrier {
    NSString *countryCode = [carrier mobileCountryCode];
    NSLog(@"current country code is %@", countryCode);
    return countryCode;
}

+ (CTCarrier *)getCarrier {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return carrier;
}


+ (OperatorName)getChinaOperatorName {
    CTCarrier *carrier = [self getCarrier];
    NSString *countryCode = [self getOperatorCountryCode:carrier];
    if ([countryCode isEqualToString:@"460"]) {
        NSString *code = [self getOperatorNetworkCode:carrier];
        if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
            return CMCC;
        }
        if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
            return CUCC;
        }
        if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"] || [code isEqualToString:@"11"]) {
            return CTCC;
        }
    } else {
        NSString *carrierName = [carrier carrierName];
        
        if ([carrierName isEqualToString:@"中国移动"]) {
            return CMCC;
        } else if ([carrierName isEqualToString:@"中国联通"]) {
            return CUCC;
        } else if ([carrierName isEqualToString:@"中国电信"]) {
            return CTCC;
        }
    }
    
    return Unkown;
}

+(BOOL)checkChinaMobile {
    return [self getChinaOperatorName] == CMCC ? YES : NO;
}

+(BOOL)simExist {
    CTCarrier *carrier = [self getCarrier];
    if ([self getOperatorCountryCode:carrier]) {
        return YES;
    } else if ([carrier carrierName]) {
        return YES;
    }
    return NO;
}

#pragma mark -----deviceid-----
+(NSString *)getDeviceID {
    static NSString *deviceId = nil;
    if (deviceId) {
        return deviceId;
    }
    NSString *deviceIdInCache = (NSString *)[userInfoStorage getInfoWithKey:deviceIdsk];
    if (deviceIdInCache) {
        deviceId = deviceIdInCache;
        return deviceIdInCache;
    } else {
        NSString *newDeviceId =[[UIDevice currentDevice].identifierForVendor UUIDString];
        [userInfoStorage setInfo:newDeviceId withKey:deviceIdsk];
        deviceId = newDeviceId;
        return newDeviceId;
    }
}

#pragma mark -----net statuts-----
+(NetworkStatus)GetCurrntNet {
    secReachability *r = [secReachability reachabilityWithHostName:@"www.baidu.com"];
    return [r currentReachabilityStatus];
}

#pragma mark -----check cellular status-----
+(BOOL)checkCellular {
    struct ifaddrs* interfaces = NULL;
    struct ifaddrs* temp_addr = NULL;
    
    // retrieve the current interfaces - returns 0 on success
    NSInteger success = getifaddrs(&interfaces);
    NSInteger pdpip0Count = 0;
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            NSString* name = [NSString stringWithUTF8String:temp_addr->ifa_name];
            
//            NSString *address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//            NSLog(@" Name:%@   IP:%@",name,address);
            if ([name isEqualToString:@"pdp_ip0"]) {
                pdpip0Count++;
            }
            
            temp_addr = temp_addr->ifa_next;
            
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    if (pdpip0Count > 1) {
        return YES;
    }
    return NO;
}

+(BOOL)hasCellularAuthority {
    BOOL authority = NO;
#if TARGET_IPHONE_SIMULATOR
    return authority;
#elif TARGET_OS_IPHONE
    static BOOL hasNotifier = NO;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0) {
        __block IDMPCellularData *cellularData = [IDMPCellularData shareInstance];
        if (!hasNotifier) {
            __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
                            dispatch_semaphore_signal(sema);
                hasNotifier = YES;
            };
            dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
        }

        CTCellularDataRestrictedState state = cellularData.restrictedState;
        switch (state) {
            case kCTCellularDataRestricted:
                NSLog(@"Restricrted");
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                authority = YES;
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        }
    } else {
        authority = YES;
    }
    return authority;
#endif
}


#pragma mark -----获得设备型号-----
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
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhoneX";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhoneX";
    
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




#pragma mark -----越狱检测-------
+ (BOOL)checkJailbroken
{
    //以下检测的过程是越往下，越狱越高级
    
    //    /Applications/Cydia.app, /privte/var/stash
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        return YES;
        
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        return YES;
    }
    
    //可能存在hook了NSFileManager方法，此处用底层C stat去检测
    struct stat stat_info;
    if (0 == stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &stat_info)) {
        return YES;
    }
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        return YES;
    }
    if (0 == stat("/var/lib/cydia/", &stat_info)) {
        return YES;
    }
    if (0 == stat("/var/cache/apt", &stat_info)) {
        return YES;
    }
    //    /Library/MobileSubstrate/MobileSubstrate.dylib 最重要的越狱文件，几乎所有的越狱机都会安装MobileSubstrate
    //    /Applications/Cydia.app/ /var/lib/cydia/绝大多数越狱机都会安装
    //    /var/cache/apt /var/lib/apt /etc/apt
    //    /bin/bash /bin/sh
    //    /usr/sbin/sshd /usr/libexec/ssh-keysign /etc/ssh/sshd_config
    
    //可能存在stat也被hook了，可以看stat是不是出自系统库，有没有被攻击者换掉
    //这种情况出现的可能性很小
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *,struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        NSLog(@"lib:%s",dylib_info.dli_fname);      //如果不是系统库，肯定被攻击了
        if (strcmp(dylib_info.dli_fname, "/usr/lib/system/libsystem_kernel.dylib")) {   //不相等，肯定被攻击了，相等为0
            return YES;
        }
    }
    
    //还可以检测链接动态库，看下是否被链接了异常动态库，但是此方法存在appStore审核不通过的情况，这里不作罗列
    //通常，越狱机的输出结果会包含字符串： Library/MobileSubstrate/MobileSubstrate.dylib——之所以用检测链接动态库的方法，是可能存在前面的方法被hook的情况。这个字符串，前面的stat已经做了
    
    //如果攻击者给MobileSubstrate改名，但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库
    //那么可以，检测当前程序运行的环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        return YES;
    }
    
    return NO;
}



+ (NSString *)getSystemName {
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *os = [NSString stringWithFormat:@"%@ %@",systemName,systemVersion];
    return os;
}




#pragma mark -------采集数据接口--------
+ (void)collectUserDeviceData
{
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *phoneModel = [IDMPDevice getCurrentDeviceModel];
    NSString *os = [IDMPDevice getSystemName];
    NSString *operatorCode = [IDMPDevice getOperatorNetworkCode:[self getCarrier]];
    
    if (!CollectDeviceDataDictionary)
    {
        CollectDeviceDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    
    [CollectDeviceDataDictionary setObject:IDFV forKey:kIDFV];
    [CollectDeviceDataDictionary setObject:phoneModel forKey:kphoneModel];
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
        NSString *base64_wifissid = [data_wifissid idmp_base64Encoding];
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

