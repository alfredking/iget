//
//  IDMPAuthModel.m
//  IDMPCMCC
//
//  Created by wj on 2017/8/17.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "IDMPAuthModel.h"
#import "userInfoStorage.h"
#import "IDMPDevice.h"
#import "IDMPDate.h"
#import "NSString+IDMPAdd.h"
#import "IDMPPublicParam.h"
#import "IDMPUtility.h"

typedef NS_ENUM(NSInteger, IDMPAuthType) {
    IDMPAuthCMCCWP = 0,
    IDMPAuthCUCCWP,
    IDMPAuthCTCCWP,
    IDMPAuthHS,
    IDMPAuthUP,
    IDMPAuthDUP,
    IDMPUpdateKS
};

#define ksCUCCWP_clientversion @"CU_WP clientversion"
#define ksCTCCWP_clientversion @"CT_WP clientversion"

//更新KS
#define updateKSClientversion  @"UPD_KS clientversion"
#define systemTime @"systemtime"

//数据短信文本
#define ksDS_clientversion @"HS clientversion"
#define ksEnClientkek @"encckek"

#define ksUP_clientversion @"UP clientversion"

#define DUPclientversion @"DUP clientversion"
#define kDUP_verificationcode @"verificationcode"





@interface IDMPAuthModel()
@property (nonatomic, strong) NSDictionary *heads;

@end


@implementation IDMPAuthModel

- (instancetype)initWPWithSipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache{
    return [self initWithAuthType:IDMPAuthCMCCWP cert:nil countHS:nil userName:nil password:nil sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache];
}

- (instancetype)initCUCCWPWithCert:(NSString *)cert sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache{
    return [self initWithAuthType:IDMPAuthCUCCWP cert:cert countHS:nil userName:nil password:nil sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache];
}

- (instancetype)initCTCCWPWithCert:(NSString *)cert sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache{
    return [self initWithAuthType:IDMPAuthCTCCWP cert:cert countHS:nil userName:nil password:nil sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache];
}

- (instancetype)initHSWithcount:(NSString *)count sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache{
    return [self initWithAuthType:IDMPAuthHS cert:nil countHS:count userName:nil password:nil sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:isTmpCache];
}


- (instancetype)initUPDKSWithUserName:(NSString *)userName sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPUpdateKS cert:nil countHS:nil userName:userName password:nil sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:NO];
}

- (instancetype)initDUPWithUserName:(NSString *)userName messgeCode:(NSString *)messgeCode sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthDUP cert:nil countHS:nil userName:userName password:messgeCode sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:NO];
}

- (instancetype)initUPWithUserName:(NSString *)userName password:(NSString *)password sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId {
    return [self initWithAuthType:IDMPAuthUP cert:nil countHS:nil userName:userName password:password sipInfo:sipinfo clientNonce:clientNonce traceId:traceId isTmpCache:NO];
}

- (instancetype)initWithAuthType:(IDMPAuthType)authType cert:(NSString *)cert countHS:(NSString *)count userName:(NSString *)userName password:(NSString *)password sipInfo:(NSString *)sipinfo clientNonce:(NSString *)clientNonce traceId:(NSString *)traceId isTmpCache:(BOOL)isTmpCache{
    if (self = [super init]) {
        NSString *BTID;
        NSString *sqn;
        NSString *encryptClientNonce= [IDMPUtility rsaOrSM4EncryptWithRawData:clientNonce];
        if (authType == IDMPAuthUP || authType == IDMPAuthDUP || authType == IDMPUpdateKS) {
            NSDictionary *user = (NSDictionary *)[userInfoStorage getInfoWithKey:userName];
            if([user objectForKey:IDMPBTID]&&[user objectForKey:IDMPKS]&&[user objectForKey:IDMPSQN]) {
                BTID = [user objectForKey:IDMPBTID];
                sqn = [user objectForKey:IDMPSQN];
            }
        } else if (isTmpCache) {
            NSDictionary *tmpUser = (NSDictionary *)[userInfoStorage getInfoWithKey:IDMPTmpUserInfo];
            BTID = [tmpUser objectForKey:IDMPBTID];
        }
        NSMutableString *authorization = [IDMPPublicParam genPublicParamWithTraceId:traceId];
        [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",kAPPID,appidString]];
        [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",sipEncFlag,yesFlag]];
        [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",httpsFlag,yesFlag]];
        [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",IDMPBTID,BTID]];
        
        NSString *isSipFromServer = (NSString *)[userInfoStorage getInfoWithKey:isSipApp];
        if ([sipinfo isEqualToString:isSip] && [sipinfo isEqualToString:isSipFromServer]) {
            sipinfo = isSip;
        } else {
            sipinfo = noSip;
        }
        [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",sipFlag,sipinfo]];

        switch (authType) {
            case IDMPAuthCMCCWP:
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksClientkek,encryptClientNonce]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",ksWP_clientversion,clientversionValue] atIndex:0];

                
                break;
            case IDMPAuthCUCCWP:
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",@"cert",cert]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksClientkek,encryptClientNonce]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",ksCUCCWP_clientversion,clientversionValue] atIndex:0];

                break;
            case IDMPAuthCTCCWP:
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",@"cert",cert]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksClientkek,encryptClientNonce]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",ksCTCCWP_clientversion,clientversionValue] atIndex:0];
                break;
            case IDMPAuthHS:
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnClientkek,encryptClientNonce]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksRAND,clientNonce]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",@"hscount",count]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",ksDS_clientversion,clientversionValue] atIndex:0];
                break;
            case IDMPAuthUP:
            {
#ifdef STATESECRET
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",@"pwdEncType",@"1"]];
                
#endif
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksUserName,userName]];
                NSString *encryptPassWd = [IDMPUtility rsaOrSM2EncryptWithRawData:password];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnPasswd,encryptPassWd]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnClientNonce,encryptClientNonce]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",ksUP_clientversion,clientversionValue] atIndex:0];

            }
                break;
            case IDMPAuthDUP:
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksUserName,userName]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",kDUP_verificationcode,password]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnClientNonce,encryptClientNonce]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",DUPclientversion,clientversionValue] atIndex:0];

                break;
            case IDMPUpdateKS:
            {
                NSDateFormatter *dateFormat = [IDMPDate cachedDateFormatter];
                NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",IDMPSQN,sqn]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",ksEnClientNonce,encryptClientNonce]];
                [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\"",systemTime,currentDateStr]];
                [authorization insertString:[NSString stringWithFormat:@"%@=\"%@\"",updateKSClientversion,clientversionValue] atIndex:0];
                
                
            }
                break;
        }
#ifdef STATESECRET
        NSString *NCAKeyName = (NSString *)[userInfoStorage getInfoWithKey:NCANameKey];
        [authorization appendString:[NSString stringWithFormat:@",%@=\"%@\",%@=\"%@\"",@"encType",@"nca",@"keyName",NCAKeyName]];
#endif
        NSString *finalAuthorization = [authorization copy];
        NSString *signature = [finalAuthorization idmp_RSASign];
        NSString *rcData = [IDMPDevice getLocalUserDeviceData];
        self.heads = [NSDictionary dictionaryWithObjectsAndKeys:finalAuthorization,ksAuthorization,signature,ksSignature,rcData,kRC_data, nil];
    }
    return self;
}

@end
