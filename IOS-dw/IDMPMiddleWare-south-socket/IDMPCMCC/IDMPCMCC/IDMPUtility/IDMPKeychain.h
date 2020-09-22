//
//  IDMPKeychain.h
//  IDMPCMCC
//
//  Created by wj on 2018/1/23.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPKeychain : NSObject

//查询
+ (NSObject *)getDataForAccount:(NSString *)account;
+ (NSObject *)getDataForAccount:(NSString *)account service:(NSString *)service;


//存储
+ (BOOL)setData:(NSObject *)data account:(NSString *)account;
+ (BOOL)setData:(NSObject *)data account:(NSString *)account service:(NSString *)service;

//删除
+ (BOOL)deleteDataForAccount:(NSString *)account;
+ (BOOL)deleteDataForAccount:(NSString *)account service:(NSString *)service;


#define PublicKeyTag @"cmccKomectSecRSAUtil_PubKey"
#define PrivateKeyTag @"cmccKomectSecRSAUtil_PrivKey"

+ (SecKeyRef)addPublicKey:(NSString *)key;
+ (SecKeyRef)addPrivateKey:(NSString *)key;
@end
