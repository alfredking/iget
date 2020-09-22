#ifndef _MSKDB_H_
#define _MSKDB_H_

#include "msk_errno.h"

typedef enum
{
	SM4,
	DES_64,
	DES_128,
	DES_192,
	AES_128,
	AES_192,
	AES_256
} SYMM_ALG_TYPE;

typedef enum
{
	SM2,
	RSA_512_3,
	RSA_512_65537,
	RSA_768_3,
	RSA_768_65537,
	RSA_1024_3,
	RSA_1024_65537,
	RSA_1152_3,
	RSA_1152_65537,
	RSA_1408_3,
	RSA_1408_65537,
	RSA_1984_3,
	RSA_1984_65537,
	RSA_2048_3,
	RSA_2048_65537,
	RSA_3072_3,
	RSA_3072_65537,
	RSA_4096_3,
	RSA_4096_65537
} ASYMM_ALG_TYPE;

typedef enum
{
	KEY_ATTR_NULL,
	KEY_ATTR_IN,
	KEY_ATTR_OUT,
	KEY_ATTR_IN_AND_OUT
} KEY_ATTR;

typedef enum
{
	DATA_FILL_MODE_NULL,
	DATA_FILL_MODE_FRONT_ZERO,
	DATA_FILL_MODE_REAR_ZERO,
	DATA_FILL_MODE_PKCS
} DATA_FILL_MODE;

/***********************************************************
  功能:
	设置MSK的目录
  参数:
	dir[in]		目录
	devid[in]	设备ID
	sign[in]	APK签名
  返回值:
	无
 ***********************************************************/
void mskdb_info(const char *dir,const char *devid,const char *sign);
char *mskdb_get_devid();

/***********************************************************
  功能:
	创建新的MSK库
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	pk[in]			SM2公钥(0~9A~F),保护MK输出
	pin[in]			pin，要删除对称密钥库时使用
	mk[out]			MK密钥（SM4）,使用PK保护
	cv[out]			CV密钥检验值
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int mskdb_new(const char *msk_name,const char *pk, const char *pin, char *mk, char *cv);

/***********************************************************
  功能:
	删除MSK库
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	pin[in]			16位的pin，要删除对称密钥库时使用
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int mskdb_delete(const char *msk_name,const char *pin);

/***********************************************************
  功能:
	检查MSK库是否存在
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
  返回值:
	1	存在
	0	不存在
 ***********************************************************/
int mskdb_check(const char *msk_name);

/***********************************************************
  功能:
	显示MSK库
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	fp[in]			文件句柄
  返回值:
	无
 ***********************************************************/
void mskdb_print(const char *msk_name,FILE *fp);

