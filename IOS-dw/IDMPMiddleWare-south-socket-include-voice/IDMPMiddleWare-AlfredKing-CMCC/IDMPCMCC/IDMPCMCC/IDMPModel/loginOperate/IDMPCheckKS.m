//
//  IDMPCheckKS.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/25.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPCheckKS.h"
#import "IDMPConst.h"
#import "IDMPParseParament.h"
#import "IDMPKDF.h"
#import "IDMPRSA_Encrypt_Decrypt.h"
#import "IDMPMD5.h"
#import "IDMPFormatTransform.h"
#import "userInfoStorage.h"


typedef NS_OPTIONS(NSInteger, IDMPKSType) {
    IDMPWP = 1 << 0,
    IDMPHS = 1 << 1,
    IDMPUP = 1 << 2,
    IDMPDUP= 1 << 3,
    IDMPUpdateWP = 1 << 4,
    IDMPUpdateHS = 1 << 5,
    IDMPUpdateUP = 1 << 6,
    IDMPUpdateDUP = 1 << 7,
    IDMPVUP= 1 << 8,
    IDMPUpdateVUP = 1 << 9

};

//typedef NS_ENUM(NSInteger, IDMPUPdateType) {
//
//};

@implementation IDMPCheckKS

+ (NSDictionary *)checkWAPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce {
    return [self checkKSIsValidWithKSType:IDMPWP responseHeaders:responseHeaders clientNonce:clientNonce userName:nil password:nil];
}

+ (NSDictionary *)checkDataSmsKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce {
    return [self checkKSIsValidWithKSType:IDMPHS responseHeaders:responseHeaders clientNonce:clientNonce userName:nil password:nil];
}

+ (NSDictionary *)checkUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd  {
    return [self checkKSIsValidWithKSType:IDMPUP responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:passWd];
}

+ (NSDictionary *)checkDUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd {
    return [self checkKSIsValidWithKSType:IDMPDUP responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:passWd];
}

+ (NSDictionary *)checkVUPKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName passWd:(NSString *)passWd {
    return [self checkKSIsValidWithKSType:IDMPVUP responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:passWd];
}

+ (NSDictionary *)checkUpdateKSIsValid:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName {
    return [self checkKSIsValidWithKSType:(IDMPUpdateUP | IDMPUpdateDUP | IDMPUpdateWP | IDMPUpdateHS | IDMPUpdateVUP) responseHeaders:responseHeaders clientNonce:clientNonce userName:userName password:nil];
}


+ (NSDictionary *)checkKSIsValidWithKSType:(NSInteger)ksType responseHeaders:(NSDictionary *)responseHeaders clientNonce:(NSString *)clientNonce userName:(NSString *)userName password:(NSString *)password{
//    NSInteger resultCode = [[responseHeaders objectForKey:ksResultCode] integerValue];
//    if(resultCode!=IDMPResultCodeSuccess) {
//        return nil;
//    }
    NSString *wwwauthenticate = [responseHeaders objectForKey:ksWWW_Authenticate];
    NSString *serverMac = [responseHeaders objectForKey:ksMac];
    if(!wwwauthenticate||!serverMac) {
        return nil;
    }
    //解析返回参数
    NSDictionary *parament = [self parseParament:wwwauthenticate ksType:ksType];
    
    //解析服务端随机数
    NSString *serverNonce= [self getServerNonce:parament ksType:ksType];
    
    //解析用户名
    if (ksType == IDMPWP) {
        userName = [parament objectForKey:ksUserName];
        if(![IDMPFormatTransform checkNSStringisNULL:userName]) {
            userName=secRSA_Decrypt(userName);
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
        //存储用户信息
        NSString *expireTimeString = [parament objectForKey:ksExpiretime];
        IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
        NSString *rand =[md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@",serverNonce,clientNonce]];
        NSMutableDictionary *user=[[NSMutableDictionary alloc]init];
        [user setObject:expireTimeString forKey:ksExpiretime];
        [user setObject:[IDMPFormatTransform charToNSHex:ks length:16] forKey:@"KS"];
        [user setObject:rand forKey:@"Rand"];
        NSString *passid=[parament objectForKey:@"passid"];
        [user setObject:passid forKey:@"passid"];
        NSString *sqn=[parament objectForKey:ksSQN];
        NSString *BTID=[parament objectForKey:ksBTID];
        [user setObject: sqn forKey:@"sqn"];
        [user setObject: BTID forKey:@"BTID"];
        [user setObject:serverMac forKey:@"mac"];
        NSString *openid = [parament objectForKey:@"openid"];
        if (![IDMPFormatTransform checkNSStringisNULL:openid]) {
            [user setObject:openid forKey:@"openid"];
        }
        [userInfoStorage setInfo:[user copy] withKey:userName];
        [userInfoStorage setInfo:[NSDate date] withKey:ksUpdateDate];
        
        //存储账户列表
        [self saveAccountListWithUserName:userName expireTime:expireTimeString ksType:ksType];

        free(ks);
        ks=NULL;
        NSLog(@"KS存储成功!");
        return parament;
    } else {
        free(ks);
        ks=NULL;
        return nil;
        NSLog(@"KS验证不正确");
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
        case IDMPVUP:
        case IDMPUpdateVUP:
        {
            IDMPMD5 *md5 = [[IDMPMD5 alloc] init];
            NSString *Ha1 = nil;
            if (ksType == IDMPUP || ksType == IDMPDUP) {
                Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:%@",userName,ksDomainName,passWd]];
            } else {
                Ha1 = [md5 getMd5_32Bit_String:[NSString stringWithFormat:@"%@:%@:",userName,ksDomainName]];
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
        case IDMPVUP:
            detailType = ksType;
            break;
        case IDMPUpdateUP | IDMPUpdateDUP | IDMPUpdateHS | IDMPUpdateWP | IDMPUpdateVUP:
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
        case IDMPVUP:
        case IDMPUpdateVUP:
            isLocalNum = [NSNumber numberWithBool:NO];
            break;
    }
    NSMutableArray *accounts =[NSMutableArray arrayWithArray:(NSArray *)[userInfoStorage getInfoWithKey:userList]];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:expireTime,ksExpiretime,isLocalNum,@"isLocalNum",userName,@"userName", nil];
    if([accounts count]>0) {
        int count = 0;
        for (NSDictionary *model in accounts) {
            if ([[model objectForKey:@"userName"]isEqualToString:userName]) {
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
        case IDMPVUP:
            resultDic = [IDMPParseParament parseParamentFrom:parament];
            break;
        case IDMPUpdateWP | IDMPUpdateHS | IDMPUpdateDUP | IDMPUpdateUP | IDMPUpdateVUP:
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
        case IDMPVUP:
            serverNonce = [parament objectForKey:ksVUP_nonce];
            break;
        case IDMPUpdateWP | IDMPUpdateHS | IDMPUpdateDUP | IDMPUpdateUP | IDMPUpdateVUP:
            serverNonce = [parament objectForKey:@"Nonce"];
            break;
    }
    return serverNonce;
}

@end
