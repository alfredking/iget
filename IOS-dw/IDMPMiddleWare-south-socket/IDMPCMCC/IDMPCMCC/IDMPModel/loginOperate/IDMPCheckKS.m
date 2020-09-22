//
//  IDMPCheckKS.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPCheckKS.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "NSString+IDMPAdd.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"
#import "IDMPUtility.h"


typedef NS_OPTIONS(NSInteger, IDMPKSType) {
    IDMPWP = 1 << 0,
    IDMPHS = 1 << 1,
    IDMPUP = 1 << 2,
    IDMPDUP= 1 << 3,
    IDMPUpdateWP = 1 << 4,
    IDMPUpdateHS = 1 << 5,
    IDMPUpdateUP = 1 << 6,
    IDMPUpdateDUP = 1 << 7
    
};

#define ksDS_GBA @"HS_GBA_Ks"
#define ksDS_nonce @"HS Nonce"

#define ksUP_nonce @"UP Nonce"
#define ksUP_GBA @"PW_GBA_Ks"

#define ksTS_nonce @"DUP Nonce"

#define ksExpiretime @"expiretime"


//typedef NS_ENUM(NSInteger, IDMPUPdateType) {
//
//};

@implementation IDMPCheckKS

+ (NSDictionary *)checkWAPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce isTmpCache:(BOOL)isTmpCache {
    return [self checkKSIsValidWithKSType:IDMPWP responseHeaders:responseHeaders clientNonce:clientNonce userName:nil password:nil isTmpCache:isTmpCache];
}

+ (NSDictionary *)checkDataSmsKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce isTmpCache:(BOOL)isTmpCache {
    return [self checkKSIsValidWithKSType:IDMPHS responseHeaders:responseHeaders clientNonce:clientNonce userName:nil password:nil isTmpCache:isTmpCache];
}

+ (NSDictionary *)checkUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd {
    return [self checkKSIsValidWithKSType:IDMPUP responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:passWd isTmpCache:NO];
}

+ (NSDictionary *)checkDUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd{
    return [self checkKSIsValidWithKSType:IDMPDUP responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:passWd isTmpCache:NO];
}

+ (NSDictionary *)checkUpdateKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName{
    return [self checkKSIsValidWithKSType:(IDMPUpdateUP | IDMPUpdateDUP | IDMPUpdateWP | IDMPUpdateHS) responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:nil isTmpCache:NO];
}


