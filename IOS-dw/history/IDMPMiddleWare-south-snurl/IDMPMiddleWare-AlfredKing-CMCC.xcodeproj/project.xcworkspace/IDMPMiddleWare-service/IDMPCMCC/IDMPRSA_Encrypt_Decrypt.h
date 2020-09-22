//
//  IDMPRSA_Encrypt_Decrypt.h
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include"openssl/pem.h"
#include<openssl/evp.h>
#include<openssl/rsa.h>
#include<openssl/err.h>

@interface IDMPRSA_Encrypt_Decrypt : NSObject

NSString *RSA_encrypt(NSString *data,NSString *keyPath);
NSString *RSA_decrypt(NSString *data,NSString *keyPath);


@end
