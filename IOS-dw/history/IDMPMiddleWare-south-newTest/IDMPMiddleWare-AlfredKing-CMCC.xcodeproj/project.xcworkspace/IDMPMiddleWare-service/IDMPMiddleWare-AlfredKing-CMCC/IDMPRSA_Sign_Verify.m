//
//  IDMPRSA_Sign_Verify.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Sign_Verify.h"

@implementation IDMPRSA_Sign_Verify


 NSString *RSA_EVP_Sign(NSString *data,NSString *keyPath)
{
    
    unsigned char *Str=[data UTF8String];
    const char *priKeyPath=[keyPath UTF8String];

    EVP_PKEY *prikey;
    BIO *keyFile=BIO_new_file(priKeyPath, "r");
    if(!keyFile)
    {
       perror("open key file error  sign ");
    }
    prikey=PEM_read_bio_PrivateKey(keyFile, NULL, NULL, NULL);
    if(NULL==prikey)
    {
        ERR_print_errors_fp(stdout);
    }
    BIO_free(keyFile);
    int strLen=strlen(Str);
    EVP_MD_CTX mdctx;
    EVP_MD_CTX_init(&mdctx);
    if(!EVP_SignInit_ex(&mdctx, EVP_sha256(), NULL))
    {
       printf("error\n");
       EVP_PKEY_free(prikey);
    }
    if(!EVP_SignUpdate(&mdctx, Str, strLen))
    {
       printf("error\n");
       EVP_PKEY_free(prikey);
    
    }
    unsigned int signLen=EVP_PKEY_size(prikey);
    unsigned char* signBuf=(unsigned char *)calloc(signLen+1, sizeof(char));
   
    if(!EVP_SignFinal(&mdctx, signBuf, &signLen, prikey))
    {
        printf("error\n");
        EVP_PKEY_free(prikey);
    }
    EVP_MD_CTX_cleanup(&mdctx);
    NSMutableString *result = [NSMutableString stringWithCapacity:128];
    for(int i = 0; i < 128; i++)
        [result appendFormat:@"%02x", signBuf[i]];
    
    return result;

}


int RSA_EVP_Verify(NSString *srcString,NSString *signature,NSString *keyPath)
{
    
    char *Str=[srcString UTF8String];
    char *sign=[signature UTF8String];
    char* pubKeyPath=[keyPath UTF8String];
    EVP_PKEY *pubkey;
    BIO *keyFile=BIO_new_file(pubKeyPath, "r");
    if(!keyFile)
    {
        perror("open key file error  sign ");
    }
    pubkey=PEM_read_bio_PUBKEY(keyFile, NULL, NULL, NULL);
    if(NULL==pubkey)
    {
        ERR_print_errors_fp(stdout);
    }
    BIO_free(keyFile);
    EVP_MD_CTX mdctx;
    EVP_MD_CTX_init(&mdctx);
    int strLen=strlen(Str);
    int signLen=strlen(sign);
    if(!EVP_VerifyInit_ex(&mdctx, EVP_sha256(), NULL))
    {
        printf("error\n");
        EVP_PKEY_free(pubkey);
    }
    if(!EVP_VerifyUpdate(&mdctx, Str, strLen))
    {
        printf("error\n");
        EVP_PKEY_free(pubkey);
        
    }
    int result=EVP_VerifyFinal(&mdctx,sign,signLen,pubkey);
    EVP_PKEY_free(pubkey);
    EVP_MD_CTX_cleanup(&mdctx);
    return result;
}


@end
