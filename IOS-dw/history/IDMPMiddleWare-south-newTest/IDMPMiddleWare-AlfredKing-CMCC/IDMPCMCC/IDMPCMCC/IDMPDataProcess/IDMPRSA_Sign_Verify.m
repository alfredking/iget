//
//  IDMPRSA_Sign_Verify.m
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import "IDMPRSA_Sign_Verify.h"
#import "IDMPRSA_Encrypt_Decrypt.h"



@implementation IDMPRSA_Sign_Verify

NSString *RSA_EVP_Sign(NSString *data)
{
    
    return [IDMPRSA_Encrypt_Decrypt signString:data privateKey:PRIVATE_KEY];
}


int RSA_EVP_Verify(NSString *srcString,NSString *signature)
{
    return 0;
}


@end
