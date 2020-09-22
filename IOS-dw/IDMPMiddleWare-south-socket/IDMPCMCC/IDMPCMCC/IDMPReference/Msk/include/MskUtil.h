//
//  MskUtil.h
//  msk
//
//  Created by wanggp on 2017/9/15.
//  Copyright © 2017年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MskUtil : NSObject


+(NSData *)convertHexStrToData:(NSString *)str;
+ (NSString *)convertDataToHexStr:(NSData *)data;

+ (NSString*)hexStringForChar:(unsigned char *)data len:(int)len;
@end
