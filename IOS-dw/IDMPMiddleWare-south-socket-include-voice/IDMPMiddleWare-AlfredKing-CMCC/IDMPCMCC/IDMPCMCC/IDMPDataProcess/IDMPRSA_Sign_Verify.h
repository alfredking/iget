//
//  IDMPRSA_Sign_Verify.h
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/bio.h>
#import "pem.h"
#import "err.h"
@interface IDMPRSA_Sign_Verify : NSObject

NSString *secRSA_EVP_Sign(NSString *data);
//int secRSA_EVP_Verify(NSString *srcString,NSString *signature);

NSString *backupRSA_EVP_Sign(NSString *data);
//int backupRSA_EVP_Verify(NSString *srcString,NSString *signature);

@end