+ (NSDictionary *)checkKSIsValidWithKSType:(NSInteger)ksType responseHeaders:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName password:(NSString *)password isTmpCache:(BOOL)isTmpCache {
//    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
//    if(resultCode!=IDMPResultCodeSuccess) {
//        return nil;
//    }
    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
    NSString *serverMac = [responseHeaders objectForKey:IDMPMAC];
    if(!wwwauthenticate||!serverMac) {
        return nil;
    }
    //解析返回参数
    NSDictionary *parament = [self parseParament:wwwauthenticate ksType:ksType];
    
    //解析服务端随机数
    NSString *serverNonce= [self getServerNonce:parament ksType:ksType];
    
    //解析用户名
    if (ksType == IDMPWP) {
        NSString *encUserName = [parament objectForKey:ksUserName];
        if(![IDMPUtility checkNSStringisNULL:encUserName]) {
            userName = [IDMPUtility rsaOrSM4DecryptWithEncData:encUserName];
            if (!userName) {
                userName = [encUserName idmp_RSADecrypt];
            }
        }

    } else if (ksType == IDMPHS) {
        userName = [parament objectForKey:ksUserName];
    }
    
    //解析updateks type
    ksType = [self getDetailUpdateTypeWithParament:parament ksType:ksType];
    
    //计算ks
    unsigned char *ks = [self calculateKsWithKSType:ksType clientNonce:clientNonce serverNonce:serverNonce userName:userName passWd:password];
    if (ks == NULL) {
        return nil;
    }
    //计算mac
    NSString *nativeMac=[IDMPKDF getNativeMac:ks data:wwwauthenticate];
    if([nativeMac isEqualToString:serverMac]) {
        if (!isTmpCache) {
            //存储用户信息
            NSString *expireTimeString = [parament objectForKey:ksExpiretime];
            NSString *rand = [[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce] idmp_getMd5String];
            NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
            [user setObject:expireTimeString forKey:ksExpiretime];
            [user setObject:[NSString idmp_hexStringWithChar:ks length:16] forKey:IDMPKS];
            [user setObject:rand forKey:@"Rand"];
            NSString *passid=[parament objectForKey:IDMPPassID];
            [user setObject:passid forKey:IDMPPassID];
            NSString *sqn=[parament objectForKey:IDMPSQN];
            NSString *BTID=[parament objectForKey:IDMPBTID];
            [user setObject: sqn forKey:IDMPSQN];
            [user setObject: BTID forKey:IDMPBTID];
            [user setObject:serverMac forKey:@"mac"];
            NSString *openid = [parament objectForKey:IDMPOPENID];
            if (![IDMPUtility checkNSStringisNULL:openid]) {
                [user setObject:openid forKey:IDMPOPENID];
            }
            [userInfoStorage setInfo:[user copy] withKey:userName];
            [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
            
            //存储账户列表
            [self saveAccountListWithUserName:userName expireTime:expireTimeString ksType:ksType];
        } else {
            //临时存储用户信息，下次协商时删除。
            NSMutableDictionary *tmpUser = [[NSMutableDictionary alloc]init];
            NSString *tmpSqn=[parament objectForKey:IDMPSQN];
            NSString *tmpBtid=[parament objectForKey:IDMPBTID];
            NSString *tmpks = [NSString idmp_hexStringWithChar:ks length:16];
            [tmpUser setObject:tmpks forKey:IDMPKS];
            [tmpUser setObject: tmpSqn forKey:IDMPSQN];
            [tmpUser setObject: tmpBtid forKey:IDMPBTID];
            [userInfoStorage setInfo:tmpUser withKey:IDMPTmpUserInfo];
        }
        free(ks);
        ks=NULL;
        NSLog(@"KS存储成功!");
        return parament;
    } else {
        free(ks);
        ks=NULL;
        NSLog(@"KS验证不正确");

        return nil;
    }
    
    return nil;
}

//计算ks
+ (unsigned char *)calculateKsWithKSType:(NSInteger)ksType clientNonce:(NSString *)clientNonce serverNonce:(NSString *)serverNonce userName:(NSString *)userName passWd:(NSString *)passWd  {
    unsigned char *ks = NULL;
    if (!serverNonce) {
        return nil;
    }
    switch (ksType) {
        case IDMPWP:
        case IDMPUpdateWP:
        {
            ks = kdf_sms((unsigned char *)[clientNonce UTF8String],(char *)[ksWP_GBA UTF8String],(char *)[serverNonce UTF8String]);
        }
        break;
        case IDMPHS:
        case IDMPUpdateHS:
        {
            ks = kdf_sms((unsigned char *)[clientNonce UTF8String],(char *)[ksDS_GBA UTF8String],(char *)[serverNonce UTF8String]);
        }
        break;
            case IDMPUP:
            case IDMPDUP:
            case IDMPUpdateUP:
            case IDMPUpdateDUP:
        {
            NSString *Ha1 = nil;
            if (ksType == IDMPUP || ksType == IDMPDUP) {
                Ha1 = [[NSString stringWithFormat:@"%@:%@:%@",userName,ksDomainName,passWd] idmp_getMd5String];
            } else {
                Ha1 = [[NSString stringWithFormat:@"%@:%@:",userName,ksDomainName] idmp_getMd5String];
            }
            ks = kdf_pw((unsigned char *)[Ha1 UTF8String],(char *)[ksUP_GBA UTF8String],(char *)[serverNonce UTF8String],(char *)[clientNonce UTF8String]);
        }
    }
    return ks;
}

+ (NSInteger)getDetailUpdateTypeWithParament:(NSDictionary *)parament ksType:(NSInteger)ksType {
    NSInteger detailType = -1;
    switch (ksType) {
        case IDMPWP:
        case IDMPHS:
        case IDMPUP:
        case IDMPDUP:
            detailType = ksType;
            break;
        case IDMPUpdateUP | IDMPUpdateDUP | IDMPUpdateHS | IDMPUpdateWP:
        {
            NSString *caculateType=[parament objectForKey:@"KSRTYPE"];
            if ([caculateType isEqualToString:@"WP"]){
                detailType = IDMPUpdateWP;
            }else if([caculateType isEqualToString:@"HS"]){
                detailType = IDMPUpdateHS;
            }else if([caculateType isEqualToString:@"UP"]){
                detailType = IDMPUpdateUP;
            }else {
                detailType = IDMPUpdateDUP;
            }
        }
            break;
    }
    return detailType;
}

+ (void)saveAccountListWithUserName:(NSString *)userName expireTime:(NSString *)expireTime ksType:(NSInteger)ksType{
    NSNumber *isLocalNum = nil;
    switch (ksType) {
        case IDMPWP:
        case IDMPHS:
        case IDMPUpdateHS:
        case IDMPUpdateWP:
            isLocalNum = [NSNumber numberWithBool:YES];
            break;
        case IDMPUP:
        case IDMPDUP:
        case IDMPUpdateDUP:
        case IDMPUpdateUP:
            isLocalNum = [NSNumber numberWithBool:NO];
            break;
    }
    NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTime,ksExpiretime,isLocalNum,@"isLocalNum",userName,IDMPUserName, nil];
    if([accounts count]>0) {
        int count = 0;
        for (NSDictionary *model in accounts) {
            if ([[model objectForKey:IDMPUserName]isEqualToString:userName]) {
                [accounts removeObject:model];
                [accounts addObject:userInfo];
                break;
            }
            count++;
        }
        if (count>=[accounts count]) {
            [accounts addObject:userInfo];
        }
        [userInfoStorage setInfo:accounts withKey:userList];
        
    } else {
        NSMutableArray *accounts=[[NSMutableArray alloc]init];
        [accounts addObject:userInfo];
        [userInfoStorage setInfo:accounts withKey:userList];
    }
}

