//
//  WeiboGeoInfo.m
//  Fenvo
//
//  Created by Caesar on 15/7/19.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboGeoInfo.h"


@implementation WeiboGeoInfo

@dynamic address;
@dynamic city;
@dynamic city_name;
@dynamic latitude;
@dynamic longitude;
@dynamic more;
@dynamic pinyin;
@dynamic province;
@dynamic province_name;

+ (WeiboGeoInfo *)createdByDictionary:(NSDictionary *)geo{
    WeiboGeoInfo *geoInfo = [WeiboGeoInfo createdInCoreData];
    
    if(geo != nil || geo.allKeys.count != 0){
        geoInfo.longitude = [NSNumber numberWithDouble:[geo[@"longitude"] doubleValue]];
        geoInfo.latitude = [NSNumber numberWithDouble:[geo[@"latitude"] doubleValue]];
        geoInfo.city = geo[@"city"];
        geoInfo.province = geo[@"province"];
        geoInfo.city_name = geo[@"city_name"];
        geoInfo.province_name = geo[@"province_name"];
        geoInfo.address = geo[@"address"];
        geoInfo.pinyin = geo[@"pinyin"];
        geoInfo.more = geo[@"more"];
    }
    
    return geoInfo;
}

+ (WeiboGeoInfo *)createdInCoreData {
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = application.delegate;
    NSManagedObjectContext *managedObjectContext = [delegate managedObjectContext];
    WeiboGeoInfo *geoInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([WeiboGeoInfo class]) inManagedObjectContext:managedObjectContext];
    
    return geoInfo;
}
@end
