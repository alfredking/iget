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


/**
 KeyChain set

 @param info value
 @param key key
 @return 存储结果
 */
+(BOOL)setAppInfo:(NSObject *)info withKey:(NSString *)key;

/**
 KeyChain get

 @param key key
 @return 获取的value
 */
+(NSObject *)getAppInfoWithKey: (NSString *)key;


/**
 KeyChain delete

 @param key key
 @return 删除结果
 */
+(BOOL)removeAppInfoWithKey:(NSString *)key;


@end