+ (NSDictionary *)parseParament:(NSString *)parament ksType:(NSInteger)ksType {
    NSDictionary *resultDic = nil;
    switch (ksType) {
        case IDMPWP:
        case IDMPHS:
        case IDMPUP:
        case IDMPDUP:
            resultDic = [IDMPParseParament parseParamentFrom:parament];
            break;
        case IDMPUpdateWP | IDMPUpdateHS | IDMPUpdateDUP | IDMPUpdateUP:
            resultDic = [IDMPParseParament updateParseParamentFrom:parament];
            break;
    }
    return resultDic;
}

+ (NSString *)getServerNonce:(NSDictionary *)parament ksType:(NSInteger)ksType {
    NSString *serverNonce = nil;
    switch (ksType) {
        case IDMPWP:
            serverNonce = [parament objectForKey:ksWP_nonce];
            break;
        case IDMPHS:
            serverNonce = [parament objectForKey:ksDS_nonce];
            break;
        case IDMPUP:
            serverNonce = [parament objectForKey:ksUP_nonce];
            break;
        case IDMPDUP:
            serverNonce = [parament objectForKey:ksTS_nonce];
            break;
        case IDMPUpdateWP | IDMPUpdateHS | IDMPUpdateDUP | IDMPUpdateUP:
            serverNonce = [parament objectForKey:@"Nonce"];
            break;
    }
    return serverNonce;
}

@end
