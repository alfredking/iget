//
//  secFileStorage.h
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface secFileStorage : NSObject

+(BOOL)setUserInfo:(NSDictionary *)userInfo;
+(NSDictionary *)getUserInfo;


@end
