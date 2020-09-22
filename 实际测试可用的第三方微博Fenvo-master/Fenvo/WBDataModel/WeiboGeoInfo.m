//
//  WeiboGeoInfo.m
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import "WeiboGeoInfo.h"
/*
 返回值字段	字段类型	字段说明
 longitude	string	经度坐标
 latitude	string	维度坐标
 city	string	所在城市的城市代码
 province	string	所在省份的省份代码
 city_name	string	所在城市的城市名称
 province_name	string	所在省份的省份名称
 address	string	所在的实际地址，可以为空
 pinyin	string	地址的汉语拼音，不是所有情况都会返回该字段
 more	string	更多信息，不是所有情况都会返回该字段
 */
@implementation WeiboGeoInfo
-(WeiboGeoInfo *)initWithDictionary:(NSDictionary *)geo{
    if(geo != nil || geo.allKeys.count != 0){
    self.longitude = geo[@"longitude"];
    self.latitude = geo[@"latitude"];
    self.city = geo[@"city"];
    self.province = geo[@"province"];
    self.city_name = geo[@"city_name"];
    self.province_name = geo[@"province_name"];
    self.address = geo[@"address"];
    self.pinyin = geo[@"pinyin"];
    self.more = geo[@"more"];
    }
    return  self;
}
@end
