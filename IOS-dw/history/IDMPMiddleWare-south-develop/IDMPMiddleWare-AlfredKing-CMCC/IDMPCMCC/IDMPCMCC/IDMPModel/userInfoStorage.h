//
//  userInfoStorage.h
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface userInfoStorage : NSObject

+(BOOL)setInfo:(NSObject *)userInfo withKey:(NSString *)key;
+(NSObject *)getInfoWithKey:(NSString *)key;
+(BOOL)removeInfoWithKey:(NSString *)key;
+(BOOL)setAppInfo:(NSObject *)info withKey:(NSString *)key;
+(NSObject *)getAppInfoWithKey: (NSString *)key;
+(BOOL)removeAppInfoWithKey:(NSString *)key;


@end
