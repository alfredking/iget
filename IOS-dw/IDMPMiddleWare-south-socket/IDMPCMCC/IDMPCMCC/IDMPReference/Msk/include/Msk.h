//
//  Msk.h
//  msk
//
//  Created by wanggp on 2017/8/17.
//  Copyright © 2017年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mskdb.h"
#import "MskResponse.h"

@interface Msk : NSObject

@property (strong,nonatomic) NSString *name;

- (id)initWithName:(NSString *)name;

/**
 * 生成对称密钥
 *
 * @param index        密钥索引(1~SYMM_MAX_NUM)
 * @param alg_type      密钥类型
 * @param key_attr 密钥属性
 * @return 错误码
 */
-(MskResponse *) symmGenKey:(int)index alg_type:(SYMM_ALG_TYPE)alg_type key_attr:(KEY_ATTR)key_attr;

/**
 * 更新对称密钥
 *
 * @param index 密钥索引(1~SYMM_MAX_NUM)
 * @return 错误码
 */
-(MskResponse *)symmUpdateKey:(int) index;

/**
 * 删除对称密钥
 *
 * @param index 密钥索引(1~SYMM_MAX_NUM)
 * @return 错误码
 */
- (MskResponse *)symmDeleteKey:(int) index;

/**
 * 导入对称密钥
 *
 * @param index        密钥索引
 * @param symmAlg      密钥类型
 * @param keyAttribute 密钥属性
 * @param kv           密钥值
 * @param cv           校验值
 * @return 错误码
 */
- (MskResponse *)symmInputKey:(int)index symmAlg:(SYMM_ALG_TYPE)symmAlg KeyAttribute:(KEY_ATTR)keyAttribute kv:(NSString *)kv cv:(NSString *) cv;


/**
 * 导出对称密钥
 *
 * @param index 密钥索引(1~SYMM_MAX_NUM)
 * @return 导出的对称密钥
 */
- (MskResponse *) symmOutputKey:(int) index;

/**
 * 生成非对称密钥
 *
 * @param index        密钥索引(1~ASYMM_MAX_NUM)
 * @param asymmAlg     密钥类型
 * @param key_attr 密钥属性
 * @return 错误码
 */
-(MskResponse *)asymmGenKeyPair:(int)index asymmAlg:(ASYMM_ALG_TYPE) asymmAlg key_attr:(KEY_ATTR)key_attr;

/**
 * 更新非对称密钥
 *
 * @param index 密钥索引(1~ASYMM_MAX_NUM)
 * @return 错误码
 */
- (MskResponse *) asymmUpdateKeyPair:(int) index;

/**
 * 删除非对称密钥
 *
 * @param index 密钥索引(1~ASYMM_MAX_NUM)
 * @return 错误码
 */
- (MskResponse *)asymmDeleteKeyPair:(int) index;

/**
 * 导入非对称公钥
 *
 * @param index        密钥索引(1~ASYMM_MAX_NUM)
 * @param asymmAlg     密钥算法
 * @param keyAttribute 密钥属性
 * @param pk           公钥
 * @return 错误码
 */
- (MskResponse *) asymmInputPublicKey:(int) index  asymmAlg:(ASYMM_ALG_TYPE)asymmAlg keyAttribute:(KEY_ATTR)keyAttribute pk:(NSString *)pk;

/**
 * 导出非对称公钥
 *
 * @param index 密钥索引(1~ASYMM_MAX_NUM)
 * @return 非对称公钥
 */
- (MskResponse *)asymmOutputPublicKey:(int) index;

/**
 * 对称密钥加密数据
 *
 * @param index 密钥索引(1~SYMM_MAX_NUM)
 * @param data  待加密的数据
 * @return 密文对象
 */
- (MskResponse *)symmEncrypt:(int)index data:(NSString *)data DEPRECATED_MSG_ATTRIBUTE("本方法已经过期，请使用 - (MskResponse *)symmEncrypt:(int)index binaryData:(NSData *)data");
- (MskResponse *)symmEncrypt:(int)index binaryData:(NSData *)data;

/**
 * 对称密钥解密数据
 *
 * @param index 密钥索引(1~SYMM_MAX_NUM)
 * @param data  待解密的数据（2进制数）
 * @return 通用结果对象
 */
-(MskResponse*)symmDecrypt:(int)index data:(NSData *)data;

/**
 * 对称密钥转加密数据
 *
 * @param oriIndex 源密钥索引(1~SYMM_MAX_NUM)
 * @param desIndex 目的密钥索引(1~SYMM_MAX_NUM)
 * @param data     待转加密的数据（2进制数）
 * @return 通用结果对象
 */
-(MskResponse *)symmTransferEncrypt:(int)oriIndex desIndex:(int)desIndex data:(NSData *)data;

/**
 * 非对称密钥签名
 *
 * @param index     密钥索引(1~ASYMM_MAX_NUM)
 * @param fill_mode 填充模式
 * @param hashID    HASH标识
 * @param userID    用户标识
 * @param data      签名数据（2进制数）
 * @return 通用结果对象
 */
-(MskResponse *)asymmSign:(int)index fill_mode:(DATA_FILL_MODE)fill_mode hashID:(NSString *)hashID userID:(NSString *)userID  data:(NSData *)data;

