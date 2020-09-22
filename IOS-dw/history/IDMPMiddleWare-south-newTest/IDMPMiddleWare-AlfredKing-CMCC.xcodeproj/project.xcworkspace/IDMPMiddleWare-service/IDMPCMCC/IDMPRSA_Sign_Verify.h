//
//  IDMPRSA_Sign_Verify.h
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-6.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pem.h"
#import "err.h"

@interface IDMPRSA_Sign_Verify : NSObject

NSString *RSA_EVP_Sign(NSString *data,NSString *keyPath);
int RSA_EVP_Verify(NSString *srcString,NSString *signature,NSString *keyPath);
@end
