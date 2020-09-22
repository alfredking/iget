//
//  WeiboGeoInfo.h
//  Fenvo
//
//  Created by Caesar on 15/3/28.
//  Copyright (c) 2015年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboGeoInfo : NSObject
//longitude	string	经度坐标
@property (nonatomic, copy)NSString *longitude;
//latitude	string	维度坐标
@property (nonatomic, copy)NSString *latitude;
//city	string	所在城市的城市代码
@property (nonatomic, copy)NSString *city;
//province	string	所在省份的省份代码
@property (nonatomic, copy)NSString *province;
//city_name	string	所在城市的城市名称
@property (nonatomic, copy)NSString *city_name;
//province_name	string	所在省份的省份名称
@property (nonatomic, copy)NSString *province_name;
//address	string	所在的实际地址，可以为空
@property (nonatomic, copy)NSString *address;
//pinyin	string	地址的汉语拼音，不是所有情况都会返回该字段
@property (nonatomic, copy)NSString *pinyin;
//more	string	更多信息，不是所有情况都会返回该字段
@property (nonatomic, copy)NSString *more;

-(WeiboGeoInfo *)initWithDictionary:(NSDictionary *)geo;
@end
