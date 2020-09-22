//
//  secFileStorage.h
//  IDMPCMCC
//
//  Created by alfredking－cmcc on 16/7/11.
//  Copyright © 2016年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface secFileStorage : NSObject


/**
 保存信息到文件

 @param userInfo 信息
 @param fileError 错误
 @return 保存结果
 */
+(BOOL)setUserInfo:(NSDictionary *)userInfo withError:(NSError **)fileError;


/**
 从文件获取信息

 @param fileError 错误
 @return 获取到的信息
 */
+(NSDictionary *)getUserInfoWithError:(NSError **)fileError;


/**
 获得加密文件的密钥

 @return 密钥
 */
+(NSString *)getEncrptKey;

@end
