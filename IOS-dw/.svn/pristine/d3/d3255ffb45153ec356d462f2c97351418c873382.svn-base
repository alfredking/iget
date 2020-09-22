//
//  IDMPKDF.m
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import "IDMPKDF.h"
#import "IDMPOpensslDigest.h"
#import "IDMPFormatTransform.h"

#define TRAN32(X) ((((uint32_t)(X)&0xff000000)>>24) | (((uint32_t)(X)&0x00ff0000)>>8) | (((uint32_t)(X)&0x0000ff00)<<8) | (((uint32_t)(X) & 0x000000ff) << 24))

@implementation IDMPKDF


unsigned char* kdf_pw(unsigned char* key, char* pscene, char* pnonce, char* pcnonce)
{
    printf("@ kdf_pw 1   %s    @2   %s   @3   %s   @4    %s \n",key,pscene,pnonce,pcnonce);
    char* p_array[3];
    p_array[0] = pscene;
    p_array[1] = pnonce;
    p_array[2] = pcnonce;
    unsigned char* s;
    unsigned char* ks;
    int s_len;
    compose_s(p_array, 3, &s, &s_len);
//    ks = (unsigned char*)malloc(32);
//    memset(ks,'\0',32);
    int key_len = (int)strlen ((const char *)key);
    ks=sha256WithKeyAndData(key,key_len,s,s_len);
    free(s);
    s=NULL;
    return ks;
}


unsigned char* kdf_sms(unsigned char* key, char* pscene, char* pnonce)
{
    printf("@ kdf_sms 1   %s    @2   %s   @3   %s   \n",key,pscene,pnonce);
    char* p_array[2];
    p_array[0] = pscene;
    p_array[1] = pnonce;
    unsigned char* s=nil;
    int s_len;
    compose_s(p_array, 2, &s, &s_len);
    unsigned char* ks;
//    ks = malloc(32);
//    memset(ks,'\0',32);
    unsigned int key_len =(unsigned int)strlen((const char *)key);
    ks=sha256WithKeyAndData(key,key_len,s,s_len);
    free(s);
    s=NULL;
   	return ks;
}

void compose_s(char** p_array, int p_array_len, unsigned char** s, int* ps_len)
{
    unsigned char FC = 0x01;
    int i;
    unsigned char* oct_str = malloc(p_array_len * 2);
    *ps_len = 1 + 1;
    int array_lable[4];
    int pLen=(int)strlen((const char *)p_array);
    NSLog(@"p_array长度: %d \n",pLen);
    //    if (pLen<p_array_len)
    //    {
    //        p_array_len=pLen;
    //        NSLog(@"长度修正");
    //    }
    for(i = 0; i <p_array_len; i++)
    {
        printf("p_array元素:%d   %s \n",i,p_array[i]);
        unsigned int tmp_len = (unsigned int)strlen(p_array[i]);
        array_lable[i] = tmp_len;
        *ps_len = *ps_len + tmp_len + 2;
        num_to_octstr(tmp_len, oct_str + i*2);
    }
    *s = (unsigned char*)calloc(*ps_len,sizeof(unsigned char));
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
    free(oct_str);
    oct_str=NULL;
    *ps_len = (int)(p - *s);
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
    unsigned char *mac=nil;
    int key_len=(int)strlen(ks);
    int data_len=(int)strlen([wwwauthenticate UTF8String]);
    NSLog(@"key length is %d,data length is %d",key_len,data_len);
    mac=sha256WithKeyAndData(ks,key_len,[wwwauthenticate UTF8String],data_len);
    
    print_hex(mac);
    NSString *nativeMac=[IDMPFormatTransform charToNSHex:mac length:32];
    //    free(mac);
    mac=NULL;
    return [nativeMac lowercaseString];
}



@end