/**
 * 非对称密钥验签
 *
 * @param index     密钥索引(1~ASYMM_MAX_NUM)
 * @param fill_mode 填充模式
 * @param hashID    HASH标识
 * @param userID    用户标识
 * @param data      签名数据（2进制数）
 * @param sign      签名值
 * @return 通用结果对象
 */
-(MskResponse *)asymmVerify:(int)index  fill_mode:(DATA_FILL_MODE)fill_mode hashID:(NSString *)hashID userID:(NSString *)userID data:(NSString *)data sign:(NSString *)sign DEPRECATED_MSG_ATTRIBUTE("本方法已经过期，请使用 -(MskResponse *)asymmVerify:(int)index  fill_mode:(DATA_FILL_MODE)fill_mode hashID:(NSString *)hashID userID:(NSString *)userID binaryData:(NSData *)data sign:(NSString *)sign");
-(MskResponse *)asymmVerify:(int)index  fill_mode:(DATA_FILL_MODE)fill_mode hashID:(NSString *)hashID userID:(NSString *)userID binaryData:(NSData *)data sign:(NSString *)sign;

/**
 * 非对称密钥加密数据
 *
 * @param index     密钥索引(1~ASYMM_MAX_NUM)
 * @param fill_mode 填充方式
 * @param data      待加密的数据（2进制数）
 * @return 通用结果对象
 */
-(MskResponse *)asymmEncrypt:(int)index fill_mode:(DATA_FILL_MODE)fill_mode data:(NSData *)data;


/**
 * 非对称密钥解密数据
 *
 * @param index     密钥索引(1~ASYMM_MAX_NUM)
 * @param fill_mode 填充方式
 * @param data      待解密的数据（2进制数）
 * @return 通用结果对象
 */
-(MskResponse *) asymmDecrypt:(int)index fill_mode:(DATA_FILL_MODE)fill_mode data:(NSData *)data;
/**
 * 导入OTP的种子
 *
 * @param otpLen   口令长度，4-12位
 * @param cycle    口令变化周期，建议120秒
 * @param wnd      窗口期，建议是2
 * @param seed_len 种子长度，字节表示
 * @param seed     OTP种子(0~9A~F)，使用MK1保护
 * @return 错误码
 */
-(MskResponse *)otpInputSeed:(int)otpLen cycle:(int)cycle wnd:(int)wnd seed_len:(int)seed_len seed:(NSString*) seed;

/**
 * 生成动态口令
 *
 * @param autoCode 认证码
 * @return 动态口令对象
 */
-(MskResponse *)otpGen:(NSString*) autoCode;


/**
 * 验证动态口令
 *
 * @param autoCode 认证码
 * @param opt      动态口令
 * @return 偏移时间对象
 */
-(MskResponse *)otpVerify:(NSString*)autoCode opt:(NSString *)opt;
/**
 * 数据存储
 *
 * @param index 数据存储的位置(1~DATA_MAX_NUM)
 * @param data  待存储的数据
 * @return 错误码
 */
-(MskResponse *)dataStore:(int)index data:(NSData *)data;

/**
 * 读取数据
 *
 * @param index 数据存储的位置(1~DATA_MAX_NUM)
 * @return 读取数据对象
 */
-(MskResponse *)dataRead:(int) index;

/**
 * 删除数据
 *
 * @param index 数据存储的位置(1~DATA_MAX_NUM)
 * @return 错误码
 */
-(MskResponse*) dataDelete:(int) index;

/**
 * 清除所有数据
 *
 * @return 错误码
 */
-(MskResponse *)dataClear;

/**
 * sm3摘要
 * @param data 待计算数据
 * @param len  数据长度
 * @return 摘要结果
 */
- (MskResponse *)sm3:(NSData *)data len:(int)len;

// 获取PIN的随机数0-F
- (MskResponse *) getPinRandom;


-(MskResponse *)inputPinChar:(NSString *)pinStr;

// 删除一个字符的PIN，返回值是当前的PIN长度
-(MskResponse *) deletePinChar;

// 清除所有PIN
-(MskResponse *)  clearPinhar;


-(MskResponse *) getCipher:(NSString *)msk_name index:(int)index;

/**
 EER2 平台接口对接加密格式

 @param msk_name 库名
 @param index 索引
 @param rs 服务端随机数
 @return 通过 result 获取密文字符串：客户端随机数密文 + "|" + 密码密文
 */
-(MskResponse *) getCipher:(NSString *)msk_name index:(int)index serverRandom:(NSString *)rs;


/**
 数字信封解密

 @param index 私钥索引值
 @param zekByPK 公钥加密的 ZEK
 @param data ZEK 加密的密文
 @return 解密后的明文
 */
- (MskResponse *) digitalEnvelopeDecrypt:(int) index ZEKByPK:(NSString *) zekByPK data:(NSData *) data;


/**
 数字信封加密

 @param index 公钥索引值
 @param data 数据明文，数据必须是填充好的数据，国际算法填充到 8 的倍数，国密算法填充到 16 的倍数
 @return 加密后的 ZEK 和数据密文
 */
- (MskResponse *) digitalEnvelopeEncrypt:(int) index data:(NSData *) data;

@end
