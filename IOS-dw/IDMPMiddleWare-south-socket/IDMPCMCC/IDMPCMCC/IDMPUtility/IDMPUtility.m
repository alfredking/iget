//
//  IDMPUtility.m
//  IDMPCMCC
//
//  Created by wj on 2018/5/15.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "IDMPUtility.h"

#import "NSData+IDMPAdd.h"
#import "NSString+IDMPAdd.h"
#import "IDMPQueryModel.h"
#import "userInfoStorage.h"
#import "IDMPDevice.h"
#import "userInfoStorage.h"

@implementation IDMPUtility

+(BOOL)checkNSStringisNULL:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    } else if ([string isKindOfClass:[NSString class]]&&string.length==0) {
        NSLog(@"string");
        return YES;
    }
    else if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    } else if ( [string isKindOfClass:[NSString class]] && [string isEqualToString:@"<null>"]) {
        return YES;
    } else if ( [string isKindOfClass:[NSString class]] && [string isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - MIX(MD5&SM3) HASH
//+ (NSString *)md5OrSM3WithRawData:(NSString *)rawData {
//#ifdef STATESECRET
//    return [IDMPUtility sm3WithRawData:rawData];
//#else
//    return [rawData idmp_getMd5String];
//#endif
//}

#pragma mark - MIX(RSA&SM2) CRYPT & SIGN
+ (NSString *)rsaOrSM2EncryptWithRawData:(NSString *)rawData {
#ifdef STATESECRET
    return [IDMPUtility sm2EncryptWithPublicKey:sm2PUBLIC_KEY rawData:rawData];
#else
    return [rawData idmp_RSAEncrypt];
#endif
}

#pragma mark - MIX(RSA&SM4) DECRYPT
+ (NSString *)rsaOrSM4DecryptWithEncData:(NSString *)encData {
#ifdef STATESECRET
    return [IDMPUtility sm4WithOperation:SM4Decrypt rawData:encData];
#else
    return [encData idmp_RSADecrypt];
#endif
}

+ (NSString *)rsaOrSM4EncryptWithRawData:(NSString *)rawData {
#ifdef STATESECRET
    return [IDMPUtility sm4WithOperation:SM4Encrypt rawData:rawData];
#else
    return [rawData idmp_RSAEncrypt];
#endif
}

#pragma mark - MIX(AES&SM4) CRYPT
//如果是SM4，把加密的字符串和key作为加密内容
+ (NSString *)aesORSM4EncryptRawData:(NSString *)rawData key:(NSString *)key {
#ifdef STATESECRET
    return [IDMPUtility sm4WithOperation:SM4Encrypt rawData:[NSString stringWithFormat:@"%@%@",rawData,key]];
#else
    return [[rawData idmp_aesEncryptWithKey:key] idmp_base64Encoding];
#endif
}

+ (NSString *)aesORSM4DecryptRawData:(NSString *)rawData key:(NSString *)key {
#ifdef STATESECRET
    return [IDMPUtility sm4WithOperation:SM4Decrypt rawData:[NSString stringWithFormat:@"%@%@",rawData,key]];
#else
    return [[rawData idmp_aesDecryptWithKey:key] idmp_base64Encoding];
#endif
}

#pragma mark - SM2 CRYPT
#ifdef STATESECRET
+ (NSString *)sm2EncryptWithPublicKey:(NSString *)pubKey rawData:(NSString *)rawData{
    MskManager *mskManager =  [MskManager shareInstance];
    BOOL isExist = [mskManager isExist:[IDMPUtility getMskName]];
    if (!isExist) {
        [mskManager deleteMsk:[IDMPUtility getMskName] pin:PinCode];
        return nil;
    }
    Msk *msk = [mskManager getMsk:[IDMPUtility getMskName]];
    MskResponse *response = [msk asymmEncrypt:sm2Index fill_mode:DATA_FILL_MODE_NULL data:[rawData dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [response getDataValue:@"result"];
    NSString *encryptPassWd = [data idmp_hexEncodedString];
    return encryptPassWd;
}

#pragma mark - SM4
+ (NSString *)sm4WithOperation:(IDMPSM4Operation)operation rawData:(NSString *)rawData{
    MskManager *mskManager =  [MskManager shareInstance];
    BOOL isExist = [mskManager isExist:[IDMPUtility getMskName]];
    if (!isExist) {
        [mskManager deleteMsk:[IDMPUtility getMskName] pin:PinCode];
        return nil;
    }
    Msk *msk = [mskManager getMsk:[IDMPUtility getMskName]];
    NSString *result = nil;
    switch (operation) {
        case SM4Decrypt:
        {
            MskResponse *response = [msk symmDecrypt:sm4Index data:[MskUtil convertHexStrToData:rawData]];
            NSData *data = [response getDataValue:@"result"];
            NSString *rawStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSInteger length = [[rawStr substringToIndex:4] integerValue];
            result = [rawStr substringWithRange:NSMakeRange(4, length)];
        }
            break;
        case SM4Encrypt:
        {
            NSString *finalData = [IDMPUtility dataAlign:rawData];
            MskResponse *response = [msk symmEncrypt:sm4Index binaryData:[finalData dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *data = [response getDataValue:@"result"];
            result = [MskUtil convertDataToHexStr:data];
        }
            break;
    }
    return result;
}

+ (NSString *)dataAlign:(NSString *)rawData {
    NSUInteger rawDatalength = rawData.length;
    NSString *lengthStr = [NSString stringWithFormat:@"%lu", (unsigned long)rawDatalength];
    NSUInteger headZeroNum = 4 - lengthStr.length;

    NSMutableString *finalData = [NSMutableString stringWithString:rawData];
    [finalData insertString:lengthStr atIndex:0];
    for (int i = 0; i < headZeroNum; i++) {
        [finalData insertString:@"0" atIndex:0];
    }
    while (true) {
        [finalData appendString:@"0"];
        if (finalData.length % 16 == 0) {
            break;
        }
    }

    return [finalData copy];

}

+ (NSString *)sm3WithRawData:(NSString *)rawData{
    MskManager *mskManager =  [MskManager shareInstance];
    BOOL isExist = [mskManager isExist:[IDMPUtility getMskName]];
    if (!isExist) {
        [mskManager deleteMsk:[IDMPUtility getMskName] pin:PinCode];
        return nil;
    }
    Msk *msk = [mskManager getMsk:[IDMPUtility getMskName]];
    MskResponse *response = [msk sm3:[rawData dataUsingEncoding:NSUTF8StringEncoding] len:(int)rawData.length];
    NSData *sm3 = [response getDataValue:@"result"];
    NSString *sm3Str = [[NSString alloc] initWithData:sm3 encoding:NSUTF8StringEncoding];
    return sm3Str;
}

+ (NSString *)getMskName {
    NSString *mskName = (NSString *)[userInfoStorage getInfoWithKey:MskNameKey];
    if (mskName) {
        return mskName;
    }
    NSString *idfv = [IDMPDevice getDeviceID];
    NSString *bundleid = [[NSBundle mainBundle] bundleIdentifier];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    mskName = [[NSString stringWithFormat:@"%@%@%f",idfv, bundleid, time] idmp_getMd5String];
    [userInfoStorage setInfo:mskName withKey:MskNameKey];
    NSString *mskNameKey =  (NSString *)[userInfoStorage getInfoWithKey:MskNameKey];
    return mskNameKey;
}

+ (void)inputMskManager:(MskManager *)mskManager keyValue:(NSString *)keyValue checkValue:(NSString *)checkValue {
    Msk *msk = [mskManager getMsk:[IDMPUtility getMskName]];
    [msk symmInputKey:sm4Index symmAlg:SM4 KeyAttribute:KEY_ATTR_IN_AND_OUT kv:keyValue cv:checkValue];
    [msk asymmInputPublicKey:sm2Index asymmAlg:SM2 keyAttribute:KEY_ATTR_IN_AND_OUT pk:sm2PUBLIC_KEY];
}

#endif

@end
