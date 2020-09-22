//
//  IDMPOpensslDigest.h
//  IDMPMiddleWare
//
//  Created by alfredking－cmcc on 14-8-18.
//  Copyright (c) 2014年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "evp.h"
#include <openssl/hmac.h>

@interface IDMPOpensslDigest : NSObject

unsigned char* sha256WithKeyAndData(char* key,char *data);

@end
