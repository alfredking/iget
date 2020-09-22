//
//  MskManager.h
//  msk
//
//  Created by wanggp on 2017/8/17.
//  Copyright © 2017年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Msk.h"
#import "MskResponse.h"
#import "NSString+Extension.h"

@interface MskManager : NSObject

+(instancetype) shareInstance ;

/**
 * 获取设备唯一ID
 * @return 设备唯一ID
 */
-(NSString*)getDevId;

/**
 * 创建msk库
 * @param name  库名
 * @param pk    公钥
 * @return      创建结果
 */
-(MskResponse*)createMsk:(NSString *)name pk:(NSString *)pk pin:(NSString*)pin;

/**
 * 创建msk库
 * @param pk    公钥
 * @param pin   pin
 * @return      创建结果
 */
-(MskResponse*)createMskWithPK:(NSString *)pk pin:(NSString*)pin;

/**
 * 删除msk库
 * @param name  msk库名
 * @param pin   pin值
 * @return       错误码
 */
-(MskResponse*)deleteMsk:(NSString *)name pin:(NSString *)pin;

/**
 * 删除默认msk库
 * @param pin   pin值
 * @return      错误码
 */
-(MskResponse *) deleteMsk:(NSString *)pin;

-(Msk*)getMsk:(NSString *) name;


/**
 检查 MSK 是否存在

 @param name MSK 的名字
 @return YES 存在 NO 不存在
 */
- (BOOL) isExist:(NSString *) name;

@end
