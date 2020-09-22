//
//  IDMPAES.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-9-11.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPAES : NSObject

NSString *AES_Encrypt(NSString *data,NSString *keyPath);

NSString *AES_Decrypt(NSString *data,NSString *keyPath);

@end
