//
//  IDMPRSA_Encrypt_Decrypt.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPFormatTransform.h"

@implementation IDMPRSA_Encrypt_Decrypt

NSString *RSA_encrypt(NSString *data,NSString *keyPath)
{
    
    unsigned char *str=[data UTF8String];
    char *path_key=[keyPath UTF8String];
    char *p_en;
    RSA *p_rsa;
    FILE *file;
    int rsa_len;
    if((file=fopen(path_key,"r"))==NULL){
        perror("open key file error");
        return NULL;
    }
    if((p_rsa=PEM_read_RSA_PUBKEY(file,NULL,NULL,NULL))==NULL){
        //if((p_rsa=PEM_read_RSAPublicKey(file,NULL,NULL,NULL))==NULL){   换成这句死活通不过，无论是否将公钥分离源文件
        ERR_print_errors_fp(stdout);
        return NULL;
    }
    
    rsa_len=RSA_size(p_rsa);
    p_en=(unsigned char *)malloc(rsa_len+1);
    memset(p_en,0,rsa_len+1);
    int Result=RSA_public_encrypt(strlen(str),(unsigned char *)str,(unsigned char*)p_en,p_rsa,RSA_PKCS1_PADDING);
    if(Result<0)
        return NULL;
   
    RSA_free(p_rsa);
    fclose(file);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++)
        [result appendFormat:@"%02x", (unsigned char)p_en[i]];
    
    return result;

}
NSString *RSA_decrypt(NSString *data,NSString *keyPath)
{
    unsigned char *str=[data UTF8String];
    char *path_key=[keyPath UTF8String];
    char *p_de;
    RSA *p_rsa;
    FILE *file;
    int rsa_len;
    if((file=fopen(path_key,"r"))==NULL){
        perror("open key file error");
        return NULL;
    }
    if((p_rsa=PEM_read_RSAPrivateKey(file,NULL,NULL,NULL))==NULL){
        ERR_print_errors_fp(stdout);
        return NULL;
    }
    rsa_len=RSA_size(p_rsa);
    p_de=(unsigned char *)malloc(rsa_len+1);
    memset(p_de,0,rsa_len+1);
    int slen=rsa_len;
    if(RSA_private_decrypt(slen,(unsigned char *)str,(unsigned char*)p_de,p_rsa,RSA_PKCS1_PADDING)<0){
        return NULL;
    }
    RSA_free(p_rsa);
    fclose(file);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++)
        [result appendFormat:@"%02x", p_de[i]];
    
    return result;

}

@end
