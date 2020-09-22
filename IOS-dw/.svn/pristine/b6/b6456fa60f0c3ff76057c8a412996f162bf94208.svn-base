//
//  IDMPRusultHandler.h
//  IDMPCMCC
//
//  Created by wj on 2017/8/28.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^accessBlock)(NSDictionary *paraments);

typedef NS_ENUM(NSInteger, IDMPAuthType) {
    IDMPWP = 1 << 0,
    IDMPHS = 1 << 1,
    IDMPUP = 1 << 2,
    IDMPDUP= 1 << 3,
    IDMPVUP= 1 << 4

};

@interface IDMPRusultHandler : NSObject

/**
 处理认证结果

 @param wwwauthenticate 服务端返回的认证结果
 @param userName 用户名， 认证类型为IDMPUP，IDMPDUP时必传，认证类型为IDMPWP，IDMPHS时传nil
 @param authType 认证类型
 @param sipinfo sip信息
 @param traceId traceId
 @param successBlock 成功回调
 @param failBlock 失败回调
 */
+ (void)getRusultByHandlerWWWAuthenticate:(NSDictionary *)wwwauthenticate userName:(NSString *)userName authType:(NSInteger)authType sipinfo:(NSString *)sipinfo traceId:(NSString *)traceId successBlock:(accessBlock)successBlock failBlock:(accessBlock)failBlock;

@end