/***********************************************************
  功能:
	生成对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
	alg_type[in]		密钥类型
	key_attr[in]            密钥属性
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_gen(const char *msk_name,unsigned int index,SYMM_ALG_TYPE alg_type, KEY_ATTR key_attr);

/***********************************************************
  功能:
	更新对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_update(const char *msk_name,unsigned int index);

/***********************************************************
  功能:
	删除对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_delete(const char *msk_name,unsigned int index);

/***********************************************************
  功能:
	导入对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
	alg_type[in]		密钥类型
	key_attr[in]            密钥属性
	kv[in]			密钥值(0~9A~F)，使用MK1保护
	cv[in]			校验值(0~9A~F)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_input(const char *msk_name,unsigned int index,SYMM_ALG_TYPE alg_type, KEY_ATTR key_attr, const char *kv, const char *cv);

/***********************************************************
  功能:
	导出对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
	alg_type[out]		密钥类型
	key_attr[out]		密钥属性
	kv[out]			密钥值(0~9A~F)，使用MK1保护
	cv[out]			校验值(0~9A~F)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_output(const char *msk_name,unsigned int index,SYMM_ALG_TYPE *alg_type, KEY_ATTR *key_attr, char *kv, char *cv);

/***********************************************************
  功能:
	对称密钥加密数据
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
	data[in]                待加密的数据（2进制数）
	data_len[in]		数据长度
	result[out]            	加密结果（2进制数）
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_encrypt(const char *msk_name,unsigned int index,const unsigned char *data,int data_len,unsigned char *result);

/***********************************************************
  功能:
	对称密钥解密数据
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~SYMM_MAX_NUM)
	data[in]                待加密的数据（2进制数）
	data_len[in]		数据长度
	result[out]            	加密结果（2进制数）
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_decrypt(const char *msk_name,unsigned int index,const unsigned char *data,int data_len,unsigned char *result);

/***********************************************************
  功能:
	对称密钥转加密数据
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	ori_index[in]		源密钥索引(1~SYMM_MAX_NUM)
	des_index[in]		目的密钥索引(1~SYMM_MAX_NUM)
	data[in]                待转加密的数据（2进制数）
	data_len[in]		数据长度
	result[out]            	转加密结果（2进制数）
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int symm_transfer_encrypt(const char *msk_name,unsigned int ori_index,unsigned int des_index,const unsigned char *data,int data_len,unsigned char *result);

/***********************************************************
  功能:
	生成非对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	alg_type[in]		密钥类型
	key_attr[in]            密钥属性
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_gen(const char *msk_name,unsigned int index, ASYMM_ALG_TYPE alg_type, KEY_ATTR key_attr);

/***********************************************************
  功能:
	更新非对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_update(const char *msk_name,unsigned int index);

/***********************************************************
  功能:
	删除非对称密钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_delete(const char *msk_name,unsigned int index);

/***********************************************************
  功能:
	导出非对称公钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	alg_type[out]		密钥类型
	key_attr[out]		密钥属性
	pk[out]			密钥值(0~9A~F)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_output_pk(const char *msk_name,unsigned int index,ASYMM_ALG_TYPE *alg_type, KEY_ATTR *key_attr, char *pk);

/***********************************************************
  功能:
	导入非对称公钥
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	alg_type[in]		密钥类型
	key_attr[in]            密钥属性
	pk[in]			公钥值(0~9A~F)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_input_pk(const char *msk_name,unsigned int index,ASYMM_ALG_TYPE alg_type, KEY_ATTR key_attr, const char *pk);

/***********************************************************
  功能:
	非对称签名
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	fill_mode[in]		数据填充方式
					0：不填充，
					1：填充0，
					2：pkcs填充方式
	hashID[in]		HASH算法标识
					可选，如果不采用HASH，则为NULL
					01：SHA-1 sha1withrsa
					02：MD5 md5withrsa
					03：SM3，当密钥为SM2密钥时才可用
					04：SHA256 sha256withrsa
					11：SHA1
					12：MD5
					14：SHA256
	userID[in]		用户ID，只有为SM2算法且hashID不为NULL时才需要
	data_len[in]		签名数据长度
	data[in]		签名数据
	sign[out]		签名结果
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_sign(const char *msk_name,unsigned int index,unsigned int fill_mode, const char *hashID, const char *userID, int data_len, const unsigned char *data, char* sign);

/***********************************************************
  功能:
	非对称验签
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	fill_mode[in]		数据填充方式
					0：不填充，
					1：填充0，
					2：pkcs填充方式
	hashID[in]		HASH算法标识
					可选，如果不采用HASH，则为NULL
					01：SHA-1 sha1withrsa
					02：MD5 md5withrsa
					03：SM3，当密钥为SM2密钥时才可用
					04：SHA256 sha256withrsa
					11：SHA1
					12：MD5
					14：SHA256
	userID[in]		用户ID，只有为SM2算法且hashID不为NULL时才需要
	data_len[in]		签名数据长度
	data[in]		签名数据
	sign[in]		签名
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_verify(const char *msk_name,unsigned int index,unsigned int fill_mode, const char *hashID, const char *userID, int data_len, const unsigned char *data, const char *sign);

/***********************************************************
  功能:
	非对称公钥加密
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	fill_mode[in]		数据填充方式
					0：不填充，
					1：填充0，
					2：pkcs填充方式
	data[in]		待加密数据
	data_len[in]		待加密数据长度
	result[out]		加密结果
	len[out]		加密结果的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_encrypt(const char *msk_name,unsigned int index, unsigned int fill_mode, const unsigned char *data, int data_len, unsigned char *result, unsigned int *len);

/***********************************************************
  功能:
	非对称私钥解密
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		密钥索引(1~ASYMM_MAX_NUM)
	fill_mode[in]		数据填充方式
					0：不填充，
					1：填充0，
					2：pkcs填充方式
	data[in]		待解密数据
	data_len[in]		待解密数据长度
	result[out]		解密结果
	len[out]		解密结果的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int asymm_decrypt(const char *msk_name,unsigned int index, unsigned int fill_mode, const unsigned char *data, int data_len, unsigned char *result, unsigned int *len);

/***********************************************************
  功能:
	导入OTP的种子
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	otp_len[in]		口令长度，4-12位
	cycle[in]		口令变化周期，建议120秒
	wnd[in]			窗口期，建议是2
	seed_len[in]		OTP种子的长度
	seed[in]		OTP种子(0~9A~F)，使用MK1保护
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int otp_input_seed(const char *msk_name,unsigned int otp_len,unsigned int cycle, unsigned int wnd,unsigned int seed_len,const char *seed);

/***********************************************************
  功能:
	生成动态口令
  参数:
 	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	auto_code[in]		认证码
	otp[out]		动态口令
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int otp_gen(const char *msk_name,const char *auto_code,char *otp);

/***********************************************************
  功能:
	验证动态口令
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	auto_code[in]		认证码
	otp[in]			动态口令
	offset[out]		时间偏移量
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int otp_verify(const char *msk_name,const char *auto_code,const char *otp,int *offset);

/***********************************************************
  功能:
	获取APK正版签名信息
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	pk[in]			SM2公钥
	sign[out]		签名信息
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int get_genuine_sign(const char *msk_name,const char *pk,char *sign);

/***********************************************************
  功能:
	数据存储
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		数据存储的位置(1~DATA_MAX_NUM)
	data[in]		待存储的数据
	len[in]			数据的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int data_store(const char *msk_name,unsigned int index,const unsigned char *data,unsigned int len);

/***********************************************************
  功能:
	数据读取
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		数据存储的位置(1~DATA_MAX_NUM)
	data[out]		待存储的数据
	len[in|out]		数据的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int data_read(const char *msk_name,unsigned int index,unsigned char *data,unsigned int *len);

/***********************************************************
  功能:
	数据删除
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	index[in]		数据存储的位置(1~DATA_MAX_NUM)
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int data_delete(const char *msk_name,unsigned int index);

/***********************************************************
  功能:
	清除所有数据
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int data_clear(const char *msk_name);

/***********************************************************
  功能:
	获取PIN的随机数
  参数:
	random[in]		随机数
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int get_pin_random(char *random);

/***********************************************************
  功能:
	输入一个字符的PIN
  参数:
	pin[in]		和随机数异或之后的密码
	pin_len[out]		PIN的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int input_pin_char(unsigned char pin);

/***********************************************************
  功能:
	删除一个字符的PIN
  参数:
	pin_len[out]		PIN的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int delete_pin_char();

/***********************************************************
  功能:
	清除所有PIN
  参数:
	无
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int clear_pin_char();

/***********************************************************
  功能:
	获取密文PIN
  参数:
	msk_name[in]		MSK库的名称，如果只有一个则输入NULL启用默认值msk
	pk_index[in]		公钥索引位置
	cipher[out]		PIN的密文
	pin_len[out]		PIN的长度
  返回值:
	=0	成功
	<0	错误码
 ***********************************************************/
