//
//  IDMPKDF.h
//  IDMPMiddleWare-AlfredKing-CMCC
//
//  Created by alfredking－cmcc on 14-8-28.
//  Copyright (c) 2014年 alfredking－cmcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDMPKDF : NSObject

unsigned char* kdf_pw(unsigned char* key, char* pscene, char* pnonce, char* pcnonce);
unsigned char* kdf_sms(unsigned char* key, char* pscene, char* pnonce);
void compose_s(char** p_array, int p_array_len, unsigned char** s, int* ps_len);
+(NSString*)getNativeMac:(unsigned char*)ks data:(NSString *)wwwauthenticate;

@end
