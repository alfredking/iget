//
//  NSString+ChinaSecurity.m
//  IDMPCMCC-chinaSecurity
//
//  Created by wj on 2018/3/26.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "NSString+StateSecret.h"
#import "IDMPFormatTransform.h"
#import "NSData+IDMPAdd.h"
#import "MskManager.h"


#define sm2PinCode @"x8_1s9!"
#define sm2MskName @"IDMP_MSK_SM2_ON_LINE"

@implementation NSString (StateSecret)

#pragma mark - 国密SM2

- (NSString *)idmp_sm2WithPublicKey:(NSString *)pubKey {
    MskManager *mskManager =  [MskManager shareInstance];
    BOOL isExist = [mskManager isExist:sm2MskName];
    MskResponse *response = nil;
    if (!isExist) {
       response = [mskManager createMsk:sm2MskName pk:pubKey pin:sm2PinCode];
    }
    Msk *msk = [mskManager getMsk:sm2MskName];
    [msk asymmInputPublicKey:1 asymmAlg:SM2 keyAttribute:KEY_ATTR_IN_AND_OUT pk:pubKey];
    response = [msk asymmEncrypt:1 fill_mode:DATA_FILL_MODE_NULL data:[self dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [response getDataValue:@"result"];
    NSString *encryptPassWd = [data idmp_hexEncodedString];
    return encryptPassWd;
}

@end