int get_cipher(const char *msk_name,int pk_index,char *cipher,int *pin_len);

/***********************************************************
 功能:
 数字信封加密
 参数:
 msk_name[in]        MSK库的名称，如果只有一个则输入NULL启用默认值msk
 pk_index[in]        公钥索引位置
 data[in]                待加密的数据（2进制数）
 data_len[in]        数据长度
 zek_by_pk[out]        公钥加密的ZEK
 result[out]                加密结果（2进制数）
 返回值:
 >=0    成功，加密结果字节长度
 <0    错误码
 ***********************************************************/
int digital_envelope_encrypt(const char*msk_name,int pk_index,const unsigned char *data,int data_len,char *zek_by_pk,unsigned char *result);

/***********************************************************
 功能:
 数字信封解密
 参数:
 msk_name[in]        MSK库的名称，如果只有一个则输入NULL启用默认值msk
 pk_index[in]        公钥索引位置
 zek_by_pk[in]        公钥加密的ZEK
 data[in]                待加密的数据（2进制数）
 data_len[in]        数据长度
 result[out]                加密结果（2进制数）
 返回值:
 >=0    成功，解密结果字节长度
 <0    错误码
 ***********************************************************/
int digital_envelope_decrypt(const char*msk_name,int vk_index,const char *zek_by_pk,const unsigned char *data,int data_len,unsigned char *result);

/***********************************************************
 功能:
 获取密文PIN
 参数:
 msk_name[in]        MSK库的名称，如果只有一个则输入NULL启用默认值msk
 pk_len[in]        公钥长度
 cipher[out]        PIN的密文
 rc[out]            rc的密文
 返回值:
 =0    成功
 <0    错误码
 ***********************************************************/
int get_eer2_cipher(const char *msk_name, int pk_index,const char *rs, char *cipher, char *rc);



#endif
