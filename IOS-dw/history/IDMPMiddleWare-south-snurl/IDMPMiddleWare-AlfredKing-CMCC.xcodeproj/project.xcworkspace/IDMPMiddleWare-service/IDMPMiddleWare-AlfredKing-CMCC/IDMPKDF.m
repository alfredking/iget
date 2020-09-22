//
//  IDMPKDF.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPKDF.h"
#import "IDMPOpensslDigest.h"
#import "hmac_sha256.h"
#import "IDMPFormatTransform.h"

#define TRAN32(X) ((((uint32_t)(X)&0xff000000)>>24) | (((uint32_t)(X)&0x00ff0000)>>8) | (((uint32_t)(X)&0x0000ff00)<<8) | (((uint32_t)(X) & 0x000000ff) << 24))

@implementation IDMPKDF


unsigned char* kdf_pw(unsigned char* key, char* pscene, char* pnonce, char* pcnonce)
{
    
    char* p_array[3];
	p_array[0] = pscene;
	p_array[1] = pnonce;
	p_array[2] = pcnonce;
	unsigned char* s;
	unsigned char* ks;
	int s_len;
	compose_s(p_array, 3, &s, &s_len);
	ks = (unsigned char*)malloc(32);
	memset(ks,'\0',32);
	unsigned int key_len = strlen (key);
    hmac_sha256(key, key_len, s, s_len, ks);
	return ks;
}


unsigned char* kdf_sms(unsigned char* key, char* pscene, char* pnonce)
{
	char* p_array[2];
	p_array[0] = pscene;
	p_array[1] = pnonce;
	unsigned char* s;
	int s_len;
	compose_s(p_array, 2, &s, &s_len);
    unsigned char* ks;
	ks = malloc(32);
	memset(ks,'\0',32);
	unsigned int key_len =strlen(key);
	hmac_sha256(key, key_len, s, s_len, ks);
	return ks;
}

void compose_s(char** p_array, int p_array_len, unsigned char** s, int* ps_len)
{
	unsigned char FC = 0x01;
	int i;
	unsigned char* oct_str = malloc(p_array_len * 2);
	*ps_len = 1 + 1;
	int array_lable[4];
    for(i = 0; i < p_array_len; i++)
    {
		unsigned int tmp_len = strlen(p_array[i]);
        array_lable[i] = tmp_len;
		*ps_len = *ps_len + tmp_len + 2;
		num_to_octstr(tmp_len, oct_str + i*2);
    }
	*s = (unsigned char*)malloc(*ps_len);
	unsigned char* p = *s;
    memset(p, FC, 1);
	p+=1;
	for(i = 0; i < p_array_len; i++)
    {
		memcpy(p, p_array[i], array_lable[i]);
		p += array_lable[i];
        memcpy(p, oct_str+i*2, 2);
		p += 2;
	}
 	*ps_len = p - *s;
}

unsigned char* num_to_octstr(int num, unsigned char* oct_str)
{
	int cut_high = 0x00FF;
	unsigned char num_low = num & cut_high;
	unsigned char num_high = num >> 8;
	memset(oct_str, num_high, 1);
	memset(oct_str+1, num_low, 1);
	return oct_str;
}

+(NSString*)getNativeMac:(unsigned char*)ks data:(NSString *)wwwauthenticate
{
    ks[16]='\0';
    unsigned  char *mac=(char*)calloc(sizeof(char*),32);
    memset(mac,'\0',33);
    mac=sha256WithKeyAndData(ks,[wwwauthenticate UTF8String]);
    NSString *nativeMac=[IDMPFormatTransform charToNSHex:mac length:32];
    return [nativeMac lowercaseString];
}



@end