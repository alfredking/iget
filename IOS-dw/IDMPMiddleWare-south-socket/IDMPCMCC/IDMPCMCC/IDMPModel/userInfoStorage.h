//
//  userInfoStorage.h
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/12.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface userInfoStorage : NSObject


/**
 保存信息到静态字典，文件与keychain

 @param userInfo 键
 @param key 值
 @return 保存状态
 */
+(BOOL)setInfo:(NSObject *)userInfo withKey:(NSString *)key;


/**
 从静态字典，文件与keychain获取信息

 @param key 值
 @return 键
 */
+(NSObject *)getInfoWithKey:(NSString *)key;


/**
 从静态字典，文件与keychain删除信息

 @param key 值
 @return 删除状态
 */
+(BOOL)removeInfoWithKey:(NSString *)key;


/**
 KeyChain set

 @param info value
 @param key key
 @return 存储结果
 */
//+(BOOL)setAppInfo:(NSObject *)info withKey:(NSString *)key;

/**
 KeyChain get

 @param key key
 @return 获取的value
 */
//+(NSObject *)getAppInfoWithKey: (NSString *)key;


/**
 KeyChain delete

 @param key key
 @return 删除结果
 */
//+(BOOL)removeAppInfoWithKey:(NSString *)key;


@end
